# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **documentation and UI/UX specification repository** for **Khoga Café** — a multi-location coffee shop chain management system. It is not a runnable application. The deliverables are SRS documents, Mermaid diagrams, and static HTML mockups.

## Document Compilation

To rebuild the compiled SRS from modular sections:

```powershell
python compile_srs.py
# or
.\compile_srs.ps1
```

Output: `srs_document_full.md` (authoritative compiled document).

## Repository Structure

| Path | Purpose |
|------|---------|
| `sections/` | 17 modular SRS markdown files (one per functional domain) |
| `admin_hq_mockups/` | Web UI mockups for HQ Admin — catalog, vouchers, users, branches, reports |
| `cashier_pos_mockups/` | Touchscreen POS mockups — checkout, shifts, payments, order history |
| `barista_monitor_mockups/` | Kitchen Display System (KDS) tablet mockups for baristas |
| `store_manager_mockups/` | Store Manager web dashboard — inventory, staff, revenue |
| `mobile_auth_mockups/` | Mobile login and profile screens |
| `srs_document_full.md` | Compiled single-file SRS (generated — do not edit directly) |
| `feature_function_matrix.md` | Development roadmap: 70 use cases across 3 iterations |
| `group_division_plan.md` | 5-person team ownership map |
| `mockup_mapping.md` | Index mapping every mockup HTML file to its SRS use cases |

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

## Conventions

- **Use case IDs** follow `UC-XX` format (e.g., `UC-01` = Login).
- **Business rule IDs** follow `BR-XX` format.
- **Screen names** in mockups must match the official names used in `mockup_mapping.md` and the SRS — do not rename screens arbitrarily.
- All SRS sections are written in Vietnamese; README and this file are in English.
- Mockups are plain HTML/CSS/JS — no framework. They are for specification visualization only, not production code.

## Architecture Decisions

- The order lifecycle is a strict state machine: `Pending → Preparing → Ready → Completed / Cancelled`. See `sections/03_7_order_management.md` and `proposed_cancellation_workflow.md` for cancellation edge cases.
- Menu items use recipe-based stock deduction — inventory levels are updated automatically when an order completes, not when it is placed.
- The system targets **6 roles** (RBAC) defined authoritatively in §3.2.0 of `sections/03_2_system_access_security.md`: `ceoviewer` (HQ read-only reports), `businessadmin` (HQ menu/recipe/voucher/CRM), `ssadmin` (HQ users/config/branches), `storemanager`, `cashier`, `barista`. The new org structure rationale lives in `system_architecture_and_operations.md`.
- **No loyalty membership tiers** — Bronze/Silver/Gold/Diamond were removed (BR-34 deleted). Accrual is a % of Net Total Payable with a per-order cap; points expire after 12 months of inactivity (BR-35). See `sections/03_8_customer_membership.md`.
- **No central warehouse** — there is no HQ stock module. `businessadmin` owns the chain-wide **raw-material master list** (defined in **UC-74 / §3.5.0**, screen 50 in the §3.1 matrix; BR-63/BR-64): definitions/units, the source for recipes (§3.3) + branch import dropdowns. Branches import directly from third-party suppliers (UC-32) and manage their own quantities. Skeleton UI: `admin_hq_mockups/materials_web.html`.
- **One Store Manager = one branch** — `USER.store_id` is a single FK; no Regional/Area Manager tier. HQ oversight of all branches is via consolidated reports (`ceoviewer`).
- **`businessadmin` is intentionally one role** — Ops & Supply + Marketing & CRM are combined (separation handled organizationally, not by RBAC).
- **Branch capacity is parameterized** — use `MAX_ACTIVE_BRANCHES`; no hardcoded "5" (cleaned from UC-64).
- **Cash refunds hit the currently-open shift's drawer** (BR-09), not the original order's shift. **Cross-branch attendance** is dual-attributed (BR-53a): payroll by `employee_id`, branch labour cost by terminal `store_id`.

## 6-Role RBAC Migration Status

**All written SRS sections are migrated** from the legacy 4-role model (`Admin / Store Manager / Cashier / Barista`)
to the 6-role model above. The HQ "Admin" umbrella is split into `ceoviewer` / `businessadmin` / `ssadmin`.
The only remaining gap is the HTML mockups (not yet audited for legacy role labels / portal assumptions).

