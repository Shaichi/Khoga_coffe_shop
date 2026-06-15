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
| 1 | Manager | Selects Employee, Date, **Start/End time** (or Shift Type), POS Register, and **target Branch** (defaults to the manager's own branch; may be another branch for cross-branch help — BR-90), then clicks "Assign". |
| 2 | Portal | Validates schedule availability (conflict check) **and** labour constraints — max daily/weekly hours, minimum rest between shifts, and the branch labour-hour budget (BR-92). |
| 3 | Portal | Saves the shift session and updates the schedule calendar. If the target branch differs from the employee's home branch, writes a cross-branch assignment audit entry (BR-90). |

#### Alternative Flows
##### AT1: Schedule Conflict
- **Trigger**: At step 2, target employee is already assigned to a shift on that date.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays conflict error message: "Employee shift conflict. The employee is already scheduled..." (MSG12). |

##### AT2: Labour Constraint Exceeded
- **Trigger**: At step 2, the assignment would breach max daily/weekly hours, the minimum-rest gap, or the branch labour-hour budget.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Warns the Manager: `"This shift exceeds {max hours / rest gap / labour budget}. Adjust or confirm override."` Hard limits (max hours, rest) block; the labour-budget cap is a soft warning the Manager may override with a reason (logged). (BR-92) |

##### AT3: Cross-Branch Assignment
- **Trigger**: At step 1, the Manager selects a target branch other than the employee's home branch.

| Sub-step | Actor | Action |
|---|---|---|
| 3.1 | Portal | Creates the shift at the target branch, audit-logs the cross-branch assignment (`employee_id`, home `store_id`, target `store_id`, actor SM, date), and makes the borrowed employee visible to the **host** branch's Store Manager for that shift (BR-90 / BR-59 exception). No host approval is required. |

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
| BR-38 | **Attendance Log Recording**: The system records check-in and check-out entries under the local branch's `store_id` where the attendance action was taken. At `CHECK_IN`, the system snapshots the scheduled shift's start time into the `scheduled_start` column (nullable for cross-branch walk-ins with no `shift_id`) so lateness can be reconstructed historically even if the schedule is later edited. |
| BR-39 | **Lateness Computation (branch-local, derived)**: Lateness is **not** persisted as a stored column — it is derived at the reporting layer as `max(0, recorded_at − scheduled_start)`, where **both timestamps are first converted to the branch's configured local timezone** (per §5.2.2) before the comparison. A `CHECK_IN` at or before `scheduled_start` yields 0 lateness. Lateness is `NULL` when `scheduled_start` is `NULL` (cross-branch walk-in). _(Computing on raw UTC instants is prohibited to avoid the ±7h error for Asia/Ho_Chi_Minh — RV-C03.)_ |
| BR-53 | **Attendance Check-in & Check-out**: Staff check-in and check-out are performed via a dedicated attendance popup by entering a personal 4-digit PIN and taking a camera snapshot. This action is independent of the active terminal session login — the shared POS session on the terminal is not interrupted. |
| BR-90 | **Cross-Branch Shift Assignment**: A Store Manager may assign one of **their own-branch** employees to a shift at **another branch** directly (no host approval), via UC-36. The assignment is audit-logged (`employee_id`, home `store_id`, target `store_id`, assigning SM, date) and makes the borrowed employee visible to the **host** Store Manager for that shift's duration (BR-59 exception). Worked hours follow `employee_id` (payroll) and branch labour cost follows the terminal `store_id` (BR-53a). (RV-C04) |
| BR-91 | **Absence & OT / Early-Leave Derivation**: From scheduled shifts (UC-36) vs `attendance_logs`, the system derives, per employee per day: **Absence** = a scheduled shift with no `CHECK_IN`; **Overtime** = worked-hours beyond the scheduled shift length; **Early-Leave** = `CHECK_OUT` before the scheduled end. These are computed flags/metrics surfaced on the attendance and worked-hours reports (UC-67/UC-80) — non-monetary; payroll stays external (§1.2). No in-system leave-request workflow is provided in this release. (RV-C06) |
| BR-92 | **Labour Budget & Working-Time Validation**: At scheduling (UC-36), the system enforces configurable working-time limits — `MAX_DAILY_HOURS`, `MAX_WEEKLY_HOURS`, and `MIN_REST_HOURS` between consecutive shifts (hard blocks) — and a per-branch `LABOUR_HOUR_BUDGET` per period (soft warning the Store Manager may override with a logged reason). Prevents uncontrolled labour cost and unsafe rostering. (RV-C07) |
| BR-93 | **Attendance PIN Uniqueness & Mandatory Photo**: An attendance PIN must be **unique within its branch** (`store_id` scope) and is locked after a configurable number of failed entries. The camera snapshot is **mandatory** at check-in/out; if the camera is unavailable, the action is **queued and flagged** for Store-Manager confirmation rather than recorded without a photo — closing the buddy-punching gap left by a nullable photo. (RV-C08) |

### 3.9.4.3 Database Schema (Attendance Logs)

```sql
CREATE TABLE attendance_logs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id),
    store_id        UUID NOT NULL REFERENCES stores(id),   -- branch where action was taken
    shift_id        UUID REFERENCES staff_shifts(id),      -- scheduled shift (nullable: cross-branch walk-ins)
    scheduled_start TIMESTAMP WITH TIME ZONE,              -- snapshot of the shift's scheduled start at CHECK_IN (BR-38); NULL when shift_id is NULL
    action          VARCHAR(10) NOT NULL,                  -- 'CHECK_IN' | 'CHECK_OUT'
    photo_url       VARCHAR(500),                          -- camera snapshot URL (taken at action time)
    photo_purge_at  DATE,                                  -- scheduled erasure date for the snapshot = recorded_at::date + 90 days (BR-72)
    recorded_at     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
    -- NOTE: lateness is NOT stored. It is derived at the reporting layer per BR-39, comparing
    --       recorded_at vs scheduled_start AFTER converting both to the branch-local timezone (§5.2.2).
    --       The previous GENERATED column referenced a non-existent `scheduled_start` and never ran (RV-C02).
);

CREATE INDEX idx_attendance_store_date ON attendance_logs(store_id, recorded_at);
CREATE INDEX idx_attendance_user       ON attendance_logs(user_id);
CREATE INDEX idx_attendance_photo_purge ON attendance_logs(photo_purge_at) WHERE photo_url IS NOT NULL;
```

> **scheduled_start**: A point-in-time copy of the rostered start of `shift_id`, written at `CHECK_IN`. Storing it as a real column (rather than joining to `staff_shifts` at read time) makes historical lateness immune to later schedule edits and removes the broken generated-column dependency.
>
> **photo_url / photo_purge_at**: `photo_url` stores the URL/path of the camera snapshot taken during the attendance popup, required for fraud prevention (verifying the correct employee is clocking in). Nullable only when the attendance action is performed in an offline/no-camera mode. `photo_purge_at` drives the automatic erasure job that deletes the biometric-adjacent snapshot 90 days after capture (BR-72 / §4.2.6); the log row itself is retained for payroll history with `photo_url` nulled.

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
| BR-59 | **Branch Staff Isolation & Read-Only**: A Store Manager can only view, search, and call their local staff. All mutation capabilities (create, modify role, deactivate user, update PIN) are restricted to the System Admin (`ssadmin`). A Store Manager must not view rosters or contact details of staff registered at other branches — **except** an employee currently assigned a cross-branch shift at the manager's branch, who becomes visible to that host Store Manager for the duration of the assignment (BR-90). |

---

## 3.9.6 F46.3 - Export Worked-Hours Report / UC-80 Export Worked-Hours Report

### 3.9.6.1 Screen Mock-up (Mobile / Tablet Portrait)
```
+------------------------------------+
|       Worked-Hours Export          |
|                                    |
|  Branch: District 1 (yours)        |
|  Period: [2026-05-01]–[2026-05-31] |
|                                    |
|  Employee        Days  Hours  Flag |
|  Nguyen Van An    24   188.5    -  |
|  Tran Thi Binh    22   171.0   (1) |
|  Le Van Cuong     20   152.5    -  |
|  ........................          |
|  (1) = 1 day with missing checkout |
|                                    |
|  [ Export CSV ]   [ Export PDF ]   |
+------------------------------------+
```

#### Table 3-69: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Period | Date Picker | Yes | | Pay-period window (branch-local, §5.2.2). |
| 2 | Employee rows | Grid | | | Per employee: days worked, total worked-hours (BR-77), and a flag count of days with missing/unpaired checkout. |
| 3 | Missing-checkout flag | Indicator | | | Days with a `CHECK_IN` but no matching `CHECK_OUT` are flagged for manual correction and **excluded** from the hours total (BR-77). |
| 4 | Export CSV / PDF | Button | | | Generates the worked-hours file to feed the external payroll/accounting system (§1.2). |

### 3.9.6.2 Use Case Description

| Use Case ID | UC-80 | Use Case Name | Export Worked-Hours Report |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-06-14 | | |

| Field | Description |
|---|---|
| **Actor** | Store Manager (own branch only) |
| **Description** | Produces a per-employee **worked-hours** summary for a pay period at the manager's branch, exportable as CSV/PDF to feed the **external** payroll system. The system computes hours only — it does **not** calculate or pay wages (§1.2). Cross-branch shifts are attributed per BR-53a (payroll hours follow `employee_id`). |
| **Precondition** | Store Manager is logged in and viewing their own branch. |
| **Trigger** | Store Manager opens "Worked-Hours Export" and selects a period. |
| **Post-Condition** | A worked-hours file is generated; days needing correction are flagged. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Store Manager | Selects the pay period. |
| 2 | Portal | Pairs each `CHECK_IN` with its next `CHECK_OUT` per employee per day and sums the durations (BR-77). |
| 3 | Portal | Lists per-employee days and total hours, flagging any day with a missing checkout. |
| 4 | Store Manager | Clicks Export CSV / PDF to download the file for external payroll. |

#### Alternative Flows
##### AT1: Missing Checkout
- **Trigger**: At step 2, an employee has a `CHECK_IN` with no matching `CHECK_OUT` for that day.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Flags that day, excludes it from the hours total, and surfaces it for manual correction before export. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-77 | **Worked-Hours Computation**: For each employee per business day (branch-local, §5.2.2), worked-hours = Σ of paired (`CHECK_OUT` − `CHECK_IN`) durations from `attendance_logs`. A `CHECK_IN` with no matching `CHECK_OUT` (or vice-versa) is **flagged and excluded** from the total — never auto-completed. Hours are aggregated by `employee_id` for payroll (BR-53a). The system reports hours only and performs **no wage calculation** (§1.2); the export feeds an external payroll system. |


