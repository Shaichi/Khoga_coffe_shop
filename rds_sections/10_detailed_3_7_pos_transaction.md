### **3.7 POS Transaction**

*\[Provide the detailed design for POS Transaction, covering UC-44→UC-55 (Open Shift, Full Checkout Pipeline, VietQR Payment, Close Shift/Z-Report). Actor: cashier (POS Terminal on Flutter). Key design decisions: (1) DiscountStackingEngine enforces voucher + loyalty point stacking rules (BR-70); (2) VietQR uses idempotency key = orderId (BR-84/BR-85); (3) ShiftAutoCloseScheduler force-closes open shifts at 23:59.\]*

#### ***3.7.1 Class Diagram***

*\[Class diagram for POS Transaction. COMET stereotypes: ShiftOpenForm, PosCheckoutGrid, PaymentPanel, ShiftCloseForm («boundary»); VietQRClient, PrinterServiceProxy («boundary» external); CheckoutCoordinator, ShiftSessionCoordinator («control»); DiscountStackingEngine, ShiftReconciliationService («application logic»); ShiftAutoCloseScheduler («timer»); ShiftSession, Order, Voucher, Customer, SystemConfig («entity»).\]*

```mermaid
classDiagram
    class ShiftOpenForm {
        <<boundary>>
        +cashierId: UUID
        +openingCash: BigDecimal
        +posRegisterId: String
        +submitOpen()
    }
    class PosCheckoutGrid {
        <<boundary>>
        +menuGrid: MenuItemGrid
        +cart: CartPanel
        +customerPanel: CustomerPanel
        +voucherInput: TextField
        +totalPanel: TotalPanel
        +submitOrder()
    }
    class PaymentPanel {
        <<boundary>>
        +paymentMethod: PaymentMethod
        +cashReceived: BigDecimal
        +qrCodeDisplay: QRImage
        +confirmCash()
        +confirmQrPaid()
    }
    class ShiftCloseForm {
        <<boundary>>
        +closingCash: BigDecimal
        +submitClose()
    }

    class CheckoutCoordinator {
        <<control>>
        +buildCart(items): CartDto
        +applyVoucher(code, cart): CartDto
        +applyLoyaltyPoints(customerId, points, cart): CartDto
        +submitOrder(cart, paymentMethod): OrderDto
        +confirmCashPayment(orderId, cashReceived): ReceiptDto
        +initiateQrPayment(orderId): QrPaymentDto
        +handleQrCallback(orderId, status): void
        +printReceipt(orderId): void
    }
    class ShiftSessionCoordinator {
        <<control>>
        +openShift(dto): ShiftSession
        +closeShift(sessionId, closingCash): ZReportDto
        +getActiveShift(cashierId): ShiftSession
    }
    class DiscountStackingEngine {
        <<application logic>>
        +applyVoucher(voucherCode, cart): CartDto
        +applyLoyaltyPoints(points, cart): CartDto
        +computeFinalTotal(cart): BigDecimal
        +enforceStackingRules(cart): CartDto
    }
    class ShiftReconciliationService {
        <<application logic>>
        +computeExpectedCash(sessionId): BigDecimal
        +computeDiscrepancy(expected, actual): BigDecimal
        +generateZReport(sessionId): ZReportDto
    }

    class ShiftAutoCloseScheduler {
        <<timer>>
        +schedule: "59 23 * * *" (23:59 cron)
        +forceCloseOpenShifts(): void
    }
    class ShiftSession {
        <<entity>>
        +id: UUID
        +storeId: UUID
        +userId: UUID
        +posRegisterId: String
        +startingCash: BigDecimal
        +endingCash: BigDecimal
        +status: ShiftStatus
        +startTime: DateTime
        +endTime: DateTime
    }
    class VietQRClient {
        <<boundary>>
        +generateQrCode(orderId, amount): QrPaymentDto
        +verifyWebhookSignature(payload): Boolean
        +processCallback(payload): PaymentResult
    }
    class PrinterServiceProxy {
        <<boundary>>
        +printReceipt(receiptDto): void
        +printCupLabel(labelDto): void
    }
    class Voucher {
        <<entity>>
        +id: UUID
        +code: String
        +discountType: DiscountType
    }
    class Customer {
        <<entity>>
        +id: UUID
        +loyaltyPoints: Integer
    }
    class SystemConfig {
        <<entity>>
        +configKey: String
        +configValue: String
        +scope: ConfigScope
        +storeId: UUID
    }

    ShiftOpenForm ..> ShiftSessionCoordinator
    ShiftCloseForm ..> ShiftSessionCoordinator
    PosCheckoutGrid ..> CheckoutCoordinator
    PaymentPanel ..> CheckoutCoordinator

    CheckoutCoordinator --> DiscountStackingEngine
    CheckoutCoordinator --> ShiftSession
    CheckoutCoordinator --> VietQRClient
    CheckoutCoordinator --> PrinterServiceProxy
    ShiftSessionCoordinator --> ShiftReconciliationService
    ShiftSessionCoordinator --> ShiftSession
    ShiftAutoCloseScheduler --> ShiftSessionCoordinator
    DiscountStackingEngine --> Voucher
    DiscountStackingEngine --> Customer
    DiscountStackingEngine --> SystemConfig
```

