# 3.6 POS Transaction

This section details specifications for cashier POS checkout sessions, order processing, and cash reconciliation.

---

## 3.6.1 F28 - Open Shift / UC-44 Open Shift

### 3.6.1.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|             Open Shift             |
|                                    |
|  Register ID                       |
|  [ REG-01                      ][v]|
|                                    |
|  Starting Cash Float (VND)         |
|  [ 1,000,000                     ] |
|                                    |
|         [ START SESSION ]          |
|                                    |
+------------------------------------+
```

#### Table 3-29: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Register ID | Dropdown | Yes | | POS Terminal/Register selection. |
| 2 | Starting Cash Float | Text | Yes | 15 | Opening cash drawer float amount in VND. |
| 3 | Start Session | Button | | | Opens the shift session and registers terminal. |

### 3.6.1.2 Use Case Description

| Use Case ID | UC-44 | Use Case Name | Open Shift |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Cashier |
| **Description** | Commences a cashier's work session and registers the opening drawer float. |
| **Precondition** | Cashier has no active open shifts, and the selected register is free. |
| **Trigger** | Cashier signs into POS terminal. |
| **Post-Condition** | A new shift session is initialized. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Cashier | Selects register ID, enters starting cash float, and clicks "Start Session". |
| 2 | Portal | Validates register is free, and starting cash is positive/zero. |
| 3 | Portal | Opens the work session, records starting cash float and timestamp, and redirects to sales grid. |

#### Alternative Flows
##### AT1: Register Already Busy
- **Trigger**: At step 2, register has another active open shift session.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"POS register [ID] already has an active open shift. Please close the active shift first."` |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-33 | Starting cash float must be greater than or equal to zero. |

---

## 3.6.2 F29 - POS Checkout Grid / UC-45 Add Item, UC-46 Update Cart, UC-47 Search Item

