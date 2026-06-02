# 3.5 Inventory & Stock Management

This section details specifications for viewing inventory, managing imports/exports, and reconciling discrepancies.

---

## 3.5.1 F23 - View Stock List / UC-31 View Stock List

### 3.5.1.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|            Stock List              |
|                                    |
|  Search: [ CoffeeBeans           ] |
|  [x] Low Stock Only                |
|                                    |
|  - Coffee Beans (STK-01)           |
|    Qty: 1.2 kg  (Min: 5.0 kg) [LOW]|
|                                    |
|  - Fresh Milk (STK-02)             |
|    Qty: 12.0 liters  (Min: 6.0 l)  |
|                                    |
|         [ IMPORT ]    [ EXPORT ]   |
+------------------------------------+
```

#### Table 3-24: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Search | Text | No | 50 | Filter stock list by item name. |
| 2 | Low Stock Only | Checkbox | Yes | | Toggles display to only show items below alert threshold. |
| 3 | Import | Button | | | Navigates to Import Stock screen. |
| 4 | Export | Button | | | Navigates to Export Stock screen. |

### 3.5.1.2 Use Case Description

| Use Case ID | UC-31 | Use Case Name | View Stock List |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Store Manager |
| **Description** | Displays the current physical inventory count of ingredients and store supplies. |
| **Precondition** | Store Manager is logged in and assigned to store. |
| **Trigger** | Manager navigates to Stock List view. |
| **Post-Condition** | Displays local inventory item counts and safety statuses. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Manager | Opens the Stock List screen. |
| 2 | Portal | Displays current stock items list including quantity, unit type, threshold level, and alert flag. |

---

## 3.5.2 F24 - Import Stock / UC-32 Import Stock

### 3.5.2.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|            Import Stock            |
|                                    |
|  Item Name                         |
|  [ Coffee Beans                ][v]|
|                                    |
|  Quantity (kg)                     |
|  [ 15.0                          ] |
|                                    |
|  Supplier                          |
|  [ Highlands Supplier            ] |
|                                    |
|  Unit Price (VND)                  |
|  [ 180,000                       ] |
|                                    |
|  Notes                             |
|  [ Restock coffee beans          ] |
|                                    |
|        [ SUBMIT ]   [ CANCEL ]     |
+------------------------------------+
```

#### Table 3-25: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Item Name | Dropdown | Yes | | Scopes stock items list available for branch. |
| 2 | Quantity | Text | Yes | 10 | Import decimal volume. |
| 3 | Supplier | Text | No | 100 | Supplier source name. |
| 4 | Unit Price | Text | Yes | 15 | Purchase cost per unit in VND. |
| 5 | Notes | Text | No | 250 | Transaction notes. |
| 6 | Submit | Button | | | Submits transaction and increases inventory levels. |
| 7 | Cancel | Button | | | Discards edits and returns to Stock list. |

### 3.5.2.2 Use Case Description

| Use Case ID | UC-32 | Use Case Name | Import Stock |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Store Manager |
| **Description** | Records incoming items received from suppliers to replenish local inventory levels. |
| **Precondition** | Manager is logged in. |
| **Trigger** | Manager clicks "Import" button. |
| **Post-Condition** | Stock is replenished. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Manager | Selects item, inputs quantity, supplier, unit cost, and notes, then clicks "Submit". |
| 2 | Portal | Validates quantity and cost are positive. |
| 3 | Portal | Increments stock quantity and records transaction logs. |

#### Alternative Flows
##### AT1: Validation Errors
- **Trigger**: At step 2, input checks fail.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"Please enter a positive numeric quantity and cost."` |

---

## 3.5.3 F25 - Export Stock / UC-33 Export Stock

### 3.5.3.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|            Export Stock            |
|                                    |
|  Item Name                         |
|  [ Fresh Milk                  ][v]|
|                                    |
|  Quantity (liters)                 |
|  [ 2.0                           ] |
|                                    |
|  Reason                            |
|  [ Damage/Spoilage             ][v]|
|                                    |
|  Notes                             |
|  [ Discarded sour milk           ] |
|                                    |
|        [ SUBMIT ]   [ CANCEL ]     |
+------------------------------------+
```

#### Table 3-26: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Item Name | Dropdown | Yes | | Scopes stock items list. |
| 2 | Quantity | Text | Yes | 10 | Decimal quantity. |
| 3 | Reason | Dropdown | Yes | | Reason (`Daily Operations Usage`, `Damage/Spoilage`, `Loss/Theft`). |
| 4 | Notes | Text | No | 250 | Optional notes. |
| 5 | Submit | Button | | | Submits export request. |
| 6 | Cancel | Button | | | Discards edits. |

### 3.5.3.2 Use Case Description

| Use Case ID | UC-33 | Use Case Name | Export Stock |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Store Manager |
| **Description** | Records manual stock removals for internal usage or wastage disposal. |
| **Precondition** | Manager is logged in. |
| **Trigger** | Manager clicks "Export" button. |
| **Post-Condition** | Stock is reduced. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Manager | Selects item, inputs quantity and reason, then clicks "Submit". |
| 2 | Portal | Validates quantity does not exceed current safety stock counts. |
| 3 | Portal | Decrements stock quantity and logs transaction details. |

