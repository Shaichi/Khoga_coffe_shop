# Tóm Tắt Các Task Cần Chỉnh Sửa Đặc Tả SRS (Khoga Café)

Tài liệu này tổng hợp danh sách các công việc chỉnh sửa đặc tả SRS và giao diện Mockup của dự án Khoga Café nhằm tinh gọn và tối giản hóa quy trình nghiệp vụ.

---

## I. Giao Diện Mockup (HTML) - 🟢 ĐÃ HOÀN THÀNH

Các file giao diện đã được cập nhật trực tiếp để đồng bộ với logic nghiệp vụ mới:

*   [x] **[index.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/index.html)**: Cập nhật hướng dẫn chạy thử luồng hủy đơn (hủy trực tiếp khi đơn ở trạng thái `PENDING`, không cần nhập mã PIN quản lý `1234`).
*   [x] **[cashier_pos_mockups/cancel_override.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/cashier_pos_mockups/cancel_override.html)**: 
    *   Loại bỏ cảnh báo về hao hụt nguyên liệu khi đang pha chế.
    *   Thêm logic JavaScript tự động kiểm tra trạng thái: Nếu đơn hàng khác `PENDING` sẽ hiển thị thông báo lỗi màu đỏ và khóa nút bấm hủy đơn.
    *   Bỏ cơ chế phê duyệt bằng mã PIN của Quản lý khi hủy đơn thành công.
*   [x] **[cashier_pos_mockups/order_detail.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/cashier_pos_mockups/order_detail.html)**:
    *   Thêm nhãn trạng thái `Chờ pha chế` (`PENDING`).
    *   Khóa nút **[ HỦY ĐƠN & HOÀN TIỀN ]** và đổi nhãn nút nếu trạng thái đơn hàng khác `PENDING` (ví dụ: đang pha chế, chờ lấy hàng, hoàn thành).
*   [x] **[store_manager_mockups/order_detail.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/store_manager_mockups/order_detail.html)**: Bổ sung nhãn trạng thái `PENDING` và cập nhật logic đồng bộ.
*   [x] **[barista_monitor_mockups/barista_queue.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/barista_monitor_mockups/barista_queue.html)**: Xác nhận nút `[ READY ]` hoạt động dạng **1 chạm** (không cần nhập PIN Barista cá nhân, in nhãn dán dán ly và chuyển trạng thái tức thì).
*   [x] **[admin_hq_mockups/user_add_web.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/admin_hq_mockups/user_add_web.html)** & **[user_edit_web.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/admin_hq_mockups/user_edit_web.html)**: Cho phép cấu hình và bắt buộc nhập **Mã PIN cá nhân 4 số** cho toàn bộ nhân viên (bao gồm cả Thu ngân và Pha chế) phục vụ cho chấm công.

---

## II. Giao Diện Mockup (HTML) - 🟡 CẦN THỰC HIỆN

*   [ ] **[store_manager_mockups/stock_import.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/store_manager_mockups/stock_import.html)**: 
    *   Chuyển giao diện từ nhập lẻ từng nguyên liệu thành bảng lưới dòng (Table/Grid) cho phép nhập kho hàng loạt nhiều mặt hàng trên cùng một phiếu.

---

## III. File Đặc Tả SRS (.md trong thư mục `sections/`) - 🔴 CẦN CHỈNH SỬA

### 1. Nhóm Nghiệp Vụ Hủy Đơn, Chấm Công & KPI Bếp

*   [ ] **[sections/05_appendix_mapping.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/05_appendix_mapping.md)**:
    *   **BR-05 (Quyền hủy đơn)**: Sửa thành chỉ cho phép hủy đơn khi trạng thái là `PENDING`.
    *   **BR-51 (Nhật ký hủy đơn)**: Bỏ yêu cầu nhập PIN quản lý/người phê duyệt; chỉ ghi nhận định danh thu ngân trực tiếp thực hiện hủy.
    *   **BR-53 (Chấm công)**: Mô tả cơ chế chấm công độc lập thông qua popup nhập mã PIN 4 số cá nhân và chụp ảnh bằng camera POS/Tablet (không cần logout tài khoản bán hàng).
