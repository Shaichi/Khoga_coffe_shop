> ## ✅ TRẠNG THÁI XỬ LÝ (cập nhật 2026-06-18)
> Đã sửa và recompile (`compile_rds.py`). Các nhóm P0/P1/P2 bên dưới **đã khắc phục trong RDS**:
> - **UC mapping**: sửa UC-51/53 (§3.7), UC-55 cancel (§3.8), UC-49 redeem (§3.5), UC-76/77 (§3.10); bỏ nhãn sai UC-66 (check-in)/UC-73 (auto-abandon). _(Xác minh: huỷ order PENDING = **UC-55** theo mô tả SRS "clicks Cancel Order".)_
> - **BR cite**: sửa BR-11/42/54/68/81/88 ở §3.1/3.2/3.4/3.7/3.10/3.11 + package diagram.
> - **Class ↔ schema**: bỏ thuộc tính không có trong DB (Customer.birthDate/isActive, StockItem.unit, Order.notes, StockTransaction before/after), thêm OrderRefund.shift_session_id, sửa kiểu pos_register_id → String.
> - **Enum/thuật ngữ**: PAID → COMPLETED; action_type → UPDATE; voucher state DRAFT → SCHEDULED; actor Reports về đúng ceoviewer/SM.
> - **Logic nghiệp vụ**: lockout 15-min tự mở (BR-11); READY→ABANDONED + SM force-close (BR-88); cash-refund trừ drawer + reverse loyalty (BR-09/08/67); deactivate branch kiểm tra order non-terminal + cascade (BR-55/56).
> - **`system_configs`**: theo quyết định product owner → **giữ 21 entity**, ghi chú rõ là bảng key-value tầng hạ tầng (Section 2 + §3.11).
>
> **Còn lại (mức SRS, CHƯA sửa — cần quyết định riêng):** một số gốc rễ nằm ở SRS, không chỉ RDS — ví dụ SRS không có UC tường minh cho "Cancel Order" / "Attendance Check-in", và SRS cũng không định nghĩa bảng config. RDS hiện đã nhất quán nội bộ + trỏ đúng BR/UC; nếu muốn "sạch" hai chiều thì nên đồng bộ ngược lại SRS. Báo nếu bạn muốn tôi làm tiếp phần SRS.

---

# Đánh giá RDS — `RDS_Khoga_CoffeeShop_v1.0.md`

> Review bởi vai trò Senior Engineer / Reviewer. Đối chiếu RDS v1.0 (15 section trong `rds_sections/`) với SRS (`srs_document_full.md`, `sections/`).
> Phạm vi đối chiếu: 21 entity, 83 use case (UC-01→UC-83, khuyết UC-43/56/67), 94 business rule (BR-01→BR-94), 6 role RBAC, 60 màn hình.
> Ngày: 2026-06-18.

---

## 1. Kết luận tổng quan

RDS **có chất lượng tốt về mặt cấu trúc và độ phủ**: bám đúng phương pháp COMET (EBC), kiến trúc 4-tier MVC (Spring Boot + Thymeleaf + Flutter + SQL Server) rõ ràng, class diagram / sequence diagram / statechart đầy đủ cho hầu hết 11 module. Database design (Section 2) **đồng bộ gần như tuyệt đối** với SRS §3.1 (21 bảng, đúng cột, đúng enum, đúng PK UUID).

**Tuy nhiên, RDS CHƯA thể coi là "rõ ràng – đầy đủ – đồng bộ hoàn toàn"** vì còn các nhóm sai sót sau, xếp theo mức độ:

| Mức | Nhóm vấn đề | Số lượng |
|-----|-------------|----------|
| 🔴 P0 (phải sửa) | Entity `SystemConfig` được dùng trong thiết kế nhưng KHÔNG có trong schema 21 bảng | 1 |
| 🔴 P0 | Ánh xạ số hiệu UC bị lệch so với SRS (đặt sai tên/số UC cho sequence) | ≥ 8 chỗ |
| 🟠 P1 | Trích dẫn BR sai số (cite nhầm rule) | ≥ 9 chỗ |
| 🟠 P1 | Thuộc tính trong class diagram không khớp / không tồn tại trong schema DB | ≥ 6 chỗ |
| 🟡 P2 | Logic nghiệp vụ trong sequence chưa phủ hết business rule (thiếu nhánh) | ≥ 5 chỗ |
| 🟡 P2 | Sai lệch thuật ngữ / enum / đặt tên | nhiều |

