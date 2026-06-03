# Kế Hoạch Chỉnh Sửa SRS: Hủy Đơn, Chấm Công, Bếp & Đồng Bộ Nghiệp Vụ (Khoga Café)

Tài liệu này tổng hợp toàn bộ các quyết định thiết kế nghiệp vụ tối giản, các lỗi logic được phát hiện và danh sách chi tiết các công việc cần thực hiện để cập nhật vào đặc tả SRS chính của dự án.

---

## I. Tóm Tắt Các Nghiệp Vụ Cải Tiến Tối Giản & Logic Mới

### 1. Luồng Hủy Đơn Tối Giản
*   **Nguyên tắc**: **Chỉ cho phép hủy đơn khi đang ở trạng thái `PENDING` (Chờ chế biến/Chưa thanh toán)**.
*   **Vận hành**: Thu ngân (Cashier) tự bấm hủy trực tiếp, không cần mã PIN của Quản lý.
*   **Khi đã chế biến (`PREPARING` $\to$ `COMPLETED`)**: Hệ thống **khóa/vô hiệu hóa hoàn toàn** chức năng hủy đơn. Không cho phép bất kỳ ai hủy đơn để tránh gian lận tiền mặt và đơn giản hóa việc quản lý hao hụt nguyên liệu.

### 2. Luồng Chấm Công Độc Lập (PIN + Camera POS)
*   **Nguyên tắc**: Tách biệt hoàn toàn luồng đăng nhập thiết bị và luồng chấm công cá nhân.
*   **Vận hành**:
    *   Thiết bị POS và Tablet Barista vẫn giữ phiên đăng nhập dùng chung cả ngày.
    *   Nhân viên muốn chấm công chỉ cần bấm nút **[ CHẤM CÔNG ]** trên màn hình → Hệ thống mở camera trước của máy POS/Tablet → Nhân viên nhập **Mã PIN cá nhân 4 số** → Hệ thống chụp ảnh làm bằng chứng và lưu log chấm công.
    *   Không cần đăng xuất (logout) tài khoản ứng dụng đang bán hàng/hiển thị bếp.

### 3. Luồng Pha Chế & KPI Barista theo Ca
*   **Nguyên tắc**: Barista làm việc theo tinh thần đồng đội tại quầy bar.
*   **Vận hành**:
    *   Khi hoàn thành món, Barista chỉ cần bấm **1 chạm duy nhất vào nút `[ READY ]`** trên màn hình bếp để in tem dán ly và chuyển trạng thái.
    *   **Hoàn toàn không yêu cầu nhập mã PIN** cho từng ly để bảo đảm tốc độ ra đồ uống.
    *   **KPI hiệu suất**: Được tính gộp theo **Ca làm việc** (tổng số ly hoàn thành trong ca, thời gian làm đồ trung bình của ca) hoặc theo **Chi nhánh**, không theo vết riêng lẻ từng ly cho từng người.

### 4. Ca Làm Việc & Đăng Xuất (Tách biệt Session & Shift)
*   **Nguyên tắc**: Cho phép Thu ngân đăng xuất tài khoản cá nhân (User Session) mà không bắt buộc phải Đóng ca (Close Shift). Ca làm việc (Shift Session) của két POS vẫn được duy trì mở để người khác vào đăng nhập bán thay (tránh bắt buộc đóng két đếm tiền chỉ để đi ăn trưa/nghỉ giữa ca).

### 5. Quản Lý Trạng Thái Món Ăn (Availability)
*   **Nguyên tắc**: Loại bỏ thuộc tính `is_available` dùng chung trên bảng `menu_items` (tránh việc chi nhánh này hết nguyên liệu tắt món làm ảnh hưởng toàn bộ các chi nhánh còn lại). Tạo bảng liên kết mới `branch_menu_status` (`store_id`, `menu_item_id`, `is_available`) để quản lý riêng biệt. Bảng `menu_items` đổi sang dùng trường `is_active` để bật/tắt bán món trên toàn chuỗi (do Admin quyết định).

---

## II. Danh Sách Việc Cần Làm (TODO List) Để Cập Nhật SRS

Dưới đây là các đầu việc chi tiết cần chỉnh sửa trong các file tài liệu đặc tả và mockup giao diện:

### 1. Cập nhật các Mockup Giao diện (HTML)

