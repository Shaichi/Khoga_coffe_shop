# Khoga Café — SRS Review Findings (Backlog)

> Danh sách phát hiện từ đợt **CEO-review** (5 agent quét sâu toàn SRS, 2026-06-13/14).
> Đây là **backlog để duyệt**, KHÔNG phải thay đổi đã áp vào SRS. Mỗi mục cần product owner/team quyết trước khi sửa.
> Nguồn đối chiếu: `srs_document_full.md`, `system_architecture_and_operations.md`, `CLAUDE.md`, `project_design_rules` (memory).

## Quy ước
- **Ưu tiên:** `P0` = mâu thuẫn/lỗi/pháp lý phải sửa; `P1` = rủi ro tiền/gian lận/kẹt vận hành; `P2` = thiếu năng lực nên có; `P3` = nice-to-have/roadmap.
- **ID nhóm:** `RV-S` Gian lận & Bảo mật · `RV-O` Vận hành & Kho · `RV-F` Tài chính & Report · `RV-C` Tuân thủ, Con người & NFR.
- Cột **Refs** trỏ tới §/UC/BR liên quan trong SRS.

---

## ✅ Đã giải quyết trong v1.11–v1.12 (không cần raise lại)
Trừ kho thống nhất `PREPARING` (UC-62/BR-07); migration 6-role §3.2 (thân use case); BR-54/số "5" §3.13; dọn "kho tổng"/"hạng thành viên" org doc; **topping có recipe + trừ kho** (BR-65); **standard-cost COGS** (BR-66) + **UC-76** margin/shrinkage; **refund/comp sau PENDING** (UC-75/BR-67, gồm partial refund + phân biệt void/refund); **audit-log giá/voucher** (BR-68) + **UC-77**; dọn prose "Admin" + tier language §2.3; P-DEDUCT (chuỗi chỉ bán đồ pha chế → n/a); `RECIPE_ITEM`→`RAW_MATERIAL`; tầm nhìn COGS toàn chuỗi cho ceoviewer (UC-76).

### ✅ 15 P1 còn lại (vận hành/kho + tuân thủ/người/NFR) đã clear trong v1.15 (2026-06-14)
**Cụm VietQR/offline/đóng ca (RV-O):** O01 late-callback auto-flag hoàn (BR-85); O02 idempotency 1-settlement/order (BR-84); O03 state ABANDONED + force-close (BR-88); O04 KDS/in tem offline fallback (BR-87); O05 degraded **cash-only** (BR-86); O06 auto-confirm spec (BR-84); O16 negative-stock/phantom ledger (BR-89).
**Cụm tuân thủ/người/NFR (RV-C):** C04 cross-branch SM-nhà-gán + audit (BR-90); C05 hợp nhất BR-38; C06 derive Absence/OT/Early-Leave minimal (BR-91); C07 labour budget/max-hours/rest (BR-92); C08 PIN-unique + ảnh bắt buộc (BR-93); C16 capacity per-branch × MAX_ACTIVE_BRANCHES; C17 SLA loại trừ bảo trì; C19 offline mode đầy đủ (cash-only, client-UUID, reconcile).
**Quyết định chốt:** offline = cash-only (không offline-card); VietQR trễ = auto-refund không hồi sinh; nhân sự = minimal (không leave-request UC); cross-branch = SM nhà gán trực tiếp + audit.

### ✅ 5 RV-S P1 (gian lận & bảo mật) đã clear trong v1.14 (2026-06-14)
- **RV-S05** — MFA bắt buộc cho HQ roles (email OTP/TOTP), param `HQ_MFA_REQUIRED`, POS roles miễn (**BR-83**, UC-01 AT4 + màn 58).
- **RV-S04** — Bootstrap ssadmin đầu qua seed; cấm tự nâng quyền (đổi role/status phải do ssadmin khác) (**BR-82**, UC-12/14 AT3).
- **RV-S03** — SoD provisioning: audit mọi thay đổi tài khoản + **UC-83** Access Review report cho ceoviewer (**BR-81**) — nhất quán triết lý "audit thay maker-checker".
- **RV-S02** — Log mọi voucher/redeem tại checkout vào AUDIT_LOG (**BR-80**).
- **RV-S01** — **UC-82** Cashier Void/Refund Anomaly report + flag ngưỡng `CANCEL_REFUND_ALERT_THRESHOLD` (**BR-79**); giữ no-PIN PENDING + refund SM-auth.

