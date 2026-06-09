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

### 4.2 Điểm CẦN THAY ĐỔI / CẢI THIỆN (ưu tiên giảm dần)

> Đây là các điểm cần team thảo luận & product owner quyết định.

**🔴 P1 — Thiếu phân hệ Kho tổng / Điều phối cung ứng (lệch giữa tổ chức và hệ thống).**
Org doc ghi Bộ phận Vận hành & Cung ứng "giám sát **tồn kho tổng** và **điều phối nguồn NVL cung ứng** cho các chi nhánh". Nhưng SRS §3.5 **chỉ có tồn kho cấp branch** (Store Manager), và đã **bỏ toàn bộ quyền xem kho của HQ**. ⇒ Không có module kho tổng / phiếu điều chuyển HQ→branch. **Quyết định cần ra:** (a) bổ sung module Kho tổng cho `businessadmin`, hoặc (b) thu hẹp mô tả vai trò Ops trong org doc cho khớp phạm vi hệ thống.

**🔴 P2 — Audit mockup chưa làm, portal HQ vẫn gộp.**
`admin_hq_mockups/` hiện là một portal "HQ Admin" chung. Cần xác minh từng màn hình **chỉ hiện module đúng vai trò**: `ceoviewer` không thấy CRUD menu/voucher/user; `businessadmin` không thấy user/config/branch; `ssadmin` không thấy báo cáo ngoài quyền. Nếu mockup không phản ánh, đặc tả và UI sẽ lệch nhau.

**🟠 P3 — `businessadmin` gộp 2 phòng khác nhau.**
Org doc tách rõ **Vận hành & Cung ứng** vs **Marketing & CRM**, nhưng hệ thống gộp cả hai vào một role `businessadmin`. ⇒ Một nhân viên Marketing có thể sửa **giá menu/công thức** (vi phạm separation of duties). **Đề xuất:** cân nhắc tách thành 2 role (catalog/recipe vs voucher/CRM) hoặc dùng permission con nếu hai phòng là hai người khác nhau.

**🟠 P4 — Số chi nhánh: tham số động vs số cứng "5".**
BR-54 nói số chi nhánh là động qua `MAX_ACTIVE_BRANCHES`, nhưng UC-64 (03_13) còn ghi precondition "less than the maximum capacity (**5**)". ⇒ Thống nhất một nguồn (xóa số cứng 5, chỉ tham chiếu tham số).

**🟡 P5 — Thiếu tầng quản lý Vùng/Khu vực (Regional/Area Manager).**
Mô hình hiện nhảy thẳng HQ → branch, không có vai trò trung gian giám sát vận hành nhiều branch. Với chuỗi mở rộng, cảnh báo lệch quỹ / sự cố branch không có ai ở tầng vùng tiếp nhận (hiện fallback về chính Store Manager). Cần cân nhắc khi scale.

**🟡 P6 — Edge case nghiệp vụ cần làm rõ:**
- **Refund vs ca:** hoàn tiền mặt trong 7 ngày (BR-09) lấy từ két ca nào nếu đã đóng ca/đổi người?
- **Chấm công cross-branch:** chấm công ghi theo `store_id` của terminal vật lý (BR-53/38) — cần đảm bảo báo cáo công/lương xử lý đúng khi nhân viên làm khác chi nhánh nhà.

**🟢 P7 — Vệ sinh tài liệu:** khôi phục/cập nhật `mockup_mapping.md` (cần cho bước audit mockup) và 2 file kế hoạch đã bị xóa, hoặc gỡ tham chiếu trong CLAUDE.md.

---

## 5. Khuyến nghị bước tiếp theo

1. **Chốt P1 (kho tổng) và P3 (tách businessadmin)** ở cấp product owner — đây là quyết định kiến trúc, ảnh hưởng cả SRS lẫn mockup.
2. **Audit toàn bộ mockup HTML** theo bảng §3.1 (49 màn hình × 6 vai trò); khôi phục `mockup_mapping.md` trước để đối chiếu.
3. **Dọn các điểm nhỏ:** số "5" cứng (P4), edge case refund/chấm công (P6).
4. **Recompile** SRS sau mỗi đợt sửa.

---

## 6. Tóm tắt một dòng

> Lõi nghiệp vụ (trừ kho theo công thức, đối soát ca, KDS, menu 2 cấp, VietQR) **vững và khớp mô hình tự phục vụ**. Khoảng trống chính: **(1)** thiếu phân hệ kho tổng/cung ứng mà org doc mô tả, **(2)** mockup chưa migrate sang 6 vai trò, **(3)** `businessadmin` đang gộp 2 phòng có xung đột quyền. Ba điểm này nên được team quyết trước khi đóng băng đặc tả.
