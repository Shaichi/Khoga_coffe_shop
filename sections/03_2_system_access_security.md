# 3.2 System Access & Security

This section details the functional requirements for authentication, user profiles, and employee account administration.

---

## 3.2.1 F01 - Login / UC-01 Login

### 3.2.1.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|               Login                |
|                                    |
|  [Logo Coffee Shop]                |
|                                    |
|  User Name                         |
|  [ Username                      ] |
|                                    |
|  Password                          |
|  [ **********                    ] |
|                                    |
|         [      LOGIN      ]        |
|                                    |
|         _Forgot Password?_         |
|                                    |
+------------------------------------+
```

#### Table 3-1: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | User Name | Text | Yes | 50 | Account login name. |
| 2 | Password | Password | Yes | 255 | Masked input field for password entry. |
| 3 | Login | Button | | | Triggers credential verification and logs the user in. |
| 4 | Forgot Password | Link | | | Navigates user to Forgot Password flow. |

### 3.2.1.2 Use Case Description

| Use Case ID | UC-01 | Use Case Name | Login |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin, Store Manager, Cashier, Barista |
| **Description** | Allows authorized staff members to authenticate and access their specific operational portals. |
| **Precondition** | User account is active and user is not currently logged in. |
| **Trigger** | User opens the application and lands on the Login screen. |
| **Post-Condition** | User is successfully authenticated, session is established, and user is redirected to their homepage. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | User | Enters Username and Password, and clicks the "Login" button. |
| 2 | Portal | Verifies the credentials and checks account status. |
| 3 | Portal | Validates successful login and redirects the user to the interface matching their role. |

#### Alternative Flows
##### AT1: Invalid Credentials
- **Trigger**: At step 2, the user enters incorrect username or password.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays warning message: `"Incorrect username or password. Remaining attempts: {count}."` (MSG02) |

##### AT2: Mandatory Password Reset
- **Trigger**: At step 3, the account is flagged for mandatory password change.

| Sub-step | Actor | Action |
|---|---|---|
| 3.1 | Portal | Redirects the user immediately to the Force Password Change screen and restricts access to other areas. |

##### AT3: Too Many Failed Login Attempts
- **Trigger**: At step 2, 5 consecutive failed login attempts occur.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Suspends the user account from login attempts for 15 minutes. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-10 | Accounts with `is_active = false` must be blocked from logging in. |
| BR-11 | Account suspension lasts exactly 15 minutes after 5 consecutive failed attempts. |
| BR-12 | Mandatory password change flag blocks navigation to any other module. |

---

## 3.2.2 F02 - Logout / UC-02 Logout

### 3.2.2.1 Screen Mock-up (Mobile Portrait Confirmation)
```
+------------------------------------+
|        Logout Confirmation         |
|                                    |
|                                    |
|   Are you sure you want to log     |
|   out of the application?          |
|                                    |
|                                    |
|      [ Cancel ]     [ Log Out ]    |
|                                    |
+------------------------------------+
```

#### Table 3-2: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Cancel | Button | | | Aborts logout flow and returns to current active page. |
| 2 | Log Out | Button | | | Clears active session, logs action, and returns to Login. |

### 3.2.2.2 Use Case Description

| Use Case ID | UC-02 | Use Case Name | Logout |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin, Store Manager, Cashier, Barista |
| **Description** | Safely terminates the active user session. |
| **Precondition** | User is authenticated. |
| **Trigger** | User clicks the "Logout" button/link. |
| **Post-Condition** | Active session tokens are cleared, logout is logged, and user is returned to Login screen. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | User | Clicks the Logout option. |
| 2 | Portal | Displays logout confirmation modal. |
| 3 | User | Clicks "Log Out" button. |
| 4 | Portal | Terminates active session, records timestamp, and redirects to Login screen. |

#### Alternative Flows
##### AT1: Active Shift Check
- **Trigger**: At step 2, Cashier has an active POS shift open.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays warning message: `"You have an active shift session open. Please close your shift before logging out."` |
| 2.2 | Cashier | Chooses to proceed with logout anyway, or cancels to close shift first. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-13 | Logout time must be logged upon termination of user session. |

---

## 3.2.3 F03 - Change Password / UC-09 Change Password

### 3.2.3.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|          Change Password           |
|                                    |
|  Current Password                  |
|  [ **********                    ] |
|                                    |
|  New Password                      |
|  [ **********                    ] |
|                                    |
|  Confirm New Password              |
|  [ **********                    ] |
|                                    |
|         [ SAVE CHANGES ]           |
|                                    |
+------------------------------------+
```

