# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Global Rule: Language

**Always respond in Vietnamese (Tiếng Việt)** in all conversations for this project, regardless of the language the user writes in. Code, identifiers, and file content follow existing conventions, but all explanatory prose, summaries, and answers to the user must be in Vietnamese.

## Project Overview

This is a **documentation, design-spec, and UI/UX repository** for **Khoga Café** — a multi-location coffee shop chain management system. It is not a runnable application. The deliverables are:
- the **SRS** (Software Requirements Specification — *what* the system does),
- the **RDS** (Report 4 / Software Design Document — *how* it is built, following the COMET method),
- Mermaid diagrams, and static HTML mockups.

The repo has moved past the requirements (SRS) phase into the **detailed-design (RDS)** phase. The RDS defines the target implementation stack (see "Target Implementation Architecture" below); no application code is committed yet.

## Document Compilation

Two compiled documents are generated from modular section files. **Always edit the section files, never the compiled output.**

```powershell
# RDS — Software Design Document (current active deliverable)
python compile_rds.py        # rds_sections/*.md  ->  RDS_Khoga_CoffeeShop_v1.0.md

# SRS — Requirements (compile scripts were DELETED from the working tree)
# compile_srs.py / compile_srs.ps1 no longer exist on disk; restore from git if needed:
#   git checkout -- compile_srs.py compile_srs.ps1
# srs_document_full.md is still present and is the authoritative compiled SRS.
```

Recompile (`python compile_rds.py`) after each batch of `rds_sections/` edits.

**RDS diagram maintenance:** `standardize_sequence_diagrams.py` rewrites free-text sequence-diagram labels in `rds_sections/` into formal UML method signatures (e.g. `enter OTP` → `inputOtp(otp)`). Run it after adding sequence diagrams to keep them UML-compliant.

## Repository Structure

| Path | Purpose |
|------|---------|
| `sections/` | Modular **SRS** markdown files (one per functional domain) — source for `srs_document_full.md` |
| `rds_sections/` | Modular **RDS** (Software Design) files — source for `RDS_Khoga_CoffeeShop_v1.0.md` (compiled by `compile_rds.py`) |
| `srs_document_full.md` | Compiled single-file SRS (generated — do not edit directly) |
| `RDS_Khoga_CoffeeShop_v1.0.md` | Compiled single-file RDS / Software Design Document (generated — do not edit directly) |
| `admin_hq_mockups/` | Web UI mockups for the 3 HQ roles — catalog, vouchers, users, branches, reports, materials |
| `cashier_pos_mockups/` | Touchscreen POS mockups — checkout, shifts, payments, order history |
| `barista_monitor_mockups/` | Kitchen Display System (KDS) tablet mockups for baristas |
| `store_manager_mockups/` | Store Manager web dashboard — inventory, staff, revenue |
| `mobile_auth_mockups/` | Mobile login and profile screens (shared auth set for web + mobile) |
| `system_architecture_and_operations.md` | Org structure, core business processes, and 6-role rationale |
| `implementation_plan.md` | RDS/COMET build plan (Vietnamese) — maps the 3 COMET phases to concrete artifacts |
| `coding_division_plan.md` | Per-student (5-member, 3-iteration) UC/screen/mockup assignment for parallel coding |
| `group_division_plan.md` | Team division map (restored) |
| `feature_function_matrix.md` | Feature/function roadmap matrix (restored) |
| `project_summary.md` | Team-facing overview + keep/improve assessment |
| `srs_review_findings.md` | CEO-review backlog (RV-S/O/F/C findings) — all P0/P1 cleared; only P2/P3 remain |

## SRS Section Map

