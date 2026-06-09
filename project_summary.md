# Khoga Café — Bản Tổng hợp Dự án (Team Review)

> Tài liệu này tổng hợp hiện trạng dự án **đặc tả hệ thống quản lý chuỗi cà phê tự phục vụ Khoga Café** để cả team cùng đánh giá, kèm phần nhận định **điểm nên giữ** và **điểm cần thay đổi/cải thiện** xét theo mô hình kinh doanh và cấu trúc tổ chức.
>
> _Cập nhật: 2026-06-09. Nguồn authoritative: `srs_document_full.md` (compile từ `sections/`), `system_architecture_and_operations.md`, `CLAUDE.md`._

---

## 1. Dự án là gì

- **Bản chất:** Repo **tài liệu đặc tả (SRS) + mockup UI**, không phải ứng dụng chạy được. Sản phẩm bàn giao: tài liệu SRS theo module, sơ đồ Mermaid, và mockup HTML tĩnh.
- **Đối tượng hệ thống:** Chuỗi cà phê **tự phục vụ** (self-service), quản lý phân cấp Tổng công ty (HQ) → Chi nhánh (Branch).
- **Quy mô tài liệu:** 17 section SRS · ~70 use case (UC-XX) · ~62 business rule (BR-XX) · ~73 mockup HTML trên 5 phân hệ.

### Năm phân hệ ứng dụng
| Phân hệ | Thiết bị | Vai trò chính |
|---|---|---|
| HQ Admin Portal (`admin_hq_mockups/`) | Web desktop | `ceoviewer`, `businessadmin`, `ssadmin` (dùng chung portal) |
| Store Manager Web (`store_manager_mockups/`) | Web | `storemanager` |
| Cashier POS (`cashier_pos_mockups/`) | Cảm ứng | `cashier` |
| Barista KDS (`barista_monitor_mockups/`) | Tablet ngang | `barista` |
| Mobile Auth (`mobile_auth_mockups/`) | Mobile | tất cả (đăng nhập/hồ sơ) |

---

## 2. Trạng thái hiện tại

### ✅ Đã hoàn tất
- **Migration RBAC 4 vai trò → 6 vai trò** trên **toàn bộ section SRS**: tách "HQ Admin" thành `ceoviewer` / `businessadmin` / `ssadmin`; remap toàn bộ trường Actor, business rule, bảng phân quyền.
- **§3.2.0** bảng RBAC authoritative 6 vai trò; **§3.1** bảng phân quyền 49 màn hình × 6 cột; **§5.4** Feature-Actor Matrix 6 cột.
- Các quyết định nghiệp vụ đã chốt: bỏ hạng thành viên loyalty, hủy đơn không cần PIN (chỉ PENDING), menu 2 cấp (`is_active` chain-wide vs `branch_menu_status` branch-level), KDS 1-chạm.
- `srs_document_full.md` đã recompile mới nhất.

### ⬜ Còn lại (khoảng trống đã biết)
- **Audit mockup HTML** chưa thực hiện — chưa kiểm nhãn vai trò/portal so với mô hình 6 vai trò. **Đây là rủi ro lớn nhất còn lại.**
- 3 file index/kế hoạch (`mockup_mapping.md`, `feature_function_matrix.md`, `group_division_plan.md`) đang ở trạng thái **deleted** (git) nhưng CLAUDE.md vẫn tham chiếu → cần khôi phục hoặc bỏ tham chiếu.

---

## 3. Cấu trúc tổ chức ↔ Vai trò hệ thống

| Cấu trúc tổ chức (org doc) | Vai trò RBAC | Phạm vi |
|---|---|---|
| Ban Giám đốc / Chủ chuỗi | `ceoviewer` | HQ — chỉ đọc báo cáo tổng hợp |
| Bộ phận Vận hành & Cung ứng **+** Marketing & CRM | `businessadmin` | HQ — menu/recipe/voucher/CRM |
| Bộ phận IT / Hệ thống | `ssadmin` | HQ — config, VietQR/OTP, user, branch |
| Quản lý cửa hàng | `storemanager` | Branch — kho, ca, lịch, đối soát |
| Thu ngân | `cashier` | Branch — POS, mở/đóng ca |
| Pha chế | `barista` | Branch — KDS |

