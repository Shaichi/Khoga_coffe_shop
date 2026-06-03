# Kế Hoạch Phân Công Code Chi Tiết (5 Thành Viên / 3 Iterations)

Tài liệu này tóm tắt danh sách các **Use Cases**, **Màn hình (Screen Name)** và các **File HTML Mockup** tương ứng mà từng mã sinh viên phụ trách để lập trình song song, tránh xung đột mã nguồn (git conflict) tối đa.

---

## 1. HE190528 (Sinh viên A) - Core Auth & User Management
*   **Phân hệ chính:** Quản trị truy cập hệ thống & Quản lý tài khoản nhân viên.
*   **Tổng số Use Cases:** 14 UCs (5 Iter 1, 5 Iter 2, 4 Iter 3).
*   **Danh sách Use Cases chi tiết:**
    *   **Iteration 1:**
        *   `UC-01: Login` (Đăng nhập hệ thống)
        *   `UC-02: Logout` (Đăng xuất hệ thống)
        *   `UC-07: View Profile` (Xem thông tin cá nhân)
        *   `UC-08: Update Profile` (Cập nhật thông tin liên hệ)
        *   `UC-09: Change Password` (Đổi mật khẩu tài khoản)
    *   **Iteration 2:**
        *   `UC-10: View User Account List` (Xem danh sách tài khoản nhân viên)
        *   `UC-11: Add User Account` (Thêm mới nhân viên)
        *   `UC-12: Update User Account` (Sửa thông tin nhân viên)
        *   `UC-13: View User Account Detail` (Xem chi tiết & lịch sử nhân viên)
        *   `UC-14: Deactivate User Account` (Khóa/mở khóa tài khoản nhân viên)
    *   **Iteration 3:**
        *   `UC-03: Forgot Password` (Yêu cầu khôi phục mật khẩu)
        *   `UC-04: Verify OTP` (Xác thực mã OTP khôi phục)
        *   `UC-05: Set New Password` (Thiết lập mật khẩu mới)
        *   `UC-06: Force Password Change` (Bắt buộc đổi mật khẩu lần đầu)
*   **Màn hình phụ trách (Screen Names):**
    *   `1. Login Screen`
    *   `2. Forgot Password Screen`
    *   `3. OTP Verification Screen`
    *   `4. Set New Password Screen`
    *   `5. Force Password Change Screen`
    *   `6. View Profile Screen`
    *   `7. Edit Profile Screen`
    *   `8. Change Password Screen`
    *   `Logout Screen/Action`
    *   `10. Account Management List Screen`
    *   `11. Add User Account Form`
    *   `12. Edit User Account Form`
    *   `13. User Detail & Audit Logs Screen`
*   **File HTML Mockup tương ứng để code:**
    *   `admin_hq_mockups/user_management_web.html` (Màn hình quản lý tài khoản của Admin)
    *   `mobile_auth_mockups/` (Các màn hình đăng nhập trên thiết bị di động nếu có)

---

## 2. HE180062 (Sinh viên B) - Product Catalog & Promotions
*   **Phân hệ chính:** Quản lý thực đơn (Menu, Categories, Toppings), công thức món và Voucher khuyến mãi.
*   **Tổng số Use Cases:** 14 UCs (5 Iter 1, 5 Iter 2, 4 Iter 3).
*   **Danh sách Use Cases chi tiết:**
    *   **Iteration 1:**
        *   `UC-15: View Menu & Categories List` (Xem danh sách sản phẩm)
        *   `UC-16: Add Category` (Thêm mới danh mục món)
        *   `UC-17: Update Category` (Sửa danh mục món)
        *   `UC-70: Delete Category` (Xóa danh mục trống)
        *   `UC-18: Add Menu Item & Recipe` (Thêm món mới kèm công thức định lượng)
    *   **Iteration 2:**
        *   `UC-20: View Vouchers List` (Xem danh sách mã giảm giá)
        *   `UC-21: Add Voucher` (Tạo mã giảm giá mới)
        *   `UC-22: Update Voucher` (Cập nhật thời hạn/giới hạn voucher)
        *   `UC-23: Delete Voucher` (Hủy/xóa mã giảm giá)
        *   `UC-71: Manage Toppings & Options` (Quản lý các loại Topping kèm món)
    *   **Iteration 3:**
        *   `UC-19: Update Menu Item & Recipe` (Sửa món ăn & công thức định lượng)
        *   `UC-72: Delete Menu Item` (Xóa/Ẩn sản phẩm khỏi thực đơn)
        *   `UC-68: View Menu Item Detail` (Xem chi tiết card thông tin sản phẩm)
        *   `UC-69: View Categories List` (Xem danh mục sản phẩm)