*   [ ] **[sections/03_7_order_management.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_7_order_management.md)**:
    *   **UC-55 (Request Transaction Refund)**: Thêm tiền điều kiện (Precondition) là trạng thái đơn phải là `PENDING`. Bỏ các bước xác thực PIN quản lý trong luồng chính và luồng phụ.
    *   **UC-57 (View Order Queue Display)**: Mô tả hành động nhấn `[ READY ]` hoạt động tức thì 1 chạm mà không có popup PIN.
*   [ ] **Ca làm việc & Phiên đăng nhập (Tách biệt Logout & Active Shift)**:
    *   Cho phép Thu ngân đăng xuất tài khoản cá nhân (User Session) mà không bắt buộc phải Đóng ca (Close Shift). Ca làm việc (Shift Session/Register Session) của két POS vẫn được duy trì mở để người khác vào đăng nhập bán thay (tránh bắt buộc đóng két đếm tiền chỉ để đi ăn trưa/nghỉ giữa ca).
*   [ ] **Quy trình Khôi phục mật khẩu & cờ `must_change_password` (UC-05 & Entity USER)**:
    *   Quy định rõ sau khi người dùng thực hiện thành công luồng đổi mật khẩu mới qua mã OTP (UC-05), hệ thống sẽ tự động cập nhật cờ `must_change_password = false` để tránh việc bắt buộc đổi mật khẩu lần 2 ở màn hình Force Change Password (UC-06) khi đăng nhập lại.
*   [ ] **Ràng buộc duy nhất Email khi tự cập nhật thông tin cá nhân (UC-08 - Update Profile)**:
    *   Bổ sung kiểm tra trùng lặp (Uniqueness Constraint) đối với Email/Số điện thoại trong CSDL khi nhân viên tự cập nhật thông tin. Tránh trường hợp 2 tài khoản trùng Email dẫn đến lỗi logic hoặc gửi nhầm OTP khi dùng tính năng Quên mật khẩu.
*   [ ] **Cơ chế mở khóa tài khoản thủ công (UC-01 AT3 & UC-12)**:
    *   Thêm tính năng cho phép Store Manager hoặc HQ Admin mở khóa (Unlock) tài khoản nhân viên bị tạm khóa 15 phút do nhập sai mật khẩu 5 lần liên tiếp (Lockout), giúp tránh gián đoạn vận hành bán hàng lúc đông khách.
*   [ ] **Hỗ trợ điều động nhân sự liên chi nhánh (Entity USER)**:
    *   Cho phép nhân viên đăng nhập/mở ca tại các chi nhánh khác chi nhánh gốc (khi được điều động hỗ trợ chéo). Hệ thống sẽ ghi nhận `store_id` điểm danh và doanh thu ca làm việc theo thiết bị POS thực tế đang vận hành thay vì lấy `store_id` mặc định cố định của tài khoản nhân viên.
*   [ ] **Bảo mật mật khẩu tạm thời khi tạo tài khoản (UC-11)**:
    *   Thay đổi cơ chế: Loại bỏ việc Admin tự gõ tay mật khẩu tạm thời ở dạng văn bản thô (Plaintext). Hệ thống tự sinh ngẫu nhiên mật khẩu tạm thời bảo mật hoặc gửi email liên kết kích hoạt để nhân viên tự đặt mật khẩu khi đăng nhập lần đầu.
*   [ ] **Quy tắc tự động sinh Username (UC-11 - BR-58)**:
    *   Thống nhất quy tắc sinh Username: Ký tự đầu tiên của tên chính bắt buộc viết thường (ví dụ: `anNV43` hoặc `anVN43` thay vì viết hoa chữ `A`).
