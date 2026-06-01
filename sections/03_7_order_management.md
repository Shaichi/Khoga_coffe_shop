# 3.7 Order Management

This section details specifications for tracking orders, barista queue controls, stickers printing, and cancellation flows.

### Order Status State Machine

All orders follow the state transitions below:

```
[PENDING] ---(Barista: START PREP)---> [PREPARING]
             \--(Cashier cancel)------> [CANCELLED]

[PREPARING] --(Barista: READY)--------> [READY]
             \--(Manager/Admin cancel)-> [CANCELLED]
             \--(Barista: REPORT ISSUE)-> [ON_HOLD]

[ON_HOLD] ----(Barista: RESUME PREP)--> [PREPARING]
           \--(Manager/Admin cancel)---> [CANCELLED]

[READY] -----(Cashier: payment done)--> [COMPLETED]
         \--(Manager/Admin cancel)------> [CANCELLED]

[COMPLETED] → Terminal state (no further transitions)
[CANCELLED]  → Terminal state (no further transitions)
```

> **ON_HOLD state:** Triggered by the Barista via the "Report Issue" action when a preparation problem occurs (missing ingredient, equipment fault, etc.). An ON_HOLD order remains visible in the Barista queue with a highlighted warning indicator. The Store Manager or Admin must be notified. The Barista can resume preparation (→ PREPARING) once the issue is resolved, or the Manager/Admin can cancel the order.

---

## 3.7.1 F35 - View Order List / UC-40/54 View Order List