### ✅ 6 RV-F P1 (cụm tài chính/report) đã clear trong v1.13 (2026-06-14)
- **RV-F03** — Quy đổi điểm→VND: param `LOYALTY_REDEMPTION_VALUE_PER_POINT` (100 VND/đ), bội số 100, floor VND (**BR-74**).
- **RV-F04** — Stack điểm+voucher: đã được **BR-70 + BR-50** phủ (≤1 voucher, điểm sau voucher, cap tổng = Gross Subtotal) — thêm cross-ref ở §3.6.7.
- **RV-F05** — **UC-78** Loyalty Liability & Movement (ceoviewer), báo cáo theo **điểm** (không quy VND) (**BR-75**).
- **RV-F06** — **UC-79** Labour Hours vs Revenue (ceoviewer + SM), **phi tiền tệ** giữ đúng §1.2 (**BR-76**).
- **RV-F07** — **UC-80** Worked-Hours export (Store Manager, own branch), giờ công feed payroll ngoài (**BR-77**).
- **RV-F08** — **UC-81** Daily Z-report cấp cửa hàng (Store Manager) gộp mọi ca/ngày (**BR-78**).

### ✅ 6 P0 đã clear trong v1.12 (2026-06-14)
- **RV-C02** — Schema `attendance_logs` sửa: bỏ generated column lỗi, thêm cột thật `scheduled_start` snapshot tại check-in; lateness derive ở reporting layer (BR-38/39).
- **RV-C03** — Lateness pin về **branch-local time** (§5.2.2), hết lệch ±7h (BR-39).
- **RV-F01** — Cơ sở tích điểm "Net Total Payable" = số tiền thực thu (VAT-inclusive, sau voucher & sau redeem điểm) → **BR-69** (§3.6.7 step 6).
- **RV-F02** — Thứ tự stack Voucher→Điểm→VAT→accrual → **BR-70** (§3.6.7).
- **RV-C01** — PDPA/NĐ13: consent UC-25 (BR-71), retention PII 24 tháng + erasure on-request + purge ảnh 90 ngày (BR-72), §4.2.6.1.
- **RV-O17** — Recipe unit bắt buộc == master unit (hard validate, không quy đổi) → **BR-73** (UC-18 AT2).

---

## A. Gian lận & Bảo mật (RV-S)

