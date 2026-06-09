# 5. Requirement Appendix & Mapping

This section contains business rules, global requirements, common application messages, and the Feature-Actor Mapping Matrix.

---

## 5.1 Business Rules

| ID | Rule Definition |
|---|---|
| BR-01 | **Membership Point Accrual**: Customers accumulate loyalty points as a percentage of the **Net Total Payable** value of their invoice, up to a maximum points accrual limit per order (configurable via system parameters). Points are not accrued for the portion of the order covered by loyalty points redemption. |
| BR-02 | **Membership Point Redemption**: Points can be redeemed for discounts at checkout, subject to point balance validation, with a limit on the maximum percentage of the invoice value that can be paid using points, and a maximum discount amount per order (configurable via central system parameters). |
| BR-03 | **Shift Session Closing**: A cashier cannot close a shift unless all orders associated with their shift ID are marked with terminal states (`COMPLETED` or `CANCELLED`). Cashier cannot close shift if there are active order queue items pending preparation. |
| BR-04 | **Shift Discrepancy Alert**: Any cash discrepancy exceeding 100,000 VND must be flagged and automatically emailed to the Store Manager. If email delivery fails, an in-app push notification is sent to the Store Manager's dashboard as a fallback. |
| BR-05 | **Order Cancellation Rules**: Order cancellation is strictly restricted to the `PENDING` status. Once the order transitions to `PREPARING` (preparation started), the cancellation action is disabled for all users, including Cashiers and Managers. |
| BR-06 | [RESERVED / DELETED] |
| BR-07 | **Inventory Action on Cancellation**: For packaged/ready-to-serve products, stock is deducted immediately at payment checkout (UC-51). If the order is cancelled while in the `PENDING` state, these items are auto-replenished. For freshly prepared items, stock is only deducted when the order transitions to the `PREPARING` state (UC-62). If cancelled while in the `PENDING` state, no stock deduction has occurred yet, so no replenishment is needed. |
| BR-08 | **Loyalty & Voucher Rollback**: Order cancellation reverses used vouchers (restoring total and customer limits) and adjusts loyalty points (gained points are deducted, and redeemed points are refunded to the customer balance). |
| BR-09 | **Refund Authorization & Execution**: Refunds for orders in the `PENDING` status can be performed directly by the Cashier without manager approval. All refunds must occur within **7 days** of the original purchase. **Cash refunds** are paid from, and recorded against, the **currently open Shift Session** on the terminal at the moment of refund (the drawer that physically pays out) — regardless of which shift the original order belonged to — reducing that shift's expected cash for reconciliation (BR-03). If **no** shift is open at the time, a cash refund cannot be processed until a shift is opened. **Card/VietQR refunds** invoke the payment gateway's refund API and have no cash-drawer impact, so they are independent of the shift session. |
| BR-10 | **Inactive Accounts Block**: Accounts with `is_active = false` must be blocked from logging in. |
| BR-11 | **Account Suspension**: Account suspension lasts exactly 15 minutes after 5 consecutive failed attempts. |
| BR-12 | **Force Password Change Block**: Mandatory password change flag blocks navigation to any other module. User cannot bypass the Force Password Change screen. |
| BR-13 | **Logout Session Logging**: Logout time must be logged upon termination of user session. |
| BR-14 | **Password Complexity**: New passwords must be at least 8 characters, containing at least one uppercase letter, one lowercase letter, one number, and one special character. |
| BR-15 | **Password Uniqueness**: New passwords cannot match the current password. |
| BR-16 | **OTP Validity Duration**: OTP validity duration is exactly 10 minutes. |
| BR-17 | **OTP Attempt Limit**: Maximum of 3 OTP attempts before recovery session is locked. |
| BR-18 | **Session Token Invalidation**: Password change or setting status to Inactive terminates active session tokens on all other devices immediately. |
| BR-19 | **Profile Field Scopes**: Cashiers and Baristas can only change their contact email and phone. Only the System Admin (`ssadmin`) can update administrative parameters (e.g. role, branch assignment, account status) via the User Account Management tools. |
| BR-20 | **User List Pagination**: User accounts list supports pagination (default: 20 records per page). |
| BR-21 | **Activity History Scope**: Activity history displays the last 50 logins, shift history, and changes made by the user. |
| BR-22 | **Default Active Status**: Created accounts default status to active, and force a password change on next login. |
| BR-23 | **Last System Admin Account Protection**: System must block any attempt to deactivate or change the role of the last active System Admin (`ssadmin`) account, since `ssadmin` is the only role able to provision users and manage system access. |
| BR-24 | **Menu Items Autocomplete & Filters**: Items list shows search autocomplete results and real-time category filtering. |
| BR-25 | **Menu Item Availability Status**: Availability states must indicate `Available` or `Out of Stock` based on active quantities or flags. |
| BR-26 | **Menu Item Abbreviation Generation**: Abbreviation is automatically created based on first letters of words in the unsignified name (e.g. "Cà phê đá" -> "cfd") and updates if name is modified. |
| BR-27 | [RESERVED / DELETED] |
| BR-28 | **Menu Items Soft Delete**: Menu items are never permanently deleted from database to preserve historical sales reports. |
| BR-29 | **Topping Pricing & Linkage**: Price can be 0 for standard options (e.g. "No Ice", "No Sugar"). Toppings can be linked globally or selectively to drinks. |
| BR-30 | **Category Sales propagation**: Category updates propagate immediately to POS sales screen catalogs. |
| BR-31 | **Category Deletion Restriction**: Cannot delete a category if it currently contains active menu items. |
| BR-32 | **Audit Discrepancy Note**: Explanatory notes are mandatory if physically counted actual quantity does not match expected value. |
| BR-33 | **Cash Float Limit**: Starting cash float must be greater than or equal to zero. |
| BR-34 | **[RESERVED / DELETED]** (Previously: Real-Time Membership Tier Levels) |
| BR-35 | **Loyalty Points Expiry**: Loyalty points expire after 12 months of customer inactivity (no new transactions made by the customer). |
| BR-36 | **Past Schedules Block**: Cannot modify schedules that occurred in the past. |
| BR-37 | **Schedules Deletion Notify**: Deletion removes the shift and sends notification alerts to affected employees. |
| BR-38 | **Attendance PIN Verification**: Staff attendance check-in and check-out records are recorded manually via the dedicated attendance popup, and are not automatically created upon logging into the user account session. |
| BR-39 | **Lateness Calculation Rule**: Lateness is calculated relative to the scheduled shift start time (e.g. check-in after 06:00 AM for a morning shift). |
| BR-40 | **Read-Only Voucher Code**: Alphanumeric Voucher Code string value cannot be modified after saving. |
| BR-41 | **Deactivation Redemption Block**: Deactivating a voucher immediately stops all checkout redemptions. |
| BR-42 | [RESERVED / DELETED] |
| BR-43 | [RESERVED / DELETED] |
| BR-44 | **Reports & Metrics Scope**: Store Managers can only view and export reports scoped to their assigned branch. CEO Viewers can access and export consolidated brand reports. |
| BR-45 | **VAT Configuration Limits**: Default VAT rate must be between 0% and 20%. |
| BR-46 | **Config Sync propagation**: Saving changes updates the receipt calculation engine and template layouts immediately. |
| BR-47 | **Branch Config Scope**: Store Managers configure their own branch's local operational settings (timezone, hardware, logo) via UC-42 Branch Local Settings. The System Admin (`ssadmin`) does not edit branch local settings; the System Admin's branch authority is limited to the Branch Management lifecycle — create, view, and deactivate branches (UC-63 to UC-65). |
| BR-48 | **IP/COM Printer Port Validation**: Device configuration fields can accept TCP/IP addresses or Serial COM ports. |
| BR-49 | **Manual Points Adjustment Limitations**: Manual points adjustments require a recorded reason and are locked to Business Admin role. |
| BR-50 | **Discount Cap**: The Net Total Payable after all discounts (voucher discount and point redemption) cannot be negative. Minimum Net Total Payable is 0 VND. The system caps the combined discount value at the Gross Subtotal. |
| BR-51 | **Order Cancellation Logging**: Every order cancellation action must record the cashier's identity, timestamp, cancellation reason, and detailed notes in the `order_cancellations` log. No manager PIN or override code verification is required. |
| BR-52 | **Voucher Status Definitions**: A voucher's display status is computed dynamically: `SCHEDULED` = current date is before `Start Date`; `ACTIVE` = current date is between `Start Date` and `End Date` inclusive and voucher has not been manually deactivated; `EXPIRED` = current date is after `End Date` or voucher has been manually deactivated. |
| BR-53 | **Attendance Check-in & Check-out**: Staff check-in and check-out are performed via a dedicated attendance popup by entering a personal 4-digit PIN and taking a camera snapshot. This action is independent of the active terminal session login. |
| BR-53a | **Cross-Branch Attendance Attribution**: Each `attendance_logs` row stores both the `employee_id` and the **terminal `store_id`** where the check-in/out physically occurred (which may differ from the employee's home `store_id`). Reports aggregate on two axes: **payroll / total worked hours** are summed by `employee_id` across **all** branches (so an employee is paid for every shift worked, anywhere); **branch labour-cost reports** are summed by the **terminal `store_id`** (so each branch's cost reflects whoever actually worked there). |
| BR-54 | **Maximum Active Branch Capacity**: The system supports a dynamic number of active branches simultaneously, configured via the system parameter `MAX_ACTIVE_BRANCHES`. Deactivated branches (`is_active = false`) do not count toward this limit. The "Add Branch" button is disabled when the limit is reached. |
| BR-55 | **Branch Deactivation Preconditions**: A branch cannot be deactivated if it has any open shift sessions (`SHIFT_SESSION.status = OPEN`) or any orders in non-terminal states (`PENDING`, `PREPARING`, `HOLD`, `READY`). All shifts must be closed and all orders must reach terminal states (`COMPLETED` or `CANCELLED`) before deactivation is permitted. |
| BR-56 | **Branch Deactivation Cascade Effects**: When a branch is deactivated: (1) All `USER` accounts with matching `store_id` are set to `is_active = false` and their session tokens are terminated (per BR-18); (2) All future `STAFF_SCHEDULE` entries (`shift_date > current_date`) for the branch are deleted and notification alerts are sent to affected employees (per BR-37); (3) Existing historical data (`ORDER`, `STOCK_ITEM`, `ATTENDANCE`, `SHIFT_SESSION`) is preserved as read-only for reporting purposes. |
| BR-57 | **Employee ID Auto-Allocation**: When creating a new employee, the system must automatically allocate a unique sequential Employee ID with the format `EMP-{Sequence}` (e.g. `EMP-043` for the 43rd employee record). |
| BR-58 | **Real-time Username Generation**: The system must automatically generate a proposed username when the System Admin enters the employee's full name. The generation algorithm uses the formula: `[Normalized Main Name in Lowercase][Initials of Middle & Family Names][Clean Sequence ID]`. Vietnamese characters must be converted to plain English alphabet. E.g. "Nguyễn Văn An" with sequence ID 43 -> "AnNV43". |
| BR-59 | **Branch Staff Isolation & Read-Only**: A Store Manager can only view, search, and call their local staff. All mutation capabilities (create, modify role, deactivate user, update PIN) are restricted to the System Admin (`ssadmin`). A Store Manager must not be allowed to view rosters or contact details of staff registered at other branch facilities. |
| BR-60 | **User Session / Shift Session Independence**: Terminating a cashier's User Session does not close the active Shift Session on the POS terminal. The Shift Session persists until explicitly closed by a cashier (UC-53) and approved by the Store Manager. |
| BR-61 | **KDS KPI Aggregation Scope**: Barista performance indicators (average preparation time, orders completed per shift) are calculated at the `store_id + shift_session_id` level. No per-barista per-drink metric is recorded. |
| BR-62 | **Category Soft-Delete Handling**: When a category is soft-deleted (`is_deleted = true`), all `menu_items` rows that referenced it have their `category_id` set to `NULL` (nullable FK) to prevent FK constraint violations. Items with `category_id = NULL` appear as uncategorized. |
| BR-63 | **Raw Material Master Ownership**: The raw-material catalog is chain-wide and maintained exclusively by the `businessadmin` (UC-74). Branch `STOCK_ITEM` records reference a master material by foreign key; Store Managers may transact quantities (UC-32/33/34) but cannot create, rename, or delete material types. There is no central warehouse — branches import directly from third-party suppliers. |
| BR-64 | **Raw Material Soft-Delete**: Raw materials are never hard-deleted — they are set `Inactive` to preserve recipe links and historical stock transactions. An inactive material is hidden from new recipe and import selections but remains visible in history and existing branch stock. |