*   [ ] **Quản lý Khách hàng & Điểm thưởng Loyalty (UC-26, BR-35, BR-01, BR-02)**:
    *   **Màn hình Edit Customer (UC-26)**: Cho phép chỉnh sửa Họ tên (`full_name`) và Email của khách hàng. **Khóa cứng/Vô hiệu hóa chỉnh sửa Số điện thoại** (`phone`) vì đây là trường khóa chính định danh duy nhất của hồ sơ khách hàng.
    *   **Hết hạn điểm thưởng (BR-35)**: Quy định rõ cơ chế điểm thưởng hết hạn sau 12 tháng khách hàng không phát sinh bất kỳ giao dịch mua sắm nào (inactivity). Hệ thống tự động thu hồi điểm hết hạn qua tác vụ quét định kỳ.
    *   **Logic tính & tiêu điểm thưởng (BR-01, BR-02)**:
        *   *Tích lũy*: Tính theo tỷ lệ % cấu hình của giá trị hóa đơn thanh toán thực tế (Net Total Payable). Bổ sung tham số cấu hình tỷ lệ tích lũy và giới hạn số điểm tối đa được tích lũy trên mỗi hóa đơn.
        *   *Tiêu điểm*: Giới hạn tỷ lệ thanh toán bằng điểm (ví dụ không quá X% tổng hóa đơn) và số tiền giảm giá tối đa bằng điểm (ví dụ tối đa 100.000 VND/đơn hàng) để kiểm soát tài chính.

### 2. Nhóm Nghiệp Vụ Quản Lý Kho & Nhập Kho Hàng Loạt

*   [ ] **[sections/03_5_inventory_management.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_5_inventory_management.md)**:
    *   **UC-32 (Stock Import)**: Sửa đổi mô tả luồng thực hiện để hỗ trợ nhập nhiều dòng mặt hàng cùng một lúc thay vì nhập lẻ tẻ từng nguyên liệu.

### 3. Nhóm Cập Nhật Cơ Sở Dữ Liệu & Sơ Đồ ERD

*   [ ] **[sections/03_1_functional_overview.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_1_functional_overview.md)**:
    *   **Bảng `order_cancellations`**: Xóa trường `manager_id` (hoặc `approver_id`).
    *   **Bảng `attendance_logs`**: Bổ sung trường `photo_url` (VARCHAR) lưu liên kết ảnh chụp xác thực từ camera.
    *   **Bảng `vouchers`**: Bổ sung trường `max_discount_amount` (DECIMAL) để giới hạn số tiền giảm tối đa của Voucher %.
    *   **Trạng thái khả dụng món ăn theo Chi nhánh**: Loại bỏ thuộc tính `is_available` dùng chung trên bảng `menu_items` (tránh việc chi nhánh này hết sữa tắt món Latte làm ảnh hưởng toàn bộ chuỗi). Tạo bảng liên kết mới `branch_menu_status` (`store_id`, `menu_item_id`, `is_available`) để quản lý riêng biệt. Bảng `menu_items` đổi sang dùng trường `is_active` để bật/tắt bán món trên toàn chuỗi (do Admin quyết định).
    *   **Ràng buộc khóa ngoại khi xóa danh mục**: Thay đổi thuộc tính `category_id` trong bảng `menu_items` từ bắt buộc sang tùy chọn (Nullable). Khi Admin xóa một danh mục, hệ thống tự động set `category_id = NULL` cho tất cả các sản phẩm thuộc danh mục đó đã bị xóa mềm (`is_deleted = true`), tránh lỗi ràng buộc khóa ngoại (Foreign Key Constraint) gây crash database.
    *   **Sơ đồ Mermaid ERD**: Cập nhật sơ đồ (mục 3.1.5) và mô tả thực thể (mục 3.1.6) để thêm bảng `order_cancellations`, `branch_menu_status`, và `audit_logs`.

### 4. Nhóm Cải Tiến Thực Tế Theo Thị Trường

*   [ ] **[sections/03_3_menu_management.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_3_menu_management.md)**:
    *   Cập nhật các Use Cases quản lý sản phẩm để hỗ trợ thiết lập Variants/Sizes.
