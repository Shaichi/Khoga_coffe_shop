# 3.9 Staff Management

This section details specifications for staff shifts assignment, schedules views, and schedules cancellations.

---

## 3.9.1 F44 - Create Staff Schedule / UC-36 Create Staff Schedule

### 3.9.1.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|          Create Schedule           |
|                                    |
|  Employee                          |
|  [ Nguyen Van A                ][v]|
|                                    |
|  Date                              |
|  [ 2026-05-25                    ] |
|                                    |
|  Shift Type                        |
|  [ Morning (06:00 - 14:00)     ][v]|
|                                    |
|  Allocated POS Register            |
|  [ REG-01                      ][v]|
|                                    |
|         [ ASSIGN ]   [ CANCEL ]    |
+------------------------------------+
```

#### Table 3-44: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Employee | Dropdown | Yes | | Active employee user accounts list. |
| 2 | Date | Date | Yes | | Target scheduling date calendar. |
| 3 | Shift Type | Dropdown | Yes | | Shift duration (`Morning`, `Afternoon`, `Full-Day`). |
| 4 | Allocated POS Register | Dropdown | Conditional | | POS terminal register allocation. **Mandatory when Employee role = `CASHIER`; Optional (leave blank) when role = `BARISTA` or `STORE_MANAGER`.** |
| 5 | Assign | Button | | | Submits details to schedule shift. |
| 6 | Cancel | Button | | | Returns to Shift Schedule view. |

### 3.9.1.2 Use Case Description

| Use Case ID | UC-36 | Use Case Name | Create Staff Schedule |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Store Manager |
| **Description** | Assigns employee to an operational work shift. |
| **Precondition** | Manager is logged in. |
| **Trigger** | Manager taps "Assign Shift" button on calendar scheduler. |
| **Post-Condition** | Shift schedule is updated. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Manager | Selects Employee, Date, Shift Type, and POS Register, and clicks "Assign". |
| 2 | Portal | Validates employee schedule availability (conflicts check). |
| 3 | Portal | Saves the shift session and updates schedule calendar. |

#### Alternative Flows
##### AT1: Schedule Conflict
- **Trigger**: At step 2, target employee is already assigned to a shift on that date.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays warning message: `"Employee is already assigned to another shift on this day."` |

---

## 3.9.2 F45 - View Staff Schedule / UC-35 View Staff Schedule

### 3.9.2.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|           Shift Schedule           |
|                                    |
|  Filter: [ All Roles           ][v]  |
|  Date: [ 2026-05-25            ]   |
|                                    |
|  - Nguyen Van A (Cashier)          |
|    Morning (06:00 - 14:00) - REG-01|
|                                    |
|  - Tran Thi B (Barista)            |
|    Morning (06:00 - 14:00)         |
|                                    |
|        [ + Add ]   [ Back ]        |
+------------------------------------+
```

#### Table 3-45: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Filter | Dropdown | Yes | | Filters list by employee roles. |
| 2 | Date | Date | Yes | | Jumps display date. |
| 3 | Add | Button | | | Navigates to Create Staff Schedule view. |
| 4 | Back | Button | | | Returns to dashboard. |

### 3.9.2.2 Use Case Description

| Use Case ID | UC-35 | Use Case Name | View Staff Schedule |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Store Manager, Cashier, Barista |
| **Description** | Displays shift assignments in calendar format. |
| **Precondition** | User is logged in. |
| **Trigger** | User opens shift schedule calendar menu. |
| **Post-Condition** | Displays shift schedule list. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | User | Opens schedule dashboard view. |
| 2 | Portal | Retrieves active schedules for selected role/date filters and displays them. |

---

## 3.9.3 F46 - Update/Delete Staff Schedule / UC-37, UC-38 Edit/Remove Shift

### 3.9.3.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|           Modify Shift             |
|                                    |
|  Employee: Nguyen Van A            |
|  Date: 2026-05-25                  |
|                                    |
|  Shift Type                        |
|  [ Afternoon (14:00-22:00)     ][v]|
|                                    |
|  Register                          |
|  [ REG-01                      ][v]|
|                                    |
|        [ SAVE ]   [ DELETE ]       |
|               [ CANCEL ]           |
+------------------------------------+
```

#### Table 3-46: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Shift Type | Dropdown | Yes | | Select shift hours. |
| 2 | Register | Dropdown | Yes | | Select target register. |
| 3 | Save | Button | | | Submits modifications to scheduled shift. |
| 4 | Delete | Button | | | Deletes shift scheduling. |
| 5 | Cancel | Button | | | Discards changes. |

### 3.9.3.2 Use Case Description

| Use Case ID | UC-37 | Use Case Name | Update Staff Schedule |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Store Manager |
| **Description** | Modifies or deletes shift assignments. |
| **Precondition** | Shift schedule is scheduled in the future. |
| **Trigger** | Manager taps on a scheduled shift row on the calendar. |
| **Post-Condition** | Shift schedule details are updated. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Manager | Selects scheduled shift cell, modifies values, and taps "Save" (or clicks "Delete"). |
| 2 | Portal | Validates inputs. |
| 3 | Portal | Updates shift schedule calendar view and syncs notifications. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-36 | Cannot modify schedules that occurred in the past. |
| BR-37 | Deletion removes the shift and sends notification alerts to affected employees. |

---

## 3.9.4 F46.1 - View Staff Attendance Report / UC-39 View Staff Attendance Report

### 3.9.4.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|         Attendance Report          |
|                                    |
|  Date: [ 2026-05-24 ]              |
|  Filter: [ Late Only           ][v]  |
|                                    |
|  - Nguyen Van A (Cashier)          |
|    Check-in: 06:15 AM (Late 15m)   |
|    Check-out: 14:02 PM             |
|                                    |
|  - Tran Thi B (Barista)            |
|    Check-in: 05:58 AM (On Time)    |
|    Check-out: 14:00 PM             |
|                                    |
|                        [ Back ]    |
+------------------------------------+
```

#### Table 3-46: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Date | Date | Yes | | Target scheduling date calendar. |
| 2 | Filter | Dropdown | Yes | | Filters list by attendance categories (`All`, `Late Only`, `Absent`). |
| 3 | Back | Button | | | Returns to Shift Schedule view. |

### 3.9.4.2 Use Case Description

| Use Case ID | UC-39 | Use Case Name | View Staff Attendance Report |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Store Manager |
| **Description** | Accesses and reviews daily check-in and check-out logs for store staff. |
| **Precondition** | Store Manager is logged in. |
| **Trigger** | Store Manager clicks "View Attendance Report" button from the Shift Schedule screen. |
| **Post-Condition** | Attendance logs for the selected date are displayed. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Store Manager | Selects a date and filter option. |
| 2 | Portal | Retrieves attendance records for the selected filters. |
| 3 | Portal | Displays employee name, actual check-in/out times, and calculated lateness. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-38 | **Attendance Check-in Registration**: A check-in record is automatically created based on the employee's first successful login at a local terminal station within their scheduled shift time window. Subsequent logins within the same shift window do not create duplicate check-in records. If no scheduled shift exists for the login time, no check-in record is created. |
| BR-39 | Lateness is calculated relative to the scheduled shift start time (e.g. check-in after 06:00 AM for a morning shift). |
| BR-53 | **Attendance Check-out Registration**: A check-out record is automatically recorded when the employee closes their active POS shift session (UC-53 Close Shift) or logs out of the system. The last recorded logout or shift-close time within the shift window is used as the check-out timestamp. |