> Đánh giá ngắn gọn: **phần "khung" (architecture, DB, class) rất chắc; phần "nhãn" (số UC, số BR, tên enum, tên thuộc tính) bị làm ẩu và không soát lại chéo với SRS.** Đây là loại lỗi dễ bị giám khảo/CEO bắt vì chỉ cần tra bảng là thấy. Cần một vòng rà soát đối chiếu (traceability) trước khi nộp.

---

## 2. Điểm mạnh (giữ nguyên)

- **Section 2 Database Design**: 21 bảng khớp SRS §3.1.6 — đúng tên cột, kiểu dữ liệu, enum (`order_status` 7 trạng thái, `transaction_type` gồm `PHANTOM_USAGE`, `refund_type` REFUND/COMP_REMAKE…), PK UUID VARCHAR(36), composite PK `branch_menu_status`, ràng buộc XOR trên `recipe_items`. Rất tốt.
- **Quyết định "lateness không lưu, derive ở reporting layer"** (BR-39) được mô tả nhất quán giữa schema (`attendance_logs` có `scheduled_start`, bỏ `lateness_minutes`) và sequence 3.9.5. Đồng bộ tốt với quyết định RV-C02.
- **Ánh xạ COMET → Spring** (Section 1.1) rõ ràng, dùng được làm kim chỉ nam khi code.
- **RecipeDeductionService (3.6.4)** mô hình hóa đúng BR-89 (cho âm kho + ghi `PHANTOM_USAGE`, không block prep).
- **Negative-stock, PDPA photo purge (3.9.4), cross-branch + labour validation (3.9.2)** được thiết kế đúng tinh thần BR-89/BR-72/BR-90/BR-92.

---

## 3. 🔴 P0 — Lỗi nghiêm trọng (phải sửa trước khi nộp)

### 3.1. Entity `SystemConfig` được dùng khắp nơi nhưng KHÔNG nằm trong 21 bảng

- Section 1.1 và Section 2 khẳng định **"21 entities / 21 tables"**, và liệt kê đúng 21 bảng — **không có bảng cấu hình hệ thống nào**.
- Nhưng class diagram **3.7.1 (POS)** và **3.11.1 (Config)** đều khai báo entity `SystemConfig {configKey, configValue, scope, storeId, updatedBy, updatedAt}` («entity»), và sequence **3.11.2** đọc/ghi `SystemConfig (DB)` cho `MAX_ACTIVE_BRANCHES`, VAT, loyalty rate, VietQR credentials…
- → **Mâu thuẫn nội bộ trực tiếp**: các tham số trung tâm (UC-30, BR-45/46/54/74/94…) cần một bảng lưu trữ, nhưng schema không định nghĩa nó. Hoặc là thiếu bảng thứ 22 (`system_configs`), hoặc phải nói rõ nó lưu ở đâu (file/properties).

**Hành động:** Thêm `system_configs` vào ERD Section 2 (và cập nhật con số "21" → "22"), HOẶC ghi chú rõ cấu hình lưu ngoài DB. Khuyến nghị: thêm bảng, vì `updatedBy/updatedAt` + audit log (BR-46) ngụ ý lưu DB.

### 3.2. Ánh xạ số hiệu Use Case bị lệch so với SRS

Nhiều sequence được gán **sai số UC** so với danh mục UC chuẩn trong SRS §2.3. Đây là lỗi traceability nghiêm trọng (giám khảo tra bảng UC là thấy ngay):

| Vị trí RDS | Đang ghi | UC thật trong SRS | UC đúng phải là |
|-----------|----------|-------------------|-----------------|
| 3.7.4 | "UC-53 VietQR Payment Flow" | UC-53 = **Close Shift** | UC-51 (Process Payment) |
| 3.7.5 | "UC-55 Close Shift" | UC-55 = **Request Transaction Refund** | UC-53 (Close Shift) |
| 3.8 header + 3.8.2 | "UC-58 (Cancel PENDING Order)" | UC-58 = **Update Preparation Status** | (xem mục Câu hỏi §7 — SRS không có UC "Cancel Order" rõ ràng) |
| 3.8.4 | "UC-73 Auto-Abandon READY Orders" | UC-73 = **View Order Detail** | (đây là chức năng tự động theo BR-88, không phải UC-73) |
| 3.9 header + 3.9.3 | "UC-66 Attendance Check-in/out" | UC-66 = **View Branch Staff List** | (check-in là chức năng theo BR-38/53/93, không phải UC-66) |
| 3.10.3 | "UC-79 COGS & Margin Report" | UC-79 = **Labour Hours vs Revenue** | UC-76 (COGS/Margin) |
| 3.10.4 | "UC-82 Anomaly Detection" | UC-82 = Cashier Void/Refund Anomaly (gần đúng) | OK về nội dung, nhưng sai actor (xem §5) |
| 3.10.5 | "UC-76 Price Change History" | UC-76 = **COGS/Margin** | UC-77 (Price & Voucher Change History) |
| 3.5 header + 3.5.3 | "UC-27 Redeem Loyalty Points" | UC-27 = **View Customer History** | UC-49 (Redeem Loyalty Points) |