#### [x] Bước 1: Chỉnh sửa màn hình Chi tiết Đơn hàng [order_detail.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/cashier_pos_mockups/order_detail.html)
*   [x] Thêm nhãn trạng thái `Chờ pha chế` (`PENDING`).
*   [x] Khóa nút **[ HỦY ĐƠN & HOÀN TIỀN ]** và đổi nhãn nút nếu trạng thái đơn hàng khác `PENDING` (ví dụ: đang pha chế, chờ lấy hàng, hoàn thành).

#### [x] Bước 2: Chỉnh sửa màn hình Hủy Đơn [cancel_override.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/cashier_pos_mockups/cancel_override.html)
*   [x] Loại bỏ cảnh báo về hao hụt nguyên liệu khi đang pha chế.
*   [x] Thêm logic JavaScript tự động kiểm tra trạng thái: Nếu đơn hàng khác `PENDING` sẽ hiển thị thông báo lỗi màu đỏ và khóa nút bấm hủy đơn.
*   [x] Bỏ cơ chế phê duyệt bằng mã PIN của Quản lý khi hủy đơn thành công.

#### [x] Bước 3: Cập nhật màn hình Bếp [barista_monitor_mockups](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/barista_monitor_mockups)
*   [x] Xác nhận nút `[ READY ]` hoạt động dạng **1 chạm** (không cần nhập PIN Barista cá nhân, in nhãn dán dán ly và chuyển trạng thái tức thì).

#### [x] Bước 4: Cập nhật cấu hình PIN cho toàn bộ vai trò nhân viên [user_add_web.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/admin_hq_mockups/user_add_web.html) & [user_edit_web.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/admin_hq_mockups/user_edit_web.html)
*   [x] Cho phép cấu hình và bắt buộc nhập **Mã PIN cá nhân 4 số** cho toàn bộ nhân viên (bao gồm cả Thu ngân và Pha chế) phục vụ cho chấm công.

#### [ ] Bước 5: Cập nhật màn hình Nhập kho [stock_import.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/store_manager_mockups/stock_import.html)
*   [ ] Chuyển giao diện từ nhập lẻ từng nguyên liệu thành bảng lưới dòng (Table/Grid) cho phép nhập kho hàng loạt nhiều mặt hàng trên cùng một phiếu.

---

### 2. Cập nhật tài liệu đặc tả (.md trong thư mục `sections`)

#### [ ] Bước 6: Sửa đổi các Business Rules trong [05_appendix_mapping.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/05_appendix_mapping.md)
*   **[ ] Sửa BR-05 (Quyền hủy đơn)**:
    *   *Nội dung mới*: "Order cancellation is strictly restricted to the `PENDING` status. Once the order transitions to `PREPARING` (preparation started), the cancellation action is disabled for all users, including Cashiers and Managers."
*   **[ ] Sửa BR-51 (Nhật ký hủy đơn)**:
    *   *Nội dung mới*: "Every order cancellation action must record the cashier's identity, timestamp, cancellation reason, and detailed notes in the `order_cancellations` log. No manager PIN or override code verification is required."
*   **[ ] Sửa BR-53 (Chấm công)**:
    *   *Nội dung mới*: "Staff check-in and check-out are performed via a dedicated attendance popup by entering a personal 4-digit PIN and taking a camera snapshot. This action is independent of the active terminal session login."
*   **[ ] Sửa BR-54 (Cấu hình số chi nhánh)**:
    *   *Nội dung mới*: Đổi giới hạn cứng "tối đa 5 chi nhánh" thành cấu hình động theo tham số hệ thống.
*   **[ ] Sửa BR-01 (Tích lũy điểm) & BR-02 (Tiêu điểm)**:
    *   *Nội dung mới*: Tích lũy theo % giá trị hóa đơn (Net Total Payable), có giới hạn điểm tích lũy tối đa/đơn. Tiêu điểm có giới hạn tối đa % hóa đơn được giảm và số tiền giảm tối đa/đơn.
*   **[ ] Sửa BR-35 (Hết hạn điểm)**:
    *   *Nội dung mới*: Điểm hết hạn sau 12 tháng khách hàng không phát sinh giao dịch mới (inactivity).

#### [ ] Bước 7: Cập nhật Nghiệp vụ Đơn hàng & Chấm công trong [03_7_order_management.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_7_order_management.md)
*   **[ ] Sửa Use Case UC-55 (Request Transaction Refund)**:
    *   Cập nhật mô tả: Tiền điều kiện (Precondition) là đơn phải ở trạng thái `PENDING`. Xóa bỏ các bước yêu cầu Manager phê duyệt hoặc nhập PIN Quản lý trong các luồng phụ.