*   [ ] **[sections/03_10_promotion_campaign.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_10_promotion_campaign.md)**:
    *   Bổ sung quy tắc nghiệp vụ giới hạn giảm giá tối đa (`max_discount_amount`) khi áp dụng Voucher %.
*   [ ] **[sections/03_13_system_configuration.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_13_system_configuration.md)**:
    *   Cập nhật quy định hệ thống giới hạn 5 chi nhánh (BR-54) thành tham số động `MAX_ACTIVE_BRANCHES` để cấu hình tùy ý.
*   [ ] **Phân quyền truy cập của Store Manager (Bảng phân quyền & UC-19)**:
    *   Cho phép Store Manager truy cập Menu Management ở chế độ **Chỉ xem (Read-only)**. Tại đây, Store Manager chỉ được phép thao tác nút Toggle trạng thái khả dụng (`is_available` của chi nhánh đó) mà không được sửa giá, tên hay công thức sản phẩm.

### 5. Nhóm Sửa Lỗi Sai Sót & Đồng Bộ Đặc Tả

*   [ ] **[sections/03_4_category_management.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_4_category_management.md)**:
    *   Sửa lỗi sao chép tiêu đề Use Case UC-17 (ghi nhầm thành "Delete Category" thay vì "Update Category").
*   [ ] **Cập nhật Sơ đồ Use Case tổng quan** (nếu có):
    *   Bổ sung kết nối từ vai trò Cashier sang các Use Cases của Customer (như đăng ký thành viên, tích lũy điểm).

### 6. Nhóm Loại Bỏ Tích Hợp ShopeeFood & Đối Tác Giao Hàng

*   [ ] **Xóa bỏ tài liệu đặc tả đối tác giao hàng**:
    *   Xóa file đặc tả **[03_11_delivery_partner.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_11_delivery_partner.md)**.
*   [ ] **Cập nhật các tài liệu đặc tả khác**:
    *   **[sections/02_user_requirements.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/02_user_requirements.md)**: Loại bỏ tác nhân ngoài API đối tác giao hàng (GrabFood, ShopeeFood).
    *   **[sections/03_1_functional_overview.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_1_functional_overview.md)**:
        *   Xóa hàm hệ thống chạy ngầm số 7: "Delivery Partner Integration Revenue Report Fetcher".
        *   Xóa giá trị `SHOPEEFOOD` trong thuộc tính `payment_method` của thực thể `ORDER`.
        *   Cập nhật sơ đồ Mermaid ERD loại bỏ liên kết liên quan (nếu có).
    *   **[sections/03_6_pos_transaction.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_6_pos_transaction.md)**: Loại bỏ phương thức thanh toán ShopeeFood khỏi màn hình thanh toán POS và Use Case.
    *   **[sections/04_non_functional_requirements.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/04_non_functional_requirements.md)**: Loại bỏ các tham chiếu đến việc đình chỉ xác thực ShopeeFood ở trạng thái ngoại tuyến.
*   [ ] **Chỉnh sửa các Mockup Giao diện (HTML)**:
    *   **[cashier_pos_mockups/payment.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/cashier_pos_mockups/payment.html)**: Gỡ bỏ thẻ phương thức thanh toán ShopeeFood, panel nhập mã đơn đối soát ShopeeFood và các đoạn code JS kiểm định liên quan.
    *   **[cashier_pos_mockups/print_invoice.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/cashier_pos_mockups/print_invoice.html)**: Gỡ bỏ phần mapping phương thức thanh toán ShopeeFood.
    *   **[barista_monitor_mockups/barista_queue.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/barista_monitor_mockups/barista_queue.html)**: Xóa thẻ đơn hàng số `#015` (vốn là đơn ShopeeFood giả lập) hoặc chuyển đổi nó thành đơn thường (`Dine-in`/`Take-away`).
*   [ ] **Cập nhật các tài liệu tóm tắt dự án**:
    *   Gỡ bỏ mô tả tích hợp Grab/ShopeeFood trong `project_summary.md` và `README.md`.