**Authoritative ownership mapping** (from §3.2.0): users/config/branches → `ssadmin`; menu/category/voucher/CRM → `businessadmin`; HQ reports (read-only) → `ceoviewer`.

| Area | Status | Notes |
|------|--------|-------|
| `sections/03_2_system_access_security.md` §3.2.0 RBAC matrix | ✅ Done | Authoritative 6-role table + permission summary |
| `sections/01_product_overview.md` | ✅ Done | Objectives + System Context Diagram split HQ into 3 actor nodes |
| `sections/02_user_requirements.md` | ✅ Done | Actors → 6 roles; Admin use-case diagram split into 2.2.2 CEO Viewer / 2.2.3 Business Admin / 2.2.4 System Admin (downstream renumbered); §2.3 Actor column remapped; removed stale "Bronze member" |
| `sections/03_1_functional_overview.md` | ✅ Done | Screen Authorization table expanded to 6 columns; USER `role` enum → 6 ids; entity/desc text updated |
| `sections/03_3, 03_4, 03_8, 03_10, 03_12, 03_13` | ✅ Done | Actor "Admin" remapped: 03_3/04/10 → `businessadmin`; 03_8 CRM → `businessadmin` (kept Cashier/Store Manager); 03_12 HQ reports → `ceoviewer` (kept Store Manager); 03_13 config+branch → `ssadmin`. Loyalty params in 03_10 → `ssadmin` (live in Central System Settings). "HQ Admin Portal" breadcrumbs left intact. |
| `sections/05_appendix_mapping.md` §5.4 + §5.1 BRs | ✅ Done | §5.4 expanded to 6 role columns (CEO Viewer/Business Admin/System Admin/SM/Cashier/Barista); Inventory + Branch Local Settings = no HQ access (per §3.1). §5.1 stale "Admin" BRs all remapped: BR-44→ceoviewer, BR-49→businessadmin, BR-58/59→ssadmin, BR-04→Store Manager dashboard, BR-19/23→ssadmin only, BR-47 rewritten to split Branch Local Settings (SM) vs Branch Mgmt lifecycle (ssadmin). |
| HTML mockups (all `*_mockups/`) | 🔶 In progress | HQ portal split into 3 role dashboards: `admin_hq_mockups/dashboard_{ceoviewer,businessadmin,ssadmin}_web.html` (skeletons, no JS) + new `materials_web.html`. Remaining module screens not yet audited; login→role-dashboard routing + deprecating shared `dashboard_web.html` still TODO. |

**Key decisions made (and why):**
- **Full 3-way HQ split** (not a single "HQ Admin" umbrella) — the new org structure in `system_architecture_and_operations.md` defines three genuinely distinct HQ departments with non-overlapping permissions.
- **Screen Authorization table expanded to 6 columns** — to encode per-sub-role access precisely rather than hiding it behind one "Admin" column.
- **HQ inventory access dropped** — under §3.2.0 no HQ role owns branch stock screens (26/26a); the old "Admin = Read (auditing)" was removed. Chain-wide stock visibility reaches `ceoviewer` via consolidated reports only.
- **Branch Local Settings vs Branch Management split** — UC-42 Branch Local Settings (timezone/hardware/logo) is Store Manager-only; the branch lifecycle (create/view/deactivate, UC-63–65) is `ssadmin`-only. BR-47 was rewritten to remove the legacy "Admin also edits branch config" wording that contradicted the §3.1 screen table.
- **Loyalty parameters belong to `ssadmin`** — accrual rate / redeem caps live in the Central System Settings screen (UC-30), not in Business Admin's voucher/CRM scope.

**Next steps for a future session:**
1. Audit HTML mockups (all `*_mockups/`) for legacy role labels / portal assumptions — the only remaining migration gap. Note the shared `admin_hq_mockups/` folder must serve 3 HQ roles (`ceoviewer`/`businessadmin`/`ssadmin`); verify each screen surfaces only its role's modules.
2. Recompile (`python compile_srs.py`) after each batch of section edits.

See `project_summary.md` for a team-facing overview + a keep/improve assessment of fit against the business model and org structure.