#### Table 3-3: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Current Password | Password | Yes | 255 | Current masked password. |
| 2 | New Password | Password | Yes | 255 | New password adhering to complexity requirements. |
| 3 | Confirm New Password | Password | Yes | 255 | Re-enter new password to verify match. |
| 4 | Save Changes | Button | | | Submits change request. |

### 3.2.3.2 Use Case Description

| Use Case ID | UC-09 | Use Case Name | Change Password |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin, Store Manager, Cashier, Barista |
| **Description** | Allows logged-in users to update their password. |
| **Precondition** | User is authenticated. |
| **Trigger** | User navigates to Change Password screen in settings. |
| **Post-Condition** | User's password is changed successfully. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | User | Inputs Current Password, New Password, and Confirm Password, then clicks "Save Changes". |
| 2 | Portal | Verifies that Current Password is correct and New Password matches Confirm Password. |
| 3 | Portal | Saves new password, displays success message, and terminates other active sessions. |

#### Alternative Flows
##### AT1: Current Password Incorrect
- **Trigger**: At step 2, Current Password does not match recorded password.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"The current password entered is incorrect."` |

##### AT2: Password Complexity Failed
- **Trigger**: At step 2, New Password does not meet complexity guidelines.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"Password must be at least 8 characters long and contain uppercase, lowercase, numeric, and special characters."` |

##### AT3: Password Mismatch
- **Trigger**: At step 2, New Password and Confirm Password do not match.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"Confirm password does not match the new password."` |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-14 | New passwords must be at least 8 characters, containing at least one uppercase letter, one lowercase letter, one number, and one special character. |
| BR-15 | New passwords cannot match the current password. |

---

## 3.2.4 F04 - Forgot Password / UC-03 Forgot Password

### 3.2.4.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|          Forgot Password           |
|                                    |
|  Enter your registered email to    |
|  receive a verification OTP code.  |
|                                    |
|  Email Address                     |
|  [ email@example.com             ] |
|                                    |
|         [   SEND OTP   ]           |
|                                    |
|         _Back to Login_            |
+------------------------------------+
```

#### Table 3-4: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Email Address | Text | Yes | 100 | Registered work email address. |
| 2 | Send OTP | Button | | | Triggers sending verification OTP code to email. |
| 3 | Back to Login | Link | | | Navigates user back to Login screen. |

### 3.2.4.2 Use Case Description

| Use Case ID | UC-03 | Use Case Name | Forgot Password |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin, Store Manager, Cashier, Barista |
| **Description** | Initiates password recovery when a user forgets their credentials. |
| **Precondition** | User is not logged in. |
| **Trigger** | User clicks the "Forgot Password" link on the Login screen. |
| **Post-Condition** | If email is valid, OTP code is emailed and user is sent to OTP verification view. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | User | Enters registered email address and clicks "Send OTP". |
| 2 | Portal | Checks if the email is associated with an active user account. |
| 3 | Portal | Generates a 6-digit OTP code (valid for 10 minutes), emails it to the user, and redirects user to OTP Verification screen. |

#### Alternative Flows
##### AT1: Non-existent Email
- **Trigger**: At step 2, email address is not found.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays standard confirmation message to prevent account harvesting: `"If this email is registered, you will receive a reset OTP shortly."` |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-16 | OTP validity duration is exactly 10 minutes. |

---

## 3.2.5 F05 - Verify OTP / UC-04 Verify OTP