| File | Domain |
|------|--------|
| `sections/03_1_functional_overview.md` | ERD and entity relationships |
| `sections/03_2_system_access_security.md` | Authentication, roles, OTP |
| `sections/03_3_menu_management.md` | Menu items, recipes, toppings |
| `sections/03_4_category_management.md` | Category CRUD |
| `sections/03_5_inventory_management.md` | Stock tracking, imports, audits |
| `sections/03_6_pos_transaction.md` | Cashier POS, payments, shifts |
| `sections/03_7_order_management.md` | Order state machine, barista queue |
| `sections/03_8_customer_membership.md` | CRM, loyalty points (no tiers) |
| `sections/03_9_staff_management.md` | Scheduling, attendance |
| `sections/03_10_promotion_campaign.md` | Vouchers, discount rules |
| `sections/03_12_dashboard_reporting.md` | Analytics, HQ and store reports |
| `sections/03_13_system_configuration.md` | Hardware, VAT, printer config |

## RDS (Software Design) Map

`rds_sections/` follows the COMET method (Hassan Gomaa) and compiles in numeric order. Section 3.x design files mirror the SRS functional domains, each typically containing a COMET class diagram (EBC stereotypes), sequence diagrams, and statecharts.

| File | Content |
|------|---------|
| `rds_sections/00_record_of_changes.md` | RDS change log (start here to see latest design state) |
| `rds_sections/01_system_architecture.md` | 4-tier MVC + COMET EBC architecture diagram & component table |
| `rds_sections/02_package_diagram.md` | UML package diagram (bean/view/controller/filter/dao/util) |
| `rds_sections/03_database_design.md` | 21-table ERD, split into Core-Sales/POS + Operations/Staffing/Audit |
| `rds_sections/04..14_detailed_*.md` | Per-domain detailed design (class + sequence + statechart diagrams) |

## Target Implementation Architecture (RDS)

The RDS specifies a **4-Tier MVC architecture combined with the COMET EBC (Entity–Boundary–Control) design method**. Authoritative source: `rds_sections/01_system_architecture.md`.

- **Presentation:** Thymeleaf (Spring MVC server-side rendered web) for the HQ Admin Portal (`ceoviewer`/`businessadmin`/`ssadmin`) and Store Manager Console (`storemanager`); **Flutter (Dart)** for the POS Terminal (`cashier`) and Barista Queue Monitor (`barista`). POS/Barista clients are **always-online**.
- **Application:** **Spring Boot 3.x (Java 17+)** — `@RestController` (API gateway, all endpoints under `/api/v1/`, JWT auth, Bean Validation) → `@Service` (`@Transactional` coordinators) → stateless `@Component` rule engines (DiscountStackingEngine BR-70, RecipeDeductionEngine BR-89, LoyaltyPointCalculator, COGSCalculator, AnomalyDetector, AttendancePhotoManager) → `@Scheduled` timers (OrderTimeout 15 min, ShiftAutoClose 23:59, LowStockAlert 22:00, PhotoAutoDelete 02:00 PDPA BR-72, OtpExpiry 10 min).
- **Domain / DB:** 21 JPA `@Entity` + Spring Data JPA `@Repository` → **SQL Server**, 21 tables, ACID, Unicode (`NVARCHAR`). **All PKs are UUID `VARCHAR(36)`.**
- **External systems:** VietQR payment gateway (REST webhook, idempotency key = `orderId`, BR-84/85), SMTP (OTP/alerts), ESC/POS receipt + label printers (USB/Network).

**COMET → Spring mapping:** `«boundary»` = Thymeleaf/Flutter view or `@RestController` or external proxy adapter; `«control»` = `@Service`; `«application logic»` = `@Component` engine; `«entity»` = `@Entity`+`@Repository`; `«timer»` = `@Scheduled`. Keep this mapping when authoring RDS class diagrams.

## Conventions

- **Use case IDs** follow `UC-XX` format (e.g., `UC-01` = Login).
- **Business rule IDs** follow `BR-XX` format.
- **Screen names** in mockups must match the official names used in the SRS (the §3.1 Screen Authorization table is the current authoritative list) — do not rename screens arbitrarily. _(The former `mockup_mapping.md` screen↔UC index was deleted — see Open Issues.)_
- All SRS sections are written in Vietnamese; README and this file are in English.
- Mockups are plain HTML/CSS/JS — no framework. They are for specification visualization only, not production code.