> Đặc biệt nguy hiểm: **3.10.3 và 3.10.5 hoán đổi UC-76 ↔ UC-79/UC-77** — COGS bị gán UC-79, Price History bị gán UC-76. Phải sửa lại đúng theo SRS.

---

## 4. 🟠 P1 — Trích dẫn Business Rule sai số

RDS cite nhầm số BR ở nhiều chỗ. Vì BR là "khế ước" giữa SRS và thiết kế, cite sai làm mất traceability:

| Vị trí RDS | Đang cite | Nội dung thực tế cần | BR đúng |
|-----------|-----------|----------------------|---------|
| 3.1.6 (USER statechart) | "LOCKED sau 5 lần sai (BR-15)" | Khoá tài khoản 5 lần sai | **BR-11** (BR-15 là "mật khẩu mới ≠ cũ") |
| Package #11 (`branch`) | "MAX_ACTIVE_BRANCHES (BR-35)" | Giới hạn số chi nhánh | **BR-54** (BR-35 là hết hạn điểm loyalty) |
| 3.11 header + 3.11.3 | "MAX_ACTIVE_BRANCHES (BR-35)" | nt | **BR-54** |
| 3.7.2 (Open Shift) | "một shift OPEN/register (BR-92)" | BR-92 là *labour budget* | Không có BR đúng → nên bỏ cite hoặc thêm rule |
| 3.7.6 (Shift statechart) | "auto-close 23:59 (BR-92)" | nt | **BR-88** (force close shift) gần nhất |
| 3.4.2 (Voucher) | "PERCENTAGE phải có cap (BR-66)" | Cap % giảm giá | **BR-42** (BR-66 là standard-cost COGS) |
| 3.4.2 (Voucher) | "mutation audit-logged (BR-81)" | Audit voucher | **BR-68** (BR-81 là audit user account) |
| 3.2.2 / 3.2.3 (User) | "audit log (BR-80)" | Audit thay đổi user | **BR-81** (BR-80 là audit discount checkout) |
| 3.11.2 (Config) | "audit-logged (BR-80)" | Audit config | Không có BR riêng → bỏ cite hoặc dùng BR-46 |
| 3.10.5 (Price History) | "BR-80/BR-81" | Audit đổi giá menu | **BR-68** |

---

## 5. 🟠 P1 — Class diagram không khớp / vượt ngoài schema DB (Section 2)

Các class diagram chứa thuộc tính **không tồn tại trong 21 bảng**, hoặc khác kiểu dữ liệu → khi code JPA `@Entity` sẽ lệch schema:

1. **`StockTransaction`** (3.6.1): có `quantityBefore / quantityChange / quantityAfter` (3 cột) — nhưng bảng `stock_transactions` chỉ có **một cột `quantity`**. Sequence 3.6.2/3.6.3 dựa vào snapshot before/after để audit, nhưng schema không lưu. → Hoặc thêm cột vào schema, hoặc bỏ khỏi class.
2. **`StockItem`** (3.6.1): có `unit: String` — nhưng `stock_items` không có cột `unit` (unit nằm ở `raw_materials`). → Bỏ hoặc đánh dấu derived.
3. **`Customer`** (3.5.1) + `AddCustomerForm`: có `birthDate: Date` và `isActive: Boolean` — bảng `customers` **không có** 2 cột này. → Thêm vào schema hoặc bỏ khỏi class/form.
4. **`Order`** (3.8.1): có `notes: String` và `totalAmount` — bảng `orders` không có `notes`; tên cột là `total` (+ `subtotal/discount/tax_amount`). Class bỏ qua `order_number`, `order_type`, `subtotal`, `discount`, `tax_amount`.
5. **`ShiftSession`** (3.7.1): `registerNumber: Integer` — nhưng DB `pos_register_id` là **string(50)**. Tên + kiểu đều lệch (`openedAt/closedAt/cashierId` vs `start_time/end_time/user_id`). Tương tự `StaffSchedule.posRegisterId: Integer` (3.9.1) vs DB `pos_register_id string`.
6. **`Voucher`** (3.4.1): tên thuộc tính lệch nhiều so với DB — `capAmount` vs `max_discount_amount`, `validFrom/validTo` vs `start_date/end_date`, `maxUsesTotal` vs `max_total_uses`, `maxUsesPerCustomer` vs `usage_limit_per_customer`, `currentUsesTotal` vs `total_usage_count`.