### 3.7.1.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|             Order List             |
|                                    |
|  Search: [ #012                  ] |
|  Status: [ All Statuses      ][v]  |
|                                    |
|  - Order #012 (Dine-in)       30k  |
|    Status: Preparing  (09:15)      |
|                                    |
|  - Order #011 (Take-away)    120k  |
|    Status: Ready      (09:05)      |
|                                    |
|                        [ Back ]    |
+------------------------------------+
```

#### Table 3-35: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Search | Text | No | 50 | Search by Order ID, sequence number, or customer name. |
| 2 | Status | Dropdown | Yes | | Filters list by order status. |
| 3 | Back | Button | | | Returns to dashboard portal. |

### 3.7.1.2 Use Case Description

| Use Case ID | UC-54 | Use Case Name | View Local Order History |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Cashier, Store Manager, Barista |
| **Description** | Displays local branch orders processed during the current shift. |
| **Precondition** | User is logged in. |
| **Trigger** | User navigates to Order History. |
| **Post-Condition** | Displays local order list grid. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | User | Opens Order History screen. |
| 2 | Portal | Displays current branch orders list. |

---

## 3.7.2 F36 - View Order Detail / UC-40/54 View Order Detail

### 3.7.2.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|            Order Detail            |
|                                    |
|  Order Number: #012                |
|  ID: ORD-7890                      |
|  Type: Dine-in   Time: 09:15       |
|  Status: Preparing                 |
|                                    |
|  Items:                            |
|  - 1x Espresso (No sugar)      30k |
|                                    |
|  Total Paid: 30,000 VND (VietQR)   |
|                                    |
|       [ CANCEL ]    [ REPRINT ]    |
|                 [ BACK ]           |
+------------------------------------+
```

#### Table 3-36: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Cancel | Button | | | Opens Cancel Order view screen. |
| 2 | Reprint | Button | | | Resends ticket template data to receipt printer. |
| 3 | Back | Button | | | Returns to Order List screen. |

### 3.7.2.2 Use Case Description

| Use Case ID | UC-54b | Use Case Name | View Order Detail |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Cashier, Store Manager, Barista |
| **Description** | Displays receipt details, payments, and fulfillment tracking metrics for an order. |
| **Precondition** | Order exists. |
| **Trigger** | User taps an order row. |
| **Post-Condition** | Displays detail card. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | User | Taps on specific order. |
| 2 | Portal | Displays details, payments log, and order item list. |

---

## 3.7.3 F37 - View Order Queue Display / UC-57 View Order Queue

### 3.7.3.1 Screen Mock-up (Mobile Landscape / Tablet)
```
+------------------------------------+
|           Barista Queue            |
|                                    |
|  - [ Preparing ] Order #012 (09:15)|
|    1x Espresso (No sugar)          |
|    [ READY ]      [ REPORT ISSUE ] |
|                                    |
|  - [ Pending ] Order #013   (09:20)|
|    1x Latte (Oat Milk)             |
|    [ START PREP ]                  |
+------------------------------------+
```

#### Table 3-37: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | START PREP | Button | | | Transitions order status from Pending to Preparing. |
| 2 | READY | Button | | | Transitions order status from Preparing to Ready and prints stickers. |
| 3 | REPORT ISSUE | Button | | | Puts order on Hold due to prep issue. |

### 3.7.3.2 Use Case Description

| Use Case ID | UC-57 | Use Case Name | View Order Queue Display |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Barista |
| **Description** | Displays queue of active preparation orders sorted by oldest first. |
| **Precondition** | Barista is logged in. |
| **Trigger** | Barista accesses the queue dashboard. |
| **Post-Condition** | Queue is displayed. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Barista | Opens the queue display. |
| 2 | Portal | Displays pending, preparing, and ready orders. |

---

## 3.7.4 F38 - Print Drink Label Sticker / UC-59 Print Drink Label Sticker

### 3.7.4.1 Screen Mock-up (Mobile Portrait Popup)
```
+------------------------------------+
|            Print Label             |
|                                    |
|       Print Sticker for drink:     |
|       Espresso - Order #012        |
|                                    |
|         [ PRINT ]   [ CLOSE ]      |
+------------------------------------+
```

#### Table 3-38: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Print | Button | | | Dispatches print job to sticker printer. |
| 2 | Close | Button | | | Closes modal window. |

### 3.7.4.2 Use Case Description

| Use Case ID | UC-59 | Use Case Name | Print Drink Label Sticker |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Barista |
| **Description** | Prints cup stickers to identify beverage customization details. |
| **Precondition** | Order details are loaded. |
| **Trigger** | Barista clicks Print Sticker for drink item. |
| **Post-Condition** | Label is printed. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Barista | Taps Print Sticker. |
| 2 | Portal | Dispatches item properties (Order number, modifications, time) to printer. |

---

## 3.7.5 F39 - Cancel Order / UC-43, UC-55 Request Refund & Cancellation

### 3.7.5.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|            Cancel Order            |
|                                    |
|  Reason for Cancellation           |
|  [ Out of Milk ingredient      ][v]|
|                                    |
|  Notes:                            |
|  [ Discarded order, customer refund] |
|                                    |
|  Manager Pin Code:                 |
|  [ ****                          ] |
|                                    |
|       [ CONFIRM ]   [ CLOSE ]      |
+------------------------------------+
```

#### Table 3-39: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Reason | Dropdown | Yes | | Cancellation reason mapping. |
| 2 | Notes | Text | Yes | 250 | Audit explanation. |
| 3 | Manager Pin Code | Password | Yes | 4 | Required for cashier overrides or refunds. |
| 4 | Confirm | Button | | | Confirms cancellation and refunds payment. |
| 5 | Close | Button | | | Closes modal window. |

### 3.7.5.2 Use Case Description

| Use Case ID | UC-55 | Use Case Name | Request Transaction Refund |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.1 |
| **Date** | 2026-06-01 | | |

| Field | Description |
|---|---|
| **Actor** | Cashier, Store Manager |
| **Description** | Voids an active order and processes payment refund. |
| **Precondition** | **For Cashier:** Order is in `PENDING` state (before kitchen queue entry). **For Store Manager / Admin:** Order is in `PENDING`, `PREPARING`, `ON_HOLD`, or `READY` state (not `COMPLETED`). |
| **Trigger** | Cashier clicks Cancel Order. |
| **Post-Condition** | Order is cancelled, stock rollbacked/marked waste, and refund completed. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Cashier | Taps Cancel, inputs reason, and requests manager override credentials. |
| 2 | Manager | Enters PIN code credentials. |
| 3 | Portal | Updates order state to Cancelled, updates stock counts, and processes refund. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-05 | **Cashier Cancellation Limit**: Cashiers can cancel orders only while they are in the `PENDING` state (prior to kitchen queue entry). |
| BR-06 | **Manager/Admin Cancellation Limit**: Store Managers or Admins can cancel orders at any status except `COMPLETED` (including `PENDING`, `PREPARING`, `ON_HOLD`, and `READY`). |
| BR-07 | **Inventory Action on Cancellation**: Inventory is auto-replenished only if the order is cancelled in the `PENDING` state. If cancelled during `PREPARING`, `ON_HOLD`, or `READY`, stock is considered wasted and is not restored (logged as operational waste). |
| BR-08 | **Loyalty & Voucher Rollback**: Order cancellation reverses used vouchers (restoring total and customer limits) and adjusts loyalty points (gained points are deducted, and redeemed points are refunded to the customer balance). |

---

## 3.7.6 Manager Override PIN

Manager Override PIN is a 4-digit numeric credential used to authorize cashier actions that exceed their standard permissions (e.g., cancelling a non-PENDING order, processing a post-payment refund).

### Configuration
- Each Store Manager account has a dedicated Override PIN set by the Admin via the User Account Management panel (UC-12).
- The Override PIN is stored as a salted hash — it is separate from the account login password.
- The PIN can be changed by the Admin or by the Store Manager themselves via their profile settings.

### Usage at POS
- When a Cashier initiates a cancel or refund action requiring Manager authorization, the POS screen displays a PIN entry prompt.
- The Store Manager (or Admin if on-site) enters their 4-digit PIN.
- The system validates the PIN hash against the manager's stored credential.
- On success, the action proceeds. On failure after 3 attempts, the override session is locked for 5 minutes.

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-51 | **Manager Override PIN**: Each Store Manager account has a 4-digit Override PIN, stored as a salted hash, separate from the login password. The PIN is required for Cashier-initiated cancel/refund actions. Failed PIN entry is limited to 3 consecutive attempts before a 5-minute lockout. |