## Architecture Decisions

- The order lifecycle is a strict state machine: `Pending → Preparing → Ready → Completed / Cancelled`. See `sections/03_7_order_management.md` (UC-54/UC-55) for cancellation edge cases. (The old `proposed_cancellation_workflow.md` was deleted; cancellation rules now live in §3.7 + BR-05/BR-51.)
- Menu items use recipe-based stock deduction — inventory is deducted when the order enters `PREPARING` (Barista taps "START PREP"), **not** when it is placed and **not** at completion. Authoritative timing: UC-62 + BR-07 in §3.5.6. The chain sells **only prepared items** (everything passes through the Barista queue), so this single trigger covers all stock movement — no packaged/no-prep deduction path is needed (P-DEDUCT resolved 2026-06-14).
- The system targets **6 roles** (RBAC) defined authoritatively in §3.2.0 of `sections/03_2_system_access_security.md`: `ceoviewer` (HQ read-only reports), `businessadmin` (HQ menu/recipe/voucher/CRM), `ssadmin` (HQ users/config/branches), `storemanager`, `cashier`, `barista`. The new org structure rationale lives in `system_architecture_and_operations.md`.
- **No loyalty membership tiers** — Bronze/Silver/Gold/Diamond were removed (BR-34 deleted). Accrual is a % of Net Total Payable with a per-order cap; points expire after 12 months of inactivity (BR-35). See `sections/03_8_customer_membership.md`.
- **No central warehouse** — there is no HQ stock module. `businessadmin` owns the chain-wide **raw-material master list** (defined in **UC-74 / §3.5.0**, screen 50 in the §3.1 matrix; BR-63/BR-64): definitions/units, the source for recipes (§3.3) + branch import dropdowns. Branches import directly from third-party suppliers (UC-32) and manage their own quantities. Skeleton UI: `admin_hq_mockups/materials_web.html`.
- **One Store Manager = one branch** — `USER.store_id` is a single FK; no Regional/Area Manager tier. HQ oversight of all branches is via consolidated reports (`ceoviewer`).
- **`businessadmin` is intentionally one role** — Ops & Supply + Marketing & CRM are combined (separation handled organizationally, not by RBAC).
- **Branch capacity is parameterized** — use `MAX_ACTIVE_BRANCHES`; no hardcoded "5" (cleaned from UC-64).
- **Cash refunds hit the currently-open shift's drawer** (BR-09), not the original order's shift. **Cross-branch attendance** is dual-attributed (BR-53a): payroll by `employee_id`, branch labour cost by terminal `store_id`.
- **Refund/Comp after PENDING** (decided 2026-06-13) — cancellation stays PENDING-only/no-PIN (BR-05), but post-prep complaints use a **Store-Manager-authorised** Refund or Comp/Remake path: UC-75 / BR-67 / `ORDER_REFUND` entity. Partial refunds allowed; cash → open drawer (BR-09); reverses loyalty per BR-08.
- **No maker-checker; audit-log instead** (decided 2026-06-13) — `businessadmin` keeps unilateral price/voucher CRUD, but every menu **price change** and **voucher CRUD** is written to immutable `AUDIT_LOG` (BR-68) and surfaced read-only to `ceoviewer` via UC-77 (Price & Voucher Change History).
- **Toppings have recipes and deduct stock** (decided 2026-06-13) — each topping carries a `RECIPE_ITEM` (via `option_topping_id`); UC-62 deducts base item **and** toppings at `PREPARING` (BR-65). Closes the topping shrinkage hole.
- **COGS = standard cost on the raw-material master** (decided 2026-06-13) — `RAW_MATERIAL.standard_cost` (businessadmin-maintained) is the single basis for chain-wide COGS/margin (BR-66); UC-76 reports margin-per-item + ingredient shrinkage to `ceoviewer` (the consolidated path that restores HQ stock/cost visibility).

## 6-Role RBAC Migration Status