#### ***3.7.2 UC-44 Open Shift***

*\[Cashier opens a new work shift by declaring the opening cash float. Only one OPEN shift is allowed per register per branch at a time (design constraint; see SHIFT statechart §3.7.6). System validates no duplicate active shift before creating the ShiftSession record.\]*

```mermaid
sequenceDiagram
    actor cashier
participant OpenForm as "«boundary»<br/>ShiftOpenForm"
participant ShiftCoord as "«control»<br/>ShiftSessionCoordinator"
participant ShiftDB as "«entity»<br/>ShiftSession (DB)"

    cashier->>OpenForm: inputOpeningCashFloat(openingCash) + register number
    OpenForm->>ShiftCoord: openShift(cashierId, storeId, openingCash, register)
    ShiftCoord->>ShiftDB: findOpenShift(storeId, register)
    ShiftDB-->>ShiftCoord: null (no active shift — OK)
    ShiftCoord->>ShiftDB: createShift(dto, status=OPEN, openedAt=now)
    ShiftDB-->>ShiftCoord: newSession
    ShiftCoord-->>OpenForm: return sessionId + shiftOpenedMsg
    OpenForm-->>cashier: navigate to POS Checkout Grid
```

#### ***3.7.3 UC-48/49/50/51 Full Checkout Pipeline (Cash Payment)***

*\[Cashier builds cart → optionally attaches customer and applies voucher/loyalty points → selects payment method → confirms payment → system creates order, earns loyalty points for customer, writes audit log, and prints receipt + cup label.\]*

```mermaid
sequenceDiagram
    actor cashier
    participant PosGrid as PosCheckoutGrid
participant CheckoutCoord as "«control»<br/>CheckoutCoordinator"
participant DiscountEngine as "«application logic»<br/>DiscountStackingEngine"
participant VoucherDB as "«entity»<br/>Voucher (DB)"
participant CustomerDB as "«entity»<br/>Customer (DB)"
participant OrderDB as "«entity»<br/>Order (DB)"
    participant PayPanel as PaymentPanel
participant PrintSvc as "«boundary»<br/>PrinterServiceProxy"
participant AuditDB as "«entity»<br/>AuditLog (DB)"

    cashier->>PosGrid: add items to cart
    cashier->>PosGrid: (optional) search + attach customer
    cashier->>PosGrid: (optional) enter voucher code
    PosGrid->>CheckoutCoord: applyVoucher(code, cart)
    CheckoutCoord->>DiscountEngine: applyVoucher(code, cart)
    DiscountEngine->>VoucherDB: validateVoucher(code, orderTotal)
    VoucherDB-->>DiscountEngine: voucherRecord (valid + discountValue)
    DiscountEngine-->>CheckoutCoord: updatedCart (discountApplied)

    cashier->>PosGrid: (optional) apply loyalty points
    PosGrid->>CheckoutCoord: applyLoyaltyPoints(customerId, points, cart)
    CheckoutCoord->>DiscountEngine: applyLoyaltyPoints(points, cart)
    DiscountEngine->>CustomerDB: getBalance(customerId)
    DiscountEngine-->>CheckoutCoord: updatedCart (pointsDeducted)

    cashier->>PosGrid: confirm order
    PosGrid->>CheckoutCoord: submitOrder(cart, CASH)
    CheckoutCoord->>OrderDB: createOrder(cart, status=PENDING, payment=PENDING)
    OrderDB-->>CheckoutCoord: newOrder

    cashier->>PayPanel: enter cash received
    PayPanel->>CheckoutCoord: confirmCashPayment(orderId, cashReceived)
    CheckoutCoord->>OrderDB: updatePaymentStatus(COMPLETED)
    CheckoutCoord->>CustomerDB: incrementPoints(customerId, earnedPoints)
    CheckoutCoord->>AuditDB: writeAuditLog(CHECKOUT, voucher/points usage)
    CheckoutCoord->>PrintSvc: printReceipt(orderId)
    CheckoutCoord->>PrintSvc: printCupLabel(orderId)
    CheckoutCoord-->>PayPanel: showChange(cashReceived - totalAmount)
    PayPanel-->>cashier: display change + order goes to barista queue
```