> Đây phần lớn là do class diagram dùng tên domain (camelCase) còn DB dùng snake_case — chấp nhận được **nếu** có bảng mapping. Nhưng các trường hợp 1–4 là **thuộc tính/cột thực sự thiếu hoặc thừa**, không phải chỉ đổi tên → phải đồng bộ.

---

## 6. 🟡 P2 — Logic nghiệp vụ chưa phủ hết Business Rule

1. **Deactivate Branch (3.11.3)** chỉ kiểm tra `OPEN shift sessions`. BR-55 còn yêu cầu **không có order ở trạng thái non-terminal** (PENDING/PREPARING/HOLD/READY), và BR-56 yêu cầu **cascade** (vô hiệu hoá nhân viên, xoá ca tương lai + thông báo). Sequence hiện thiếu hai phần này.
2. **VietQR (3.7.4)** chỉ mô hình "happy path". BR-84 (idempotency khi RETRY QR) và **BR-85 (callback đến trễ cho order đã huỷ → đẩy vào hàng đợi reconcile + refund, KHÔNG hồi sinh order)** không được thể hiện trong sequence. Đây là phần dễ sai nhất khi tích hợp thanh toán → nên có nhánh riêng.
3. **Refund/Comp (3.8.3)** tạo `OrderRefund` nhưng **không tác động tới ShiftSession/drawer** cho refund tiền mặt (BR-09/BR-67: cash refund trừ vào ca đang mở). Class `OrderRefund` ở 3.8.1 cũng **thiếu `shift_session_id`** (DB có cột này). Comp/remake tạo order mới nhưng không nói tới việc khử/không-tích điểm loyalty (BR-08).
4. **Account lockout (3.1.6)**: statechart cho `LOCKED → ACTIVE` chỉ qua `unlock()` thủ công của ssadmin. Nhưng **BR-11 là "treo 15 phút"** (tự mở sau 15 phút). Cần làm rõ: khoá vĩnh viễn-chờ-admin hay tự mở sau 15 phút? Hai cái mâu thuẫn.
5. **ORDER statechart (3.8.5)** thiếu transition **SM force-close READY → ABANDONED khi đóng ca** (BR-88 vế 2); chỉ có `timeTrigger 15min`. Ngoài ra dùng **hằng số cứng "15 min"** thay vì tham số `READY_ABANDON_TIMEOUT` (BR-88).

---

## 7. 🟡 P2 — Sai lệch thuật ngữ / enum / đặt tên

1. **`payment_status`**: sequence 3.7.3/3.7.4 dùng giá trị **`PAID`**, nhưng enum trong SRS/DB là **`COMPLETED`** (PENDING/COMPLETED/FAILED/REFUNDED/PARTIALLY_REFUNDED). Thống nhất 1 tên.
2. **`audit_logs.action_type`** chỉ có enum **CREATE/UPDATE/DELETE**. Nhưng sequence dùng `CONFIG_UPDATE` (3.11.2), `PRICE_UPDATE` (3.10.5), `CHECKOUT` (3.7.3) làm action — không thuộc enum. → Hoặc mở rộng enum, hoặc map về UPDATE + đặt loại ở `entity_affected`.
3. **VOUCHER statechart (3.4.3)** dùng `DRAFT / ACTIVE / EXHAUSTED / DEACTIVATED`. Nhưng SRS (BR-52) định nghĩa trạng thái voucher là **`SCHEDULED / ACTIVE / EXPIRED`** (computed). Tên trạng thái giữa SRS và RDS không khớp → nên thống nhất (ít nhất ánh xạ DRAFT≈SCHEDULED, và bổ sung/giải thích EXPIRED vs EXHAUSTED).
4. **Scheduler trùng lặp**: Section 1.1 nêu `OrderTimeoutTimer (15 min)`; Section 2 (package 16) nêu cả `OrderTimeoutScheduler (15-min READY→ABANDONED)` **và** `ReadyAbandonScheduler` — hai timer cho cùng một việc? Cần gộp/đặt tên nhất quán.
5. **Actor sai ở Reports**:
   - 3.10.2 (UC-28/29) ghi actor "ceoviewer **or businessadmin**" — SRS: HQ Business Reports (screen 23) là **ceoviewer only**.
   - 3.10.3 (COGS) ghi "businessadmin or storemanager" — SRS UC-76 actor = **ceoviewer** (+ storemanager qua screen 52), không phải businessadmin.
   - 3.10.4 (Anomaly) ghi "ssadmin or businessadmin" — SRS UC-82 actor = **Store Manager + CEO Viewer**.
