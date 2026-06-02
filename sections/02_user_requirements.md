# 2. User Requirements

This section defines the system actors and maps their operational use cases within the Coffee Shop Management System. The use cases are partitioned into separate, clear diagrams per role to prevent overlapping paths and ensure clean software design boundaries.

---

## 2.1 Actors
The system defines the following roles (actors), structured under a generalization hierarchy where all roles inherit basic account privileges from a base `User` actor:

1. **User (Base Actor)**:
   - The generalization of all employee roles. Contains basic access control, profile viewing, and password management.
2. **Admin (HQ Management)**:
   - Inherits from `User`. Manages master data (users, vouchers, menu) and views brand-level business reports.
3. **Store Manager**:
   - Inherits from `User`. Manages local inventory logistics, shift scheduling, and views local store revenue audits.
4. **Cashier**:
   - Inherits from `User`. Operates the POS terminal for order-taking, member lookups, checkout, and receipt printing.
5. **Barista**:
   - Inherits from `User`. Coordinates drink preparation using the queue monitor and prints label stickers.
6. **Delivery Partner**:
   - An external API actor that automates online order ingestion and availability syncs.

```mermaid
graph TD
    %% Actor Generalization Diagram
    User[User - Base Staff]
    Admin[Admin]
    Manager[Store Manager]
    Cashier[Cashier]
    Barista[Barista]

    Admin --> |"inherits from"| User
    Manager --> |"inherits from"| User
    Cashier --> |"inherits from"| User
    Barista --> |"inherits from"| User
```

---

## 2.2 Use Cases

### 2.2.1 General User & Authentication Use Cases
This diagram defines common access operations available to any authenticated employee.

```mermaid
graph LR
    %% Actors
    Actor_User((User))

    %% Use Cases
    subgraph Authentication System
        UC_Login([Login])
        UC_Logout([Logout])
        UC_Forgot([Forgot Password])
        UC_Verify([Verify OTP])
        UC_SetPass([Set New Password])
        UC_ForceChange([Force Password Change])
        UC_ViewProfile([View Profile])
        UC_UpdateProfile([Update Profile])
        UC_ChangePass([Change Password])
    end

    %% Connections
    Actor_User --> UC_Login
    Actor_User --> UC_Logout
    Actor_User --> UC_Forgot
    Actor_User --> UC_ViewProfile

    %% Include & Extend
    UC_Forgot -.-> |"&lt;&lt;include&gt;&gt;"| UC_Verify
    UC_Forgot -.-> |"&lt;&lt;include&gt;&gt;"| UC_SetPass
    
    UC_ForceChange -.-> |"&lt;&lt;extend&gt;&gt;"| UC_Login

    UC_UpdateProfile -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ViewProfile
    UC_ChangePass -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ViewProfile
```

---

### 2.2.2 Admin Use Cases
The Admin actor manages central catalog assets, customer accounts, vouchers, and reviews consolidated brand reports.