### 3.2.5.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|             Verify OTP             |
|                                    |
|  Enter the 6-digit verification    |
|  code sent to your email.          |
|                                    |
|  Verification Code                 |
|  [ _ _ _ _ _ _ ]                   |
|                                    |
|         [  VERIFY CODE  ]          |
|                                    |
|         _Resend Code (59s)_        |
+------------------------------------+
```

#### Table 3-5: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Verification Code | Text | Yes | 6 | 6-digit numeric recovery code. |
| 2 | Verify Code | Button | | | Submits OTP for validation. |
| 3 | Resend Code | Link | | | Resends OTP (disabled during 60-second cooldown). |

### 3.2.5.2 Use Case Description

| Use Case ID | UC-04 | Use Case Name | Verify OTP |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin, Store Manager, Cashier, Barista |
| **Description** | Validates the 6-digit verification code sent during password recovery. |
| **Precondition** | Forgot password request has been initiated. |
| **Trigger** | Redirected from Forgot Password view. |
| **Post-Condition** | Code is validated, and user is sent to Set New Password screen. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | User | Enters the 6-digit OTP code and clicks "Verify Code". |
| 2 | Portal | Validates OTP match and checks expiration timeline. |
| 3 | Portal | Flags session as verified and redirects to Set New Password screen. |

#### Alternative Flows
##### AT1: Code Mismatch or Expired
- **Trigger**: At step 2, code is incorrect or older than 10 minutes.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays warning message: `"Invalid or expired verification code. Please request a new one."` |

##### AT2: Limit Exceeded
- **Trigger**: At step 2, 3 failed OTP submissions occur.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Disables recovery session, displaying message to restart forgot password flow. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-17 | Maximum of 3 OTP attempts before recovery session is locked. |

---

## 3.2.6 F06 - Set New Password / UC-05 Set New Password

### 3.2.6.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|          Set New Password          |
|                                    |
|  Create a new password for your    |
|  account.                          |
|                                    |
|  New Password                      |
|  [ **********                    ] |
|                                    |
|  Confirm Password                  |
|  [ **********                    ] |
|                                    |
|         [ RESET PASSWORD ]         |
|                                    |
+------------------------------------+
```

#### Table 3-6: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | New Password | Password | Yes | 255 | New password adhering to complexity requirements. |
| 2 | Confirm Password | Password | Yes | 255 | Re-enter new password to verify match. |
| 3 | Reset Password | Button | | | Submits password update. |

### 3.2.6.2 Use Case Description

| Use Case ID | UC-05 | Use Case Name | Set New Password |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin, Store Manager, Cashier, Barista |
| **Description** | Finalizes password recovery flow by configuring a new password. |
| **Precondition** | User session has a validated recovery status. |
| **Trigger** | Redirected from OTP Verification page. |
| **Post-Condition** | Password is updated and user redirected to Login. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | User | Enters new password, confirms it, and clicks "Reset Password". |
| 2 | Portal | Validates password complexity and match. |
| 3 | Portal | Updates account password, closes all active sessions elsewhere, and displays: `"Password reset successful. Please login with your new credentials."` |

#### Alternative Flows
##### AT1: Validation Failure
- **Trigger**: At step 2, inputs fail complexity or mismatch check.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays appropriate error message (same as Change Password errors). |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-14 | New passwords must be at least 8 characters, containing at least one uppercase letter, one lowercase letter, one number, and one special character. |
| BR-18 | Password change or setting status to Inactive terminates active session tokens on all other devices immediately. |

---

## 3.2.7 F06.1 - Force Password Change / UC-06 Force Password Change