**All written SRS sections are migrated** from the legacy 4-role model (`Admin / Store Manager / Cashier / Barista`)
to the 6-role model above — including the §3.2 use-case bodies and the §2.3 Main-Flow prose (completed 2026-06-13/14, not just the §3.2.0 matrix). The HQ "Admin" umbrella is split into `ceoviewer` / `businessadmin` / `ssadmin`.
Remaining open work: the deleted planning/index docs (restore vs abandon) and the **CEO-review backlog** (`srs_review_findings.md`, 64 findings) — see **Open Issues** below. _(UC-74 propagation: resolved 2026-06-11. HTML mockup audit: resolved 2026-06-12. §3.2 bodies / §2.3 prose: resolved 2026-06-14.)_

**Authoritative ownership mapping** (from §3.2.0): users/config/branches → `ssadmin`; menu/category/voucher/CRM → `businessadmin`; HQ reports (read-only) → `ceoviewer`.

| Area | Status | Notes |
|------|--------|-------|
| `sections/03_2_system_access_security.md` §3.2.0 RBAC matrix | ✅ Done | Authoritative 6-role table + permission summary. _(2026-06-13: the §3.2 use-case BODIES were still 4-role until this date — UC-01..14 Actor fields, prose, BR-19, BR-23, AT1 "last Admin", "HQ Admin" unlock, breadcrumbs, and the mockup user-grid role cell were all remapped to the 6-role ids. The earlier "all migrated" claim covered only the §3.2.0 matrix, not the bodies.)_ |
| `sections/01_product_overview.md` | ✅ Done | Objectives + System Context Diagram split HQ into 3 actor nodes |
| `sections/02_user_requirements.md` | ✅ Done | Actors → 6 roles; Admin use-case diagram split into 2.2.2 CEO Viewer / 2.2.3 Business Admin / 2.2.4 System Admin (downstream renumbered); §2.3 Actor column remapped; removed stale "Bronze member". _(2026-06-14: §2.3 Main-Flow prose "Admin" → owning role per Actor column; "membership levels/milestones" → loyalty-points language; added UC-75/76/77 rows.)_ |
| `sections/03_1_functional_overview.md` | ✅ Done | Screen Authorization table expanded to 6 columns; USER `role` enum → 6 ids; entity/desc text updated |
| `sections/03_3, 03_4, 03_8, 03_10, 03_12, 03_13` | ✅ Done | Actor "Admin" remapped: 03_3/04/10 → `businessadmin`; 03_8 CRM → `businessadmin` (kept Cashier/Store Manager); 03_12 HQ reports → `ceoviewer` (kept Store Manager); 03_13 config+branch → `ssadmin`. Loyalty params in 03_10 → `ssadmin` (live in Central System Settings). "HQ Admin Portal" breadcrumbs left intact. |
| `sections/05_appendix_mapping.md` §5.4 + §5.1 BRs | ✅ Done | §5.4 expanded to 6 role columns (CEO Viewer/Business Admin/System Admin/SM/Cashier/Barista); Inventory + Branch Local Settings = no HQ access (per §3.1). §5.1 stale "Admin" BRs all remapped: BR-44→ceoviewer, BR-49→businessadmin, BR-58/59→ssadmin, BR-04→Store Manager dashboard, BR-19/23→ssadmin only, BR-47 rewritten to split Branch Local Settings (SM) vs Branch Mgmt lifecycle (ssadmin). |
| HTML mockups (all `*_mockups/`) | ✅ Done | HQ portal split into 3 role dashboards + `materials_web.html`. All 21 HQ module screens re-scoped to their owning role's sidebar (businessadmin/ssadmin/ceoviewer) per §3.1; `login_web.html` routes by demo account (`ceoviewer`/`businessadmin`/`ssadmin`) → its role dashboard; legacy shared `dashboard_web.html` deleted; all `*_mockups/` + `index.html` swept of stale "Admin" labels and hardcoded "5" branch cap (now `MAX_ACTIVE_BRANCHES`). No loyalty-tier labels remained. |