### 3.6.2.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
| POS POS-01 [Search item/SKU...] [s] |
+------------------------------------+
| [Menu Category Grid]               |
| [ Coffee ] [ Tea ] [ Pastry ]      |
|                                    |
| +--------------------------------+ |
| | Espresso              30k  [+] | |
| | Peach Tea             35k  [+] | |
| +--------------------------------+ |
|                                    |
| Items Cart:                        |
| - Espresso x 1 (No sugar)      30k |
|                                    |
| Subtotal:                   30,000 |
| Discount:                        0 |
| Net Total:                  30,000 |
|                                    |
|   [ Customer ]   [ Promo ] [ PAY ] |
+------------------------------------+
```

#### Table 3-30: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Search/SKU | Text | No | 100 | Fast search autocomplete or barcode scan lookup. |
| 2 | Plus [+] | Button | | | Adds selected item to checkout cart. |
| 3 | Customer | Button | | | Opens Customer Search modal. |
| 4 | Promo | Button | | | Opens Apply Voucher modal. |
| 5 | PAY | Button | | | Navigates to Payment screen. |

### 3.6.2.2 Use Case Description

| Use Case ID | UC-45 | Use Case Name | Add Item to Order |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Cashier |
| **Description** | Assembles products and customizations into the active checkout basket. |
| **Precondition** | Active shift session is open. |
| **Trigger** | Cashier taps menu item or scans barcode. |
| **Post-Condition** | Cart subtotal and items details are updated. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Cashier | Selects product, sets customizations/modifiers, and adds to cart. |
| 2 | Portal | Validates availability, updates cart contents, and recalculates totals. |

---

## 3.6.3 F30 - Lookup Customer Membership / UC-50 Lookup Customer Membership

### 3.6.3.1 Screen Mock-up (Mobile Portrait Modal)
```
+------------------------------------+
|         Customer Search            |
|                                    |
|  Phone Number                      |
|  [ 0987654321                    ] |
|                                    |
|         [ SEARCH CUSTOMER ]        |
|                                    |
|  Result:                           |
|  Name: Nguyen Van A                |
|  Tier: Gold (10% Tier Discount)    |
|  Points: 340                       |
|                                    |
|         [ LINK TO CART ]           |
|         [ ADD NEW CUSTOMER ]       |
|         [ CANCEL ]                 |
+------------------------------------+
```

#### Table 3-31: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Phone Number | Text | Yes | 20 | Look up membership details using phone number. |
| 2 | Search Customer | Button | | | Executes search registry lookup. |
| 3 | Link to Cart | Button | | | Links identified customer to current order checkout. |
| 4 | Add New Customer | Button | | | Opens Add Customer view modal. |
| 5 | Cancel | Button | | | Closes modal window. |

### 3.6.3.2 Use Case Description

| Use Case ID | UC-50 | Use Case Name | Lookup Customer Membership |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Cashier |
| **Description** | Identifies customer loyalty profiles to track points and apply tier-based discounts. |
| **Precondition** | Order cart is active. |
| **Trigger** | Cashier clicks "Customer" link button. |
| **Post-Condition** | Customer loyalty details are linked to order. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Cashier | Enters customer phone number and clicks "Search Customer". |
| 2 | Portal | Performs registry lookup. |
| 3 | Portal | Displays profile details (Name, Tier, Points) and Cashier clicks "Link to Cart" to apply discounts. |

#### Alternative Flows
##### AT1: Customer Offline Fallback
- **Trigger**: At step 2, POS terminal has no internet connection.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Looks up number in local offline cache storage. |
| 2.2 | Portal | If missing, cashier enters phone number to save locally for retroactive point accumulation once online. |

---

## 3.6.4 F31 - Apply Voucher / UC-48 Apply Discount Code

### 3.6.4.1 Screen Mock-up (Mobile Portrait Modal)
```
+------------------------------------+
|           Apply Voucher            |
|                                    |
|  Enter Voucher Code                |
|  [ COFFEE20                      ] |
|                                    |
|         [ VALIDATE & APPLY ]       |
|                                    |
|  Active Promos:                    |
|  [ ] COFFEE10 (10% off)            |
|  [ ] SPRING50 (Flat 50k off)       |
|                                    |
|         [ CONFIRM ]   [ CLOSE ]    |
+------------------------------------+
```

#### Table 3-32: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Voucher Code | Text | No | 50 | Alphanumeric coupon code. |
| 2 | Validate & Apply | Button | | | Verifies voucher parameters and applies discount. |
| 3 | Confirm | Button | | | Saves voucher link. |
| 4 | Close | Button | | | Closes modal window. |

### 3.6.4.2 Use Case Description

| Use Case ID | UC-48 | Use Case Name | Apply Discount Code |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Cashier |
| **Description** | Validates and applies voucher parameters to the transaction cart. |
| **Precondition** | Order cart is active. |
| **Trigger** | Cashier clicks "Promo" button. |
| **Post-Condition** | Discount rate is applied to subtotal. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Cashier | Enters coupon code (or selects active listing) and clicks "Validate & Apply". |
| 2 | Portal | Validates dates, minimum totals, and customer usage limits. |
| 3 | Portal | Updates order net total to reflect discount. |

#### Alternative Flows
##### AT1: Minimum Order Value Not Met
- **Trigger**: At step 2, subtotal is lower than voucher threshold.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays warning message: `"Order value does not meet the minimum requirement of [X] VND for this voucher."` |

##### AT2: Offline Mode Voucher Processing
- **Trigger**: At step 2, the POS terminal has lost internet connection.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Bypasses online validation APIs. Only validates against preloaded local offline voucher codes in local storage. |
| 2.2 | Portal | If the code is not found locally, displays warning: `"Online validation unavailable. Voucher not recognized locally."` |

---

## 3.6.5 F31.1 - Redeem Loyalty Points / UC-49 Redeem Loyalty Points

### 3.6.5.1 Screen Mock-up (Mobile Portrait Modal)
```
+------------------------------------+
|        Redeem Loyalty Points       |
|                                    |
|  Customer: Nguyen Van A (Gold)     |
|  Available Points: 340             |
|                                    |
|  Points to Redeem (100pt = 10k):   |
|  [ 100                           ] |
|  = Equivalent Discount: 10,000 VND |
|                                    |
|         [ APPLY DISCOUNT ]         |
|         [ CANCEL ]                 |
+------------------------------------+
```

#### Table 3-33: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Customer Info | Label | | | Displays linked customer name and active membership tier. |
| 2 | Available Points | Label | | | Displays customer's available points balance. |
| 3 | Points to Redeem | Text | Yes | 6 | Input field for loyalty points to redeem (multiples of 100). |
| 4 | Apply Discount | Button | | | Submits points redemption discount to cart. |
| 5 | Cancel | Button | | | Closes modal window without changes. |

### 3.6.5.2 Use Case Description

| Use Case ID | UC-49 | Use Case Name | Redeem Loyalty Points |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Cashier |
| **Description** | Redeems customer loyalty points for a cash discount at checkout. |
| **Precondition** | Customer membership is looked up, linked to the cart, has reached at least the **Silver** tier, and has at least **100** points. |
| **Trigger** | Cashier clicks "Redeem Points" button from cart options. |
| **Post-Condition** | Equivalent points discount is applied to checkout total. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Cashier | Enters quantity of points to redeem (e.g. 100) and clicks "Apply Discount". |
| 2 | Portal | Validates point balance is sufficient, user is at least Silver tier, and value is a multiple of 100. |
| 3 | Portal | Computes equivalent cash discount (10,000 VND per 100 points) and deducts points from active totals. |

#### Alternative Flows
##### AT1: Insufficient Points
- **Trigger**: At step 2, entered points exceed available balance.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"Insufficient points balance."` (MSG11) |