### 3.2.7.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|       Force Password Change        |
|                                    |
|  For security, you must change your|
|  temporary password before using   |
|  the system.                       |
|                                    |
|  New Password                      |
|  [ **********                    ] |
|                                    |
|  Confirm New Password              |
|  [ **********                    ] |
|                                    |
|         [ CHANGE PASSWORD ]        |
|                                    |
+------------------------------------+
```

#### Table 3-7: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | New Password | Password | Yes | 255 | Password input adhering to security requirements. |
| 2 | Confirm New Password | Password | Yes | 255 | Password input confirming the new password. |
| 3 | Change Password | Button | | | Submits the new password. |

### 3.2.7.2 Use Case Description

| Use Case ID | UC-06 | Use Case Name | Force Password Change |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | User (Base Staff) |
| **Description** | Forces a first-time logged-in user to replace their temporary password before accessing the system. |
| **Precondition** | User has logged in successfully using a temporary password. |
| **Trigger** | Portal detects that the user is logging in for the first time or has a flag to force password change. |
| **Post-Condition** | User's temporary password is replaced and user is redirected to the home screen. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Portal | Displays the Force Password Change screen. |
| 2 | User | Enters a new secure password and confirms it. |
| 3 | User | Clicks "Change Password". |
| 4 | Portal | Validates that the password conforms to security standards and both entries match. |
| 5 | Portal | Updates the password, clears the force change flag, and redirects the user to their portal home. |

#### Alternative Flows
##### AT1: Validation Errors
- **Trigger**: Passwords do not match or fail security strength check.

| Sub-step | Actor | Action |
|---|---|---|
| 4.1 | Portal | Displays warning message: `"Passwords do not match."` or `"Password must be at least 8 characters long and include numbers."` |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-12 | Mandatory password change flag blocks navigation to any other module. User cannot bypass the Force Password Change screen. |

---

## 3.2.8 F07 - View Profile / UC-07 View Profile

### 3.2.8.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|            My Profile              |
|                                    |
|  ID: EMP-042                       |
|  Name: Nguyen Van A                |
|  Username: nva_cashier             |
|  Role: Cashier                     |
|  Email: nva@coffeezone.com         |
|  Phone: 0987654321                 |
|  Store: Coffee Zone - Branch 1     |
|  Date Joined: 2026-01-15           |
|                                    |
|         [ EDIT PROFILE ]           |
|                                    |
+------------------------------------+
```

#### Table 3-8: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Edit Profile | Button | | | Navigates to Edit Profile screen. |

### 3.2.8.2 Use Case Description

| Use Case ID | UC-07 | Use Case Name | View Profile |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin, Store Manager, Cashier, Barista |
| **Description** | Allows logged-in staff to view their personal detail cards. |
| **Precondition** | User is authenticated. |
| **Trigger** | User selects the "Profile" option in settings/menu. |
| **Post-Condition** | Employee profile cards are displayed. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | User | Navigates to Profile view. |
| 2 | Portal | Retrieves employee ID, name, role, store, contact detail, and displays them. |

---

## 3.2.9 F08 - Update Profile / UC-08 Update Profile

### 3.2.9.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|           Edit Profile             |
|                                    |
|  Contact Email                     |
|  [ nva@coffeezone.com            ] |
|                                    |
|  Contact Phone                     |
|  [ 0987654321                    ] |
|                                    |
|         [  SAVE PROFILE  ]         |
|                                    |
|         [     CANCEL     ]         |
+------------------------------------+
```

#### Table 3-9: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Contact Email | Text | Yes | 100 | Active contact email. |
| 2 | Contact Phone | Text | Yes | 20 | Phone number format (10-11 digits). |
| 3 | Save Profile | Button | | | Saves modifications and updates profile. |
| 4 | Cancel | Button | | | Discards edits and returns to View Profile screen. |

### 3.2.9.2 Use Case Description

| Use Case ID | UC-08 | Use Case Name | Update Profile |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin, Store Manager, Cashier, Barista |
| **Description** | Allows staff to modify their personal contact details. |
| **Precondition** | User is authenticated. |
| **Trigger** | User clicks the "Edit Profile" button. |
| **Post-Condition** | Profile info is modified. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | User | Edits Email or Phone, and clicks "Save Profile". |
| 2 | Portal | Validates inputs. |
| 3 | Portal | Updates account details and returns to View Profile screen. |

#### Alternative Flows
##### AT1: Validation Errors
- **Trigger**: At step 2, email or phone is invalid.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"Please enter a valid email and phone number."` |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-19 | Cashiers and Baristas can only change their contact email and phone. Admins and Managers can update administrative parameters (e.g. roles) via admin tools. |

---

## 3.2.10 F09 - List User Account / UC-10 View User Account List