| ID | Ưu tiên | Phát hiện | Vì sao quan trọng | Hướng fix | Refs |
|---|:---:|---|---|---|---|
| RV-S01 | ✅ | Hủy/hoàn đơn PENDING không PIN & không cảnh báo SM | Thu ngân có thể hủy đơn tiền mặt rồi "hoàn" vào ca đang mở → bỏ túi | **Đã fix v1.14 (UC-82/BR-79):** giữ no-PIN PENDING (BR-05) + refund vẫn cần SM-auth (BR-67) + report anomaly hủy/hoàn theo cashier, flag vượt `CANCEL_REFUND_ALERT_THRESHOLD` | §3.12.9 |
| RV-S02 | ✅ | Không log việc áp voucher/redeem điểm tại checkout | `order_cancellations` là audit POS duy nhất → lạm dụng voucher/comp cho người quen vô hình | **Đã fix v1.14 (BR-80):** mọi lần áp voucher/redeem ghi AUDIT_LOG (cashier_id, order_id, time, amount), feed UC-82 | §3.6.7 |
| RV-S03 | ✅ | ssadmin (IT) tạo/sửa tài khoản role nghiệp vụ = vi phạm SoD | IT có thể tạo/mạo danh businessadmin/SM | **Đã fix v1.14 (BR-81/UC-83):** audit mọi create/role-change + Access Review report cho ceoviewer (attestation định kỳ) — nhất quán "no maker-checker" | §3.2.12/15 |
| RV-S04 | ✅ | Chưa định nghĩa bootstrap ssadmin đầu tiên + ssadmin tự nâng quyền | Chicken-and-egg; IT tự cấp quyền business/ssadmin khác | **Đã fix v1.14 (BR-82):** ssadmin đầu seed lúc cài đặt; cấm tự đổi role/status mình; đổi quyền HQ phải do ssadmin khác | §3.2.13 |
| RV-S05 | ✅ | Không 2FA/MFA khi login HQ (OTP chỉ dùng lúc quên MK) | Tài khoản quyền-toàn-chuỗi chỉ bảo vệ bằng mật khẩu | **Đã fix v1.14 (BR-83):** MFA bắt buộc cho ceoviewer/businessadmin/ssadmin (email OTP/TOTP), param `HQ_MFA_REQUIRED`; POS roles miễn | §3.2.1/14 |
| RV-S06 | P2 | Không idle/session timeout cho POS dùng chung | Walk-away để session mở trên quầy | BR auto-lock theo thời gian không thao tác | §3.2, BR-60 |
| RV-S07 | P2 | Audit log chưa quy định immutable/append-only | Hệ thống chống gian lận mà log có thể sửa | BR log append-only, tamper-proof | §5.2.1 |
| RV-S08 | P2 | Chưa có chính sách mật khẩu tổng (rotation/expiry/reuse) | Chỉ có "≠ current" (BR-15) + lockout | Hợp nhất 1 mục Authentication Policy | §3.2 |
| RV-S09 | P2 | Không ràng buộc terminal/IP/branch cho POS login | POS có thể mở ở bất kỳ đâu | Device binding / IP allowlist theo terminal đăng ký | §3.2 |
| RV-S10 | P2 | Không khóa khẩn cấp 1 chi nhánh (UC-65 yêu cầu đóng hết ca/đơn) | Không freeze ngay được khi có sự cố gian lận/bảo mật | Emergency suspend force-close session | §3.13 UC-65, BR-55 |
| RV-S11 | P2 | Central System Settings (UC-30) đổi VAT/loyalty/cap không version/audit | BR-68 chỉ phủ price/voucher; sai VAT/tỷ lệ ảnh hưởng mọi đơn | Version + audit + confirm cho field tác động cao | §3.13 UC-30 |
| RV-S12 | P2 | ceoviewer export scope chưa định (có lộ PII SĐT?) | "Read-only" nhưng export raw PII chưa cấm | Giới hạn export ở mức tổng hợp, loại row-level PII | §3.12 UC-29 |
| RV-S13 | P3 | Org chart: IT/MKT không nối branch dù ssadmin cấp tài khoản branch | Sơ đồ không phản ánh thẩm quyền cross-cutting của IT | Ghi chú IT/ssadmin là support cross-cutting | org doc |
| RV-S14 | P3 | Không có role Finance/Kế toán read-only riêng | Rà soát tài chính không có chủ tách bạch IT/CEO | Cân nhắc thêm role finance hoặc scope ceoviewer | §3.2 |
| RV-S15 | P3 | Không tầng Regional/Area khi số branch tăng | Quá khả năng giám sát trực tiếp của HQ về sau | Roadmap v2 (đã chấp nhận mô hình 1-1 hiện tại) | §3.2 |

## B. Vận hành & Kho (RV-O)