##### AT2: Ineligible Membership Tier
- **Trigger**: At step 2, the linked customer is in the Bronze membership tier.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"Insufficient points balance or membership tier ineligible for redemption."` (MSG11) |

##### AT3: Invalid Points Multiple
- **Trigger**: At step 2, entered points value is not a multiple of 100.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"Redemption points must be in multiples of 100."` (MSG14) |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-02 | 100 points can be redeemed for 10,000 VND discount at checkout, applicable only for customers who have reached at least the **Silver** tier. Point redemption must be in multiples of 100. |

---

## 3.6.6 F32 - Process Payment / UC-51 Process Payment

### 3.6.6.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|              Payment               |
|                                    |
|  Total Amount: 30,000 VND          |
|                                    |
|  Payment Method:                   |
|  ( ) Cash    ( ) Card              |
|  (x) VietQR  ( ) ShopeeFood        |
|                                    |
|  +------------------------------+  |
|  |                              |  |
|  |         [ VietQR QR ]        |  |
|  |         Dynamic QR           |  |
|  |                              |  |
|  +------------------------------+  |
|                                    |
|     [ CANCEL ]    [ RETRY QR ]     |
+------------------------------------+
```

#### Table 3-34: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Payment Method | Radio | Yes | | Selects method: `CASH`, `CARD`, `VIETQR`, `SHOPEEFOOD`. |
| 2 | Cash Received | Text | Yes | 15 | Mandatory only for Cash method to compute change. |
| 3 | Cancel | Button | | | Cancels active payment flow and returns to cart. |
| 4 | Retry QR | Button | | | Regenerates dynamic payment code request. |

### 3.6.6.2 Use Case Description

| Use Case ID | UC-51 | Use Case Name | Process Payment |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Cashier |
| **Description** | Records order payment and updates transactional status. |
| **Precondition** | Order cart is finalized. |
| **Trigger** | Cashier taps "PAY" button. |
| **Post-Condition** | Order payment is recorded, points accumulated, and printing triggered. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Cashier | Selects payment method and initiates transaction. |
| 2 | Portal | Generates payment gateway endpoint (for QR/Wallet) or registers Cash drawer float logic. |
| 3 | Portal | Verifies successful receipt confirmation, records transaction, and prints invoice. |

#### Alternative Flows
##### AT1: Gateway Timeout
- **Trigger**: At step 2, online payment callback is not received within 60 seconds.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays warning message: `"Payment gateway timeout. Please check customer transaction status or retry."` |

---

## 3.6.7 Discount Priority & Stacking Rules

This section outlines the business logic for calculating and applying discounts at checkout when multiple offers, vouchers, or points-redemptions overlap.

### 1. Stacking Rules & Restrictions
- **Voucher and Membership Tier Discount Exclusivity**: Percentage-based or flat-rate **Voucher discounts** and **Membership Tier discounts** DO NOT stack. 
  - The system compares the discount value of the linked membership tier against the active voucher discount and applies the one that yields the higher discount value.
  - **Both discount types must first be converted to VND before comparison:** `Tier Discount (VND) = Gross Subtotal × Tier Percent / 100`; `Voucher Discount (VND) = (type == PERCENT) ? Gross Subtotal × Value / 100 : Flat VND Amount`.
  - If a customer applies a voucher but the membership tier discount is higher, the system applies the membership tier discount instead.
  - **Tie-breaking rule**: If `Tier Discount (VND) == Voucher Discount (VND)`, the Voucher discount takes priority.
- **Loyalty Point Redemption Stackability**: Loyalty point redemptions (e.g. redeeming 100 points for a flat 10,000 VND discount) CAN stack with either a membership tier discount OR an active voucher discount.
- **Order of Calculations**:
  1. **Gross Subtotal**: Sum of the base prices of all selected menu items plus any applied custom toppings or option modifiers.
  2. **Campaign / Tier Discount (Exclusivity applied)**:
     - `Tier Discount (VND) = Gross Subtotal × Tier Percent / 100`
     - `Voucher Discount (VND) = (type == PERCENT) ? Gross Subtotal × Value / 100 : Flat VND`
     - `Selected Discount = Max(Tier Discount VND, Voucher Discount VND)` *(Voucher wins on tie)*
     - `Discounted Subtotal = Gross Subtotal - Selected Discount`
  3. **Loyalty Point Redemption**:
     - `Point Discount Value = (Redeemed Points / 100) * 10,000 VND`
     - `Final Taxable Subtotal = Max(0, Discounted Subtotal - Point Discount Value)`
  4. **Tax Calculations (10% VAT)**:
     - The active VAT rate (configured globally between 0% and 20%) is applied.
     - VAT is **inclusive** in final retail menu pricing. The stored `tax_amount` field is extracted as follows:
       - `tax_amount = Final Taxable Subtotal * (VAT_Rate / (100 + VAT_Rate))`
       - For standard 10% VAT: `tax_amount = Final Taxable Subtotal * 10/110`
       - `Net Total Payable = Final Taxable Subtotal` (representing the total cash/card/QR amount collected).
  5. **Discount Cap (BR-50)**: Net Total Payable cannot be negative. If the combined discounts exceed Gross Subtotal, Net Total Payable is set to 0 VND.

---

## 3.6.8 F33 - Issue Invoice / UC-52 Issue Invoice

### 3.6.8.1 Screen Mock-up (Mobile Portrait Print Confirmation)
```
+------------------------------------+
|           Invoice Print            |
|                                    |
|         Printing Invoice...        |
|         Order Number: #012         |
|                                    |
|  +------------------------------+  |
|  | COFFEE ZONE                    |  |
|  | Store #1 - 123 Street          |  |
|  | order: #012 (UUID: ...789)     |  |
|  | 1x Espresso            27,273  |  |
|  | ------------------------------ |  |
|  | Subtotal (excl. VAT):  27,273  |  |
|  | VAT (10%):              2,727  |  |
|  | Total:                 30,000  |  |
|  +------------------------------+  |
|                                    |
|         [ DONE ]   [ REPRINT ]     |
+------------------------------------+
```

#### Table 3-35: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Done | Button | | | Completes order flow and opens blank checkout screen. |
| 2 | Reprint | Button | | | Resends ticket parameters to print queue. |

### 3.6.8.2 Use Case Description

| Use Case ID | UC-52 | Use Case Name | Issue Invoice |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Cashier |
| **Description** | Generates and prints the receipt and sequential stickers for the customer. |
| **Precondition** | Order payment is successfully completed. |
| **Trigger** | Auto-triggered upon successful payment completion. |
| **Post-Condition** | Physical print queue receives transaction layout. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Portal | Sends ticket details (Store title, Order number, items count, cashier ID, loyalty summaries) to printer. |
| 2 | Cashier | Hands receipt printout to customer. |

---

## 3.6.9 F34 - Close Shift / UC-53 Close Shift

### 3.6.9.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|            Close Shift             |
|                                    |
|  Cashier ID: cashier_01            |
|  Register: REG-01                  |
|                                    |
|  Expected Cash: 2,500,000 VND      |
|  Actual Cash Counted:              |
|  [ 2,500,000                     ] |
|                                    |
|  Discrepancy Notes:                |
|  [                               ] |
|                                    |
|         [ CLOSE SESSION ]          |
+------------------------------------+
```