## 5.2 Common Requirements

### 5.2.1 Audit Logging
- **Rule**: All modifications to crucial records (user accounts, stock levels, tax rates, menu prices) must log an audit entry.
- **Audit Format**: `Timestamp`, `User ID`, `Action Type` (`CREATE`, `UPDATE`, `DELETE`), `Entity affected`, `Old Value JSON`, `New Value JSON`.

### 5.2.2 Datetime Formatting
- **Standard**: All date and time data must be recorded in UTC, but displayed in the store's configured local timezone (e.g., `Asia/Ho_Chi_Minh` - UTC+7) on all POS screens, reports, and invoices.

---

## 5.3 Application Messages List

The table below lists the standardized messages. 

> [!NOTE]
> **Localization & Central Management**: The message list is centrally managed via a dedicated translation dictionary (e.g., i18n JSON files). Application messages are referenced in code by their `Message Code` to allow dynamic localization and easier updates without requiring application recompilation.

| # | Message code | Message Type | Context | Content |
|---|---|---|---|---|
| 1 | MSG01 | Toast message | Authenticating employee entry successfully | *Login successful. Welcome back, {full_name}!* |
| 2 | MSG02 | In red, under the text box | Entering incorrect password or username on login | *Incorrect username or password. Remaining attempts: {count}.* |
| 3 | MSG03 | Dialog pop-up | Authenticating a suspended or deactivated account | *Account suspended. Please contact your administrator.* |
| 4 | MSG04 | Dialog pop-up | Session token expires or is cleared from client storage | *Session expired. Please login again.* |
| 5 | MSG05 | Toast message | Creating and registering a new product item successfully | *New item successfully added to menu.* |
| 6 | MSG06 | Toast message | Completing checkout transaction successfully | *Transaction completed. Change due: {amount}.* |
| 7 | MSG07 | Notification badge | Stock level of raw material falls below safety threshold | *Warning: Stock level for {item} is below safety threshold.* |
| 8 | MSG08 | Dialog pop-up | User attempts to access a restricted screen or feature | *Unauthorized action. You do not have permission to access this page.* |
| 9 | MSG09 | In red / Toast message | Voucher code input is invalid, expired, or doesn't meet minimum order value | *Voucher code is invalid or has expired.* |
| 10 | MSG10 | In red / Toast message | Entering incorrect or expired OTP recovery code | *Incorrect or expired OTP. Please check your email and try again.* |
| 11 | MSG11 | Toast message / Pop-up | Customer doesn't have enough loyalty points to redeem | *Insufficient points balance.* |
| 12 | MSG12 | Toast message / Pop-up | Assigning employee to a shift that conflicts with their existing scheduled shifts | *Employee shift conflict. The employee is already scheduled for another shift during this time block.* |
| 13 | MSG13 | [RESERVED / DELETED] | *[Reserved for future use]* | *[Reserved for future use]* |
| 14 | MSG14 | In red / Toast message | Entering points value that is not a multiple of 100 | *Redemption points must be in multiples of 100.* |
| 15 | MSG15 | Toast message | Admin successfully creates a new branch | *Branch successfully created.* |
| 16 | MSG16 | Dialog pop-up | Admin attempts to add a branch when maximum configured capacity is reached | *Maximum branch capacity reached. Please deactivate an existing branch or increase the limit before adding a new one.* |
| 17 | MSG17 | Dialog pop-up | Cashier attempts to log out with an active open shift | *You have an active shift session open. You must close your shift (UC-53) before logging out.* |