| ID | Ưu tiên | Phát hiện | Vì sao quan trọng | Hướng fix | Refs |
|---|:---:|---|---|---|---|
| RV-O01 | ✅ | VietQR về tiền SAU hủy/timeout → tiền vào đơn void | Tiền thật rơi vào đơn đã hủy, không đối soát | **Đã fix v1.15 (BR-85, UC-51 AT3):** late-callback → auto-flag hoàn + queue đối soát + cảnh báo SM, không hồi sinh đơn | §3.6.6 |
| RV-O02 | ✅ | Double-charge khi "RETRY QR" (không idempotency) | Khách quét cả QR cũ + mới → settle 2 lần | **Đã fix v1.15 (BR-84, UC-51 AT2):** 1 settlement/order_id, void QR cũ khi retry, duplicate → auto-refund | §3.6.6 |
| RV-O03 | ✅ | Đơn READY khách không lấy kẹt mãi; BR-03 cấm đóng ca khi còn đơn non-terminal | Không đóng được két cuối ngày | **Đã fix v1.15 (BR-88):** state ABANDONED + auto-expiry `READY_ABANDON_TIMEOUT` + SM force-close lúc đóng ca | §3.7 |
| RV-O04 | ✅ | KDS/máy in tem offline không fallback | Kẹt line giờ cao điểm | **Đã fix v1.15 (BR-87):** queue local + re-dispatch + manual on-screen ticket/reprint | §3.7.7 |
| RV-O05 | ✅ | Gateway down không có cash-only/store-and-forward | Mất mạng cổng thanh toán = không giao dịch được | **Đã fix v1.15 (BR-86, UC-51 AT4):** degraded mode **cash-only** (quyết định chốt: không offline-card) | §3.6.6, §4.2.2 |
| RV-O06 | ✅ | VietQR auto-confirm <1.5s KHÔNG có trong UC-51 (chỉ 60s timeout + manual) | Engineer sẽ build sai luồng | **Đã fix v1.15 (BR-84, UC-51 step 2a):** spec auto-confirm trên callback; 60s timeout là fallback lỗi | §3.6.6 |
| RV-O07 | P2 | Không order-edit sau thanh toán (chỉ full cancel ở PENDING) | Gõ nhầm món chỉ còn cách hủy cả đơn | Định nghĩa line-edit ở PENDING | §3.6 |
| RV-O08 | P2 | Không split/partial payment (cash+QR) | Khách trả 1 phần tiền mặt + 1 phần QR không được | Quyết định in/out scope; nếu có → split tender | §3.6 |
| RV-O09 | P2 | "Cash Received"/tiền thối có field nhưng không trong flow | Thiếu bước tendered/change trong UC-51 | Thêm bước cash-tendered/change | §3.6 UC-51 |
| RV-O10 | P2 | "Subtotal" nghĩa khác nhau giữa grid POS và invoice (VAT incl vs excl) | Lẫn lộn khi đối soát | Chuẩn hóa thuật ngữ gross-inclusive vs net-of-tax | §3.6.2/8 |
| RV-O11 | P2 | Offline áp voucher không check usage-limit | Xài lại voucher single-use khi offline | Flag voucher offline để reconcile/clawback khi online | §3.6.4 |
| RV-O12 | P2 | DELIVERY order được tham chiếu nhưng không có flow/POS channel | Scope mồ côi | Spec delivery hoặc gỡ tham chiếu | §3.7 |
| RV-O13 | P2 | Reprint hóa đơn/tem không log/giới hạn | Gian lận hóa đơn + lãng phí | Log reprint với user/time | §3.6.8, §3.7.4 |
| RV-O14 | P2 | Cross-cashier handover (logout giữ ca mở) không gắn trách nhiệm tiền | Lệch két không quy được cho ai (A/B) | Marker handover ghi cả 2 `user_id` | §3.7.7 |
| RV-O15 | P2 | Queue ordering / vị trí HOLD resume / expedite undefined | Barista tự sắp xếp, không quy tắc | Quy tắc resume position + reorder có log | §3.7 UC-57 |
| RV-O16 | ✅ | Negative stock bị clamp về 0 (UC-62 AT1) | Làm sai count, **giấu tín hiệu thất thoát** | **Đã fix v1.15 (BR-89):** cho balance âm + ghi `phantom_usage` ledger, surface ở MSG07 + UC-76, không clamp 0 | §3.5.6 |
| RV-O17 | ✅ | Đơn vị recipe (g) vs master (kg) chưa validate | Trừ "18" khỏi số dư kg → sai âm thầm | **Đã fix v1.12 (BR-73):** recipe unit bắt buộc == master unit, không quy đổi, reject khi lưu | §3.3/§3.5 |
| RV-O18 | P2 | Không supplier master / price book (UC-32 supplier free text) | HQ không benchmark được giá NCC giữa chi nhánh | Optional Supplier master + price history | §3.5.2 |
| RV-O19 | P2 | Không expiry/lot/FIFO | Sữa/syrup hỏng = mất margin trực tiếp | Thêm expiry/lot vào import + alert | §3.5.2 |
| RV-O20 | P2 | Không branch-to-branch transfer | Chi nhánh hết hàng giờ cao điểm không điều phối được | Thêm `TRANSFER` transaction type (out A / in B) | §3.5 |
| RV-O21 | P2 | Không reorder point / suggested order (UC-62 chỉ alert) | Branch chạy cạn rồi đặt phản ứng | Reorder point + suggested purchase list | §3.5 |
| RV-O22 | P2 | Recipe không versioning (UC-19 overwrite) | COGS lịch sử không truy được dùng công thức nào | Version recipe + stamp recipe_version lên order | §3.3 |
| RV-O23 | P2 | Waste vs theft: UC-33 có reason code nhưng audit UC-34 gộp free-text | Không roll-up thất thoát theo lý do | Reason code cho audit adjustment + report shrinkage theo lý do | §3.5.5 |
| RV-O24 | P2 | Multi-ingredient / yield-loss / partial-unit chưa cover | Recipe thực tế nhiều NVL + hao hụt | RECIPE_ITEM dạng list + yield factor + decimal qty | §3.3 |
| RV-O25 | P2 | Branch min-threshold override không có UC | Master "suggested min" nhưng SM không sửa được ngưỡng branch | Thêm threshold override (UC-31 hoặc branch settings) | §3.5.1 |
| RV-O26 | P2 | UC-33 export validation mâu thuẫn (safety stock vs total stock) | Main Flow vs Note nói ngược nhau | Đồng bộ wording = current total stock | §3.5.3 |
| RV-O27 | P2 | `is_available` leak ở Add form ("Available"); UC-72 nói "availability flag" | Mờ ranh giới `is_active` vs `is_available` | Đổi tên field "Active (chain-wide)"; UC-72 set `is_active` | §3.3.3/5 |
| RV-O28 | P2 | BR-31 (chặn xóa category không rỗng) vs BR-62 (auto-null `category_id`) | Hai đường xử lý xóa category mâu thuẫn | Chốt đường authoritative | §3.4 |
| RV-O29 | P3 | STK code namespace master vs branch chưa rõ FK hiển thị | Reader khó phân biệt master code vs branch row | Làm rõ branch hiển thị master code qua `raw_material_id` | §3.5.1 |

