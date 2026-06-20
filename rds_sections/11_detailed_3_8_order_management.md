### **3.8 Order Management**

*\[Provide the detailed design for Order Management, covering UC-57 (View Order Queue Display), UC-58 (Update Preparation Status by barista), UC-55 (Cancel PENDING Order / Request Transaction Refund by cashier), UC-75 (SM-Authorized Refund/Comp), and the automated READY auto-abandon (BR-88). Actors: cashier (cancel PENDING only), storemanager (refund/comp authorization), barista (queue display + status transitions), system scheduler (auto-abandon after READY_ABANDON_TIMEOUT). The ORDER statechart documents all 7 valid states and their transitions.\]*

#### ***3.8.1 Class Diagram***

*\[Class diagram for Order Management. COMET stereotypes: OrderQueueView, BaristaQueueMonitor, CancellationDialog, RefundAuthDialog («boundary»); OrderCoordinator, OrderQueueCoordinator («control»); OrderTimeoutScheduler («timer»); Order, OrderItem, OrderItemTopping, OrderCancellation, OrderRefund («entity»).\]*

```mermaid
classDiagram
    class OrderQueueView {
        <<boundary>>
        +storeId: UUID
        +statusFilter: OrderStatus
        +displayOrders()
    }
    class BaristaQueueMonitor {
        <<boundary>>
        +displayPendingQueue()
        +updateStatus(orderId, status)
    }
    class CancellationDialog {
        <<boundary>>
        +orderId: UUID
        +reason: CancelReason
        +notes: String
        +confirmCancel()
    }
    class RefundAuthDialog {
        <<boundary>>
        +orderId: UUID
        +refundType: RefundType
        +amount: BigDecimal
        +smApprovalPin: String
        +submitRefund()
    }
    class OrderCoordinator {
        <<control>>
        +getOrderQueue(storeId, filter): List~OrderDto~
        +updateOrderStatus(orderId, newStatus): OrderDto
        +cancelOrder(dto): OrderCancellation
        +authorizeRefund(dto): OrderRefund
    }
    class OrderQueueCoordinator {
        <<control>>
        +getActiveQueue(storeId): List~OrderDto~
        +pushStatusUpdate(orderId, status): void
    }
    class OrderTimeoutScheduler {
        <<timer>>
        +checkInterval: "*/1 * * * *" (every 1 min)
        +scanReadyOrders(): void
        +onTimeout(orderId): void
    }
    class Order {
        <<entity>>
        +id: UUID
        +storeId: UUID
        +orderNumber: String
        +shiftSessionId: UUID
        +customerId: UUID
        +voucherId: UUID
        +orderType: OrderType
        +status: OrderStatus
        +paymentStatus: PaymentStatus
        +paymentMethod: PaymentMethod
        +subtotal: BigDecimal
        +discount: BigDecimal
        +taxAmount: BigDecimal
        +total: BigDecimal
        +createdAt: DateTime
    }
    class OrderItem {
        <<entity>>
        +id: UUID
        +orderId: UUID
        +menuItemId: UUID
        +quantity: Integer
        +unitPrice: BigDecimal
    }
    class OrderItemTopping {
        <<entity>>
        +id: UUID
        +orderItemId: UUID
        +toppingId: UUID
        +quantity: Integer
        +unitPrice: BigDecimal
    }
    class OrderCancellation {
        <<entity>>
        +id: UUID
        +orderId: UUID
        +cashierId: UUID
        +reason: CancelReason
        +notes: String
        +cancelledAt: DateTime
    }
    class OrderRefund {
        <<entity>>
        +id: UUID
        +orderId: UUID
        +smId: UUID
        +cashierId: UUID
        +shiftSessionId: UUID
        +refundType: RefundType
        +amount: BigDecimal
        +reason: String
        +notes: String
        +createdAt: DateTime
    }

    OrderQueueView ..> OrderCoordinator
    BaristaQueueMonitor ..> OrderQueueCoordinator
    CancellationDialog ..> OrderCoordinator
    RefundAuthDialog ..> OrderCoordinator
    OrderTimeoutScheduler --> OrderCoordinator
    OrderCoordinator --> Order
    OrderCoordinator --> OrderItem
    OrderCoordinator --> OrderCancellation
    OrderCoordinator --> OrderRefund
    OrderQueueCoordinator --> Order
    Order *-- OrderItem
    Order *-- OrderCancellation
    Order *-- OrderRefund
    OrderItem *-- OrderItemTopping
```

#### ***3.8.2 UC-55 Cancel PENDING Order***

*\[Only PENDING orders can be cancelled by cashier (BR-05). The cancellation creates an immutable OrderCancellation record with the reason code and notes. Order status transitions to CANCELLED. Cancelled orders cannot be reopened.\]*

```mermaid
sequenceDiagram
    actor cashier
participant CancelDialog as "«boundary»<br/>CancellationDialog"
participant OrderCoord as "«control»<br/>OrderCoordinator"
participant OrderDB as "«entity»<br/>Order (DB)"
participant CancelDB as "«entity»<br/>OrderCancellation (DB)"

    cashier->>CancelDialog: inputCancellationDetails(orderId, reason, notes)
    CancelDialog->>OrderCoord: cancelOrder(dto)
    OrderCoord->>OrderDB: findById(orderId)
    OrderDB-->>OrderCoord: orderRecord
    OrderCoord->>OrderCoord: verifyStatus(order.status == PENDING)
    OrderCoord->>OrderDB: updateStatus(orderId, CANCELLED)
    OrderCoord->>CancelDB: createCancellation(orderId, cashierId, reason, notes, now)
    CancelDB-->>OrderCoord: cancellationRecord
    OrderCoord-->>CancelDialog: showCancellationSuccess()
    CancelDialog-->>cashier: displaySuccess()
```

