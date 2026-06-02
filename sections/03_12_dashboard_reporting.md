# 3.12 Dashboard & Reporting

This section details specifications for business reports views, sales analytics dashboards, and export spreadsheets.

---

## 3.12.1 F51 - HQ Revenue Dashboard / UC-28 View Consolidated Business Reports

### 3.12.1.1 Screen Mock-up (Desktop Landscape)
```
+---------------------------------------------------------------------------------+
| HQ Admin Portal > Business Reports & Analytics                                  |
+---------------------------------------------------------------------------------+
|  Date Range: [ 2026-05-01 ] to [ 2026-05-24 ]               [ Export Report ]   |
|                                                                                 |
|  Consolidated Sales Summary (VND):                                              |
|  +----------------------+----------------------+----------------------+        |
|  | Total Revenue        | Total Orders         | Avg Transaction Val  |        |
|  | 450,000,000 VND      | 12,500               | 36,000 VND           |        |
|  +----------------------+----------------------+----------------------+        |
|                                                                                 |
|  Branch Comparison:                                                             |
|  1. Branch 1: 250,000,000 VND  (6,800 orders)                                   |
|  2. Branch 2: 200,000,000 VND  (5,700 orders)                                   |
|                                                                                 |
|  Best Sellers: [1] Peach Tea (3.4k sold)  [2] Espresso (2.9k sold)              |
+---------------------------------------------------------------------------------+
```

#### Table 3-55: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Date Range | Date Picker | Yes | | Sets start and end range boundaries for search query. |
| 2 | Export Report | Button | | | Navigates to Export Report modal screen. |

### 3.12.1.2 Use Case Description

| Use Case ID | UC-28 | Use Case Name | View Consolidated Business Reports |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin |
| **Description** | Accesses centralized reports aggregating data from all store branches. |
| **Precondition** | Admin is logged in. |
| **Trigger** | Admin opens the Business Reports & Analytics dashboard. |
| **Post-Condition** | Consolidated metrics charts and grids are displayed. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Admin | Selects date range filter boundaries. |
| 2 | Portal | Retrieves sales data, computes totals, calculates averages, and displays dashboard. |

---

## 3.12.2 F52 - Export Report / UC-29, UC-41 Export Reports

### 3.12.2.1 Screen Mock-up (Desktop Landscape Modal)
```
+------------------------------------+
|           Export Report            |
|                                    |
|  Export Format:                    |
|  ( ) Excel (.xlsx)                 |
|  (x) PDF Document                  |
|  ( ) CSV Spreadsheet               |
|                                    |
|  Data Scopes:                      |
|  [ Sales Revenue Report        ][v]|
|                                    |
|       [ DOWNLOAD ]  [ CANCEL ]     |
+------------------------------------+
```

#### Table 3-56: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Export Format | Radio | Yes | | Select target file format (`Excel`, `PDF`, `CSV`). |
| 2 | Data Scopes | Dropdown | Yes | | Select target data scope (e.g. Sales, Shift discrepancy, Inventory waste). |
| 3 | Download | Button | | | Triggers generation and file download. |
| 4 | Cancel | Button | | | Closes modal window. |

### 3.12.2.2 Use Case Description

| Use Case ID | UC-29 | Use Case Name | Export HQ Reports |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin, Store Manager |
| **Description** | Generates and downloads data report files. |
| **Precondition** | User has reporting privileges. |
| **Trigger** | User clicks "Export Report" button on dashboard. |
| **Post-Condition** | Report file downloads to user local storage. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | User | Selects Format and Data Scope, and clicks "Download". |
| 2 | Portal | Generates sheet details and downloads report files. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-44 | Store Managers can only view and export reports scoped to their assigned branch. Admins can access and export consolidated brand reports. |

---

## 3.12.3 F51.1 - Store Revenue Reports / UC-40 View Store Revenue Reports

### 3.12.3.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|      Store Revenue Reports         |
|                                    |
|  From: [ 2026-05-01 ]              |
|  To:   [ 2026-05-24 ]              |
|                                    |
|         [ Export Report ]          |
|                                    |
|  Local Branch Sales Summary:       |
|  - Net Revenue:                    |
|    12,450,000 VND                  |
|  - Completed Orders: 345           |
|  - Discrepancy Total: 0 VND        |
|                                    |
|  Payment Method Breakdown:         |
|  - Cash:    4,500,000 VND          |
|  - Card:    3,950,000 VND          |
|  - VietQR:  4,000,000 VND          |
|                                    |
|  [Page 1 of 1]       [ Back ]      |
+------------------------------------+
```

#### Table 3-57: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | From Date | Date Picker | Yes | | Start of the target date range for local store reports. |
| 2 | To Date | Date Picker | Yes | | End of the target date range. Must be on or after From Date. Defaults to today. |
| 3 | Export Report | Button | | | Navigates to Export Report modal screen. |

### 3.12.3.2 Use Case Description

| Use Case ID | UC-40 | Use Case Name | View Store Revenue Reports |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Store Manager |
| **Description** | Accesses and reviews local branch revenue, cash drawer reconciliation summaries, and sales payment types. |
| **Precondition** | Store Manager is logged in. |
| **Trigger** | Store Manager navigates to local store reports panel. |
| **Post-Condition** | Local sales dashboard metrics are displayed. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Store Manager | Selects date or date range. |
| 2 | Portal | Retrieves local shift sessions, orders, and payment records. |
| 3 | Portal | Computes totals and displays local branch sales metrics. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-44 | Store Managers can only view and export reports scoped to their assigned branch. Admins can access and export consolidated brand reports. |