### 3.2.10.1 Screen Mock-up (Desktop Landscape)
```
+---------------------------------------------------------------------------------+
| Admin Portal > Employee Account Management                                      |
+---------------------------------------------------------------------------------+
|  Search: [ nva_cashier          ]   Role: [ All Roles ] [v]   Status: [Active]v |
|                                                                                 |
|  +-----+------------+---------------+---------+--------------------+---------+  |
|  | ID  | Username   | Full Name     | Role    | Email              | Status  |  |
|  +-----+------------+---------------+---------+--------------------+---------+  |
|  | 001 | nva_cashier| Nguyen Van A  | Cashier | nva@coffeezone.com | Active  |  |
|  | 002 | admin_hq   | Tran Thi B    | Admin   | admin@coffee.com   | Active  |  |
|  +-----+------------+---------------+---------+--------------------+---------+  |
|  [Page 1 of 5]                                              [ + Add Account ]  |
+---------------------------------------------------------------------------------+
```

#### Table 3-10: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Search | Text | No | 100 | Search criteria (Name, Username, Role). |
| 2 | Role | Dropdown | No | | Filters grid by employee role. |
| 3 | Status | Dropdown | No | | Filters grid by status (`Active` / `Inactive`). |
| 4 | Add Account | Button | | | Navigates to Add User Account view. |

### 3.2.10.2 Use Case Description

| Use Case ID | UC-10 | Use Case Name | View User Account List |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin |
| **Description** | Provides an administrative directory of all system accounts. |
| **Precondition** | Admin is logged in. |
| **Trigger** | Admin opens the Employee Account Management menu. |
| **Post-Condition** | Active grid of employee accounts is displayed. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Admin | Accesses Employee Account Management panel. |
| 2 | Portal | Displays filters and user listing grid (defaults to active accounts). |
| 3 | Admin | Enters query or filter selection to search profiles. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-20 | User accounts list supports pagination (default: 20 records per page). |

---

## 3.2.11 F10 - View User Details & History / UC-13 View User Account Detail

### 3.2.11.1 Screen Mock-up (Desktop Landscape)
```
+---------------------------------------------------------------------------------+
| Admin Portal > Employee Account Management > View Account Details               |
+---------------------------------------------------------------------------------+
|  ID: EMP-001          Full Name: Nguyen Van A          Role: Cashier            |
|  Username: nva        Email: nva@coffeezone.com        Phone: 0987654321        |
|  Status: Active       Joined: 2026-01-15               Branch: Store 1          |
|                                                                                 |
|  Activity History Log (Last 5 logins / actions):                                |
|  - 2026-05-24 08:00:15 - Successful Login                                       |
|  - 2026-05-23 22:01:00 - Closed Shift (Session ID: #104)                        |
|                                                                                 |
|                                                  [ Edit User ]    [ Back ]      |
+---------------------------------------------------------------------------------+
```

#### Table 3-11: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Edit User | Button | | | Navigates to Update User Account view. |
| 2 | Back | Button | | | Returns to Employee Account List. |

### 3.2.11.2 Use Case Description

| Use Case ID | UC-13 | Use Case Name | View User Account Detail |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin |
| **Description** | Displays full account profile details and operational history of a selected user. |
| **Precondition** | Admin is logged in. |
| **Trigger** | Admin selects a user account from the grid. |
| **Post-Condition** | Selected user's profile card and action history are displayed. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Admin | Selects an employee row. |
| 2 | Portal | Displays detailed profile information and activity history log. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-21 | Activity history displays the last 50 logins, shift history, and changes made by the user. |

---

## 3.2.12 F11 - Add User Account / UC-11 Add User Account

### 3.2.12.1 Screen Mock-up (Desktop Landscape)
```
+---------------------------------------------------------------------------------+
| Admin Portal > Employee Account Management > Add Account                        |
+---------------------------------------------------------------------------------+
|  Username: [ nva_cashier      ]   Full Name:   [ Nguyen Van A             ]     |
|  Email:    [ nva@coffee.com   ]   Phone:       [ 0987654321               ]     |
|  Role:     [ Cashier      ] [v]   Branch Store:[ Branch 1             ] [v]     |
|  Password: [ *************    ]                                                 |
|                                                                                 |
|                                                [ Save Account ]    [ Cancel ]   |
+---------------------------------------------------------------------------------+
```

