# 3.11 Delivery Partner Integration

This section details specifications for background order synchronization and manual review screens for delivery partners.

---

## 3.11.1 F50 - Pending Delivery Order Review / UC-11.1 Online Order

### 3.11.1.1 Screen Mock-up (Mobile Portrait Modal)
```
+------------------------------------+
|      Pending Delivery Order        |
|                                    |
|  Partner: GrabFood                 |
|  Timer Remaining: [ 01:45 ]        |
|                                    |
|  Ordered Items:                    |
|  - 1x Milk Tea  (Gold Topping)     |
|  * Status: IN STOCK                |
|                                    |
|  - 1x Peach Tea (Peach slices)     |
|  * Status: OUT OF STOCK [!]        |
|                                    |
|     [ CALL CUSTOMER/RIDER ]        |
|     [ ACCEPT PARTIAL ]  [ REJECT ] |
+------------------------------------+
```

#### Table 3-50: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Call Customer/Rider | Button | | | Triggers phone call connection using the rider/customer hotline. |
| 2 | Accept Partial | Button | | | Submits edited order payload excluding unavailable items. |
| 3 | Reject | Button | | | Rejects order immediately. |

### 3.11.1.2 Use Case Description

| Use Case ID | UC-11.1 | Use Case Name | Receive Online Order |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.1 |
| **Date** | 2026-06-01 | | |

| Field | Description |
|---|---|
| **Actor** | System (automated), Cashier (manual review only) |
| **Description** | Processes incoming delivery partner orders. Automatically accepts orders when all items are in stock; triggers manual review when out-of-stock items are detected. |
| **Precondition** | A valid delivery order webhook payload has been received and authenticated. |
| **Trigger** | Webhook request receives order payload from delivery partner API. |
| **Post-Condition** | Order is either auto-accepted into the kitchen queue, or manually resolved (partial accept / reject) by the Cashier. |

#### Main Flows (Auto-Accept — All Items In Stock)
| Step | Actor | Action |
|---|---|---|
| 1 | System | Receives and validates webhook payload from delivery partner. |
| 2 | System | Checks stock availability for all items in the order. |
| 3 | System | All items are in stock: automatically accepts the order and sends acceptance payload to the delivery partner API. |
| 4 | System | Creates a new order record (type: `DELIVERY`) and pushes it directly to the Barista kitchen queue in `PENDING` state. |

#### Alternative Flows
##### AT1: Out-of-Stock Item Detected (Manual Review Required)
- **Trigger**: At step 2, one or more items are out of stock.

| Step | Actor | Action |
|---|---|---|
| 1 | System | Flags the order on the POS Cashier screen with a countdown timer (BR-42: 2 minutes). |
| 2 | Cashier | Reviews out-of-stock items, contacts customer/rider if needed, and either: |
| 2a | Cashier | Clicks "Accept Partial" — removes unavailable items from the cart and sends a partial acceptance payload back to the partner API. The adjusted order is pushed to the kitchen queue. |
| 2b | Cashier | Clicks "Reject" — sends an immediate rejection payload to the delivery partner. The order is not created locally. |

##### AT2: Timer Expired (Auto-Reject)
- **Trigger**: Countdown timer reaches 0 with no Cashier action.

| Sub-step | Actor | Action |
|---|---|---|
| 1 | System | Sends automatic rejection payload to delivery partner API (BR-42). |
| 2 | System | Logs the auto-rejection event for audit. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-42 | Review countdown timer is set to exactly 2 minutes; if it expires, the order is automatically rejected. **Rejection Notification**: Upon manual rejection or auto-timeout rejection, the system sends an immediate API rejection payload callback to the third-party delivery partner (e.g., GrabFood, ShopeeFood). The delivery partner platform is responsible for notifying both the delivery rider and the end customer via their respective mobile applications. |
| BR-43 | Delivery orders bypass individual cashier shift sessions drawer cash totals. |

---

## 3.11.2 Sync Menu & Stock Availability
- **Description**: Synchronizes active store prices and ingredient/item availability to delivery partner applications.
- **Process**:
  - When an item is marked "Out of stock" locally, the status is synchronized with the delivery applications.
  - This temporarily disables the item on the delivery partner's catalog.

---

## 3.11.3 Update Order Preparation Status
- **Description**: Notifies delivery riders and platforms of kitchen status changes.
- **Process**:
  - Updating the order state to "Preparing" or "Ready" automatically synchronizes the status with the delivery partner.
  - Coordinates rider arrival with kitchen order completion.

---

## 3.11.4 Delivery Partner Integration Authentication
- **Method**: Secure access tokens are used to authenticate each registered delivery partner.
- **Validation**: Incoming integration requests must include a valid authorization token. Unauthorized requests are rejected.

---

## 3.11.5 Error Handling & Retry Policy
- **Timeout**: If no response is received from the delivery partner within 10 seconds, the request is considered timed out.
- **Retry Policy**: Failed outbound synchronization requests are retried up to 3 times. After 3 failures, the issue is logged and the Store Manager is notified.
- **Failed Synchronizations**: Failed events that exhaust all retries are logged for manual review by the Administrator.
- **Offline Handling**: If the local store is offline, synchronization events are queued locally and sent chronologically once connectivity is restored.