#### Alternative Flows
##### AT1: Insufficient Stock
- **Trigger**: At step 2, quantity exceeds **current total stock** level.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"Cannot export quantity. Current stock level is too low."` |

> **Note:** Validation checks against the item's **current total stock quantity** (not the safety threshold). The safety threshold triggers a low-stock warning (MSG07) but does not block exports.

---

## 3.5.4 F26 - View Import/Export History / UC-61 View Import/Export History

### 3.5.4.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|         Stock Transactions         |
|                                    |
|  Filter: [ All Types ] [v]         |
|                                    |
|  - 2026-05-24 09:15                |
|    IMPORT: Coffee Beans (+15.0 kg) |
|                                    |
|  - 2026-05-23 18:30                |
|    EXPORT: Fresh Milk (-2.0 l)     |
|    Reason: Damage/Spoilage         |
|                                    |
|                        [ Back ]    |
+------------------------------------+
```

#### Table 3-27: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Filter | Dropdown | Yes | | Filters by transaction type (`IMPORT`, `EXPORT`, `AUDIT`). |
| 2 | Back | Button | | | Returns to Stock List screen. |

### 3.5.4.2 Use Case Description

| Use Case ID | UC-61 | Use Case Name | View Import/Export History |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Store Manager |
| **Description** | Displays a chronological list of all stock transactions. |
| **Precondition** | Manager is logged in. |
| **Trigger** | Manager opens the transaction history log panel. |
| **Post-Condition** | Displays transaction logs. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Manager | Opens transaction history screen. |
| 2 | Portal | Retrieves and displays stock logs list. |

---

## 3.5.5 F27 - Perform Inventory Audit / UC-34 Perform Inventory Audit

### 3.5.5.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|          Inventory Audit           |
|                                    |
|  Active Item: Coffee Beans         |
|  Expected: 1.2 kg                  |
|                                    |
|  Actual Count:                     |
|  [ 1.0                           ] |
|                                    |
|  Discrepancy Notes (Mandatory if   |
|  there is a difference):           |
|  [ Spill waste during prep       ] |
|                                    |
|        [ SUBMIT ]   [ CANCEL ]     |
+------------------------------------+
```

#### Table 3-28: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Actual Count | Text | Yes | 10 | Physically counted quantity of the stock item. |
| 2 | Discrepancy Notes | Text | No | 250 | Mandatory explanation if discrepancy exists. |
| 3 | Submit | Button | | | Submits audit adjustment. |
| 4 | Cancel | Button | | | Returns to Stock list. |

### 3.5.5.2 Use Case Description

| Use Case ID | UC-34 | Use Case Name | Perform Inventory Audit |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Store Manager |
| **Description** | Reconciles discrepancies between physical counts and system values. |
| **Precondition** | Manager is logged in. |
| **Trigger** | Manager clicks Audit for specific item. |
| **Post-Condition** | Inventory records are updated. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Manager | Enters physically counted quantity and notes discrepancy. |
| 2 | Manager | Clicks "Submit". |
| 3 | Portal | Reconciles quantity and logs audit adjustment. |

#### Alternative Flows
##### AT1: Negative Quantity Input
- **Trigger**: At step 2, Manager enters a negative value for the actual counted quantity.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"Actual counted quantity must be a non-negative numeric value."` |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-32 | Explanatory notes are mandatory if physically counted actual quantity does not match expected value. |

---

## 3.5.6 F27.1 - Auto-Deduct Stock on Sale / UC-62 Auto-Deduct Inventory on Order Completion

### 3.5.6.1 Use Case Description

| Use Case ID | UC-62 | Use Case Name | Auto-Deduct Inventory on Order Completion |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.1 |
| **Date** | 2026-06-01 | | |

| Field | Description |
|---|---|
| **Actor** | System (automated) |
| **Description** | Automatically deducts ingredient quantities from stock based on the menu item recipe formulation when an order transitions to the `PREPARING` state. |
| **Precondition** | Order status transitions from `PENDING` to `PREPARING`. Menu items in the order have linked recipe ingredient mappings. |
| **Trigger** | Barista clicks "START PREP" on the kitchen queue display, transitioning the order to `PREPARING`. |
| **Post-Condition** | Stock quantities for all associated ingredients are reduced according to each item's recipe. A stock transaction log entry of type `AUTO` is created. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Barista | Taps "START PREP" on an order in the queue. |
| 2 | System | Retrieves the recipe formulation (ingredient quantities) for each menu item in the order. |
| 3 | System | Deducts the corresponding quantities from each ingredient's stock count. |
| 4 | System | Logs each deduction as a stock transaction record (type: `AUTO`, linked to Order ID). |
| 5 | System | If any ingredient falls below the safety threshold after deduction, triggers MSG07 low-stock notification to the Store Manager. |

#### Alternative Flows
##### AT1: Ingredient Quantity Insufficient
- **Trigger**: At step 3, the required ingredient quantity exceeds the current available stock.

| Sub-step | Actor | Action |
|---|---|---|
| 3.1 | System | Logs a stock discrepancy warning. Deduction proceeds to zero (stock cannot go negative). |
| 3.2 | System | Sends MSG07 critical low-stock alert to the Store Manager immediately. |

> **Note:** The system does **not** block order preparation due to insufficient stock. Operational continuity takes priority; the discrepancy is flagged for manual audit by the Store Manager.

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-32 | *(Applies)* Any discrepancy between expected and actual counts must be noted. |
| BR-07 | If an order is cancelled in `PREPARING` or `READY` state, stock is **not** restored (consumed ingredients are logged as operational waste). If cancelled in `PENDING` state (before stock deduction occurs), no deduction was made, so no rollback is needed. |