```mermaid
graph LR
    %% Actors
    Actor_Admin((Admin))

    %% Use Cases
    subgraph HQ Administration
        UC_ListUsers([View User Account List])
        UC_AddUser([Add User Account])
        UC_UpdateUser([Update User Account])
        UC_ViewUser([View User Account Detail])
        UC_DeactivateUser([Deactivate User Account])

        UC_ListVouchers([View Vouchers List])
        UC_AddVoucher([Add Voucher])
        UC_UpdateVoucher([Update Voucher])
        UC_DeleteVoucher([Delete Voucher])

        UC_ListCustomers([View Customer List])
        UC_AddCustomer([Add Customer])
        UC_UpdateCustomer([Update Customer])
        UC_ViewCustHistory([View Customer History])

        UC_ListMenu([View Menu & Categories List])
        UC_AddCat([Add Category])
        UC_UpdateCat([Update Category])
        UC_AddMenu([Add Menu Item & Recipe])
        UC_UpdateMenu([Update Menu Item & Recipe])

        UC_ViewReports([View Consolidated Business Reports])
        UC_ExportReports([Export HQ Reports])
        
        UC_ConfigCentral([Configure Central System Settings])

        UC_ListBranches([View Branch List])
        UC_AddBranch([Add Branch])
        UC_UpdateBranch([Update / Deactivate Branch])
    end

    %% Admin Links
    Actor_Admin --> UC_ListUsers
    Actor_Admin --> UC_ListVouchers
    Actor_Admin --> UC_ListCustomers
    Actor_Admin --> UC_ListMenu
    Actor_Admin --> UC_ViewReports
    Actor_Admin --> UC_ConfigCentral
    Actor_Admin --> UC_ListBranches

    %% User extends
    UC_AddUser -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListUsers
    UC_UpdateUser -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListUsers
    UC_ViewUser -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListUsers
    UC_DeactivateUser -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListUsers

    %% Voucher extends
    UC_AddVoucher -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListVouchers
    UC_UpdateVoucher -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListVouchers
    UC_DeleteVoucher -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListVouchers

    %% Customer extends
    UC_AddCustomer -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListCustomers
    UC_UpdateCustomer -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListCustomers
    UC_ViewCustHistory -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListCustomers

    %% Menu/Category extends
    UC_AddCat -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListMenu
    UC_UpdateCat -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListMenu
    UC_AddMenu -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListMenu
    UC_UpdateMenu -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListMenu

    %% Reports extends
    UC_ExportReports -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ViewReports

    %% Branch extends
    UC_AddBranch -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListBranches
    UC_UpdateBranch -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListBranches
```


---

### 2.2.3 Store Manager Use Cases
The Store Manager oversees local inventory adjustments, scheduling staff shifts, and local store financial reports.

```mermaid
graph LR
    %% Actors
    Actor_Manager((Store Manager))

    %% Use Cases
    subgraph Store Logistics & Shifts
        UC_ListStock([View Stock List])
        UC_ImportStock([Import Stock])
        UC_ExportStock([Export Stock])
        UC_AuditStock([Perform Inventory Audit])

        UC_ViewSchedule([View Staff Schedule])
        UC_CreateSchedule([Create Staff Schedule])
        UC_UpdateSchedule([Update Staff Schedule])
        UC_DeleteSchedule([Delete Staff Schedule])
        UC_ViewAttendance([View Staff Attendance Report])

        UC_ViewRevStore([View Store Revenue Reports])
        UC_ExportStoreRev([Export Store Reports])
        
        UC_ConfigBranch([Configure Local Branch Settings])
        UC_ApproveOverride([Cancel Preparing/Ready Order])
        UC_ViewStaffList([View Branch Staff List])
    end

    %% Connections
    Actor_Manager --> UC_ListStock
    Actor_Manager --> UC_ViewSchedule
    Actor_Manager --> UC_ViewRevStore
    Actor_Manager --> UC_ConfigBranch
    Actor_Manager --> UC_ApproveOverride
    Actor_Manager --> UC_ViewStaffList

    %% Stock extends
    UC_ImportStock -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListStock
    UC_ExportStock -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListStock
    UC_AuditStock -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ListStock

    %% Schedule extends
    UC_CreateSchedule -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ViewSchedule
    UC_UpdateSchedule -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ViewSchedule
    UC_DeleteSchedule -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ViewSchedule
    UC_ViewAttendance -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ViewSchedule

    %% Revenue extends
    UC_ExportStoreRev -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ViewRevStore
```


---

### 2.2.4 Cashier Use Cases
The Cashier uses the POS terminal to process orders, apply vouchers, lookup customer memberships, and print receipts.

