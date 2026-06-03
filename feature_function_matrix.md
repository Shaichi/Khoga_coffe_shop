# Feature & Function Progress Matrix

Tài liệu này chứa bảng kiểm soát tiến độ chức năng (Feature/Function List) theo chuẩn mẫu của **Trường Đại học FPT** cho dự án Coffee Shop.

---

## 1. Bảng mẫu chính xác từ hình ảnh yêu cầu (Template Example)

Dưới đây là bảng được dựng lại chính xác theo hình ảnh chụp màn hình Excel bạn đã gửi:

| # | Feature Name | Function Name | Screen Name | Actor(Users) | Complexity | Planned Code Iteration | Student Name | SRS Status | Design Status | Coding Status | Testcase Status | Test Status | Description |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Feature Name 1 | Function Name 1 | | | Simple | | | | | | | | |
| | | Function Name 2 | | | Medium | | | | | | | | |
| | | Function Name 3 | | | Complex | | | | | | | | |
| | | Function Name 4 | | | Medium | | | | | | | | |
| | | Function Name 5 | | | Complex | | | | | | | | |
| 2 | Feature Name 2 | Function Name 6 | | | | | | | | | | | |
| | | Function Name 7 | | | | | | | | | | | |
| 3 | | Function Name 8 | | | | | | | | | | | |
| 4 | | Function Name 9 | | | | | | | | | | | |
| 5 | | Function Name 10 | | | | | | | | | | | |
| 6 | | Function Name 11 | | | | | | | | | | | |
| 7 | | Function Name 12 | | | | | | | | | | | |
| 8 | | Function Name 13 | | | | | | | | | | | |

---

## 2. Bảng phân rã chức năng đầy đủ của dự án Coffee Shop (Full Coffee Shop Feature/Function List)

Bảng này tự động trích xuất toàn bộ các Use Case từ tài liệu SRS chính thức (`srs_document_full.md`), phân loại theo Feature, gán Screen Name tương ứng dựa trên mockup HTML đã có, và ước lượng độ phức tạp (Complexity).