*   **[ ] Sửa Use Case UC-57 (View Order Queue Display)**:
    *   Khẳng định nút `[ READY ]` hoạt động với 1 chạm duy nhất, không yêu cầu xác thực thêm.
*   **[ ] Ca làm việc & Phiên đăng nhập (Tách biệt Logout & Active Shift)**:
    *   Cho phép Thu ngân đăng xuất tài khoản cá nhân (User Session) mà không bắt buộc phải Đóng ca (Close Shift). Ca làm việc (Shift Session) của két POS vẫn được duy trì mở.
*   **[ ] Hỗ trợ điều động nhân sự liên chi nhánh**:
    *   Cho phép nhân viên đăng nhập/mở ca tại các chi nhánh khác chi nhánh gốc (khi được điều động hỗ trợ chéo). Hệ thống sẽ ghi nhận `store_id` điểm danh và doanh thu ca làm việc theo thiết bị POS thực tế đang vận hành.

#### [ ] Bước 8: Cập nhật hồ sơ nhân sự & bảo mật trong [03_2_account_management.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_2_account_management.md)
*   **[ ] Quy trình Khôi phục mật khẩu & cờ `must_change_password` (UC-05)**:
    *   Quy định rõ sau khi người dùng thực hiện thành công luồng đổi mật khẩu mới qua mã OTP (UC-05), hệ thống sẽ tự động cập nhật cờ `must_change_password = false`.
*   **[ ] Ràng buộc duy nhất Email khi tự cập nhật thông tin cá nhân (UC-08 - Update Profile)**:
    *   Bổ sung kiểm tra trùng lặp (Uniqueness Constraint) đối với Email/Số điện thoại trong CSDL khi nhân viên tự cập nhật thông tin.
*   **[ ] Cơ chế mở khóa tài khoản thủ công (UC-01 AT3 & UC-12)**:
    *   Thêm tính năng cho phép Store Manager hoặc HQ Admin mở khóa (Unlock) tài khoản nhân viên bị tạm khóa 15 phút do nhập sai mật khẩu 5 lần liên tiếp.
*   **[ ] Bảo mật mật khẩu tạm thời khi tạo tài khoản (UC-11)**:
    *   Loại bỏ việc Admin tự gõ tay mật khẩu tạm thời ở dạng văn bản thô. Hệ thống tự sinh ngẫu nhiên mật khẩu tạm thời hoặc gửi email liên kết kích hoạt để nhân viên tự đặt mật khẩu khi đăng nhập lần đầu.
*   **[ ] Quy tắc tự động sinh Username (UC-11 - BR-58)**:
    *   Thống nhất quy tắc sinh Username: Ký tự đầu tiên của tên chính bắt buộc viết thường (ví dụ: `anNV43`).

#### [ ] Bước 9: Cập nhật nghiệp vụ thực đơn trong [03_3_menu_management.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_3_menu_management.md)
*   **[ ] Bổ sung Size / Variant cho thực đơn**:
    *   Sửa các Use Cases về Menu để mô tả việc cấu hình Variant/Size và giá tương ứng.
*   **[ ] Phân quyền bật/tắt món của Store Manager (UC-19)**:
    *   Cho phép Store Manager truy cập Menu Management ở chế độ **Chỉ xem (Read-only)** để bật/tắt trạng thái khả dụng (`is_available` của chi nhánh đó) mà không được sửa các thông tin khác.

#### [ ] Bước 10: Cập nhật nghiệp vụ Quản lý Kho trong [03_5_inventory_management.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_5_inventory_management.md)
*   **[ ] Sửa đổi UC-32 (Stock Import) thành Nhập kho hàng loạt**:
    *   Mô tả việc nhập đồng thời nhiều mặt hàng trên cùng một hóa đơn nhập (Multi-line Invoice Form), tính tổng tiền hàng của phiếu nhập.

#### [ ] Bước 11: Cập nhật nghiệp vụ Voucher & Cấu hình hệ thống
*   **[ ] [03_10_promotion_campaign.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_10_promotion_campaign.md)**:
    *   Thêm quy định nghiệp vụ: Khi `discount_type = PERCENTAGE` và `max_discount_amount` được cấu hình, số tiền giảm tối đa sẽ bị chặn (cap) ở mức giới hạn này.
    *   Bổ sung logic tích lũy và tiêu dùng điểm thưởng Loyalty: định nghĩa tỷ lệ % tích lũy, giới hạn tích lũy tối đa/hóa đơn, tỷ lệ thanh toán tối đa bằng điểm và số tiền giảm tối đa bằng điểm.
