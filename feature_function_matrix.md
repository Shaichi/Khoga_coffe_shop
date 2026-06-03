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

Bảng này tự động trích xuất toàn bộ các Use Case từ tài liệu SRS chính thức (`srs_document_full.md`), phân loại theo Feature, gán Screen Name tương ứng dựa trên mô tả màn hình chính thức trong SRS, và ước lượng độ phức tạp (Complexity).

| # | Feature Name | Function Name | Screen Name | Actor(Users) | Complexity | Planned Code Iteration | Student Name | SRS Status | Design Status | Coding Status | Testcase Status | Test Status | Description |
|:---:|---|---|---|---|:---:|:---:|---|:---:|:---:|:---:|:---:|:---:|---|
| 1 | Authentication & Profile | UC-01: Login | 1. Login Screen | User (Base Staff) | Medium | Iteration 1 | | | | | | | Authenticates employee entry to the application. |
| 2 |  | UC-02: Logout | Logout Screen/Action | User (Base Staff) | Simple | Iteration 1 | | | | | | | Terminates active session. |
| 3 |  | UC-03: Forgot Password | 2. Forgot Password Screen | User (Base Staff) | Medium | Iteration 1 | | | | | | | Requests password recovery details. |
| 4 |  | UC-04: Verify OTP | 3. OTP Verification Screen | User (Base Staff) | Medium | Iteration 1 | | | | | | | Validates the recovery code. |
| 5 |  | UC-05: Set New Password | 4. Set New Password Screen | User (Base Staff) | Medium | Iteration 1 | | | | | | | Creates a new secure password. |
| 6 |  | UC-06: Force Password Change | 5. Force Password Change Screen | User (Base Staff) | Medium | Iteration 1 | | | | | | | Mandates password update upon first sign-in. |
| 7 |  | UC-07: View Profile | 6. View Profile Screen | User (Base Staff) | Simple | Iteration 1 | | | | | | | Accesses employee details. |
| 8 |  | UC-08: Update Profile | 7. Edit Profile Screen | User (Base Staff) | Medium | Iteration 1 | | | | | | | Edits employee contact information. |
| 9 |  | UC-09: Change Password | 8. Change Password Screen | User (Base Staff) | Medium | Iteration 1 | | | | | | | Modifies active password. |
| 10 | User Management | UC-10: View User Account List | 10. Account Management List Screen | Admin | Simple | Iteration 1 | | | | | | | Lists employee user accounts. |
| 11 |  | UC-11: Add User Account | 11. Add User Account Form | Admin | Medium | Iteration 1 | | | | | | | Registers a new employee profile. |
| 12 |  | UC-12: Update User Account | 12. Edit User Account Form | Admin | Medium | Iteration 1 | | | | | | | Modifies employee details. |
| 13 |  | UC-13: View User Account Detail | 13. User Detail & Audit Logs Screen | Admin | Simple | Iteration 1 | | | | | | | Audits employee history. |
| 14 |  | UC-14: Deactivate User Account | 10. Account Management List Screen / 12. Edit User Account Form | Admin | Medium | Iteration 1 | | | | | | | Revokes employee system access. |
| 15 | Menu & Categories | UC-15: View Menu & Categories List | 14. Menu & Categories Management Screen | Admin | Simple | Iteration 1 | | | | | | | Reviews catalog items. |
| 16 |  | UC-68: View Menu Item Detail | 14. Menu & Categories Management Screen | Admin | Simple | Iteration 1 | | | | | | | Displays the detailed card of a specific menu item, including its ingredients recipe and options. |
| 17 |  | UC-69: View Categories List | 14. Menu & Categories Management Screen | Admin | Simple | Iteration 1 | | | | | | | Displays all product categories. |
| 18 |  | UC-16: Add Category | 15. Add Category Screen | Admin | Medium | Iteration 1 | | | | | | | Creates a new product category. |
| 19 |  | UC-17: Update Category | 16. Edit Category Screen | Admin | Medium | Iteration 1 | | | | | | | Modifies category settings. |
| 20 |  | UC-70: Delete Category | 16. Edit Category Screen / 14. Menu & Categories Management Screen | Admin | Medium | Iteration 1 | | | | | | | Deactivates/deletes an empty category. |
| 21 |  | UC-18: Add Menu Item & Recipe | 17. Add Menu Item Form | Admin | Complex | Iteration 1 | | | | | | | Creates a new product and links its raw recipe. |
| 22 |  | UC-71: Manage Toppings & Options | 14. Menu & Categories Management Screen | Admin | Medium | Iteration 1 | | | | | | | Configures modifiers that customers can add to their drinks. |
| 23 |  | UC-19: Update Menu Item & Recipe | 18. Edit Menu Item Form | Admin, Store Manager | Complex | Iteration 1 | | | | | | | Edits product details or recipes, or toggles store availability. |
| 24 |  | UC-72: Delete Menu Item | 18. Edit Menu Item Form / 14. Menu & Categories Management Screen | Admin | Medium | Iteration 1 | | | | | | | Soft deletes a menu item. |
| 25 | Voucher Management | UC-20: View Vouchers List | 19. Vouchers & Promotions List Screen | Admin | Simple | Iteration 1 | | | | | | | Lists active discount promotions. |
| 26 |  | UC-21: Add Voucher | 20. Add Voucher Form | Admin | Medium | Iteration 1 | | | | | | | Configures new promotional discount. |
| 27 |  | UC-22: Update Voucher | 21. Edit Voucher Form | Admin | Medium | Iteration 1 | | | | | | | Edits voucher parameters. |
| 28 |  | UC-23: Delete Voucher | 19. Vouchers & Promotions List Screen / 21. Edit Voucher Form | Admin | Medium | Iteration 1 | | | | | | | Deactivates or removes a voucher code. |
| 29 | Customer Management | UC-24: View Customer List | 22. Customer List & Loyalty History Screen | Admin, Store Manager, Cashier | Simple | Iteration 1 | | | | | | | Reviews membership registry. |
| 30 |  | UC-25: Add Customer | 22. Customer List & Loyalty History Screen / 36. Membership Search & Add Pop-up | Admin, Store Manager, Cashier | Medium | Iteration 1 | | | | | | | Registers a new membership customer. |
| 31 |  | UC-26: Update Customer | 22. Customer List & Loyalty History Screen | Admin, Store Manager, Cashier | Medium | Iteration 1 | | | | | | | Modifies customer details. |
| 32 |  | UC-27: View Customer History | 22. Customer List & Loyalty History Screen | Admin, Store Manager, Cashier | Simple | Iteration 1 | | | | | | | Reviews membership loyalty records. |
| 33 | Reports & Analytics | UC-28: View Consolidated Business Reports | 23. HQ Business Reports Screen | Admin | Complex | Iteration 1 | | | | | | | Accesses centralized reports. |
| 34 |  | UC-29: Export HQ Reports | 23. HQ Business Reports Screen | Admin | Medium | Iteration 1 | | | | | | | Downloads brand report sheets. |
| 35 | System Configuration | UC-30: Configure Central System Settings | 24. Central System Settings Screen | Admin | Medium | Iteration 1 | | | | | | | Configures central parameters. |
| 36 | Inventory Management | UC-31: View Stock List | 26. Stock List Screen | Store Manager | Simple | Iteration 1 | | | | | | | Reviews store stock levels. |
| 37 |  | UC-32: Import Stock | 27. Stock Import Form Screen | Store Manager | Medium | Iteration 1 | | | | | | | Logs raw material receipt from suppliers. |
| 38 |  | UC-33: Export Stock | 28. Stock Export Form Screen | Store Manager | Medium | Iteration 1 | | | | | | | Logs physical material withdrawal. |
| 39 |  | UC-34: Perform Inventory Audit | 29. Stock Audit Screen | Store Manager | Complex | Iteration 1 | | | | | | | Conducts physical inventory audit. |
| 40 | Staff & Schedule | UC-35: View Staff Schedule | 30. Staff Shift Scheduler Screen | Store Manager | Simple | Iteration 1 | | | | | | | Displays shift calendar. |
| 41 |  | UC-36: Create Staff Schedule | 30a. Add Shift Screen | Store Manager | Medium | Iteration 1 | | | | | | | Assigns employee to shift. |
| 42 |  | UC-37: Update Staff Schedule | 30b. Edit Shift Screen | Store Manager | Medium | Iteration 1 | | | | | | | Modifies schedule assignments. |
| 43 |  | UC-38: Delete Staff Schedule | 30b. Edit Shift Screen / 30. Staff Shift Scheduler Screen | Store Manager | Medium | Iteration 1 | | | | | | | Removes shift assignments. |
| 44 |  | UC-39: View Staff Attendance Report | 31. Staff Attendance Report Screen | Store Manager | Simple | Iteration 1 | | | | | | | Accesses attendance sheets. |
| 45 |  | UC-66: View Branch Staff List | 47. View Branch Staff List Screen | Store Manager | Simple | Iteration 1 | | | | | | | Reviews the roster list and contact profiles of staff assigned to their branch. |
| 46 | Reports & Analytics | UC-40: View Store Revenue Reports | 32. Store Revenue Reports Screen | Store Manager | Complex | Iteration 1 | | | | | | | Accesses local branch reports. |
| 47 |  | UC-41: Export Store Reports | 32a. Reports Export Modal | Store Manager | Medium | Iteration 1 | | | | | | | Exports store-specific files. |
| 48 | System Configuration | UC-42: Configure Local Branch Settings | 33. Branch Local Settings Screen | Store Manager | Medium | Iteration 1 | | | | | | | Configures local branch settings (timezone, hardware connection, receipt logo) for their assigned branch. |
| 49 | POS Sales & Billing | UC-44: Open Shift | 34. Shift Initiation Open Shift Screen | Cashier | Medium | Iteration 1 | | | | | | | Opens cashier POS session. |
| 50 |  | UC-45: Add Item to Order | 35. POS Checkout Grid & Cart Screen | Cashier | Medium | Iteration 1 | | | | | | | Adds product to checkout cart. |
| 51 |  | UC-46: Update Cart Item | 35. POS Checkout Grid & Cart Screen | Cashier | Medium | Iteration 1 | | | | | | | Modifies quantity or toppings in cart. |
| 52 |  | UC-47: Search Menu Item | 35. POS Checkout Grid & Cart Screen | Cashier | Simple | Iteration 1 | | | | | | | Quick item lookup. |
| 53 |  | UC-48: Apply Discount Code | 37. Apply Voucher Modal | Cashier | Medium | Iteration 1 | | | | | | | Applies coupon code to cart. |
| 54 |  | UC-49: Redeem Loyalty Points | 37a. Redeem Loyalty Points Modal | Cashier | Complex | Iteration 1 | | | | | | | Redeems customer loyalty points for a cash discount at checkout. |
| 55 |  | UC-50: Lookup Customer Membership | 36. Membership Search & Add Pop-up | Cashier | Medium | Iteration 1 | | | | | | | Finds membership details for cart. |
| 56 |  | UC-51: Process Payment | 38. Payment Checkout Modal | Cashier | Complex | Iteration 1 | | | | | | | Completes order transaction. |
| 57 |  | UC-52: Issue Invoice | 35. POS Checkout Grid & Cart Screen | Cashier | Medium | Iteration 1 | | | | | | | Prints receipt and kitchen sticker. |
| 58 |  | UC-53: Close Shift | 41. Shift Reconciliation Close Shift Screen | Cashier | Medium | Iteration 1 | | | | | | | Closes POS session. |
| 59 |  | UC-54: View Local Order History | 40. Order History & Refund Request Screen | Cashier | Simple | Iteration 1 | | | | | | | Displays local branch orders. |
| 60 |  | UC-73: View Order Detail | 49. Order Detail Screen | Cashier, Store Manager, Barista | Simple | Iteration 1 | | | | | | | Displays receipt details, payments, and fulfillment tracking metrics for an order. |
| 61 |  | UC-55: Request Transaction Refund | 40. Order History & Refund Request Screen | Cashier | Complex | Iteration 1 | | | | | | | Initiates refund and cancellation process for PENDING orders. |
| 62 | Order Prep & Queue | UC-57: View Order Queue Display | 42. Barista Queue Monitor Screen | Barista | Simple | Iteration 1 | | | | | | | Monitors preparation queue. |
| 63 |  | UC-58: Update Preparation Status | 42. Barista Queue Monitor Screen / Update Prep Status | Barista | Medium | Iteration 1 | | | | | | | Modifies preparation flags. |
| 64 |  | UC-59: Print Drink Label Sticker | 42. Barista Queue Monitor Screen / Print Drink Label Sticker | Barista | Medium | Iteration 1 | | | | | | | Prints label stickers for cups. |
| 65 |  | UC-60: Report Issue / Escalate Order | 43. Report Issue & Hold Order Screen | Barista | Medium | Iteration 1 | | | | | | | Flags order preparation errors. |
| 66 | Inventory Management | UC-61: View Import/Export History | 26a. Stock History Log Screen | Store Manager | Simple | Iteration 1 | | | | | | | Reviews past stock movements. |
| 67 |  | UC-62: Auto-Deduct Inventory on Order Completion | System (automated) | System (automated) | Complex | Iteration 1 | | | | | | | Automatically deducts ingredient quantities from stock based on the recipe formulation when an order transitions to the PREPARING state. |
| 68 | Branch Management | UC-63: View Branch List | 44. Branch Management List Screen | Admin | Simple | Iteration 1 | | | | | | | Lists all registered branches and their statuses. |
| 69 |  | UC-64: Add Branch | 45. Add Branch Form | Admin | Medium | Iteration 1 | | | | | | | Registers a new store branch. |
| 70 |  | UC-65: Update / Deactivate Branch | 46. Edit / Deactivate Branch Screen | Admin | Medium | Iteration 1 | | | | | | | Updates branch information or deactivates (closes) a branch. |