| # | Feature Name | Function Name | Screen Name | Actor(Users) | Complexity | Planned Code Iteration | Student Name | SRS Status | Design Status | Coding Status | Testcase Status | Test Status | Description |
|:---:|---|---|---|---|:---:|:---:|---|:---:|:---:|:---:|:---:|:---:|---|
| 1 | Authentication & Profile | UC-01: Login | login_web.html / profile_settings | User (Base Staff) | Medium | Iteration 1 | | Done | Done | | | | Authenticates employee entry to the application. |
| 2 |  | UC-02: Logout | login_web.html / profile_settings | User (Base Staff) | Simple | Iteration 1 | | Done | Done | | | | Terminates active session. |
| 3 |  | UC-03: Forgot Password | login_web.html / profile_settings | User (Base Staff) | Medium | Iteration 1 | | Done | Done | | | | Requests password recovery details. |
| 4 |  | UC-04: Verify OTP | login_web.html / profile_settings | User (Base Staff) | Medium | Iteration 1 | | Done | Done | | | | Validates the recovery code. |
| 5 |  | UC-05: Set New Password | login_web.html / profile_settings | User (Base Staff) | Medium | Iteration 1 | | Done | Done | | | | Creates a new secure password. |
| 6 |  | UC-06: Force Password Change | login_web.html / profile_settings | User (Base Staff) | Medium | Iteration 1 | | Done | Done | | | | Mandates password update upon first sign-in. |
| 7 |  | UC-07: View Profile | login_web.html / profile_settings | User (Base Staff) | Simple | Iteration 1 | | Done | Done | | | | Accesses employee details. |
| 8 |  | UC-08: Update Profile | login_web.html / profile_settings | User (Base Staff) | Medium | Iteration 1 | | Done | Done | | | | Edits employee contact information. |
| 9 |  | UC-09: Change Password | login_web.html / profile_settings | User (Base Staff) | Medium | Iteration 1 | | Done | Done | | | | Modifies active password. |
| 10 | User Management | UC-10: View User Account List | user_management_web.html | Admin | Simple | Iteration 1 | | Done | Done | | | | Lists employee user accounts. |
| 11 |  | UC-11: Add User Account | user_management_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Registers a new employee profile. |
| 12 |  | UC-12: Update User Account | user_management_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Modifies employee details. |
| 13 |  | UC-13: View User Account Detail | user_management_web.html | Admin | Simple | Iteration 1 | | Done | Done | | | | Audits employee history. |
| 14 |  | UC-14: Deactivate User Account | user_management_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Revokes employee system access. |
| 15 | Menu & Categories | UC-15: View Menu & Categories List | menu_management_web.html | Admin | Simple | Iteration 1 | | Done | Done | | | | Reviews catalog items. |
| 16 |  | UC-68: View Menu Item Detail | menu_management_web.html | Admin | Simple | Iteration 1 | | Done | Done | | | | Displays the detailed card of a specific menu item, including its ingredients recipe and options. |
| 17 |  | UC-69: View Categories List | menu_management_web.html | Admin | Simple | Iteration 1 | | Done | Done | | | | Displays all product categories. |
| 18 |  | UC-16: Add Category | menu_management_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Creates a new product category. |
| 19 |  | UC-17: Update Category | menu_management_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Modifies category settings. |
| 20 |  | UC-70: Delete Category | menu_management_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Deactivates/deletes an empty category. |
| 21 |  | UC-18: Add Menu Item & Recipe | menu_management_web.html | Admin | Complex | Iteration 1 | | Done | Done | | | | Creates a new product and links its raw recipe. |
| 22 |  | UC-71: Manage Toppings & Options | menu_management_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Configures modifiers that customers can add to their drinks. |
| 23 |  | UC-19: Update Menu Item & Recipe | menu_management_web.html | Admin, Store Manager | Complex | Iteration 1 | | Done | Done | | | | Edits product details or recipes, or toggles store availability. |
| 24 |  | UC-72: Delete Menu Item | menu_management_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Soft deletes a menu item. |
| 25 | Voucher Management | UC-20: View Vouchers List | vouchers_web.html | Admin | Simple | Iteration 1 | | Done | Done | | | | Lists active discount promotions. |
| 26 |  | UC-21: Add Voucher | vouchers_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Configures new promotional discount. |
| 27 |  | UC-22: Update Voucher | vouchers_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Edits voucher parameters. |
| 28 |  | UC-23: Delete Voucher | vouchers_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Deactivates or removes a voucher code. |
| 29 | Customer Management | UC-24: View Customer List | customers_web.html | Admin, Store Manager, Cashier | Simple | Iteration 1 | | Done | Done | | | | Reviews membership registry. |
| 30 |  | UC-25: Add Customer | customers_web.html | Admin, Store Manager, Cashier | Medium | Iteration 1 | | Done | Done | | | | Registers a new membership customer. |
| 31 |  | UC-26: Update Customer | customers_web.html | Admin, Store Manager, Cashier | Medium | Iteration 1 | | Done | Done | | | | Modifies customer details. |
| 32 |  | UC-27: View Customer History | customers_web.html | Admin, Store Manager, Cashier | Simple | Iteration 1 | | Done | Done | | | | Reviews membership loyalty records. |
| 33 | Reports & Analytics | UC-28: View Consolidated Business Reports | hq_reports_web.html | Admin | Complex | Iteration 1 | | Done | Done | | | | Accesses centralized reports. |
| 34 |  | UC-29: Export HQ Reports | hq_reports_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Downloads brand report sheets. |
| 35 | System Configuration | UC-30: Configure Central System Settings | settings_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Configures central parameters. |
| 36 | Inventory Management | UC-31: View Stock List | inventory_web.html | Store Manager | Simple | Iteration 1 | | Done | Done | | | | Reviews store stock levels. |
| 37 |  | UC-32: Import Stock | inventory_web.html | Store Manager | Medium | Iteration 1 | | Done | Done | | | | Logs raw material receipt from suppliers. |
| 38 |  | UC-33: Export Stock | inventory_web.html | Store Manager | Medium | Iteration 1 | | Done | Done | | | | Logs physical material withdrawal. |
| 39 |  | UC-34: Perform Inventory Audit | inventory_web.html | Store Manager | Complex | Iteration 1 | | Done | Done | | | | Conducts physical inventory audit. |
| 40 | Staff & Schedule | UC-35: View Staff Schedule | schedule_web.html | Store Manager | Simple | Iteration 1 | | Done | Done | | | | Displays shift calendar. |
| 41 |  | UC-36: Create Staff Schedule | schedule_web.html | Store Manager | Medium | Iteration 1 | | Done | Done | | | | Assigns employee to shift. |
| 42 |  | UC-37: Update Staff Schedule | schedule_web.html | Store Manager | Medium | Iteration 1 | | Done | Done | | | | Modifies schedule assignments. |
| 43 |  | UC-38: Delete Staff Schedule | schedule_web.html | Store Manager | Medium | Iteration 1 | | Done | Done | | | | Removes shift assignments. |
| 44 |  | UC-39: View Staff Attendance Report | attendance_web.html | Store Manager | Simple | Iteration 1 | | Done | Done | | | | Accesses attendance sheets. |
| 45 |  | UC-66: View Branch Staff List | staff_roster_web.html | Store Manager | Simple | Iteration 1 | | Done | Done | | | | Reviews the roster list and contact profiles of staff assigned to their branch. |
| 46 | Reports & Analytics | UC-40: View Store Revenue Reports | store_reports_web.html | Store Manager | Complex | Iteration 1 | | Done | Done | | | | Accesses local branch reports. |
| 47 |  | UC-41: Export Store Reports | store_reports_web.html | Store Manager | Medium | Iteration 1 | | Done | Done | | | | Exports store-specific files. |
| 48 | System Configuration | UC-42: Configure Local Branch Settings | branch_settings_web.html | Store Manager | Medium | Iteration 1 | | Done | Done | | | | Configures local branch settings (timezone, hardware connection, receipt logo) for their assigned branch. |
| 49 | POS Sales & Billing | UC-44: Open Shift | cashier_pos_web.html | Cashier | Medium | Iteration 1 | | Done | Done | | | | Opens cashier POS session. |
| 50 |  | UC-45: Add Item to Order | cashier_pos_web.html | Cashier | Medium | Iteration 1 | | Done | Done | | | | Adds product to checkout cart. |
| 51 |  | UC-46: Update Cart Item | cashier_pos_web.html | Cashier | Medium | Iteration 1 | | Done | Done | | | | Modifies quantity or toppings in cart. |
| 52 |  | UC-47: Search Menu Item | cashier_pos_web.html | Cashier | Simple | Iteration 1 | | Done | Done | | | | Quick item lookup. |
| 53 |  | UC-48: Apply Discount Code | cashier_pos_web.html | Cashier | Medium | Iteration 1 | | Done | Done | | | | Applies coupon code to cart. |
| 54 |  | UC-49: Redeem Loyalty Points | cashier_pos_web.html | Cashier | Complex | Iteration 1 | | Done | Done | | | | Redeems customer loyalty points for a cash discount at checkout. |
| 55 |  | UC-50: Lookup Customer Membership | cashier_pos_web.html | Cashier | Medium | Iteration 1 | | Done | Done | | | | Finds membership details for cart. |
| 56 |  | UC-51: Process Payment | cashier_pos_web.html | Cashier | Complex | Iteration 1 | | Done | Done | | | | Completes order transaction. |
| 57 |  | UC-52: Issue Invoice | cashier_pos_web.html | Cashier | Medium | Iteration 1 | | Done | Done | | | | Prints receipt and kitchen sticker. |
| 58 |  | UC-53: Close Shift | cashier_pos_web.html | Cashier | Medium | Iteration 1 | | Done | Done | | | | Closes POS session. |
| 59 |  | UC-54: View Local Order History | cashier_pos_web.html | Cashier | Simple | Iteration 1 | | Done | Done | | | | Displays local branch orders. |
| 60 |  | UC-73: View Order Detail | cashier_pos_web.html | Cashier, Store Manager, Barista | Simple | Iteration 1 | | Done | Done | | | | Displays receipt details, payments, and fulfillment tracking metrics for an order. |
| 61 |  | UC-55: Request Transaction Refund | cashier_pos_web.html | Cashier | Complex | Iteration 1 | | Done | Done | | | | Initiates refund and cancellation process for PENDING orders. |
| 62 | Order Prep & Queue | UC-57: View Order Queue Display | barista_monitor_web.html | Barista | Simple | Iteration 1 | | Done | Done | | | | Monitors preparation queue. |
| 63 |  | UC-58: Update Preparation Status | barista_monitor_web.html | Barista | Medium | Iteration 1 | | Done | Done | | | | Modifies preparation flags. |
| 64 |  | UC-59: Print Drink Label Sticker | barista_monitor_web.html | Barista | Medium | Iteration 1 | | Done | Done | | | | Prints label stickers for cups. |
| 65 |  | UC-60: Report Issue / Escalate Order | barista_monitor_web.html | Barista | Medium | Iteration 1 | | Done | Done | | | | Flags order preparation errors. |
| 66 | Inventory Management | UC-61: View Import/Export History | inventory_web.html | Store Manager | Simple | Iteration 1 | | Done | Done | | | | Reviews past stock movements. |
| 67 |  | UC-62: Auto-Deduct Inventory on Order Completion | inventory_web.html | System (automated) | Complex | Iteration 1 | | Done | Done | | | | Automatically deducts ingredient quantities from stock based on the recipe formulation when an order transitions to the PREPARING state. |
| 68 | Branch Management | UC-63: View Branch List | branch_management_web.html | Admin | Simple | Iteration 1 | | Done | Done | | | | Lists all registered branches and their statuses. |
| 69 |  | UC-64: Add Branch | branch_management_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Registers a new store branch. |
| 70 |  | UC-65: Update / Deactivate Branch | branch_management_web.html | Admin | Medium | Iteration 1 | | Done | Done | | | | Updates branch information or deactivates (closes) a branch. |