```mermaid
graph LR
    %% Actors
    Actor_Cashier((Cashier))

    %% Use Cases
    subgraph POS Transaction Operations
        UC_OpenShift([Open Shift])
        UC_AddCart([Add Item to Order])
        UC_UpdateCart([Update Cart Item])
        UC_SearchMenu([Search Menu Item])
        UC_ApplyDiscount([Apply Discount Code])
        UC_RedeemPoints([Redeem Loyalty Points])
        UC_LookupMember([Lookup Customer Membership])
        UC_ProcessPay([Process Payment])
        UC_IssueInvoice([Issue Invoice])
        UC_CloseShift([Close Shift])
        
        UC_ViewLocalHistory([View Local Order History])
        UC_RequestRefund([Request Transaction Refund])
    end

    %% Connections
    Actor_Cashier --> UC_OpenShift
    Actor_Cashier --> UC_AddCart
    Actor_Cashier --> UC_SearchMenu
    Actor_Cashier --> UC_ApplyDiscount
    Actor_Cashier --> UC_RedeemPoints
    Actor_Cashier --> UC_LookupMember
    Actor_Cashier --> UC_ProcessPay
    Actor_Cashier --> UC_IssueInvoice
    Actor_Cashier --> UC_CloseShift
    Actor_Cashier --> UC_ViewLocalHistory

    %% Extends & Includes
    UC_UpdateCart -.-> |"&lt;&lt;extend&gt;&gt;"| UC_AddCart
    UC_RequestRefund -.-> |"&lt;&lt;extend&gt;&gt;"| UC_ViewLocalHistory
```


---

### 2.2.5 Barista Use Cases
The Barista tracks drink prep status, prints cup labels, and escalates preparation issues in the beverage preparation area.

```mermaid
graph LR
    %% Actors
    Actor_Barista((Barista))

    %% Use Cases
    subgraph Kitchen Queue & Preparation
        UC_ViewQueue([View Order Queue Display])
        UC_UpdatePrep([Update Preparation Status])
        UC_PrintLabel([Print Drink Label Sticker])
        UC_ReportIssue([Report Issue / Escalate Order])
    end

    %% Connections
    Actor_Barista --> UC_ViewQueue
    Actor_Barista --> UC_UpdatePrep
    Actor_Barista --> UC_ReportIssue

    %% Extends
    UC_PrintLabel -.-> |"&lt;&lt;extend&gt;&gt;"| UC_UpdatePrep
```

---

## 2.3 Use Case Descriptions
This part describes the use cases & their main flow (the list of the user actions and corresponding system responses that will take place during execution of the use case under normal, expected conditions), using the table format below.