**Key decisions made (and why):**
- **Full 3-way HQ split** (not a single "HQ Admin" umbrella) — the new org structure in `system_architecture_and_operations.md` defines three genuinely distinct HQ departments with non-overlapping permissions.
- **Screen Authorization table expanded to 6 columns** — to encode per-sub-role access precisely rather than hiding it behind one "Admin" column.
- **HQ inventory access dropped** — under §3.2.0 no HQ role owns branch stock screens (26/26a); the old "Admin = Read (auditing)" was removed. Chain-wide stock visibility reaches `ceoviewer` via consolidated reports only.
- **Branch Local Settings vs Branch Management split** — UC-42 Branch Local Settings (timezone/hardware/logo) is Store Manager-only; the branch lifecycle (create/view/deactivate, UC-63–65) is `ssadmin`-only. BR-47 was rewritten to remove the legacy "Admin also edits branch config" wording that contradicted the §3.1 screen table.
- **Loyalty parameters belong to `ssadmin`** — accrual rate / redeem caps live in the Central System Settings screen (UC-30), not in Business Admin's voucher/CRM scope.

## Open Issues / Unresolved (as of 2026-06-14)

The 6-role migration of the **written SRS** is complete (incl. §3.2 bodies + §2.3 prose), the major product decisions (P1–P6 + the four 2026-06-13 decisions) are resolved, the HTML mockup audit is done, and the **entire CEO-review P0 + P1 backlog is cleared (v1.12→v1.15)** — 6 P0 + 26 P1 findings resolved. The only remaining backlog is **P2/P3** (nice-to-have capability + roadmap), not urgent.

**Recent progress (v1.15, 2026-06-14):**
- **All remaining P1 cleared** (15 items: RV-O01–O06/O16 + RV-C04–C08/C16/C17/C19) → **no open P0 or P1 left**. VietQR auto-confirm + idempotency + late-callback reconcile (BR-84/85); offline **cash-only** degraded mode (BR-86, §4.2.2); `ABANDONED` order state + READY auto-expiry/force-close (BR-88) + KDS offline fallback (BR-87); negative-stock/phantom-usage ledger (BR-89); cross-branch assignment + BR-59 exception (BR-90); absence/OT/early-leave derivation (BR-91); labour-budget/max-hours validation (BR-92); PIN uniqueness + mandatory photo (BR-93); capacity per-branch × `MAX_ACTIVE_BRANCHES` + SLA-excludes-maintenance (RV-C16/C17). New BRs **BR-84…BR-93**. _(Decisions: offline cash-only — no offline-card; VietQR late = auto-refund not revive; staff mgmt minimal — no leave-request UC; cross-branch = home-SM direct assign + audit.)_

**Earlier progress (v1.14, 2026-06-14):**
- **RV-S P1 cluster cleared** (5 items), applying "audit-log instead of maker-checker" consistently: MFA for HQ roles (BR-83, `HQ_MFA_REQUIRED`, UC-01 AT4 + MFA Challenge screen); ssadmin bootstrap-seed + self-escalation block (BR-82); user-account-change audit + **UC-83** Access Review report (BR-81); checkout voucher/redeem audit log (BR-80); **UC-82** Cashier Void/Refund Anomaly report (BR-79, `CANCEL_REFUND_ALERT_THRESHOLD`). New BRs **BR-79…BR-83**, screens **58–60**, UC-82/83. _(Decisions: MFA reuses OTP infra, HQ-only; SoD via audit+attestation not approval workflow; PENDING cancel stays no-PIN + refunds stay SM-auth, anomaly report is detective-only.)_

**Earlier progress (v1.13, 2026-06-14):**
- **RV-F P1 cluster cleared** (6 items): redemption value/rounding param `LOYALTY_REDEMPTION_VALUE_PER_POINT` (BR-74); voucher+point stacking confirmed via BR-70/BR-50 (RV-F04); **UC-78** Loyalty Liability & Movement (points-only, ceoviewer, BR-75); **UC-79** Labour Hours vs Revenue (non-monetary, keeps payroll external per §1.2, BR-76); **UC-80** Worked-Hours Export (Store Manager, BR-77); **UC-81** Daily Z-Report (Store Manager, BR-78). New BRs **BR-74…BR-78**, screens **54–57**, UC-78/79/80/81. _(Decisions: liability in points not VND; labour metric non-monetary; worked-hours export SM-only.)_