## C. Tài chính & Report (RV-F)

| ID | Ưu tiên | Phát hiện | Vì sao quan trọng | Hướng fix | Refs |
|---|:---:|---|---|---|---|
| RV-F01 | ✅ | "Net Total Payable" (cơ sở tích điểm) chưa định nghĩa | Gồm VAT? topping? trước/sau voucher? → đổi liability mỗi đơn | **Đã fix v1.12 (BR-69):** = số tiền thực thu, VAT-incl, sau voucher & điểm | §3.6.7, §3.10.4 |
| RV-F02 | ✅ | Thứ tự stack voucher → điểm → VAT chưa định nghĩa | Quyết định biên lợi nhuận mỗi giao dịch | **Đã fix v1.12 (BR-70):** voucher → điểm → VAT → accrual | §3.6.7, §3.10 |
| RV-F03 | ✅ | Điểm→VND conversion rate + làm tròn chưa định nghĩa | 340 điểm = ? VND không tính được | **Đã fix v1.13 (BR-74):** param `LOYALTY_REDEMPTION_VALUE_PER_POINT` (100 VND/đ), bội số 100, floor VND | §3.6.5, §3.13 |
| RV-F04 | ✅ | Điểm + voucher có stack không — chưa quy định | Lỗ hổng biên nếu cộng dồn vô tội vạ | **Đã fix v1.13 (cross-ref BR-70/BR-50):** stack được, ≤1 voucher, điểm sau voucher, cap tổng = Gross Subtotal | §3.6.7, §3.10 |
| RV-F05 | ✅ | Điểm loyalty = nợ tài chính nhưng không report/đo | CEO không thấy exposure đang phình | **Đã fix v1.13 (UC-78/BR-75):** Outstanding Loyalty Liability (điểm) + Movement issued/redeemed/expired | §3.12.6 |
| RV-F06 | ✅ | Không labour-cost vs revenue report (dù có BR-53a) | Chỉ số unit-economics quan trọng nhất chuỗi F&B | **Đã fix v1.13 (UC-79/BR-76):** Labour Hours vs Revenue (phi tiền tệ — giữ §1.2), Hrs/1M VND + VND/Hr theo branch | §3.12.7 |
| RV-F07 | ✅ | Không payroll/worked-hours export (BR-53a nói payroll nhưng không UC) | Không xuất được lương/giờ công | **Đã fix v1.13 (UC-80/BR-77):** Worked-Hours export (Store Manager, own branch), giờ công thôi, feed payroll ngoài | §3.9.6 |
| RV-F08 | ✅ | Không Z-report cuối ngày cấp cửa hàng (chỉ shift report) | CEO cần tổng theo branch/ngày: tender, VAT, refund, discount | **Đã fix v1.13 (UC-81/BR-78):** Daily Z-report (Store Manager) gộp mọi ca trong ngày | §3.12.8 |
| RV-F09 | P2 | Không đo hiệu quả campaign (redemption rate, ROI, AOV) | Voucher chỉ CRUD, không đo marketing ROI | Voucher Performance report | §3.10/§3.12 |
| RV-F10 | P2 | Accrual timing async (VietQR) + refund reverse điểm chưa nối chặt | Điểm ghi khi nào với thanh toán async | Tie accrual to confirmed-settlement; refund reverse tỷ lệ | §3.6/§3.8 |
| RV-F11 | P2 | Manual point adjust (UC-26): delta vs absolute? cho âm? | "Points: [340]" mơ hồ, nguy hiểm | Quy định delta/absolute + cho/không cho âm + log | §3.8 UC-26 |
| RV-F12 | P2 | Best-seller không có chiều branch/daypart | Không hỗ trợ quyết định staffing/menu | Thêm breakdown theo branch + khung giờ | §3.12 |
| RV-F13 | P2 | Không cohort/retention/RFM analytics | Thu data khách mà không khai thác | Customer Retention report | §3.12 |
| RV-F14 | P2 | Không export scheduling (chỉ manual) | CEO không nhận report định kỳ tự động | Scheduled export (email định kỳ) | §3.12 UC-29 |
| RV-F15 | P2 | Không anomaly/threshold alerts | Report thụ động: không báo cash variance/voucher velocity/stockout | Configurable alert rules | §3.12 |
| RV-F16 | P2 | Branch không chạy promo local (voucher chỉ HQ) | Chuỗi cần promo giờ thấp điểm theo branch | Confirm HQ-only (ghi giới hạn) hoặc thêm SM-scoped promo có guardrail | §3.10 |
| RV-F17 | P2 | Voucher per-customer/total cap không enforce offline/đa chi nhánh | Double-spend voucher single-use | Central atomic decrement + định nghĩa offline (block/queue) | §3.10 UC-21 |
| RV-F18 | P3 | Gift cards / stored value vắng mặt | Nguồn doanh thu phổ biến + lớp liability khác | Note out-of-scope hoặc roadmap | §3.8/§3.10 |

