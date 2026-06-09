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

#### Table 3-46: Screen Definition
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
| 2.1 | Portal | Displays conflict error message: "Employee shift conflict. The employee is already scheduled..." (MSG12). |

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

#### Table 3-47: Screen Definition
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

#### Table 3-48: Screen Definition
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

#### Table 3-49: Screen Definition
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
| BR-38 | **Attendance Log Recording**: The system records check-in and check-out entries under the local branch's `store_id` where the attendance action was taken, calculating lateness against the scheduled shift. |
| BR-39 | Lateness is calculated relative to the scheduled shift start time (e.g. check-in after 06:00 AM for a morning shift). |
| BR-53 | **Attendance Check-in & Check-out**: Staff check-in and check-out are performed via a dedicated attendance popup by entering a personal 4-digit PIN and taking a camera snapshot. This action is independent of the active terminal session login — the shared POS session on the terminal is not interrupted. |

### 3.9.4.3 Database Schema (Attendance Logs)

```sql
CREATE TABLE attendance_logs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id),
    store_id        UUID NOT NULL REFERENCES stores(id),   -- branch where action was taken
    shift_id        UUID REFERENCES staff_shifts(id),      -- scheduled shift (nullable: cross-branch walk-ins)
    action          VARCHAR(10) NOT NULL,                  -- 'CHECK_IN' | 'CHECK_OUT'
    photo_url       VARCHAR(500),                          -- camera snapshot URL (taken at action time)
    recorded_at     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    lateness_minutes INTEGER GENERATED ALWAYS AS (
        EXTRACT(EPOCH FROM (recorded_at - scheduled_start)) / 60
    ) STORED                                               -- null if shift_id is null
);

CREATE INDEX idx_attendance_store_date ON attendance_logs(store_id, recorded_at);
CREATE INDEX idx_attendance_user       ON attendance_logs(user_id);
```

> **photo_url**: Stores the URL/path of the camera snapshot taken during the attendance popup. Required for fraud prevention (verifying the correct employee is clocking in). Nullable only when the attendance action is performed in an offline/no-camera mode.

---

## 3.9.5 F46.2 - View Branch Staff List / UC-66 View Branch Staff List

### 3.9.5.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|            Branch Staff            |
|                      [Nguyen Du]   |
|                                    |
|  [ 8 ]      [ 3 ]      [ 4 ]       |
|  Total      Cashier    Barista     |
|                                    |
|  Filter: [ All ][ Cashier ][ Barista ]
|                                    |
|  - Nguyen Van An (Cashier)     [C] |
|    Phone: 0901 234 567             |
|    Status: Active                  |
|                                    |
|  - Tran Thi Binh (Cashier)     [C] |
|    Phone: 0912 345 678             |
|    Status: Active                  |
|                                    |
|                           [ Back ] |
+------------------------------------+
```

#### Table 3-50: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Stats Grid | Display | - | | Shows counts of Total Staff, Cashiers, Baristas, Managers. |
| 2 | Filter Tabs | Button Row | Yes | | Filters list by roles (`All`, `Cashier`, `Barista`, `Manager`). |
| 3 | Call Action (C) | Button | No | | Triggers mobile native phone call to the staff member. |
| 4 | Staff Card Click | Interactive | - | | Opens detailed information modal overlay. |
| 5 | Back | Button | - | | Returns to Manager Dashboard console. |

### 3.9.5.2 Use Case Description

| Use Case ID | UC-66 | Use Case Name | View Branch Staff List |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-06-02 | | |

| Field | Description |
|---|---|
| **Actor** | Store Manager |
| **Description** | Reviews the roster list and contact profiles of staff assigned to their branch. |
| **Precondition** | Manager is logged in and viewing their local branch dashboard. |
| **Trigger** | Manager taps the "Nhân Viên" menu button on the Dashboard. |
| **Post-Condition** | Displays active/inactive local branch employee profiles. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Store Manager | Opens the Branch Staff list module. |
| 2 | Portal | Retrieves active and deactivated users whose assigned branch matches the manager's branch. |
| 3 | Portal | Shows aggregated stats and lists cards containing Names, Roles, Contacts and Badges. |
| 4 | Store Manager | (Optional) Taps on a Staff Card to open detail modal or triggers instant call link. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-59 | **Branch Staff Isolation & Read-Only**: A Store Manager can only view, search, and call their local staff. All mutation capabilities (create, modify role, deactivate user, update PIN) are restricted to HQ Admin. A Store Manager must not be allowed to view rosters or contact details of staff registered at other branch facilities. |