**Earlier progress (v1.12, 2026-06-14):**
- **All 6 P0 backlog items cleared** (owner-signed-off → SRS edits → record-of-changes → recompiled): attendance schema/timezone (RV-C02/C03, BR-38/39), loyalty accrual base + stacking order (RV-F01/F02, BR-69/70), PDPA consent/retention/erasure (RV-C01, BR-71/72 + §4.2.6.1), recipe-unit validation (RV-O17, BR-73). New BRs **BR-69…BR-73** added to §5.1.

**Earlier progress (v1.11, 2026-06-13/14):**
- **CEO-level review** of the whole SRS (5-domain deep audit) → surfaced ~80 findings; the top ones were actioned and the rest captured as a backlog (Issue 4).
- **P0 contradictions fixed:** §3.2 use-case bodies (4-role→6-role), BR-54 / hardcoded "5" in §3.13, inventory-deduction timing unified to `PREPARING` (UC-62/BR-07), stale "central warehouse"/membership-tier wording in `system_architecture_and_operations.md`, §2.3 "Admin" prose + tier language.
- **Four product decisions specced into the SRS** (see Architecture Decisions): Refund/Comp after PENDING (UC-75 / BR-67 / `ORDER_REFUND`), audit-log price/voucher (BR-68 / UC-77), topping recipes that deduct (BR-65), standard-cost COGS (BR-66 / UC-76). Screens 51–53 added to §3.1; UC-75/76/77 to §2.3; BR-65–68 to §5.1; `00_record_of_changes.md` v1.11. Detailed ASCII mock-ups added for UC-75/76/77 (Tables 3-63/64/65).
- **P-DEDUCT resolved** — chain sells only prepared items, so the `PREPARING` trigger covers all stock.

**✅ 1. HTML mockup audit — resolved 2026-06-12.**
   - HQ portal split into 3 role dashboards + `materials_web.html`.
   - All 21 HQ module screens re-scoped to their owning role's sidebar (businessadmin: menu/materials/vouchers/CRM; ssadmin: users/branches/settings; ceoviewer: reports) per §3.1, with "Trang chủ" pointing at the role dashboard.
   - `login_web.html` routes by demo account (`ceoviewer`/`businessadmin`/`ssadmin`, password `admin123`) → its role dashboard.
   - Legacy shared `dashboard_web.html` deleted; no remaining references.
   - Swept all `*_mockups/` + `index.html`: stale "Admin" portal labels → "HQ"; hardcoded "5" branch cap → `MAX_ACTIVE_BRANCHES` (display + JS guards in branches/branch_add/branch_edit/settings). No loyalty-tier labels (GOLD/Silver/…) remained in any mockup.
   - Note: per the P-decision, HQ-web auth screens (OTP / set-new-password / profile / change-password) are **not** duplicated under `admin_hq_mockups/` — `mobile_auth_mockups/` is the shared auth set; `admin_hq_mockups/` keeps only `login_web.html` + `forgot_password_web.html`.

**✅ 2. UC-74 (Raw Material Master) fully propagated (resolved 2026-06-11).**
   Now consistent across: §3.5.0, §3.1 (screen 50 + ERD), §3.3 cross-ref, §5.4, BR-63/64, the §2.3 master use-case list, the §2.2.3 Business Admin use-case diagram, and `00_record_of_changes.md` (v1.10). The ERD now has a chain-wide `RAW_MATERIAL` master entity; `STOCK_ITEM` (renumbered 10a) carries a `raw_material_id` FK and `RECIPE_ITEM` re-points to the master per BR-63. (Also recorded the prior 6-role migration as v1.9 and refreshed the §2.2.x / §3.5.0 entries in the `00_record_of_changes.md` Table of Contents, which were stale.)