## D. Tuân thủ, Con người & NFR (RV-C)

| ID | Ưu tiên | Phát hiện | Vì sao quan trọng | Hướng fix | Refs |
|---|:---:|---|---|---|---|
| RV-C01 | ✅ | PDPA/Nghị định 13/2023: SĐT/email/ảnh chấm công không consent/retention/erasure | Rủi ro pháp lý; PII + ảnh sinh trắc-cận | **Đã fix v1.12 (BR-71/72, §4.2.6.1):** consent UC-25, PII 24th + erasure, ảnh 90 ngày | §3.8, §3.9, §4.2.6 |
| RV-C02 | ✅ | `attendance_logs` schema lỗi — generated column `lateness_minutes` tham chiếu `scheduled_start` không tồn tại | Schema không chạy được | **Đã fix v1.12 (BR-38):** thêm cột thật `scheduled_start`, bỏ generated column, lateness derive ở reporting layer | §3.9 |
| RV-C03 | ✅ | Lateness tính UTC vs giờ địa phương → lệch ±7h | Tính phạt đi muộn sai | **Đã fix v1.12 (BR-39):** lateness pin về branch-local time | §3.9, §5.2.2 |
| RV-C04 | ✅ | Cross-branch help (BR-53a) không UC cấp phép/lịch; BR-59 chặn host SM thấy nhân viên khách | Không ai duyệt/giám sát/thấy nhân viên mượn | **Đã fix v1.15 (BR-90, UC-36 AT3):** SM nhà gán trực tiếp + audit; sửa BR-59 cho host SM thấy NV mượn trong kỳ | §3.9.1 |
| RV-C05 | ✅ | BR-38 mâu thuẫn (định nghĩa 2 nơi §3.9.4 vs §5.1) | Hai định nghĩa khác nhau cùng 1 BR | **Đã fix v1.15:** hợp nhất 1 BR-38 (Attendance Log Recording) ở §5.1 khớp §3.9; lateness về BR-39 | §3.9, §5.1 |
| RV-C06 | ✅ | Không OT/nghỉ phép/no-show/đi sớm; "Absent" filter không có UC tạo absence | Không quản được vắng/tăng ca | **Đã fix v1.15 (BR-91):** derive Absence/OT/Early-Leave (minimal — không leave-request UC theo quyết định) | §3.9 |
| RV-C07 | ✅ | Lịch ca không enforce labour budget/max hours/rest (chỉ chặn trùng ngày) | CEO không kiểm soát chi phí lao động qua hệ thống | **Đã fix v1.15 (BR-92, UC-36 AT2):** MAX_DAILY/WEEKLY_HOURS + MIN_REST (hard) + LABOUR_HOUR_BUDGET (soft) | §3.9 UC-36 |
| RV-C08 | ✅ | PIN 4 số không đảm bảo duy nhất + photo nullable offline | Buddy-punching dễ | **Đã fix v1.15 (BR-93):** PIN unique theo branch + lockout + ảnh bắt buộc (không cam → queue/flag, không ghi photoless) | §3.9 BR-53 |
| RV-C09 | P2 | KPI barista theo ca không theo người (BR-61) | Ẩn hiệu suất cá nhân dù có `barista_id` rẻ | Vẫn báo cáo theo ca nhưng **ghi `barista_id`** ở UC-58 để derive sau | §3.7 BR-61 |
| RV-C10 | P2 | Worked hours không tính + thiếu xử lý quên checkout | Không có giờ công để trả lương | Định nghĩa worked-hours + missing-checkout fallback | §3.9 |
| RV-C11 | P2 | Shift swap/đổi ca không có workflow | Nhân viên không xin đổi ca được | Swap request + approval, hoặc ghi out-of-scope | §3.9 |
| RV-C12 | P2 | Lịch ca quá thô (Morning/Afternoon/Full-Day) không split/peak | Đội chi phí, lệch peak/trough | Cho start/end tùy ý + nhiều ca/ngày/người | §3.9 |
| RV-C13 | P2 | Terminal `store_id` misattribution nếu clock-in nhầm terminal | Branch khác gánh chi phí nhân công sai | Validate terminal vs scheduled branch (warn/confirm) + correction flow | §3.9 BR-53a |
| RV-C14 | P2 | §5.4: SM attendance = C/R/U (nên R); thiếu dòng Cancel/Auto-Deduct | Mời gọi sửa chấm công tay (payroll fraud); RBAC chưa đủ | SM=R; system=C; thêm dòng UC-55/UC-62 vào ma trận | §5.4 |
| RV-C15 | P2 | UC-36 "Allocated POS Register" bắt buộc nhưng không flow nào dùng (mâu thuẫn BR-60) | Trường vô tác dụng/gây hiểu nhầm | Làm rõ advisory hay enforced ở Open Shift (UC-44) | §3.9 UC-36 |
| RV-C16 | ✅ | Capacity số cứng (100 session, 10.000 đơn/ngày) không scale theo `MAX_ACTIVE_BRANCHES` | Mâu thuẫn chính cam kết tham số hóa branch | **Đã fix v1.15:** capacity = per-branch (50 session, 2.000 đơn/ngày) × MAX_ACTIVE_BRANCHES; bỏ trần cứng | §4.2.3/§4.2.5 |
| RV-C17 | ✅ | 99.9% uptime mâu thuẫn cửa sổ bảo trì 2h/tháng (24h/năm) | Error budget bị phá trước cả outage | **Đã fix v1.15:** 99.9% đo **loại trừ** cửa sổ bảo trì đã lên lịch | §4.2.2 |
| RV-C18 | P2 | MTBF 8000h/10000h + "0.5 bug/KLOC" không đo được | Số phù phiếm, không làm acceptance gate | Thay bằng SLO quan sát được (crash-free session rate, critical-defect escape) | §4.2 |
| RV-C19 | ✅ | Offline mode under-specified (conflict resolution, ID collision, offline card auth, max duration) | Mất mạng branch = rủi ro thật, hành vi không xác định | **Đã fix v1.15 (BR-86, §4.2.2):** cash-only + client-UUID + append-only sync + reconcile + `MAX_OFFLINE_HOURS`; chốt **không** offline card auth | §4.2.2 |
| RV-C20 | P2 | Không WCAG/accessibility cho touch UI | Thiếu chuẩn tiếp cận | Đặt mục tiêu WCAG | §4 |
| RV-C21 | P2 | VietQR "<1.5s" lẫn render vs bank-confirm (ngoài kiểm soát) | Số cam kết không kiểm chứng được | Reframe: QR display <1.5s; confirmation polling SLA + timeout + manual fallback | §4, UC-51 |
| RV-C22 | P2 | Không payroll integration / scheduling optimization / biometric | Table-stakes cho chuỗi mở rộng | Tối thiểu document payroll-export interface (§4.1.3) + roadmap biometric | §4.1.3 |

---

## Tổng số: 64 phát hiện — **TẤT CẢ P0 + P1 đã clear** (v1.12→v1.15), còn 32 mở (toàn P2/P3)
- **P0 (6) ✅** — v1.12: RV-F01/F02, RV-C01/C02/C03, RV-O17.
- **P1 (26) ✅** — RV-F03–F08 (v1.13); RV-S01–S05 (v1.14); RV-O01–O06/O16 + RV-C04–C08/C16/C17/C19 (v1.15).
- **Còn mở (32): toàn bộ P2/P3** — năng lực nên-có & roadmap (vd: supplier master, expiry/FIFO, recipe versioning, split payment, cohort/RFM, WCAG, gift cards, Finance role, Regional tier…).

> **Đề xuất bước tiếp:** P0 + P1 đã sạch hoàn toàn — SRS đã phủ mọi mâu thuẫn/lỗi/pháp lý và mọi rủi ro tiền-thật/gian-lận/kẹt-vận-hành. Phần còn lại là **P2/P3** (nâng cao năng lực + roadmap), nên xử lý theo lô khi có nhu cầu kinh doanh, không cấp bách. Mỗi mục vẫn theo quy trình: product-owner duyệt → sửa SRS → ghi `00_record_of_changes.md`.