| ID | Group function | Use Case | Actors | Use Case Description & Main Flow |
|---|---|---|---|---|
| **UC-01** | Authentication & Profile | Login | User (Base Staff) | **Description**: Authenticates employee entry to the application.<br>**Main Flow**:<br>1. User enters username and password.<br>2. User accesses the system and is directed to their operational portal. |
| **UC-02** | Authentication & Profile | Logout | User (Base Staff) | **Description**: Terminates active session.<br>**Main Flow**:<br>1. User signs out of the application.<br>2. User is redirected back to the login gateway. |
| **UC-03** | Authentication & Profile | Forgot Password | User (Base Staff) | **Description**: Requests password recovery details.<br>**Main Flow**:<br>1. User submits their email address.<br>2. User receives a verification code via email. |
| **UC-04** | Authentication & Profile | Verify OTP | User (Base Staff) | **Description**: Validates the recovery code.<br>**Main Flow**:<br>1. User submits the verification code.<br>2. User is permitted to configure a new password. |
| **UC-05** | Authentication & Profile | Set New Password | User (Base Staff) | **Description**: Creates a new secure password.<br>**Main Flow**:<br>1. User submits the new password.<br>2. User is returned to the login page to sign in again. |
| **UC-06** | Authentication & Profile | Force Password Change | User (Base Staff) | **Description**: Mandates password update upon first sign-in.<br>**Main Flow**:<br>1. User signs in with initial temporary credentials.<br>2. User is immediately prompted to replace the temporary password with a personal one before performing work. |
| **UC-07** | Authentication & Profile | View Profile | User (Base Staff) | **Description**: Accesses employee details.<br>**Main Flow**:<br>1. User opens their profile details.<br>2. User views their contact details, assigned branch, and operational role. |
| **UC-08** | Authentication & Profile | Update Profile | User (Base Staff) | **Description**: Edits employee contact information.<br>**Main Flow**:<br>1. User updates contact details (e.g., phone or email) and saves.<br>2. The profile displays the updated information. |
| **UC-09** | Authentication & Profile | Change Password | User (Base Staff) | **Description**: Modifies active password.<br>**Main Flow**:<br>1. User enters current password and a new secure password.<br>2. User receives a password change confirmation. |
| **UC-10** | User Management | View User Account List | Admin | **Description**: Lists employee user accounts.<br>**Main Flow**:<br>1. Admin opens the employee list.<br>2. Admin views active, suspended, and role-categorized profiles. |
| **UC-11** | User Management | Add User Account | Admin | **Description**: Registers a new employee profile.<br>**Main Flow**:<br>1. Admin submits new employee info, role, and branch assignment.<br>2. A new staff profile is created, enabling them to log in. |
| **UC-12** | User Management | Update User Account | Admin | **Description**: Modifies employee details.<br>**Main Flow**:<br>1. Admin edits employee details and saves.<br>2. The employee profile is updated. |
| **UC-13** | User Management | View User Account Detail | Admin | **Description**: Audits employee history.<br>**Main Flow**:<br>1. Admin selects a user profile.<br>2. Admin reviews profile metadata and activity records. |
| **UC-14** | User Management | Deactivate User Account | Admin | **Description**: Revokes employee system access.<br>**Main Flow**:<br>1. Admin suspends employee profile.<br>2. Active access is revoked, preventing further login. |
| **UC-15** | Menu & Categories | View Menu & Categories List | Admin | **Description**: Reviews catalog items.<br>**Main Flow**:<br>1. Admin opens the product catalog.<br>2. Admin reviews categories, active dishes/beverages, and prices. |
| **UC-16** | Menu & Categories | Add Category | Admin | **Description**: Creates a new product category.<br>**Main Flow**:<br>1. Admin inputs category details and saves.<br>2. New category is added to the menu configuration. |
| **UC-17** | Menu & Categories | Update Category | Admin | **Description**: Modifies category settings.<br>**Main Flow**:<br>1. Admin updates category details or visibility.<br>2. The category parameters are updated. |
| **UC-18** | Menu & Categories | Add Menu Item & Recipe | Admin | **Description**: Creates a new product and links its raw recipe.<br>**Main Flow**:<br>1. Admin inputs name, price, barcode, and raw ingredient list.<br>2. The product and recipe are registered, making them available for checkout. |
| **UC-19** | Menu & Categories | Update Menu Item & Recipe | Admin | **Description**: Edits product details or recipes.<br>**Main Flow**:<br>1. Admin alters item pricing, availability, or raw material recipe counts.<br>2. Adjustments are saved, instantly modifying local POS catalogs. |
| **UC-20** | Voucher Management | View Vouchers List | Admin | **Description**: Lists active discount promotions.<br>**Main Flow**:<br>1. Admin opens promotions list.<br>2. Admin views campaign details, voucher codes, and usage metrics. |
| **UC-21** | Voucher Management | Add Voucher | Admin | **Description**: Configures new promotional discount.<br>**Main Flow**:<br>1. Admin submits voucher code, discount values, minimum caps, and active dates.<br>2. The voucher configuration is saved. |
| **UC-22** | Voucher Management | Update Voucher | Admin | **Description**: Edits voucher parameters.<br>**Main Flow**:<br>1. Admin adjusts campaign dates, total usage caps, or customer limits.<br>2. The voucher rules are updated. |
| **UC-23** | Voucher Management | Delete Voucher | Admin | **Description**: Deactivates or removes a voucher code.<br>**Main Flow**:<br>1. Admin selects voucher and deactivates it.<br>2. The voucher code is disabled, preventing further usage at checkout. |
| **UC-24** | Customer Management | View Customer List | Admin | **Description**: Reviews membership registry.<br>**Main Flow**:<br>1. Admin views customer directory.<br>2. Admin reviews list of active members and membership levels. |
| **UC-25** | Customer Management | Add Customer | Admin | **Description**: Registers a new membership customer.<br>**Main Flow**:<br>1. Admin enters member details (name, phone, email) and saves.<br>2. Customer is registered as a Bronze loyalty member. |
| **UC-26** | Customer Management | Update Customer | Admin | **Description**: Modifies customer details.<br>**Main Flow**:<br>1. Admin edits member details and saves.<br>2. The membership profile is updated. |
| **UC-27** | Customer Management | View Customer History | Admin | **Description**: Reviews membership loyalty records.<br>**Main Flow**:<br>1. Admin opens member profile.<br>2. Admin reviews historical orders, point accumulation ledger, and milestones. |
| **UC-28** | Reports & Analytics | View Consolidated Business Reports | Admin | **Description**: Accesses centralized reports.<br>**Main Flow**:<br>1. Admin opens consolidation dashboard.<br>2. Admin reviews global brand revenue, compares branch performance, and views best-seller charts. |
| **UC-29** | Reports & Analytics | Export HQ Reports | Admin | **Description**: Downloads brand report sheets.<br>**Main Flow**:<br>1. Admin triggers export.<br>2. The report files are generated and downloaded. |
| **UC-30** | System Configuration | Configure Central System Settings | Admin | **Description**: Configures central parameters.<br>**Main Flow**:<br>1. Admin modifies tax rates, loyalty points rates, or API credentials.<br>2. Changes to central configurations are saved. |
| **UC-31** | Inventory Management | View Stock List | Store Manager | **Description**: Reviews store stock levels.<br>**Main Flow**:<br>1. Manager opens branch inventory list.<br>2. Manager reviews raw materials quantities and low stock indicators. |
| **UC-32** | Inventory Management | Import Stock | Store Manager | **Description**: Logs raw material receipt from suppliers.<br>**Main Flow**:<br>1. Manager inputs invoice detail, items, and quantities received.<br>2. Stock counts are updated and import actions are recorded. |
| **UC-33** | Inventory Management | Export Stock | Store Manager | **Description**: Logs physical material withdrawal.<br>**Main Flow**:<br>1. Manager selects items, inputs quantities, and reasons (e.g., wastage/damage).<br>2. Stock counts are updated and export actions are recorded. |
| **UC-34** | Inventory Management | Perform Inventory Audit | Store Manager | **Description**: Conducts physical inventory audit.<br>**Main Flow**:<br>1. Manager inputs physically counted stock quantities.<br>2. Any discrepancy is calculated, stock counts are reconciled, and stock balances are updated. |
| **UC-35** | Staff & Schedule | View Staff Schedule | Store Manager | **Description**: Displays shift calendar.<br>**Main Flow**:<br>1. Manager accesses scheduling calendar.<br>2. Manager reviews cashier and barista shift assignments. |
| **UC-36** | Staff & Schedule | Create Staff Schedule | Store Manager | **Description**: Assigns employee to shift.<br>**Main Flow**:<br>1. Manager assigns employee, date, and shift time.<br>2. The shift is registered and the calendar is updated. |
| **UC-37** | Staff & Schedule | Update Staff Schedule | Store Manager | **Description**: Modifies schedule assignments.<br>**Main Flow**:<br>1. Manager adjusts shift dates or employee assignments on the calendar.<br>2. The scheduling calendar is updated. |
| **UC-38** | Staff & Schedule | Delete Staff Schedule | Store Manager | **Description**: Removes shift assignments.<br>**Main Flow**:<br>1. Manager deletes a shift assignment.<br>2. The shift assignment is removed and the calendar is updated. |
| **UC-39** | Staff & Schedule | View Staff Attendance Report | Store Manager | **Description**: Accesses attendance sheets.<br>**Main Flow**:<br>1. Manager displays attendance details.<br>2. Manager reviews check-in/out logs, showing late times. |
| **UC-66** | Staff & Schedule | View Branch Staff List | Store Manager | **Description**: Reviews the roster list and contact profiles of staff assigned to their branch.<br>**Main Flow**:<br>1. Store Manager opens the Branch Staff list module.<br>2. Portal retrieves active and deactivated users whose assigned branch matches the manager's branch.<br>3. Portal shows aggregated stats and lists cards containing Names, Roles, Contacts and Badges. |
| **UC-40** | Reports & Analytics | View Store Revenue Reports | Store Manager | **Description**: Accesses local branch reports.<br>**Main Flow**:<br>1. Manager opens store report panel.<br>2. Manager reviews local sales revenue, shift closures, and payment breakdowns. |
| **UC-41** | Reports & Analytics | Export Store Reports | Store Manager | **Description**: Exports store-specific files.<br>**Main Flow**:<br>1. Manager exports local sales and inventory spreadsheets.<br>2. Report files are generated and downloaded. |
| **UC-43** | POS Sales & Billing | Approve Cashier Override / Refund | Store Manager | **Description**: Allows Store Manager to cancel orders in preparing/ready states directly on the POS terminal.<br>**Main Flow**:<br>1. Manager logs into the POS or accesses the active order.<br>2. Manager selects the order, enters cancellation reason/notes, and voids the transaction. |
| **UC-44** | POS Sales & Billing | Open Shift | Cashier | **Description**: Opens cashier POS session.<br>**Main Flow**:<br>1. Cashier inputs POS register ID and opening drawer cash float (VND).<br>2. The shift state is validated and the session is opened. |
| **UC-45** | POS Sales & Billing | Add Item to Order | Cashier | **Description**: Adds product to checkout cart.<br>**Main Flow**:<br>1. Cashier clicks a menu item or scans SKU barcode.<br>2. Availability is validated and the item is added to the order cart. |
| **UC-46** | POS Sales & Billing | Update Cart Item | Cashier | **Description**: Modifies quantity or toppings in cart.<br>**Main Flow**:<br>1. Cashier adjusts quantity or selects option toppings.<br>2. The cart items are updated and the subtotal is recalculated. |
| **UC-47** | POS Sales & Billing | Search Menu Item | Cashier | **Description**: Quick item lookup.<br>**Main Flow**:<br>1. Cashier inputs search text or scans barcode.<br>2. The menu grid is filtered by name, abbreviation, or SKU. |
| **UC-48** | POS Sales & Billing | Apply Discount Code | Cashier | **Description**: Applies coupon code to cart.<br>**Main Flow**:<br>1. Cashier inputs voucher code or selects matching code.<br>2. Constraints are validated and the order total is updated. |
| **UC-49** | POS Sales & Billing | Redeem Loyalty Points | Cashier | **Description**: Redeems customer loyalty points for a cash discount at checkout.<br>**Main Flow**:<br>1. Cashier checks customer's available points balance.<br>2. Cashier enters points amount to redeem, applying a corresponding discount to the order. |
| **UC-50** | POS Sales & Billing | Lookup Customer Membership | Cashier | **Description**: Finds membership details for cart.<br>**Main Flow**:<br>1. Cashier inputs customer phone number.<br>2. Customer details are retrieved, and active discount rates are applied. |
| **UC-51** | POS Sales & Billing | Process Payment | Cashier | **Description**: Completes order transaction.<br>**Main Flow**:<br>1. Cashier selects payment method (dynamic VietQR/cash/card).<br>2. Payment is processed and the payment status is updated. |
| **UC-52** | POS Sales & Billing | Issue Invoice | Cashier | **Description**: Prints receipt and kitchen sticker.<br>**Main Flow**:<br>1. The receipt is printed upon payment completion.<br>2. Cashier hands invoice and sequential order sticker to client. |
| **UC-53** | POS Sales & Billing | Close Shift | Cashier | **Description**: Closes POS session.<br>**Main Flow**:<br>1. Cashier counts cash and inputs closing float.<br>2. Discrepancies are calculated and flagged, and the session is closed. |
| **UC-54** | POS Sales & Billing | View Local Order History | Cashier | **Description**: Displays local branch orders.<br>**Main Flow**:<br>1. Cashier opens order history grid.<br>2. Cash drawer orders processed during the current shift are displayed. |
| **UC-55** | POS Sales & Billing | Request Transaction Refund | Cashier | **Description**: Initiates refund and cancellation process for PENDING orders.<br>**Main Flow**:<br>1. Cashier selects a pending order and clicks Cancel Order.<br>2. Cashier inputs cancellation reason and details, then confirms cancellation. POS voids transaction and updates stock immediately. |
| **UC-57** | Order Prep & Queue | View Order Queue Display | Barista | **Description**: Monitors preparation queue.<br>**Main Flow**:<br>1. Barista opens queue display.<br>2. Pending, preparing, and ready orders are displayed. |
| **UC-58** | Order Prep & Queue | Update Preparation Status | Barista | **Description**: Modifies preparation flags.<br>**Main Flow**:<br>1. Barista selects active order and moves it to preparing/ready.<br>2. Timestamps are logged and the cashier status is updated. |
| **UC-59** | Order Prep & Queue | Print Drink Label Sticker | Barista | **Description**: Prints label stickers for cups.<br>**Main Flow**:<br>1. Barista clicks Print Sticker for drink item.<br>2. The label parameters are sent to the local printer. |
| **UC-60** | Order Prep & Queue | Report Issue / Escalate Order | Barista | **Description**: Flags order preparation errors.<br>**Main Flow**:<br>1. Barista reports machine/ingredient issue.<br>2. The order is marked with an issue flag, notifying POS cashiers. |
| **UC-61** | Inventory Management | View Import/Export History | Store Manager | **Description**: Reviews past stock movements.<br>**Main Flow**:<br>1. Manager opens history logs.<br>2. Details of stock imports and exports are displayed. |
| **UC-62** | Inventory Management | Auto-Deduct Inventory on Order Completion | System (automated) | **Description**: Automatically deducts ingredient quantities from stock based on the recipe formulation when an order transitions to the PREPARING state.<br>**Main Flow**:<br>1. Barista taps "START PREP" on an order.<br>2. System retrieves recipes for each menu item.<br>3. System deducts corresponding ingredient quantities and logs transactions. |
| **UC-63** | Branch Management | View Branch List | Admin | **Description**: Lists all registered branches and their statuses.<br>**Main Flow**:<br>1. Admin opens the Branch Management panel.<br>2. Admin views all branches with name, address, phone, and active/inactive status. |
| **UC-64** | Branch Management | Add Branch | Admin | **Description**: Registers a new store branch.<br>**Main Flow**:<br>1. Admin enters branch name, address, and phone number, then clicks "Save".<br>2. A new branch is created with active status and appears in the branch list. |
| **UC-65** | Branch Management | Update / Deactivate Branch | Admin | **Description**: Updates branch information or deactivates (closes) a branch.<br>**Main Flow**:<br>1. Admin edits branch details or sets status to Inactive, then clicks "Save".<br>2. Branch information is updated. If deactivated, all associated staff accounts are disabled and future schedules are cancelled. |