**🟡 3. Deleted planning/index docs — partly restored.**
   Restored and present: `feature_function_matrix.md`, `group_division_plan.md` (plus new `coding_division_plan.md` + `implementation_plan.md` for the build phase). Still missing: `mockup_mapping.md` (mockup↔UC index), `proposed_cancellation_workflow.md`, `srs_revision_{summary,todo}.md`, `srs_vs_market_analysis.md`. `mockup_mapping.md` would still be useful as the mockup↔UC↔screen index for the 5 mockup folders + role dashboards + `materials_web.html`.

**🟢 4. CEO-review backlog — `srs_review_findings.md` (64 findings; ALL 6 P0 + 26 P1 cleared v1.12→v1.15 → 32 open, all P2/P3). ← only nice-to-have/roadmap left.**
   Direction chosen by the product owner: keep as a **reviewed backlog, not auto-applied** to the SRS. Findings are grouped `RV-S` (security/fraud), `RV-O` (operations/inventory), `RV-F` (financial/reporting), `RV-C` (compliance/people/NFR), each with priority P0–P3, rationale, fix direction, and §/UC/BR refs.
   - **✅ All 6 P0 items cleared (v1.12, 2026-06-14)** — owner-signed-off + applied to SRS:
     - `RV-C02` — `attendance_logs` rebuilt: dropped the broken `lateness_minutes` GENERATED column, added a real `scheduled_start` column snapshotted at check-in (BR-38). (§3.9)
     - `RV-C03` — lateness now derived in **branch-local** time, fixing the ±7h UTC error (BR-39). (§3.9, §5.2.2)
     - `RV-F01` — accrual base "Net Total Payable" defined = VAT-inclusive amount collected, after voucher & point redemption (**BR-69**). (§3.6.7)
     - `RV-F02` — stacking order fixed: Voucher → Points → VAT → accrual (**BR-70**). (§3.6.7)
     - `RV-C01` — PDPA / Decree 13/2023: consent capture at UC-25 (**BR-71**); 24-month PII retention + on-request erasure + 90-day attendance-photo purge (**BR-72**); §4.2.6.1. (§3.8, §3.9, §4.2.6)
     - `RV-O17` — recipe lines must use the raw material's exact master unit; no kg↔g conversion, rejected at save (**BR-73**, UC-18 AT2). (§3.3, §3.5)
   - **✅ RV-F P1 cluster cleared (v1.13)** — loyalty-liability report (UC-78), labour-vs-revenue (UC-79), worked-hours export (UC-80), daily Z-report (UC-81), redemption param (BR-74), stacking confirm (RV-F04).
   - **✅ RV-S P1 cluster cleared (v1.14)** — HQ MFA (BR-83), bootstrap+self-escalation (BR-82), account-change audit + Access Review UC-83 (BR-81), checkout discount audit (BR-80), Cashier Void/Refund Anomaly UC-82 (BR-79).
   - **✅ Remaining P1 cleared (v1.15)** — VietQR/offline/shift-close (BR-84…88), negative-stock ledger (BR-89), staff cross-branch/absence/labour/PIN (BR-90…93), NFR capacity & SLA (RV-C16/C17). **No open P0 or P1 remain.**
   - **Next step — P2/P3 only** (nice-to-have + roadmap): e.g. supplier master/price book (RV-O18), expiry/lot/FIFO (RV-O19), recipe versioning (RV-O22), split/partial payment (RV-O08), cohort/RFM analytics (RV-F13), campaign ROI (RV-F09), WCAG (RV-C20), gift cards (RV-F18), Finance read-only role (RV-S14). Not urgent.
   - **Workflow per item:** product-owner sign-off → SRS edit → `00_record_of_changes.md` entry → recompile.

**Reminder:** recompile after each batch of section edits — `python compile_rds.py` for `rds_sections/` (active), or restore + run `compile_srs.py` for `sections/`.

See `project_summary.md` for a team-facing overview + a keep/improve assessment of fit against the business model and org structure.