*   **[ ] [03_13_system_configuration.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_13_system_configuration.md)**:
    *   Định nghĩa thêm tham số hệ thống `MAX_ACTIVE_BRANCHES` trong danh mục cấu hình của HQ Admin.

#### [ ] Bước 12: Cập nhật CSDL & Sơ Đồ ERD trong [03_1_functional_overview.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_1_functional_overview.md)
*   **[ ] Cập nhật bảng `order_cancellations`**: Xóa trường `manager_id`.
*   **[ ] Cập nhật bảng `attendance_logs`**: Thêm cột `photo_url` (VARCHAR) lưu ảnh từ camera.
*   **[ ] Cập nhật bảng `vouchers`**: Bổ sung cột `max_discount_amount DECIMAL(12,2) NULL`.
*   **[ ] Bảng liên kết `branch_menu_status`**: Định nghĩa bảng liên kết chứa các trường `store_id`, `menu_item_id`, `is_available` để quản lý khả dụng món ăn độc lập giữa các chi nhánh.
*   **[ ] Ràng buộc khóa ngoại khi xóa danh mục**: Đổi `category_id` trong `menu_items` thành Nullable để tự động set NULL cho sản phẩm đã bị xóa mềm (`is_deleted = true`).
*   **[ ] Cập nhật sơ đồ Mermaid ERD và mô tả chi tiết thực thể**: Thêm bảng `order_cancellations`, `branch_menu_status`, và `audit_logs`.

#### [ ] Bước 13: Sửa lỗi sai sót và đồng bộ đặc tả
*   **[ ] [03_4_category_management.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_4_category_management.md)**:
    *   Sửa lỗi sao chép tiêu đề Use Case UC-17 (ghi nhầm thành "Delete Category" thay vì "Update Category").
*   **[ ] Cập nhật Sơ đồ Use Case tổng quan**:
    *   Bổ sung kết nối từ vai trò Cashier sang các Use Cases của Customer (như đăng ký thành viên, tích lũy điểm).

#### [ ] Bước 14: Cập nhật nghiệp vụ Khách hàng trong [03_8_customer_membership.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_8_customer_membership.md)
*   **[ ] Sửa Use Case UC-26 (Update Customer) & Giao diện Edit Customer**:
    *   Cho phép chỉnh sửa Họ tên (`full_name`) và Email, nhưng khóa cứng không cho phép chỉnh sửa Số điện thoại (`phone`).
    *   Cập nhật quy định hết hạn điểm thưởng (BR-35) sau 12 tháng khách hàng không phát sinh giao dịch (inactivity).

#### [ ] Bước 15: Loại bỏ hoàn toàn tích hợp ShopeeFood & Đối tác giao hàng
*   **[ ] Xóa file đặc tả đối tác giao hàng**: Xóa file **[03_11_delivery_partner.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_11_delivery_partner.md)**.
*   **[ ] Cập nhật đặc tả**:
    *   **[02_user_requirements.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/02_user_requirements.md)**: Loại bỏ tác nhân ngoài API đối tác giao hàng.
    *   **[03_1_functional_overview.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_1_functional_overview.md)**: Xóa hàm ngầm "7. Delivery Partner Integration Revenue Report Fetcher", loại bỏ `SHOPEEFOOD` trong `payment_method` của ORDER.
    *   **[03_6_pos_transaction.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_6_pos_transaction.md)**: Xóa phương thức thanh toán ShopeeFood khỏi POS và UC.
    *   **[04_non_functional_requirements.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/04_non_functional_requirements.md)**: Loại bỏ các tham chiếu đến ngoại tuyến đối soát ShopeeFood.
*   **[ ] Sửa các Mockup Giao diện (HTML)**:
    *   **[payment.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/cashier_pos_mockups/payment.html)**: Xóa thẻ và panel nhập đơn ShopeeFood cùng logic JS đối soát.
    *   **[print_invoice.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/cashier_pos_mockups/print_invoice.html)**: Xóa mapping `SHOPEEFOOD` payment text.
    *   **[barista_queue.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/barista_monitor_mockups/barista_queue.html)**: Xóa/Chuyển đơn ShopeeFood giả lập `#015` thành đơn thường.
*   **[ ] Cập nhật tóm tắt**: Gỡ bỏ mô tả tích hợp Grab/ShopeeFood trong `project_summary.md` và `README.md`.