#### ***3.8.3 UC-75 SM-Authorized Refund / Comp Remake***

*\[For post-PENDING complaints (e.g., wrong order already prepared), only storemanager can authorize a REFUND or COMP_REMAKE (BR-67). SM enters their PIN to authorize. System creates an immutable OrderRefund record. A CASH refund debits the currently-open shift drawer (BR-09) and stamps `shift_session_id`; card/VietQR refunds go via the gateway with no drawer impact. Loyalty points earned/redeemed on the original order are reversed per BR-08. For COMP_REMAKE type, a new duplicate order is created in PENDING status.\]*

```mermaid
sequenceDiagram
    actor cashier
    actor storemanager
participant RefundDialog as "«boundary»<br/>RefundAuthDialog"
participant OrderCoord as "«control»<br/>OrderCoordinator"
participant UserDB as "«entity»<br/>User (DB)"
participant OrderDB as "«entity»<br/>Order (DB)"
participant RefundDB as "«entity»<br/>OrderRefund (DB)"
participant ShiftDB as "«entity»<br/>ShiftSession (DB)"
participant CustomerDB as "«entity»<br/>Customer (DB)"

    cashier->>RefundDialog: inputRefundDetails(orderId, refundType, amount)
    RefundDialog->>RefundDialog: requestSmPin()
    storemanager->>RefundDialog: inputSmPin(smPin)
    RefundDialog->>OrderCoord: authorizeRefund(dto, smPin)
    OrderCoord->>UserDB: verifySmPin(smId, smPin)
    UserDB-->>OrderCoord: authenticated
    OrderCoord->>OrderDB: findById(orderId)
    OrderDB-->>OrderCoord: orderRecord

    alt CASH refund (BR-09)
        OrderCoord->>ShiftDB: getOpenShift(storeId)
        ShiftDB-->>OrderCoord: openShift (drawer to debit)
        Note over OrderCoord, ShiftDB: refund debits the currently-open drawer; shift_session_id stamped
    else CARD / VietQR refund
        Note over OrderCoord: gateway refund API — no drawer impact
    end

    OrderCoord->>RefundDB: createRefund(orderId, smId, cashierId, shiftSessionId, refundType, amount, reason, notes, now)
    RefundDB-->>OrderCoord: refundRecord
    OrderCoord->>CustomerDB: reverseLoyalty(orderId) (BR-08)

    alt REFUND type
        OrderCoord->>OrderDB: flagRefunded(orderId)
    else COMP_REMAKE type
        OrderCoord->>OrderDB: createNewOrder(cloneOf=orderId, status=PENDING)
    end

    OrderCoord-->>RefundDialog: showRefundSuccess(refundRecord)
    RefundDialog-->>cashier: displaySuccess()
```

#### ***3.8.4 Auto-Abandon READY Orders (OrderTimeoutScheduler, BR-88 — automated)***

*\[READY orders not picked up within `READY_ABANDON_TIMEOUT` are automatically set to ABANDONED by the OrderTimeoutScheduler (BR-88). This is an automated system function (not a user use case). It prevents stale orders from persisting indefinitely in the barista queue.\]*

```mermaid
sequenceDiagram
participant TimeoutScheduler as "«timer»<br/>OrderTimeoutScheduler"
participant OrderCoord as "«control»<br/>OrderCoordinator"
participant OrderDB as "«entity»<br/>Order (DB)"

    loop every 1 minute
        TimeoutScheduler->>OrderDB: findReadyOrdersOlderThan(15min)
        OrderDB-->>TimeoutScheduler: expiredOrders[]

        loop for each expiredOrder
            TimeoutScheduler->>OrderCoord: updateOrderStatus(orderId, ABANDONED)
            OrderCoord->>OrderDB: updateStatus(orderId, ABANDONED)
        end
    end
```

#### ***3.8.5 ORDER Lifecycle Statechart***

*\[The Order has 7 states. Transitions are enforced by OrderCoordinator. The HOLD state is triggered when a preparation issue is reported by the Barista (reportIssue()). ABANDONED is reached two ways (BR-88): system-triggered after `READY_ABANDON_TIMEOUT` in READY state, or Store-Manager force-close of remaining READY orders at shift close. CANCELLED and ABANDONED are terminal states.\]*

```mermaid
stateDiagram-v2
    [*] --> PENDING : submitCheckout() / status = PENDING

    PENDING --> IN_PROGRESS : startPreparation() / deductStock()
    PENDING --> CANCELLED : cancelOrder(reason) [status == PENDING] / logCancellation()

    state IN_PROGRESS {
        [*] --> PREPARING
        PREPARING --> HOLD : reportIssue()
        HOLD --> PREPARING : resolveIssue()
        PREPARING --> READY : completePreparation()
    }

    IN_PROGRESS --> COMPLETED : confirmPickup() [status == READY] / status = COMPLETED
    IN_PROGRESS --> ABANDONED : timeTrigger [elapsedTime >= READY_ABANDON_TIMEOUT] / status = ABANDONED
    IN_PROGRESS --> ABANDONED : forceCloseAtShiftClose() [isStoreManager == true] / status = ABANDONED

    COMPLETED --> [*] : archive()
    CANCELLED --> [*] : archive()
    ABANDONED --> [*] : archive()
```