6. **`LoyaltyPointCalculator.calculateEarned(orderTotal)`** (3.5.1) — cơ sở tích điểm phải là **Net Total Payable** (BR-69), không phải `orderTotal`. Nên đổi tham số cho đúng ngữ nghĩa.

---

## 8. ❓ Câu hỏi cần làm rõ (chưa đủ thông tin để kết luận đúng/sai)

1. **"Cancel Order" là UC nào?** SRS §2.3 không có UC tên "Cancel Order" tường minh (UC-54 = View Local Order History, UC-55 = Request Transaction Refund). RDS gán cho UC-58 (sai). Bạn dự định huỷ order PENDING là UC số mấy? Cần bổ sung vào SRS hoặc ánh xạ đúng.
2. **Bảng `system_configs`** (xem §3.1): bạn có chủ đích coi nó là entity thứ 22 không, hay cấu hình lưu ngoài DB? Quyết định này ảnh hưởng tới con số "21 tables" ở Section 1.1/Section 2.
3. **Khoá tài khoản (BR-11)**: 15 phút auto-unlock hay chờ ssadmin mở? RDS đang mô hình kiểu chờ admin — cần thống nhất với SRS.
4. **`StockTransaction` lưu before/after?** Class diagram cần (cho audit trail), schema không có. Bạn muốn theo class (thêm cột) hay theo schema (tính toán lại)?
5. **Độ phủ sequence**: một số UC trong phạm vi đã khai báo nhưng **không có sequence riêng** (UC-78 Loyalty Liability, UC-80 Worked-Hours Export, UC-81 Z-Report Archive, UC-83 Access Review). Có cần bổ sung, hay chấp nhận "cùng cấu trúc nên mô tả 1 lần"? Nếu chấp nhận, nên ghi chú rõ trong header để tránh hiểu nhầm là thiếu.

---

## 9. Checklist hành động đề xuất (ưu tiên giảm dần)

- [ ] **P0** — Quyết định & bổ sung entity `system_configs` (hoặc ghi rõ lưu ngoài DB); cập nhật con số entity.
- [ ] **P0** — Rà soát lại TOÀN BỘ số hiệu UC trong header & tiêu đề sequence theo bảng §3.2 (đặc biệt POS 3.7.4/3.7.5, Reports 3.10.3/3.10.5, Customer 3.5.3, Order 3.8.x, Staff 3.9.3).
- [ ] **P1** — Sửa 10 chỗ cite BR sai theo bảng §4.
- [ ] **P1** — Đồng bộ thuộc tính class ↔ cột DB theo §5 (thêm/bỏ `quantityBefore/After`, `StockItem.unit`, `Customer.birthDate/isActive`, `Order.notes`, kiểu `pos_register_id`, `OrderRefund.shift_session_id`).
- [ ] **P2** — Bổ sung nhánh nghiệp vụ còn thiếu (BR-55/56 deactivate branch, BR-85 VietQR late-callback, BR-09 cash-refund drawer, BR-88 SM force-close).
- [ ] **P2** — Thống nhất thuật ngữ enum (`PAID`→`COMPLETED`; action_type; trạng thái voucher) và actor ở Reports.
- [ ] Sau mỗi đợt sửa `rds_sections/*.md` → chạy lại `python compile_rds.py` và (nếu sửa sequence label) `python standardize_sequence_diagrams.py`.

---

*Ghi chú: Section 2 (Database) và phần kiến trúc COMET đã đạt; phần lớn lỗi nằm ở "nhãn dán" (số UC/BR, tên enum/thuộc tính) do chưa soát chéo với SRS. Khắc phục nhóm P0+P1 là đủ để RDS đạt mức "rõ ràng, đầy đủ, đồng bộ".*