#### Table 3-36: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Actual Cash Counted | Text | Yes | 15 | Drawer cash count in VND at end of shift. |
| 2 | Discrepancy Notes | Text | No | 250 | Mandatory input if expected cash does not match actual cash. |
| 3 | Close Session | Button | | | Logs close timestamps and shifts cashier status. |

### 3.6.9.2 Use Case Description

| Use Case ID | UC-53 | Use Case Name | Close Shift |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Cashier |
| **Description** | Ends the cashier session, records ending cash drawer float, and audits discrepancies. |
| **Precondition** | All shift orders must be in final states (`COMPLETED` or `CANCELLED`). |
| **Trigger** | Cashier logs out of shift menu. |
| **Post-Condition** | Session status is CLOSED. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Cashier | Counts cash, enters Actual Cash Counted, and inputs discrepancy explanation notes (if any). |
| 2 | Cashier | Taps "Close Session". |
| 3 | Portal | Closes shift, records data, and prints shift reports. |

#### Alternative Flows
##### AT1: Cashier Disputes Discrepancy
- **Trigger**: At step 1, the actual counted cash does not match the expected cash count calculated by the system.

| Sub-step | Actor | Action |
|---|---|---|
| 1.1 | Portal | Flags the discrepancy. Displays expected cash value and counted float input box. |
| 1.2 | Cashier | Enters counted cash, and inputs detailed discrepancy/dispute explanations in the mandatory discrepancy notes field. |
| 1.3 | Cashier | Submits shift closure. The system logs the disputed amount, closes the shift, and immediately escalates a discrepancy alert to the Store Manager (BR-04). |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-03 | A cashier cannot close a shift unless all orders associated with their shift ID are marked with terminal states (`COMPLETED` or `CANCELLED`). Cashier cannot close shift if there are active order queue items pending preparation/delivery. |
| BR-04 | Any cash discrepancy exceeding 100,000 VND must be flagged and automatically emailed to the Store Manager. |