---

## 4. Đánh giá độ phù hợp với mô hình kinh doanh & tổ chức

### 4.1 Điểm NÊN GIỮ (đang khớp tốt)

1. **6-role RBAC ánh xạ sát cấu trúc tổ chức 3 phòng HQ + 3 vai trò branch.** Tách bạch quyền giúp separation of duties: IT cấu hình nhưng không đụng giá menu; Ban Giám đốc xem nhưng không sửa.
2. **Trừ kho tự động theo công thức (recipe-based auto-deduction)** — giải quyết bài toán thất thoát NVL, "đau đầu" lớn nhất của ngành F&B. Đây là giá trị cốt lõi của hệ thống.
3. **Đối soát ca & két tiền tự động** với ngưỡng cảnh báo 100.000 VND — kiểm soát tài chính từ xa, chống gian lận tiền mặt tại branch.
4. **KDS START PREP / READY + tem dán ly tự động + buzzer** — tối ưu tốc độ phục vụ giờ cao điểm, đúng tinh thần mô hình tự phục vụ.
5. **Menu 2 cấp** (`is_active` toàn chuỗi do HQ + `branch_menu_status` do branch) — vừa chuẩn hóa danh mục toàn chuỗi vừa cho branch chủ động tắt món khi hết NVL. Rất đúng nhu cầu chuỗi.
6. **VietQR động auto-confirm < 1.5s** — bỏ bước thu ngân chụp màn hình chuyển khoản, giảm sai sót & gian lận.
7. **Tách User Session khỏi Shift Session (BR-60)** — cho phép đổi ca/đổi người mà không đóng ca, hợp với vận hành quầy nhiều nhân viên.
8. **Loyalty bỏ hạng thành viên** — đơn giản hóa, giảm phức tạp không cần thiết cho mô hình chuỗi nhỏ.

### 4.2 Quyết định đã chốt (product owner) & hành động

> Các điểm dưới đây đã được product owner quyết và phản ánh vào tài liệu trong đợt cập nhật 2026-06-09.

**✅ P1 — Không có Kho tổng. `businessadmin` sở hữu danh mục nguyên liệu master.**
Quyết định: hệ thống **không** có kho tổng nhập từ bên thứ 3 ở cấp HQ. Bộ phận Cung ứng (`businessadmin`) **khai báo danh mục nguyên liệu dùng chung toàn chuỗi** (master list: tên, đơn vị, hạn mức gợi ý) — là nguồn cho công thức món và dropdown nhập/xuất kho. Chi nhánh nhập **trực tiếp từ NCC** (UC-32) và tự quản số lượng. _Đã làm:_ cập nhật org doc; tạo skeleton `admin_hq_mockups/materials_web.html`; **thêm UC-74 "Manage Raw Material Master" vào §3.5.0** + cross-ref ở §3.3; thêm **màn hình 50** vào bảng phân quyền §3.1 (owner `businessadmin`); đăng ký **BR-63/BR-64** và một dòng trong ma trận §5.4.

**✅ P2 — Tách portal HQ thành 3 dashboard theo vai trò (skeleton).**
_Đã làm (chỉ tạo file, chưa code logic):_ `dashboard_ceoviewer_web.html` (chỉ Báo cáo), `dashboard_businessadmin_web.html` (Thực đơn / Nguyên liệu / Voucher / CRM), `dashboard_ssadmin_web.html` (Nhân sự / Chi nhánh / Cấu hình) — mỗi dashboard chỉ hiện nav đúng vai trò theo §3.1. _Còn lại:_ điều hướng login → đúng dashboard; gỡ/deprecate `dashboard_web.html` gộp cũ; rà soát các màn module còn lại.

