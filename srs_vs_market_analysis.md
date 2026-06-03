# Báo Cáo Phân Tích Chuyên Sâu SRS Khoga Café
## Đối Chiếu Với Thực Tế Vận Hành F&B & Khuyến Nghị Điều Chỉnh Scope

> **Phiên bản**: 2.0 — Phân tích chuyên sâu  
> **Ngày phân tích**: 2026-06-03  
> **Đối tượng so sánh**: iPOS.vn (chuỗi F&B chuyên sâu), KiotViet F&B (SME phổ biến)  
> **Tài liệu gốc**: [srs_document_full.md](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/srs_document_full.md) (v1.7, 5525 dòng, 73 Use Cases, 56 Business Rules)

---

## Mục Lục

1. [Tổng Quan Quy Mô Dự Án](#1-tổng-quan-quy-mô-dự-án)
2. [Bảng Đối Chiếu Chi Tiết Theo Từng Phân Hệ](#2-bảng-đối-chiếu-chi-tiết-theo-từng-phân-hệ)
3. [Kiểm Toán Mâu Thuẫn Nội Bộ Trong Tài Liệu](#3-kiểm-toán-mâu-thuẫn-nội-bộ-trong-tài-liệu)
4. [Phân Tích Lỗ Hổng Thiết Kế (Gap Analysis)](#4-phân-tích-lỗ-hổng-thiết-kế-gap-analysis)
5. [Đánh Giá Database Schema](#5-đánh-giá-database-schema)
6. [Đánh Giá Yêu Cầu Phi Chức Năng (NFR)](#6-đánh-giá-yêu-cầu-phi-chức-năng-nfr)
7. [Ma Trận Đánh Giá Tổng Hợp](#7-ma-trận-đánh-giá-tổng-hợp)
8. [Khuyến Nghị Điều Chỉnh Use Case & Scope (Ưu tiên hóa)](#8-khuyến-nghị-điều-chỉnh-use-case--scope-ưu-tiên-hóa)

---

## 1. Tổng Quan Quy Mô Dự Án

### Thống kê SRS hiện tại

| Chỉ số | Giá trị |
|:---|:---|
| Tổng số Use Cases | **73** (UC-01 đến UC-73) |
| Tổng số Business Rules | **56** (BR-01 đến BR-61, trừ 5 mã RESERVED/DELETED) |
| Tổng số Screens (giao diện) | **48** màn hình (8 Common + 16 Admin + 9 Manager + 10 Cashier + 5 Barista) |
| Tổng số Entities (bảng CSDL) | **16** bảng + 1 bảng audit log (`order_cancellations`) |
| Số phiên bản sửa đổi (Record of Changes) | **8** phiên bản (v1.0 → v1.7) |
| Tổng số Application Messages | **17** mã thông báo (MSG01 → MSG17) |
| Số Non-Screen Functions (tự động) | **7** chức năng nền (scheduler, token refresh, auto-deduct...) |

### So sánh quy mô với sản phẩm thực tế

| Tiêu chí | Khoga Café (SRS) | iPOS.vn (Production) | KiotViet F&B (Production) |
|:---|:---|:---|:---|
| Số module chức năng | 13 module (3.1–3.13) | ~20+ module (POS, KDS, CRM, Inventory, HR, FoodHub, Accounting...) | ~15 module (POS, Kho, Nhân sự, CRM, Báo cáo, Kết nối app giao hàng...) |
| Số vai trò người dùng | 4 vai trò nội bộ + 1 API | 6+ vai trò (thêm Owner, Accountant, Kitchen Staff riêng biệt) | 5+ vai trò (thêm Owner/Chủ shop, Kế toán) |
| Giới hạn chi nhánh | Tối đa 5 (BR-54) | Không giới hạn | Không giới hạn (tính phí theo gói) |
| Hỗ trợ đa ngôn ngữ | Thiết kế i18n message codes | Tiếng Việt + English | Tiếng Việt chính |

> **Nhận xét**: Quy mô 73 Use Cases cho một dự án quản lý chuỗi cà phê 5 chi nhánh là **rất lớn**, tiệm cận với sản phẩm thương mại thực tế. Điều này vừa là điểm mạnh (chi tiết, bài bản) vừa là rủi ro (khó triển khai hoàn chỉnh nếu nguồn lực hạn chế).

---

## 2. Bảng Đối Chiếu Chi Tiết Theo Từng Phân Hệ

### 2.1 Xác thực & Bảo mật (Section 3.2 — 13 Use Cases)

| Tính năng | Khoga Café | iPOS.vn | KiotViet | Đánh giá |
|:---|:---|:---|:---|:---|
| Đăng nhập đa vai trò | ✅ Username/Password, chuyển hướng theo role | ✅ Tương tự + hỗ trợ mã PIN nhanh | ✅ Tương tự | **Phù hợp** |
| Khóa tài khoản (BR-11) | ✅ Khóa 15 phút sau 5 lần sai | ✅ Tùy cấu hình (3-10 lần) | ✅ Khóa vĩnh viễn đến khi Admin mở khóa | Khoga Café hợp lý; KiotViet cứng hơn |
| Đổi mật khẩu lần đầu (UC-06) | ✅ Force Password Change | ❌ Không bắt buộc | ❌ Không bắt buộc | **Khoga Café chặt hơn thực tế** — phù hợp yêu cầu bảo mật cao |
| OTP qua Email (UC-04) | ✅ 6 số, hết hạn 10 phút, tối đa 3 lần | ✅ OTP qua SMS hoặc Email | ✅ OTP qua SMS | Nên cân nhắc thêm kênh SMS vì nhân viên quán cà phê thường không check email thường xuyên |
| Silent Token Refresh | ✅ Refresh khi còn < 30 phút, idle 30 phút tự logout | ✅ Tương tự | ✅ Session dựa trên cookie | **Thiết kế tốt** |

### 2.2 Quản lý Thực đơn & Danh mục (Section 3.3–3.4 — 7 Use Cases)

| Tính năng | Khoga Café | iPOS.vn | KiotViet | Đánh giá |
|:---|:---|:---|:---|:---|
| CRUD Menu Items | ✅ Đầy đủ, soft-delete (BR-28) | ✅ Tương tự | ✅ Tương tự | **Phù hợp** |
| Toppings/Options (UC-71) | ✅ Global hoặc per-item, giá có thể = 0 | ✅ Nhóm topping đa tầng (Modifier Groups) | ✅ Đơn giản hơn | Khoga Café thiếu khái niệm **Modifier Groups** (nhóm bắt buộc chọn, ví dụ: "Chọn size", "Chọn mức đá") |
| Recipe/Định lượng | ✅ Liên kết 1-1 (menu_item → stock_item qua recipe_items) | ✅ Đa tầng (bán thành phẩm → thành phẩm) | ✅ 1-1 đơn giản | **Thiếu bán thành phẩm** — xem chi tiết tại Gap Analysis |
| Barcode/SKU | ✅ Có field barcode, hỗ trợ scan | ✅ Tương tự | ✅ Tương tự | **Phù hợp** |
| Menu Size/Variants | ❌ **Không hỗ trợ** | ✅ Size S/M/L với giá khác nhau | ✅ Biến thể sản phẩm | **Thiếu lớn** — xem Gap Analysis |

### 2.3 Quản lý Kho (Section 3.5 — 7 Use Cases)

| Tính năng | Khoga Café | iPOS.vn | KiotViet | Đánh giá |
|:---|:---|:---|:---|:---|
| Nhập kho (UC-32) | ✅ Nhập theo đơn vị, ghi nhà cung cấp, giá nhập | ✅ Tương tự + hỗ trợ nhập nhiều mặt hàng cùng lúc (batch import) | ✅ Tương tự + batch import | **Thiếu batch import** — chỉ cho phép nhập từng mặt hàng một |
| Xuất kho (UC-33) | ✅ Có dropdown lý do (Wastage, Damage, Loss) | ✅ Tương tự | ✅ Tương tự | **Phù hợp** |
| Kiểm kê (UC-34) | ✅ So sánh Expected vs Actual, bắt buộc ghi chú khi lệch | ✅ Tương tự + hỗ trợ kiểm kê hàng loạt | ✅ Tương tự | **Thiếu kiểm kê hàng loạt** — hiện tại chỉ audit từng mặt hàng |
| Tự động trừ kho (UC-62) | ✅ Trừ khi chuyển sang PREPARING, không chặn nếu hết kho | ✅ Cấu hình linh hoạt (trừ khi thanh toán hoặc khi chế biến) | ✅ Trừ khi thanh toán | **Tốt hơn KiotViet** — trừ tại PREPARING phản ánh đúng thực tế tiêu hao |
| Cảnh báo tồn kho thấp | ✅ Badge + email tổng hợp lúc 22:00 | ✅ Real-time + push notification | ✅ Real-time badge | **Phù hợp** |

### 2.4 Nghiệp vụ POS Bán hàng (Section 3.6 — 9 Use Cases)

| Tính năng | Khoga Café | iPOS.vn | KiotViet | Đánh giá |
|:---|:---|:---|:---|:---|
| Mở/Đóng ca (UC-44, UC-53) | ✅ Bắt buộc khai báo két, đối chiếu cuối ca, cảnh báo lệch > 100k | ✅ Tương tự + phê duyệt đa cấp | ✅ Đơn giản hơn | **Rất tốt** — thiết kế chặt chẽ |
| Thanh toán VietQR động | ✅ Sinh QR động tích hợp giá trị VND, timeout 60 giây | ✅ VietQR + Momo + ZaloPay | ✅ VietQR + ví điện tử | **Thiếu ví điện tử** (Momo, ZaloPay) |
| Stacking Rules (Section 3.6.7) | ✅ Tier vs Voucher so sánh lấy cao hơn, Points stack thêm | ✅ Cấu hình linh hoạt qua rules engine | ✅ Đơn giản hơn (không stack) | **Rất chi tiết & chặt chẽ** — ưu điểm lớn |
| VAT inclusive (BR-46) | ✅ VAT bao gồm trong giá bán, tính ngược `tax = total * 10/110` | ✅ Tùy chọn inclusive/exclusive | ✅ Tùy chọn | **Phù hợp** thực tế VN (giá niêm yết đã bao gồm VAT) |
| Offline POS | ✅ Cache local, sync 60 giây, khóa Loyalty/VietQR khi offline | ✅ LAN nội bộ + offline cloud | ✅ Offline trên app | **Tốt** |
| Tự động đóng ca bỏ quên | ✅ Scheduler 23:59 (Non-Screen Function #5) | ✅ Tương tự | ✅ Tương tự | **Phù hợp** |
| Order Timeout (15 phút) | ✅ Auto-cancel đơn PENDING quá 15 phút (Non-Screen Function #6) | ✅ Tùy cấu hình | ❌ Không có | **Tốt** — tránh tồn đọng đơn ảo |

### 2.5 Quản lý Đơn hàng & Pha chế (Section 3.7 — 7 Use Cases)

| Tính năng | Khoga Café | iPOS.vn | KiotViet | Đánh giá |
|:---|:---|:---|:---|:---|
| Order State Machine | ✅ 6 trạng thái (PENDING → PREPARING → HOLD → READY → COMPLETED / CANCELLED) | ✅ Tương tự + thêm trạng thái SERVED | ✅ Đơn giản hơn (3-4 trạng thái) | **Rất tốt** — trạng thái HOLD cho phép xử lý sự cố |
| Barista Queue (UC-57) | ✅ Landscape tablet, sắp xếp theo thời gian | ✅ KDS chuyên dụng, màn hình đa cột theo trạng thái | ✅ Đơn giản hơn | Khoga Café đi đúng hướng nhưng layout đơn giản hơn iPOS KDS |
| In nhãn dán ly (UC-59) | ✅ Có | ✅ Có | ✅ Có | **Phù hợp** |
| Report Issue (UC-60) | ✅ Barista báo lỗi → HOLD, thông báo POS | ✅ Tương tự | ❌ Không có | **Ưu điểm** so với KiotViet |
| Audit log hủy đơn | ✅ Bảng `order_cancellations` riêng biệt | ✅ Tương tự | ✅ Ghi log chung | **Tốt** — dễ truy vết gian lận |

### 2.6 CRM & Hội viên (Section 3.8 — 4 Use Cases)

| Tính năng | Khoga Café | iPOS.vn | KiotViet | Đánh giá |
|:---|:---|:---|:---|:---|
| Phân hạng (BR-34) | ✅ 4 bậc: Bronze/Silver/Gold/Diamond, cập nhật real-time | ✅ Tùy cấu hình n bậc | ✅ 3-5 bậc tùy chọn | **Phù hợp** |
| Tiêu điểm (UC-49) | ✅ 100 điểm = 10k VND, chỉ từ Silver trở lên | ✅ Tùy cấu hình tỷ lệ quy đổi | ✅ Tùy cấu hình | Khoga Café cứng nhắc hơn (tỷ lệ cố định, không cấu hình được) |
| Hết hạn điểm (BR-35) | ✅ 12 tháng không giao dịch → hết hạn, audit ngày 31/12 | ✅ Tương tự, cấu hình linh hoạt | ✅ Có | **Phù hợp** |
| Ví thành viên trên Zalo/App | ❌ Không có | ✅ Zalo Mini App + ví thành viên | ❌ Không có | Ngoài scope nhưng đáng lưu ý cho tương lai |

### 2.7 Nhân sự & Chấm công (Section 3.9 — 5 Use Cases)

| Tính năng | Khoga Café | iPOS.vn | KiotViet | Đánh giá |
|:---|:---|:---|:---|:---|
| Xếp lịch phân ca (UC-36) | ✅ Morning/Afternoon/Full-Day, phân bổ máy POS | ✅ Tương tự + ca tùy chỉnh giờ | ✅ Đơn giản hơn | **Phù hợp**, nhưng thiếu ca tùy chỉnh giờ |
| Chấm công check-in (BR-38) | ✅ Tự động qua login vào terminal | ✅ Mã PIN / vân tay / nhận diện khuôn mặt | ✅ Mã PIN cá nhân | **Rủi ro cao** — xem Mâu thuẫn #2 |
| Chấm công check-out (BR-53) | ✅ Cashier: đóng ca POS; Barista: logout hệ thống | ✅ Riêng biệt, không phụ thuộc logout | ✅ Riêng biệt | **Rủi ro cao** — xem Mâu thuẫn #2 |
| Tính phút đi muộn (BR-39) | ✅ Tự động tính dựa trên giờ ca vs giờ login | ✅ Tương tự | ✅ Tương tự | **Phù hợp** |

### 2.8 Tích hợp Delivery & Báo cáo (Section 3.11–3.12)

| Tính năng | Khoga Café | iPOS.vn | KiotViet | Đánh giá |
|:---|:---|:---|:---|:---|
| Tích hợp Grab/ShopeeFood | ⚠️ Chỉ lấy báo cáo cuối ngày (out-of-scope xử lý đơn) | ✅ Đồng bộ đơn thời gian thực + ẩn/hiện món | ✅ Đồng bộ thời gian thực | **Phù hợp scope** — giảm phức tạp |
| Retry Policy (3.11.2) | ✅ Timeout 15s, retry 3 lần mỗi giờ | ✅ Tương tự | ✅ Tương tự | **Phù hợp** |
| Dashboard HQ (UC-28) | ✅ Tổng hợp doanh thu đa chi nhánh, so sánh branch, best sellers | ✅ Chuyên sâu hơn (heatmaps, trends) | ✅ Đơn giản hơn | **Phù hợp** với quy mô 5 chi nhánh |
| Export (UC-29) | ✅ Excel/PDF/CSV | ✅ Tương tự | ✅ Tương tự | **Phù hợp** |

---

## 3. Kiểm Toán Mâu Thuẫn Nội Bộ Trong Tài Liệu

Qua quá trình rà soát chéo giữa các phần của SRS, tôi phát hiện **5 mâu thuẫn** cần giải quyết trước khi bắt đầu lập trình:

### 🔴 Mâu thuẫn 1 (Nghiêm trọng): Quy trình hủy đơn — có cần mã PIN Quản lý hay không?

| Nguồn | Nội dung |
|:---|:---|
| [index.html dòng 349](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/index.html#L349) | *"hủy đơn → nhập mã PIN xác thực của quản lý là **1234** (theo BR-51)"* |
| [BR-51 dòng 5430](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/srs_document_full.md#L5430) | *"**No manager PIN or override code verification is required.**"* |
| [UC-55 AT1 dòng 3811](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/srs_document_full.md#L3811) | *"Manager... taps 'Approve Cancellation' (**no PIN entry needed**, authentication checked by manager account role)"* |
| [Mockup cancel_override.html](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/cashier_pos_mockups/cancel_override.html) | Giao diện có ô nhập mã PIN quản lý |

**Phân tích**: 3 nguồn khác nhau nói 3 điều khác nhau. Tài liệu hướng dẫn demo (`index.html`) yêu cầu PIN `1234`, đặc tả nghiệp vụ (BR-51 + UC-55 AT1) nói không cần PIN, nhưng mockup HTML (`cancel_override.html`) lại có giao diện nhập PIN. Đây là xung đột nghiêm trọng nhất vì ảnh hưởng trực tiếp đến luồng xử lý kiểm soát gian lận tài chính.

### 🔴 Mâu thuẫn 2 (Nghiêm trọng): Chấm công Barista gắn liền với Logout

| Nguồn | Nội dung |
|:---|:---|
| [BR-53 dòng 5432](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/srs_document_full.md#L5432) | *"For non-cashier roles... a check-out record is recorded upon system logout."* |
| Thực tế vận hành quán cà phê | Máy tính bảng Barista là thiết bị **dùng chung** tại quầy pha chế, chạy liên tục suốt ngày |

**Phân tích**: Nếu Barista A hết ca và logout để chấm công ra về, màn hình Barista Queue sẽ bị thoát. Barista B vào ca phải đăng nhập lại → mất thời gian + mất hiển thị hàng đợi đang chế biến dở. Trong thực tế iPOS và KiotViet, chấm công là hành động riêng biệt, không gắn với phiên đăng nhập của thiết bị.

### 🟡 Mâu thuẫn 3 (Trung bình): Bảng `order_cancellations` không nằm trong ERD

| Nguồn | Nội dung |
|:---|:---|
| [ERD dòng 868–893](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/srs_document_full.md#L868-L893) | Không có entity `order_cancellations` |
| [Section 3.7.6 dòng 3829–3841](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/srs_document_full.md#L3829-L3841) | Định nghĩa đầy đủ bảng `order_cancellations` với schema SQL |
| [Entities Description dòng 897–916](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/srs_document_full.md#L897-L916) | Liệt kê 16 entities, không bao gồm `order_cancellations` |

**Phân tích**: Bảng `order_cancellations` được định nghĩa chi tiết trong mục 3.7.6 nhưng không xuất hiện trong sơ đồ ERD (mục 3.1.5) và danh sách Entities Description (mục 3.1.6). Điều này sẽ gây nhầm lẫn cho thành viên phụ trách thiết kế cơ sở dữ liệu.

### 🟡 Mâu thuẫn 4 (Trung bình): Tiêu đề Use Case trùng lặp cho Delete Category

| Nguồn | Nội dung |
|:---|:---|
| [Section 3.4.4 dòng 2550](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/srs_document_full.md#L2550) | Tiêu đề: *"F22 - Delete Category / **UC-17 Update Category**"* |
| [Section 3.4.4 nội dung dòng 2572](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/srs_document_full.md#L2572) | Nội dung bên trong: *"Use Case ID: **UC-70**, Use Case Name: **Delete Category**"* |

**Phân tích**: Tiêu đề mục ghi nhầm Use Case ID là UC-17 (vốn thuộc Update Category), nhưng nội dung bên trong lại đúng là UC-70 Delete Category. Lỗi copy/paste nhỏ nhưng gây nhầm lẫn khi tra cứu.

### 🟡 Mâu thuẫn 5 (Trung bình): Cashier vừa có quyền vừa không có quyền xem Customer List

| Nguồn | Nội dung |
|:---|:---|
| [Screen Authorization dòng 819](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/srs_document_full.md#L819) | Screen 22 (Customer List): Cashier = **Yes** |
| [Feature-Actor Mapping dòng 5503](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/srs_document_full.md#L5503) | Customer Loyalty Registry: Cashier = **C / R / U** (có quyền) |
| [UC-24 Actor dòng 3890](file:///c:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/srs_document_full.md#L3890) | Actors: **Cashier, Store Manager, Admin** |

**Phân tích**: Ba nguồn đều đồng ý Cashier có quyền xem/thêm/sửa Customer. Tuy nhiên, trong **UC Diagram 2.2.2 (Admin Use Cases)** dòng 351–354, các Use Case View/Add/Update Customer chỉ nằm trong subgraph "HQ Administration" và chỉ kết nối với Actor Admin. Sơ đồ Use Case **thiếu kết nối** Cashier/Store Manager đến các Customer Use Cases.

---

## 4. Phân Tích Lỗ Hổng Thiết Kế (Gap Analysis)

### 🔴 Gap 1: Không hỗ trợ Size/Biến thể sản phẩm (Size Variants)

**Vấn đề**: Trong thực tế quán cà phê, gần như 100% đồ uống đều có biến thể kích cỡ (S/M/L) với giá khác nhau. SRS hiện tại không có khái niệm "Size" hay "Variant" trong bảng `menu_items`. Mỗi kích cỡ phải được tạo thành một `menu_item` riêng biệt (ví dụ: "Espresso S", "Espresso M", "Espresso L"), dẫn đến:
- Danh sách menu phình to gấp 2-3 lần
- Khó quản lý giá/recipe khi cùng 1 món
- POS Checkout Grid hiển thị quá nhiều mục

**So sánh**:
- **iPOS.vn**: Có entity `product_variants` liên kết với `menu_items`, mỗi variant có giá và recipe riêng
- **KiotViet**: Có "Biến thể sản phẩm" (Attribute + Value = Variant)

**Mức ảnh hưởng**: Cao — ảnh hưởng đến Schema, POS UI, và Recipe Management

### 🟡 Gap 2: Không hỗ trợ Modifier Groups (Nhóm tùy chọn bắt buộc)

**Vấn đề**: SRS có `option_toppings` nhưng thiếu khái niệm **Modifier Group** (nhóm tùy chọn). Trong thực tế, khi gọi một ly cà phê, khách hàng **bắt buộc** phải chọn:
- Mức đá (Đá, Ít đá, Không đá) — chỉ được chọn 1
- Mức đường (100%, 70%, 50%, 0%) — chỉ được chọn 1
- Topping thêm (Trân châu, Thạch, Kem phô mai...) — chọn nhiều, phụ thu giá

Hiện tại `option_toppings` không phân biệt được nhóm bắt buộc vs tùy chọn, cũng không giới hạn số lượng chọn tối đa/tối thiểu trong mỗi nhóm.

**So sánh**:
- **iPOS.vn**: Modifier Groups với thuộc tính `is_required`, `min_select`, `max_select`
- **KiotViet**: Nhóm thuộc tính đơn giản hơn

**Mức ảnh hưởng**: Trung bình — có thể workaround bằng cách tạo nhiều toppings, nhưng không tối ưu

### 🟡 Gap 3: Không hỗ trợ định lượng bán thành phẩm (Semi-Finished Products)

**Vấn đề**: Quán cà phê thường chế biến trước các nguyên liệu bán thành phẩm, ví dụ:
- Pha 1 nồi syrup vanilla (sử dụng: 500g đường + 1L nước + 50ml vanilla extract) → được 1.5L syrup
- Mỗi ly Vanilla Latte cần 30ml syrup vanilla (chứ không trực tiếp cần đường + nước + vanilla)

SRS hiện tại chỉ hỗ trợ liên kết 1 tầng: `menu_item → recipe_item → stock_item`. Không có khái niệm bán thành phẩm (semi-finished) làm lớp trung gian.

**So sánh**:
- **iPOS.vn (iPOS Inventory)**: Hỗ trợ công thức đa tầng (recipe chaining)
- **KiotViet**: Không hỗ trợ (1-1 giống Khoga Café)

**Mức ảnh hưởng**: Thấp — chỉ ảnh hưởng chính xác chi phí nguyên liệu (COGS), workaround bằng cách coi syrup là stock_item riêng nhập thủ công

### 🟡 Gap 4: Nhập kho chỉ từng mặt hàng một (không có Batch Import)

**Vấn đề**: UC-32 Import Stock chỉ cho phép nhập 1 mặt hàng mỗi lần submit. Trong thực tế, khi nhà cung cấp giao hàng, Store Manager cần nhập cùng lúc 10-20 mặt hàng trên một phiếu nhập kho duy nhất.

**So sánh**: Cả iPOS và KiotViet đều hỗ trợ phiếu nhập kho đa dòng (multi-line import form).

**Mức ảnh hưởng**: Trung bình — ảnh hưởng trải nghiệm người dùng, không ảnh hưởng logic nghiệp vụ

### 🟢 Gap 5: Thiếu trạng thái READY → COMPLETED transition trigger rõ ràng cho DINE_IN

**Vấn đề**: State Machine ghi *"Cashier: handover/pickup"* chuyển READY → COMPLETED. Nhưng trong luồng bán hàng POS, không có Use Case nào mô tả rõ **Cashier bấm nút nào** để xác nhận đơn đã giao cho khách. UC-55 là Cancel, UC-52 là Issue Invoice (chạy ngay sau thanh toán). Luồng từ READY → COMPLETED bị "treo" không có giao diện cụ thể.

**Mức ảnh hưởng**: Thấp — có thể bổ sung nút "Complete" trên màn hình Order Detail hoặc Barista Queue

---

## 5. Đánh Giá Database Schema

### 5.1 Những điểm thiết kế tốt
- ✅ Sử dụng UUID làm Primary Key — phù hợp hệ thống phân tán
- ✅ Soft-delete cho menu_items (field `is_deleted`) — bảo toàn lịch sử bán hàng
- ✅ Tách riêng `order_item_toppings` — thiết kế chuẩn hóa tốt
- ✅ `recipe_items` liên kết cả menu_item và option_topping — cho phép toppings cũng tiêu hao nguyên liệu
- ✅ `stock_items` scoped theo `store_id` — hỗ trợ đa chi nhánh

### 5.2 Những điểm cần cải thiện

| Vấn đề | Chi tiết | Khuyến nghị |
|:---|:---|:---|
| Thiếu bảng `order_cancellations` trong ERD | Bảng được định nghĩa ở Section 3.7.6 nhưng không có trong ERD 3.1.5 | Bổ sung vào ERD và Entities Description |
| `ORDER.payment_method` là Enum đơn giá trị | Không hỗ trợ thanh toán tách (split payment) — ví dụ khách trả 50% tiền mặt + 50% VietQR | Nếu cần split payment, cần tách thành bảng `order_payments` riêng |
| Thiếu bảng `audit_logs` chung | BR-51 và Section 5.2.1 yêu cầu audit logging, nhưng không có entity `audit_logs` trong schema | Bổ sung bảng `audit_logs` vào ERD hoặc ghi chú rõ dùng logging framework bên ngoài |
| `CUSTOMER.phone` max_length khác nhau | Entity schema: VARCHAR(20). UC-25 AT2: validate 10-11 digits. UC-42 Hotline: validate 10-12 digits | Thống nhất quy tắc validate số điện thoại |
| `VOUCHER` thiếu field `max_discount_amount` | Voucher PERCENTAGE (ví dụ 20%) trên đơn 1 triệu VND sẽ giảm 200k. Trong thực tế, voucher thường có cap "Giảm tối đa 50k" | Bổ sung field `max_discount_amount` DECIMAL(12,2) nullable |

---

## 6. Đánh Giá Yêu Cầu Phi Chức Năng (NFR)

| NFR | Đặc tả Khoga Café | Đánh giá so với thực tế |
|:---|:---|:---|
| Uptime 99.9% | Cam kết rõ ràng | **Tham vọng** — 99.9% = tối đa 8.76 giờ downtime/năm, đòi hỏi kiến trúc HA (High Availability) |
| POS Checkout < 100ms | Response time thêm món vào giỏ | **Khả thi** — thao tác cục bộ, không cần gọi API |
| Process Payment < 1.5s | Khởi tạo QR hoặc ghi nhận tiền mặt | **Khả thi** cho tiền mặt; QR phụ thuộc payment gateway |
| RPO 1 giờ / RTO 4 giờ | Backup mỗi 60 phút, phục hồi 4 giờ | **Hợp lý** cho quy mô 5 chi nhánh |
| 100 TPS throughput | Backend API toàn cục | **Vượt mức cần thiết** — 5 chi nhánh × 20 đơn/giờ peak = ~0.03 TPS, 100 TPS là headroom rất lớn |
| MTBF POS 8000 giờ | ~333 ngày liên tục | **Tham vọng** nhưng hợp lý nếu dùng Flutter stable |
| Bug rate < 0.5/KLOC | Tiêu chuẩn chất lượng cao | **Khó đo lường** trong thực tế dự án nhóm 5 người |
| Flutter cross-platform | Android 9+, iOS 14+, Windows 10+ | **Phù hợp** với yêu cầu thiết bị POS đa nền tảng |

---

## 7. Ma Trận Đánh Giá Tổng Hợp

| Phân hệ | Độ hoàn thiện SRS | Tính khả thi triển khai | Phù hợp thực tế VN | Rủi ro mâu thuẫn | Đề xuất ưu tiên |
|:---|:---:|:---:|:---:|:---:|:---|
| Xác thực & Bảo mật (3.2) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 🟢 Thấp | Giữ nguyên |
| Menu & Category (3.3–3.4) | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | 🟡 TB | **Bổ sung Size Variants** |
| Kho hàng (3.5) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 🟢 Thấp | Bổ sung Batch Import |
| POS Bán hàng (3.6) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 🔴 Cao | **Sửa mâu thuẫn hủy đơn** |
| Đơn hàng & Pha chế (3.7) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 🟡 TB | Bổ sung trigger READY→COMPLETED |
| CRM Hội viên (3.8) | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 🟢 Thấp | Cấu hình mềm tỷ lệ quy đổi điểm |
| Nhân sự & Chấm công (3.9) | ⭐⭐⭐ | ⭐⭐ | ⭐⭐ | 🔴 Cao | **Thiết kế lại BR-53** |
| Voucher (3.10) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 🟢 Thấp | Bổ sung max_discount_amount |
| Delivery Integration (3.11) | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | 🟢 Thấp | Giữ nguyên (đúng scope) |
| Báo cáo (3.12) | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 🟢 Thấp | Giữ nguyên |
| Cấu hình hệ thống (3.13) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 🟢 Thấp | Giới hạn chi nhánh → cấu hình mềm |

---

## 8. Khuyến Nghị Điều Chỉnh Use Case & Scope (Ưu tiên hóa)

### 🔴 Ưu tiên 1 — BẮT BUỘC SỬA: Thống nhất quy trình hủy đơn hàng

**Vấn đề**: Mâu thuẫn #1 — ba nguồn dữ liệu mâu thuẫn nhau về yêu cầu mã PIN khi hủy đơn.

**Khuyến nghị**: Áp dụng mô hình **2 tầng xác thực phân quyền** (giống iPOS.vn):

```
- Đơn PENDING → Cashier tự hủy trực tiếp, KHÔNG cần mã PIN
                  (vì chưa thanh toán hoặc chưa vào bếp)

- Đơn PREPARING/HOLD/READY → Bắt buộc nhập mã PIN 4 chữ số
                              của Store Manager hoặc Admin
                              (vì liên quan đến tiền đã thu và nguyên liệu đã tiêu hao)
```

**Cách sửa cụ thể**:
1. Sửa **BR-51**: *"Cancellation of orders in PREPARING, HOLD, or READY states requires verification by entering the Store Manager's or Admin's 4-digit security PIN."*
2. Bổ sung field `security_pin` VARCHAR(4) vào bảng `USER` (chỉ áp dụng cho role STORE_MANAGER và ADMIN)
3. Giữ nguyên mockup `cancel_override.html` với form nhập PIN
4. Sửa mô tả trong `index.html` cho thống nhất

---

### 🔴 Ưu tiên 2 — BẮT BUỘC SỬA: Thiết kế lại cơ chế chấm công

**Vấn đề**: Mâu thuẫn #2 — BR-53 yêu cầu Barista logout để chấm công, gây gián đoạn thiết bị dùng chung.

**Khuyến nghị**: Tách hoàn toàn chấm công khỏi phiên đăng nhập thiết bị:

```
TRƯỚC (hiện tại):
  Check-in = Login vào terminal
  Check-out (Barista) = Logout hệ thống → MẤT màn hình bếp

SAU (đề xuất):
  Check-in = Nhân viên bấm nút "Chấm công vào" trên màn hình chung
             → Nhập mã PIN cá nhân 4 số để xác thực
             → KHÔNG cần đăng nhập/đăng xuất tài khoản chính

  Check-out = Nhân viên bấm nút "Chấm công ra" trên màn hình chung
              → Nhập mã PIN cá nhân 4 số
              → KHÔNG ảnh hưởng phiên đăng nhập của máy
```

**Cách sửa cụ thể**:
1. Sửa **BR-38** và **BR-53**: Chấm công qua mã PIN cá nhân, không qua login/logout
2. Bổ sung field `attendance_pin` VARCHAR(4) vào bảng `USER`
3. Thêm UC mới: **UC-74 Quick Attendance Check-in/out** — một modal/popup nhỏ trên mọi màn hình POS/Barista
4. Loại bỏ dependency: *"For non-cashier roles, check-out is recorded upon system logout"*

---

### 🟡 Ưu tiên 3 — NÊN SỬA: Bổ sung Size/Variant cho Menu Items

**Khuyến nghị ngắn gọn**: Thêm entity `menu_item_variants` với các field: `id`, `menu_item_id` (FK), `size_label` (S/M/L/XL), `price`, `is_default`. Mỗi variant liên kết riêng với `recipe_items` để định lượng nguyên liệu chính xác theo kích cỡ.

**Nếu không muốn thay đổi schema lớn**: Ghi chú rõ trong SRS rằng mỗi size sẽ được tạo thành `menu_item` riêng biệt (workaround), và Admin đặt tên theo quy ước `[Tên món] - [Size]`.

---

### 🟡 Ưu tiên 4 — NÊN SỬA: Bổ sung `max_discount_amount` cho Voucher

**Khuyến nghị**: Thêm field `max_discount_amount` DECIMAL(12,2) nullable vào bảng `VOUCHER`. Khi `discount_type = PERCENTAGE`, giá trị giảm giá sẽ bị cap tại `max_discount_amount` nếu field này != null.

Ví dụ: Voucher "Giảm 20%, tối đa 50.000 VND" → đơn 1 triệu VND chỉ giảm 50k thay vì 200k.

---

### 🟡 Ưu tiên 5 — NÊN SỬA: Đồng bộ ERD với toàn bộ entities thực tế

Bổ sung vào ERD (Section 3.1.5) và Entities Description (Section 3.1.6):
- Bảng `order_cancellations` (đã có schema SQL ở Section 3.7.6)
- Bảng `audit_logs` (nếu triển khai theo yêu cầu Section 5.2.1)

---

### 🟢 Ưu tiên 6 — CÂN NHẮC: Chuyển giới hạn 5 chi nhánh thành cấu hình mềm

Thay vì hardcode giới hạn 5 chi nhánh trong logic nghiệp vụ (BR-54), chuyển thành một System Parameter `MAX_ACTIVE_BRANCHES` trong bảng cấu hình trung tâm, cho phép HQ Admin điều chỉnh khi cần mở rộng.

---

### 🟢 Ưu tiên 7 — CÂN NHẮC: Bổ sung Batch Import cho nghiệp vụ Nhập kho

Thay đổi UC-32 để cho phép nhập nhiều mặt hàng trên cùng 1 phiếu nhập kho (multi-line form), giống cách iPOS và KiotViet đang hoạt động. Điều này giảm đáng kể thời gian thao tác cho Store Manager khi nhận hàng từ nhà cung cấp.

---

> **Kết luận chung**: Dự án Khoga Café có thiết kế SRS **rất chất lượng và chi tiết** so với mặt bằng chung của các dự án phần mềm học thuật. Tuy nhiên, cần giải quyết **2 mâu thuẫn nghiêm trọng** (hủy đơn & chấm công) trước khi bắt tay vào lập trình, và cân nhắc bổ sung **Size Variants** để phản ánh đúng thực tế vận hành quán cà phê tại Việt Nam.