---

## 5.4 Feature-Actor Mapping Matrix

The matrix below maps operational modules and system features to employee roles, defining their precise access permissions.

### Access Level Legend:
- **C**: Create
- **R**: Read
- **U**: Update
- **D**: Delete
- **—**: No Access (Unauthorized)

> **HQ role split**: The former single "HQ Admin" column is now three columns per the §3.2.0 RBAC model — **CEO Viewer** (`ceoviewer`, read-only HQ reports), **Business Admin** (`businessadmin`, catalog/category/voucher/CRM), and **System Admin** (`ssadmin`, users/config/branches). Branch inventory is owned solely by the Store Manager — no HQ role has stock access (per the §3.1 Screen Authorization note).

| Feature / Functional Module | CEO Viewer | Business Admin | System Admin | Store Manager | POS Cashier | Barista |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| **User Account Management (CRUD)** | — | — | C / R / U / D | — | — | — |
| **Branch Staff Profile List** | — | — | — | R (Read-Only) | — | — |
| **Catalog Menu & Category (CRUD)** | — | C / R / U / D | — | R (Read-Only) | R (Read-Only) | R (Read-Only) |
| **Raw Material Master (chain-wide)** | — | C / R / U / D | — | R (via stock dropdowns) | — | — |
| **Menu Availability Status toggle** | — | C / R / U | — | C / R / U | — | — |
| **Voucher & Campaign (CRUD)** | — | C / R / U / D | — | — | — | — |
| **Customer Loyalty Registry** | — | C / R / U / D | — | C / R / U | C / R / U | — |
| **Staff Scheduling & Shift planner** | — | — | — | C / R / U / D | R (Read-Only) | R (Read-Only) |
| **Staff Attendance Logs & Reports** | — | — | — | C / R / U | — | — |
| **Inventory Stock Management** | — | — | — | C / R / U | — | — |
| **POS Shift Session Control** | — | — | — | U (Override) | C / R / U | — |
| **POS Checkout & Invoicing** | — | — | — | U (Override) | C / R / U | — |
| **Order Prep & Kitchen Queue** | — | — | — | R (Read-Only) | R (Read-Only) | C / R / U |
| **HQ Consolidated Business Reports** | R (Read-Only) | — | — | — | — | — |
| **Branch Revenue & Sales Reports** | R (Consolidated) | — | — | C / R / U | — | — |
| **Central System Configurations** | — | — | C / R / U / D | — | — | — |
| **Branch Local Settings** | — | — | — | C / R / U | — | — |
| **Branch Management (Lifecycle)** | — | — | C / R / U | — | — | — |