**✅ P3 — GIỮ một role `businessadmin` duy nhất.**
Quyết định: gộp Ops & Supply + Marketing & CRM trong một role. Chấp nhận đánh đổi (người Marketing có thể sửa giá menu); việc phân tách xử lý ở cấp tổ chức/quy trình, không bằng RBAC. _Không thay đổi hệ thống._

**✅ P4 — Xóa số cứng "5", chỉ tham chiếu `MAX_ACTIVE_BRANCHES`.**
_Đã làm:_ sửa UC-64 (precondition, AT1 trigger, message MSG16) trong `03_13` — bỏ "(5)", dùng tham số.

**✅ P5 — 1 Store Manager phụ trách 1 quán. (Đánh giá: phù hợp.)**
Mô hình 1-1 khớp data model hiện tại (`USER.store_id` là FK đơn) và quy mô chuỗi hiện tại; **không cần** tầng Regional/Area Manager lúc này — HQ giám sát mọi chi nhánh qua báo cáo tổng hợp (`ceoviewer`). Lưu ý vận hành: (a) nếu một người thực tế quản 2 quán → cấp 2 tài khoản; (b) khi SM vắng, `ssadmin` đổi phân công tạm thời; (c) cân nhắc lại tầng vùng khi số branch vượt khả năng giám sát trực tiếp của HQ. _Kết luận: giữ mô hình 1-1, gỡ khuyến nghị "Regional Manager"._

**✅ P6 — Giải pháp cho 2 edge case (đã codify):**
- **Refund vs ca (BR-09 cập nhật):** hoàn tiền mặt ghi vào **ca đang mở tại terminal lúc hoàn** (két thực chi), giảm expected cash của ca đó, **bất kể đơn gốc thuộc ca nào**; nếu không có ca mở thì hoãn tới khi mở ca; card/VietQR hoàn qua gateway, không đụng két nên độc lập với ca.
- **Chấm công cross-branch (thêm BR-53a):** mỗi log lưu cả `employee_id` + `store_id` của terminal nơi chấm. **Lương/tổng giờ** tính theo `employee_id` (cộng mọi chi nhánh); **chi phí nhân công chi nhánh** tính theo `store_id` terminal (nơi thực sự làm việc).

**🟢 P7 — (còn mở) Vệ sinh tài liệu.** Khôi phục `mockup_mapping.md` (cần cho audit và để map 3 dashboard mới + `materials_web.html`); xử lý 2 file kế hoạch đã xóa.

---

## 5. Khuyến nghị bước tiếp theo

1. ~~Downstream của P1: thêm UC Nguyên liệu Master.~~ ✅ Đã làm (UC-74 / §3.5.0, màn hình 50 §3.1, BR-63/64, §5.4). _Còn lại (tùy chọn):_ bổ sung UC-74 vào danh sách use case tổng ở §2.3 và `00_record_of_changes.md`; cân nhắc thêm thực thể `RAW_MATERIAL` vào ERD §3.1.
2. **Hoàn thiện P2:** khôi phục `mockup_mapping.md`, map 3 dashboard vai trò + `materials_web.html`; điều hướng login → đúng dashboard; rà soát các màn module còn lại theo §3.1.
3. **Dọn P7** và recompile SRS sau mỗi đợt sửa section.

---

## 6. Tóm tắt một dòng

> Lõi nghiệp vụ (trừ kho theo công thức, đối soát ca, KDS, menu 2 cấp, VietQR) **vững và khớp mô hình tự phục vụ**. Sau đợt 2026-06-09: đã chốt **không có kho tổng** (businessadmin sở hữu danh mục NVL master), **tách portal HQ thành 3 dashboard vai trò** (skeleton), **giữ 1 role businessadmin**, xóa số chi nhánh cứng, và giải quyết edge case refund/chấm công. Việc lớn còn lại: bổ sung UC Nguyên liệu Master và hoàn thiện tầng UI theo vai trò.