#### ***3.7.4 UC-51 VietQR Payment Flow***

*\[When cashier selects VietQR, system calls VietQR gateway to generate a QR code. Customer scans QR and completes payment in their banking app. Gateway sends a webhook callback. System verifies HMAC signature and marks order as PAID (BR-84/BR-85).\]*

```mermaid
sequenceDiagram
    actor cashier
    actor customer
    participant PayPanel as PaymentPanel
participant CheckoutCoord as "«control»<br/>CheckoutCoordinator"
participant VietQRClient as "«boundary»<br/>VietQRClient"
    participant VietQRGateway as VietQR Gateway (External)
participant OrderDB as "«entity»<br/>Order (DB)"
participant PrintSvc as "«boundary»<br/>PrinterServiceProxy"

    cashier->>PayPanel: select VietQR payment
    PayPanel->>CheckoutCoord: initiateQrPayment(orderId)
    CheckoutCoord->>VietQRClient: generateQrCode(orderId, totalAmount)
    VietQRClient->>VietQRGateway: POST /create-payment (idempotencyKey=orderId)
    VietQRGateway-->>VietQRClient: qrPaymentUrl + transactionRef
    VietQRClient-->>CheckoutCoord: QrPaymentDto
    CheckoutCoord-->>PayPanel: displayQrCode(qrPaymentUrl)
    PayPanel-->>cashier: show QR code on screen

    customer->>VietQRGateway: scan QR + complete bank payment
    VietQRGateway->>CheckoutCoord: POST /api/v1/payments/vietqr/callback (webhook)
    CheckoutCoord->>VietQRClient: verifyWebhookSignature(payload)
    VietQRClient-->>CheckoutCoord: signature valid
    CheckoutCoord->>OrderDB: updatePaymentStatus(COMPLETED, transactionRef)
    CheckoutCoord->>PrintSvc: printReceipt(orderId)
    CheckoutCoord->>PrintSvc: printCupLabel(orderId)
    CheckoutCoord-->>PayPanel: notifyPaidSuccess()
    PayPanel-->>cashier: show "Payment Received" confirmation
```

#### ***3.7.5 UC-53 Close Shift (Z-Report)***

*\[Cashier declares the closing cash amount. System computes expected cash from all CASH orders in the shift, calculates discrepancy, generates Z-Report, and sets shift to CLOSED. ShiftAutoCloseScheduler forces close at 23:59 if cashier forgets.\]*

```mermaid
sequenceDiagram
    actor cashier
participant CloseForm as "«boundary»<br/>ShiftCloseForm"
participant ShiftCoord as "«control»<br/>ShiftSessionCoordinator"
participant ReconcileSvc as "«application logic»<br/>ShiftReconciliationService"
participant OrderDB as "«entity»<br/>Order (DB)"
participant ShiftDB as "«entity»<br/>ShiftSession (DB)"

    cashier->>CloseForm: enter closing cash amount
    CloseForm->>ShiftCoord: closeShift(sessionId, closingCash)
    ShiftCoord->>ReconcileSvc: computeExpectedCash(sessionId)
    ReconcileSvc->>OrderDB: sumCashPayments(sessionId, status=PAID)
    OrderDB-->>ReconcileSvc: totalCashSales
    ReconcileSvc->>ReconcileSvc: expectedCash = openingCash + totalCashSales - refunds
    ReconcileSvc->>ReconcileSvc: discrepancy = closingCash - expectedCash
    ReconcileSvc->>ReconcileSvc: generateZReport(sessionId, summary)
    ReconcileSvc-->>ShiftCoord: ZReportDto
    ShiftCoord->>ShiftDB: updateShift(sessionId, closingCash, status=CLOSED, closedAt=now)
    ShiftCoord-->>CloseForm: displayZReport(ZReportDto)
    CloseForm-->>cashier: displayZReport(ZReportDto)
```

#### ***3.7.6 SHIFT Session Statechart***

*\[A ShiftSession follows a simple 2-state lifecycle: OPEN → CLOSED. Only one shift can be OPEN per register per branch. ShiftAutoCloseScheduler forces CLOSED at 23:59 daily for any session still OPEN (BR-88).\]*

```mermaid
stateDiagram-v2
    [*] --> OPEN : openShift()

    OPEN --> CLOSED : closeShift()

    OPEN --> CLOSED : timeTrigger [23:59]

    CLOSED --> [*] : archive()
```

