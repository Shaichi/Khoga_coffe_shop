# Feature & Function Progress Matrix

Tài liệu này chứa bảng kiểm soát tiến độ chức năng (Feature/Function List) theo chuẩn mẫu của **Trường Đại học FPT** cho dự án Coffee Shop.

---

## Kế hoạch phát triển dự án (3 Iterations / 6 Tuần / 5 Sinh viên)

Để tối ưu hóa quá trình làm việc nhóm, tránh xung đột mã nguồn (git conflict) khi phát triển song song và đảm bảo khối lượng công việc cân bằng, dự án được phân chia theo nguyên tắc **Phân rã dọc theo nghiệp vụ (Vertical Slicing / Role-based Portals)**:

1.  **HE190528 (Sinh viên A) - Phân hệ Core Auth & User Management (14 UCs):** Chịu trách nhiệm toàn bộ luồng đăng nhập, đăng xuất, profile, đổi mật khẩu và quản lý tài khoản nhân viên toàn hệ thống.
2.  **HE180062 (Sinh viên B) - Phân hệ Product Catalog & Promotions (14 UCs):** Quản lý cấu hình danh mục, món ăn, toppings, công thức pha chế và mã giảm giá (Vouchers).
3.  **HE190704 (Sinh viên C) - Phân hệ Staff Scheduling & Administration (14 UCs):** Quản lý chi nhánh, xếp lịch ca làm việc, chấm công nhân viên và quản lý danh sách khách hàng thành viên.
4.  **HE182009 (Sinh viên D) - Phân hệ POS Sales & Billing (14 UCs):** Chịu trách nhiệm trọn gói cổng bán hàng POS của Cashier (Mở/đóng ca, giỏ hàng, áp voucher/loyalty, checkout thanh toán, in hóa đơn, lịch sử đơn hàng tại quầy và hoàn tiền).
5.  **HE186364 (Sinh viên E) - Phân hệ Inventory Logistics & Barista (14 UCs):** Quản lý kho hàng (Nhập/Xuất/Kiểm kho, tự động trừ kho), quầy chế biến của Barista (Barista Monitor, in tem dán cốc) và toàn bộ hệ thống báo cáo doanh thu HQ/Chi nhánh.

### Bảng phân bổ số lượng Use Cases:
*   Mỗi sinh viên nhận đúng **14 Use Cases** trong cả dự án.
*   Mỗi Iteration (2 tuần) được chia đều: **Iteration 1 (5 UCs)**, **Iteration 2 (5 UCs)**, và **Iteration 3 (4 UCs)**.

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

Bảng dưới đây liệt kê toàn bộ các Use Case từ tài liệu SRS chính thức (`srs_document_full.md`), được **sắp xếp gom nhóm và đồng bộ theo từng Feature Name trong tài liệu SRS, phân chia đều và phân công cụ thể cho 5 thành viên**.