*   **Màn hình phụ trách (Screen Names):**
    *   `14. Menu & Categories Management Screen`
    *   `15. Add Category Screen`
    *   `16. Edit Category Screen`
    *   `17. Add Menu Item Form`
    *   `18. Edit Menu Item Form`
    *   `19. Vouchers & Promotions List Screen`
    *   `20. Add Voucher Form`
    *   `21. Edit Voucher Form`
*   **File HTML Mockup tương ứng để code:**
    *   `admin_hq_mockups/menu_management_web.html` (Quản lý danh mục & thực đơn Admin)
    *   `admin_hq_mockups/vouchers_web.html` (Quản lý voucher khuyến mãi Admin)

---

## 3. HE190704 (Sinh viên C) - Staff Scheduling & Administration
*   **Phân hệ chính:** Quản lý chi nhánh, xếp ca làm việc, chấm công điểm danh và danh mục khách hàng thành viên.
*   **Tổng số Use Cases:** 14 UCs (5 Iter 1, 5 Iter 2, 4 Iter 3).
*   **Danh sách Use Cases chi tiết:**
    *   **Iteration 1:**
        *   `UC-63: View Branch List` (Xem danh sách chi nhánh toàn chuỗi)
        *   `UC-64: Add Branch` (Tạo mới chi nhánh cửa hàng)
        *   `UC-65: Update / Deactivate Branch` (Sửa thông tin/đóng cửa chi nhánh)
        *   `UC-24: View Customer List` (Xem danh sách khách hàng thành viên)
        *   `UC-26: Update Customer` (Sửa thông tin khách hàng)
    *   **Iteration 2:**
        *   `UC-27: View Customer History` (Xem lịch sử mua hàng & tích điểm khách hàng)
        *   `UC-30: Configure Central System Settings` (Cấu hình cài đặt trung tâm HQ)
        *   `UC-42: Configure Local Branch Settings` (Cấu hình cài đặt riêng của chi nhánh)
        *   `UC-35: View Staff Schedule` (Xem lịch xếp ca nhân viên cửa hàng)
        *   `UC-66: View Branch Staff List` (Xem danh sách nhân viên thuộc chi nhánh)
    *   **Iteration 3:**
        *   `UC-36: Create Staff Schedule` (Xếp ca làm việc mới cho nhân viên)
        *   `UC-37: Update Staff Schedule` (Sửa ca làm việc đã xếp)
        *   `UC-38: Delete Staff Schedule` (Xóa ca làm việc)
        *   `UC-39: View Staff Attendance Report` (Xem báo cáo chấm công nhân viên)
*   **Màn hình phụ trách (Screen Names):**
    *   `22. Customer List & Loyalty History Screen`
    *   `24. Central System Settings Screen`
    *   `33. Branch Local Settings Screen`
    *   `44. Branch Management List Screen`
    *   `45. Add Branch Form`
    *   `46. Edit / Deactivate Branch Screen`
    *   `47. View Branch Staff List Screen`
    *   `30. Staff Shift Scheduler Screen`
    *   `30a. Add Shift Screen`
    *   `30b. Edit Shift Screen`
    *   `31. Staff Attendance Report Screen`
*   **File HTML Mockup tương ứng để code:**
    *   `admin_hq_mockups/branch_management_web.html` (Quản lý chi nhánh của Admin)
    *   `admin_hq_mockups/customers_web.html` (Danh sách thành viên của Admin)
    *   `admin_hq_mockups/settings_web.html` (Cấu hình hệ thống chung Admin)
    *   `store_manager_mockups/schedule_web.html` (Xếp ca của Quản lý chi nhánh)
    *   `store_manager_mockups/attendance_web.html` (Xem chấm công của Quản lý)
    *   `store_manager_mockups/staff_roster_web.html` (Danh sách nhân viên cửa hàng)
    *   `store_manager_mockups/branch_settings_web.html` (Cài đặt cục bộ cửa hàng)

---

## 4. HE182009 (Sinh viên D) - POS Sales & Billing
*   **Phân hệ chính:** Toàn bộ nghiệp vụ thu ngân tại quầy POS bán lẻ (Shift drawer, checkout cart, payments, invoices).
*   **Tổng số Use Cases:** 14 UCs (5 Iter 1, 5 Iter 2, 4 Iter 3).
*   **Danh sách Use Cases chi tiết:**
    *   **Iteration 1:**
        *   `UC-44: Open Shift` (Mở ca làm việc POS & khai báo tiền lẻ)
        *   `UC-45: Add Item to Order` (Thêm sản phẩm vào giỏ hàng POS)
        *   `UC-46: Update Cart Item` (Sửa đổi số lượng/topping món trong giỏ hàng)
        *   `UC-51: Process Payment` (Thanh toán Cash/VietQR dynamic/Thẻ ngân hàng)
        *   `UC-52: Issue Invoice` (In hóa đơn thanh toán & tem Barista)
    *   **Iteration 2:**
        *   `UC-47: Search Menu Item` (Tìm nhanh món ăn trên màn hình POS)
        *   `UC-48: Apply Discount Code` (Áp dụng mã giảm giá voucher vào đơn hàng)
        *   `UC-49: Redeem Loyalty Points` (Tiêu điểm Loyalty đổi tiền giảm trừ trực tiếp)
        *   `UC-50: Lookup Customer Membership` (Tra cứu số điện thoại thành viên)
        *   `UC-25: Add Customer` (Đăng ký nhanh hội viên mới ngay tại màn hình POS)
    *   **Iteration 3:**
        *   `UC-53: Close Shift` (Kết ca, kiểm tiền drawer và bàn giao)
        *   `UC-54: View Local Order History` (Xem danh sách đơn hàng đã bán trong ca)
        *   `UC-73: View Order Detail` (Xem chi tiết lịch sử/timeline của hóa đơn)
        *   `UC-55: Request Transaction Refund` (Hủy đơn hàng PENDING & hoàn tiền/kho)