#### Table 3-12: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Username | Text | Yes | 50 | Account login name (unique). |
| 2 | Full Name | Text | Yes | 100 | Employee's full name. |
| 3 | Email | Text | Yes | 100 | Contact work email address (unique). |
| 4 | Phone | Text | Yes | 20 | Contact phone number. |
| 5 | Role | Dropdown | Yes | | Selects role (`ADMIN`, `STORE_MANAGER`, `CASHIER`, `BARISTA`). |
| 6 | Branch Store | Dropdown | No | | Scopes cashier/barista/manager to branch (Null for HQ Admins). |
| 7 | Password | Password | Yes | 255 | Temporary password for first-time use. |
| 8 | Save Account | Button | | | Submits details to create account. |
| 9 | Cancel | Button | | | Discards details and returns to Employee list. |

### 3.2.12.2 Use Case Description

| Use Case ID | UC-11 | Use Case Name | Add User Account |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin |
| **Description** | Provisions a new employee account. |
| **Precondition** | Admin is logged in. |
| **Trigger** | Admin clicks "+ Add Account" on user list view. |
| **Post-Condition** | New user account created and login activation email is sent. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Admin | Fills out employee fields, assigns role and branch, and clicks "Save Account". |
| 2 | Portal | Validates constraints (username uniqueness, email syntax, password complexity). |
| 3 | Portal | Registers account as active, sets password-reset flag, sends welcome email with credentials, and returns to list view. |

#### Alternative Flows
##### AT1: Validation Errors
- **Trigger**: At step 2, checks fail.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"Username or email already exists, or password complexity criteria not met."` |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-22 | Created accounts default status to active, and force a password change on next login. |

---

## 3.2.13 F12 - Update User Account / UC-12 Update User Account

### 3.2.13.1 Screen Mock-up (Desktop Landscape)
```
+---------------------------------------------------------------------------------+
| Admin Portal > Employee Account Management > Edit Account                       |
+---------------------------------------------------------------------------------+
|  Username: nva_cashier (Read-only)  Full Name:   [ Nguyen Van A             ]   |
|  Email:    [ nva@coffee.com   ]     Phone:       [ 0987654321               ]   |
|  Role:     [ Cashier      ] [v]     Branch Store:[ Branch 1             ] [v]   |
|  Status:   [ Active       ] [v]                                                 |
|                                                                                 |
|                                                [ Save Changes ]    [ Cancel ]   |
+---------------------------------------------------------------------------------+
```

#### Table 3-13: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Username | Label | | | Account username (cannot be modified). |
| 2 | Full Name | Text | Yes | 100 | Employee's name. |
| 3 | Email | Text | Yes | 100 | Contact email. |
| 4 | Phone | Text | Yes | 20 | Contact phone. |
| 5 | Role | Dropdown | Yes | | Account role. |
| 6 | Branch Store | Dropdown | No | | Store assignment. |
| 7 | Status | Dropdown | Yes | | Status selection (`Active` / `Inactive`). |
| 8 | Save Changes | Button | | | Submits updates. |
| 9 | Cancel | Button | | | Discards updates and returns to details. |

### 3.2.13.2 Use Case Description

| Use Case ID | UC-12, UC-14 | Use Case Name | Update & Deactivate User Account |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin |
| **Description** | Modifies employee account details or deactivates them to revoke access. |
| **Precondition** | Admin is logged in. |
| **Trigger** | Admin clicks "Edit User" on details page. |
| **Post-Condition** | Account parameters are updated and active tokens invalidated if deactivated. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Admin | Modifies employee parameters (name, contact, role) or sets status to Inactive (deactivating account), and clicks "Save Changes". |
| 2 | Portal | Validates inputs and flags. |
| 3 | Portal | Saves changes to USER registry. If deactivated, terminates active session tokens on all devices immediately (BR-18). |

#### Alternative Flows
##### AT1: Attempting to Deactivate Last Admin
- **Trigger**: At step 2, Admin attempts to set status of last Admin to `Inactive` or change role.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"Cannot deactivate the last remaining Admin account."` |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-23 | System must block any attempt to deactivate or change the role of the last active Admin account. |
| BR-18 | Password change or setting status to Inactive terminates active session tokens on all other devices immediately. |