| # | Feature Name | Function Name | Screen Name | Actor(Users) | Complexity | Planned Code Iteration | Student Name | SRS Status | Design Status | Coding Status | Testcase Status | Test Status | Description |
|:---:|---|---|---|---|:---:|:---:|---|:---:|:---:|:---:|:---:|:---:|---|
| 1 | Authentication & Profile | UC-01: Login | 1. Login Screen | User (Base Staff) | Medium | Iteration 1 | HE190528 | | | | | | Authenticates employee entry to the application. |
| 2 |  | UC-02: Logout | Logout Screen/Action | User (Base Staff) | Simple | Iteration 1 | HE190528 | | | | | | Terminates active session. |
| 3 |  | UC-03: Forgot Password | 2. Forgot Password Screen | User (Base Staff) | Medium | Iteration 3 | HE190528 | | | | | | Requests password recovery details. |
| 4 |  | UC-04: Verify OTP | 3. OTP Verification Screen | User (Base Staff) | Medium | Iteration 3 | HE190528 | | | | | | Validates the recovery code. |
| 5 |  | UC-05: Set New Password | 4. Set New Password Screen | User (Base Staff) | Medium | Iteration 3 | HE190528 | | | | | | Creates a new secure password. |
| 6 |  | UC-06: Force Password Change | 5. Force Password Change Screen | User (Base Staff) | Medium | Iteration 3 | HE190528 | | | | | | Mandates password update upon first sign-in. |
| 7 |  | UC-07: View Profile | 6. View Profile Screen | User (Base Staff) | Simple | Iteration 1 | HE190528 | | | | | | Accesses employee details. |
| 8 |  | UC-08: Update Profile | 7. Edit Profile Screen | User (Base Staff) | Medium | Iteration 1 | HE190528 | | | | | | Edits employee contact information. |
| 9 |  | UC-09: Change Password | 8. Change Password Screen | User (Base Staff) | Medium | Iteration 1 | HE190528 | | | | | | Modifies active password. |
| 10 | User Management | UC-10: View User Account List | 10. Account Management List Screen | Admin | Simple | Iteration 2 | HE190528 | | | | | | Lists employee user accounts. |
| 11 |  | UC-11: Add User Account | 11. Add User Account Form | Admin | Medium | Iteration 2 | HE190528 | | | | | | Registers a new employee profile. |
| 12 |  | UC-12: Update User Account | 12. Edit User Account Form | Admin | Medium | Iteration 2 | HE190528 | | | | | | Modifies employee details. |
| 13 |  | UC-13: View User Account Detail | 13. User Detail & Audit Logs Screen | Admin | Simple | Iteration 2 | HE190528 | | | | | | Audits employee history. |
| 14 |  | UC-14: Deactivate User Account | 10. Account Management List Screen / 12. Edit User Account Form | Admin | Medium | Iteration 2 | HE190528 | | | | | | Revokes employee system access. |
| 15 | Branch Management | UC-63: View Branch List | 44. Branch Management List Screen | Admin | Simple | Iteration 1 | HE190704 | | | | | | Lists all registered branches and their statuses. |
| 16 |  | UC-64: Add Branch | 45. Add Branch Form | Admin | Medium | Iteration 1 | HE190704 | | | | | | Registers a new store branch. |
| 17 |  | UC-65: Update / Deactivate Branch | 46. Edit / Deactivate Branch Screen | Admin | Medium | Iteration 1 | HE190704 | | | | | | Updates branch information or deactivates (closes) a branch. |
| 18 | Menu & Categories | UC-15: View Menu & Categories List | 14. Menu & Categories Management Screen | Admin | Simple | Iteration 1 | HE180062 | | | | | | Reviews catalog items. |
| 19 |  | UC-68: View Menu Item Detail | 14. Menu & Categories Management Screen | Admin | Simple | Iteration 3 | HE180062 | | | | | | Displays the detailed card of a specific menu item, including its ingredients recipe and options. |
| 20 |  | UC-69: View Categories List | 14. Menu & Categories Management Screen | Admin | Simple | Iteration 3 | HE180062 | | | | | | Displays all product categories. |
| 21 |  | UC-16: Add Category | 15. Add Category Screen | Admin | Medium | Iteration 1 | HE180062 | | | | | | Creates a new product category. |
| 22 |  | UC-17: Update Category | 16. Edit Category Screen | Admin | Medium | Iteration 1 | HE180062 | | | | | | Modifies category settings. |
| 23 |  | UC-70: Delete Category | 16. Edit Category Screen / 14. Menu & Categories Management Screen | Admin | Medium | Iteration 1 | HE180062 | | | | | | Deactivates/deletes an empty category. |
| 24 |  | UC-18: Add Menu Item & Recipe | 17. Add Menu Item Form | Admin | Complex | Iteration 1 | HE180062 | | | | | | Creates a new product and links its raw recipe. |
| 25 |  | UC-71: Manage Toppings & Options | 14. Menu & Categories Management Screen | Admin | Medium | Iteration 2 | HE180062 | | | | | | Configures modifiers that customers can add to their drinks. |
| 26 |  | UC-19: Update Menu Item & Recipe | 18. Edit Menu Item Form | Admin, Store Manager | Complex | Iteration 3 | HE180062 | | | | | | Edits product details or recipes, or toggles store availability. |
| 27 |  | UC-72: Delete Menu Item | 18. Edit Menu Item Form / 14. Menu & Categories Management Screen | Admin | Medium | Iteration 3 | HE180062 | | | | | | Soft deletes a menu item. |
| 28 | Voucher Management | UC-20: View Vouchers List | 19. Vouchers & Promotions List Screen | Admin | Simple | Iteration 2 | HE180062 | | | | | | Lists active discount promotions. |
| 29 |  | UC-21: Add Voucher | 20. Add Voucher Form | Admin | Medium | Iteration 2 | HE180062 | | | | | | Configures new promotional discount. |
| 30 |  | UC-22: Update Voucher | 21. Edit Voucher Form | Admin | Medium | Iteration 2 | HE180062 | | | | | | Edits voucher parameters. |
| 31 |  | UC-23: Delete Voucher | 19. Vouchers & Promotions List Screen / 21. Edit Voucher Form | Admin | Medium | Iteration 2 | HE180062 | | | | | | Deactivates or removes a voucher code. |
| 32 | Customer Management | UC-24: View Customer List | 22. Customer List & Loyalty History Screen | Admin, Store Manager, Cashier | Simple | Iteration 1 | HE190704 | | | | | | Reviews membership registry. |
| 33 |  | UC-25: Add Customer | 22. Customer List & Loyalty History Screen / 36. Membership Search & Add Pop-up | Admin, Store Manager, Cashier | Medium | Iteration 2 | HE182009 | | | | | | Registers a new membership customer. |
| 34 |  | UC-26: Update Customer | 22. Customer List & Loyalty History Screen | Admin, Store Manager, Cashier | Medium | Iteration 1 | HE190704 | | | | | | Modifies customer details. |
| 35 |  | UC-27: View Customer History | 22. Customer List & Loyalty History Screen | Admin, Store Manager, Cashier | Simple | Iteration 2 | HE190704 | | | | | | Reviews membership loyalty records. |
| 36 | POS Sales & Billing | UC-44: Open Shift | 34. Shift Initiation Open Shift Screen | Cashier | Medium | Iteration 1 | HE182009 | | | | | | Opens cashier POS session. |
| 37 |  | UC-45: Add Item to Order | 35. POS Checkout Grid & Cart Screen | Cashier | Medium | Iteration 1 | HE182009 | | | | | | Adds product to checkout cart. |
| 38 |  | UC-46: Update Cart Item | 35. POS Checkout Grid & Cart Screen | Cashier | Medium | Iteration 1 | HE182009 | | | | | | Modifies quantity or toppings in cart. |
| 39 |  | UC-47: Search Menu Item | 35. POS Checkout Grid & Cart Screen | Cashier | Simple | Iteration 2 | HE182009 | | | | | | Quick item lookup. |
| 40 |  | UC-48: Apply Discount Code | 37. Apply Voucher Modal | Cashier | Medium | Iteration 2 | HE182009 | | | | | | Applies coupon code to cart. |
| 41 |  | UC-49: Redeem Loyalty Points | 37a. Redeem Loyalty Points Modal | Cashier | Complex | Iteration 2 | HE182009 | | | | | | Redeems customer loyalty points for a cash discount at checkout. |
| 42 |  | UC-50: Lookup Customer Membership | 36. Membership Search & Add Pop-up | Cashier | Medium | Iteration 2 | HE182009 | | | | | | Finds membership details for cart. |
| 43 |  | UC-51: Process Payment | 38. Payment Checkout Modal | Cashier | Complex | Iteration 1 | HE182009 | | | | | | Completes order transaction. |
| 44 |  | UC-52: Issue Invoice | 35. POS Checkout Grid & Cart Screen | Cashier | Medium | Iteration 1 | HE182009 | | | | | | Prints receipt and kitchen sticker. |
| 45 |  | UC-53: Close Shift | 41. Shift Reconciliation Close Shift Screen | Cashier | Medium | Iteration 3 | HE182009 | | | | | | Closes POS session. |
| 46 |  | UC-54: View Local Order History | 40. Order History & Refund Request Screen | Cashier | Simple | Iteration 3 | HE182009 | | | | | | Displays local branch orders. |
| 47 |  | UC-73: View Order Detail | 49. Order Detail Screen | Cashier, Store Manager, Barista | Simple | Iteration 3 | HE182009 | | | | | | Displays receipt details, payments, and fulfillment tracking metrics for an order. |
| 48 |  | UC-55: Request Transaction Refund | 40. Order History & Refund Request Screen | Cashier | Complex | Iteration 3 | HE182009 | | | | | | Initiates refund and cancellation process for PENDING orders. |
| 49 | Order Prep & Queue | UC-57: View Order Queue Display | 42. Barista Queue Monitor Screen | Barista | Simple | Iteration 1 | HE186364 | | | | | | Monitors preparation queue. |
| 50 |  | UC-58: Update Preparation Status | 42. Barista Queue Monitor Screen / Update Prep Status | Barista | Medium | Iteration 1 | HE186364 | | | | | | Modifies preparation flags. |
| 51 |  | UC-59: Print Drink Label Sticker | 42. Barista Queue Monitor Screen / Print Drink Label Sticker | Barista | Medium | Iteration 1 | HE186364 | | | | | | Prints label stickers for cups. |
| 52 |  | UC-60: Report Issue / Escalate Order | 43. Report Issue & Hold Order Screen | Barista | Medium | Iteration 2 | HE186364 | | | | | | Flags order preparation errors. |
| 53 | Inventory Management | UC-31: View Stock List | 26. Stock List Screen | Store Manager | Simple | Iteration 1 | HE186364 | | | | | | Reviews store stock levels. |
| 54 |  | UC-32: Import Stock | 27. Stock Import Form Screen | Store Manager | Medium | Iteration 2 | HE186364 | | | | | | Logs raw material receipt from suppliers. |
| 55 |  | UC-33: Export Stock | 28. Stock Export Form Screen | Store Manager | Medium | Iteration 2 | HE186364 | | | | | | Logs physical material withdrawal. |
| 56 |  | UC-34: Perform Inventory Audit | 29. Stock Audit Screen | Store Manager | Complex | Iteration 3 | HE186364 | | | | | | Conducts physical inventory audit. |
| 57 |  | UC-61: View Import/Export History | 26a. Stock History Log Screen | Store Manager | Simple | Iteration 1 | HE186364 | | | | | | Reviews past stock movements. |
| 58 |  | UC-62: Auto-Deduct Inventory on Order Completion | System (automated) | System (automated) | Complex | Iteration 3 | HE186364 | | | | | | Automatically deducts ingredient quantities from stock based on the recipe formulation when an order transitions to the PREPARING state. |
| 59 | Staff & Schedule | UC-35: View Staff Schedule | 30. Staff Shift Scheduler Screen | Store Manager | Simple | Iteration 2 | HE190704 | | | | | | Displays shift calendar. |
| 60 |  | UC-36: Create Staff Schedule | 30a. Add Shift Screen | Store Manager | Medium | Iteration 3 | HE190704 | | | | | | Assigns employee to shift. |
| 61 |  | UC-37: Update Staff Schedule | 30b. Edit Shift Screen | Store Manager | Medium | Iteration 3 | HE190704 | | | | | | Modifies schedule assignments. |
| 62 |  | UC-38: Delete Staff Schedule | 30b. Edit Shift Screen / 30. Staff Shift Scheduler Screen | Store Manager | Medium | Iteration 3 | HE190704 | | | | | | Removes shift assignments. |
| 63 |  | UC-39: View Staff Attendance Report | 31. Staff Attendance Report Screen | Store Manager | Simple | Iteration 3 | HE190704 | | | | | | Accesses attendance sheets. |
| 64 |  | UC-66: View Branch Staff List | 47. View Branch Staff List Screen | Store Manager | Simple | Iteration 2 | HE190704 | | | | | | Reviews the roster list and contact profiles of staff assigned to their branch. |
| 65 | System Configuration | UC-30: Configure Central System Settings | 24. Central System Settings Screen | Admin | Medium | Iteration 2 | HE190704 | | | | | | Configures central parameters. |
| 66 |  | UC-42: Configure Local Branch Settings | 33. Branch Local Settings Screen | Store Manager | Medium | Iteration 2 | HE190704 | | | | | | Configures local branch settings (timezone, hardware connection, receipt logo) for their assigned branch. |
| 67 | Reports & Analytics | UC-28: View Consolidated Business Reports | 23. HQ Business Reports Screen | Admin | Complex | Iteration 3 | HE186364 | | | | | | Accesses centralized reports. |
| 68 |  | UC-29: Export HQ Reports | 23. HQ Business Reports Screen | Admin | Medium | Iteration 3 | HE186364 | | | | | | Downloads brand report sheets. |
| 69 |  | UC-40: View Store Revenue Reports | 32. Store Revenue Reports Screen | Store Manager | Complex | Iteration 2 | HE186364 | | | | | | Accesses local branch reports. |
| 70 |  | UC-41: Export Store Reports | 32a. Reports Export Modal | Store Manager | Medium | Iteration 2 | HE186364 | | | | | | Exports store-specific files. |