*   **Màn hình phụ trách (Screen Names):**
    *   `34. Shift Initiation Open Shift Screen`
    *   `35. POS Checkout Grid & Cart Screen`
    *   `36. Membership Search & Add Pop-up`
    *   `37. Apply Voucher Modal`
    *   `37a. Redeem Loyalty Points Modal`
    *   `38. Payment Checkout Modal`
    *   `39. Payment Retry & Cancel Modal`
    *   `40. Order History & Refund Request Screen`
    *   `41. Shift Reconciliation Close Shift Screen`
    *   `49. Order Detail Screen` (Xem chi tiết đơn hàng thu ngân)
*   **File HTML Mockup tương ứng để code:**
    *   `cashier_pos_mockups/cashier_pos_web.html` (Màn hình POS checkout thu ngân)

---

## 5. HE186364 (Sinh viên E) - Inventory, Barista & Reporting
*   **Phân hệ chính:** Quản trị Logistics kho hàng, quầy bếp pha chế của Barista và hệ thống báo cáo doanh thu.
*   **Tổng số Use Cases:** 14 UCs (5 Iter 1, 5 Iter 2, 4 Iter 3).
*   **Danh sách Use Cases chi tiết:**
    *   **Iteration 1:**
        *   `UC-31: View Stock List` (Theo dõi tồn kho nguyên vật liệu cửa hàng)
        *   `UC-61: View Import/Export History` (Xem nhật ký nhập xuất kho)
        *   `UC-57: View Order Queue Display` (Màn hình hàng chờ làm món Barista)
        *   `UC-58: Update Preparation Status` (Cập nhật trạng thái chế biến món ăn)
        *   `UC-59: Print Drink Label Sticker` (In tem dán ly đồ uống quầy pha chế)
    *   **Iteration 2:**
        *   `UC-32: Import Stock` (Thực hiện nhập kho nguyên vật liệu từ nhà cung cấp)
        *   `UC-33: Export Stock` (Thực hiện xuất kho hao hụt/hủy nguyên liệu hỏng)
        *   `UC-40: View Store Revenue Reports` (Xem báo cáo doanh thu cục bộ cửa hàng)
        *   `UC-41: Export Store Reports` (Xuất file báo cáo doanh thu cửa hàng)
        *   `UC-60: Report Issue / Escalate Order` (Barista báo lỗi máy móc/hết món để giữ đơn)
    *   **Iteration 3:**
        *   `UC-34: Perform Inventory Audit` (Thực hiện kiểm kho thực tế & đối soát lệch)
        *   `UC-62: Auto-Deduct Inventory on Order Completion` (Hệ thống tự động trừ kho nguyên liệu theo Recipe món ăn chế biến)
        *   `UC-28: View Consolidated Business Reports` (Xem báo cáo tổng hợp doanh thu chuỗi Admin)
        *   `UC-29: Export HQ Reports` (Xuất file excel/pdf báo cáo doanh thu chuỗi)
*   **Màn hình phụ trách (Screen Names):**
    *   `26. Stock List Screen`
    *   `26a. Stock History Log Screen`
    *   `27. Stock Import Form Screen`
    *   `28. Stock Export Form Screen`
    *   `29. Stock Audit Screen`
    *   `32. Store Revenue Reports Screen`
    *   `32a. Reports Export Modal`
    *   `23. HQ Business Reports Screen`
    *   `42. Barista Queue Monitor Screen`
    *   `43. Report Issue & Hold Order Screen`
*   **File HTML Mockup tương ứng để code:**
    *   `barista_monitor_mockups/barista_monitor_web.html` (Màn hình bếp Barista)
    *   `store_manager_mockups/inventory_web.html` (Kho hàng chi nhánh của Manager)
    *   `store_manager_mockups/store_reports_web.html` (Doanh thu chi nhánh của Manager)
    *   `admin_hq_mockups/hq_reports_web.html` (Doanh thu toàn hệ thống của Admin)
