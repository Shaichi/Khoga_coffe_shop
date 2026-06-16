# I. Record of Changes

This section tracks the revision history and modifications made to the Software Requirements Specification (SRS) document.

| Version | Date | Description of Change | Author | Reviewer / Approved By |
|---|---|---|---|---|
| **1.0** | 2026-05-23 | Initial drafting of the SRS including product scope, actors, use case flows, functional features (Sections 3.2 - 3.13), and non-functional specifications. | Software Engineering Team | Store Management / Product Owner |
| **1.1** | 2026-05-23 | Revised SRS according to srs_business_review.md. Synchronized currency to VND, resolved rules conflicts, detailised delivery, refund, offline mode, and multi-branch specs. | Software Engineering Team | Store Management / Product Owner |
| **1.2** | 2026-05-24 | Fixed 8 technical issues: standardized branch capacity to 5, renamed duplicate UC-31b to UC-61, added missing schema fields, documented offline voucher and order overflow edge cases, added notification fallback to BR-04, and added i18n notes to messages list. | Software Engineering Team | Store Management / Product Owner |
| **1.3** | 2026-05-24 | Resolved 15 schema, visual, and logic defects (N-01 to N-10, X-01 to X-10): added Section 3.6.6 Stacking Rules, defined tier point thresholds, added inclusive VAT to F33 mockup, resolved orphan UC-14, added stores, staff schedules, and attendances database tables, fixed manager_id nullability, and added Section 5.4 Feature-Actor Mapping Matrix. | Software Engineering Team | Store Management / Product Owner |
| **1.4** | 2026-05-24 | Resolved comprehensive review v1.3 issues: defined UC-49 Redeem Loyalty Points, fixed UTF-8 encoding in product scope, matched Login failure alert with MSG02, expanded messages dictionary (MSG09-MSG13), specified tier downgrades (BR-34) and 12-month inactivity point expiry (BR-35), detailed delivery order rejection flow (BR-42), and added new alternative flows for negative audit input and close shift disputes. | Software Engineering Team | Store Management / Product Owner |
| **1.5** | 2026-05-24 | Resolved comprehensive review v1.4 issues: added full Section 3.6.5 F31.1 for UC-49 (containing mock-up, field definition, and alternate flows), updated the Table of Contents, fully synchronized BR-42 in Section 5.1, and standardized MSG12 to pure English dictionary key text. | Software Engineering Team | Store Management / Product Owner |
| **1.6** | 2026-05-24 | Addressed final review feedback: mapped Redeem Loyalty Points Modal (37a) in functional overview and authorization matrix, assigned MSG14 for invalid loyalty redemption multiples, and updated POS transactions flow AT3. | Software Engineering Team | Store Management / Product Owner |
| **1.7** | 2026-06-02 | Added Branch Management functionality (Section 3.13.3): UC-63 View Branch List, UC-64 Add Branch, UC-65 Update/Deactivate Branch. Added 3 new screens (45-47) to Admin Portal flow, updated screen authorization matrix, Feature-Actor Mapping Matrix, and added business rules BR-54, BR-55, BR-56. Added application messages MSG15, MSG16. | Software Engineering Team | Store Management / Product Owner |
| **1.8** | 2026-06-03 | Simplified cancellation to PENDING only (no manager PIN), popup-based 4-digit PIN + camera snapshot attendance, team-based barista KPI, branch menu status table, dynamic branch limit (MAX_ACTIVE_BRANCHES), bulk stock import invoice grid, custom loyalty cap fields, and removed all ShopeeFood/Grab integrations. | Software Engineering Team | Store Management / Product Owner |
| **1.8.1** | 2026-06-03 | Patched discrepancies in v1.8: aligned BR-07/BR-09 with BR-05 (restricting cancellation/refund to PENDING only), added missing use cases (UC-68 to UC-72, UC-61, UC-73) to diagrams, resolved loyalty point config conflict and restored MSG14, authorized Barista for Order Detail screen, and fixed screen numbering gaps. | Software Engineering Team | Store Management / Product Owner |
| **1.8.2** | 2026-06-03 | Integrated Central Loyalty configurations (Accrual rate, Redeem value, Max redeem %, Max discount limit) under Admin system settings. Completely removed customer membership tiers (Bronze/Silver/Gold/Diamond) and their automatic discounts. Simplified checkout stacking and discount priority rules. | Software Engineering Team | Store Management / Product Owner |
| **1.9** | 2026-06-09 | Migrated from the legacy 4-role model to a 6-role RBAC model: the HQ "Admin" umbrella was split into `ceoviewer` (read-only reports), `businessadmin` (menu/recipe/voucher/CRM), and `ssadmin` (users/config/branches). Updated actors, use-case diagrams (§2.2.2–2.2.4), Screen Authorization matrix (§3.1, 6 columns), USER role enum, and Feature-Actor Mapping (§5.4). | Software Engineering Team | Store Management / Product Owner |
| **1.10** | 2026-06-11 | Added UC-74 Manage Raw Material Master (§3.5.0): a chain-wide raw-material master catalog owned by `businessadmin`, source for recipe formulations and branch Import/Export dropdowns. Added screen 50, BR-63/BR-64, the `RAW_MATERIAL` entity to the ERD (with `STOCK_ITEM` and `RECIPE_ITEM` re-pointed to the master), and §2.3 / §2.2.3 use-case entries. | Software Engineering Team | Store Management / Product Owner |
| **1.11** | 2026-06-13 | CEO-review resolutions. **P0 consistency:** finished the 6-role migration in §3.2 (use-case bodies were still 4-role), fixed BR-54 / hardcoded "5" in §3.13, unified inventory-deduction timing to `PREPARING` (UC-62/BR-07), and cleaned stale "central warehouse"/membership-tier wording in the architecture doc. **New capabilities:** (1) UC-75 Store-Manager Refund/Comp for post-`PENDING` complaints + BR-67 + `ORDER_REFUND` entity; (2) topping recipes that deduct stock (BR-65, UC-62 + §3.3.6); (3) standard-cost COGS via `RAW_MATERIAL.standard_cost` (BR-66) + UC-76 COGS/Margin & Shrinkage report; (4) mandatory audit-log of price/voucher changes (BR-68) + UC-77 Change-History report. Screens 51–53 added to §3.1; UC-75/76/77 added to §2.3. | Software Engineering Team | Store Management / Product Owner |
| **1.12** | 2026-06-14 | Cleared the 6 CEO-review **P0** backlog items (`srs_review_findings.md`). **RV-C02/C03:** rebuilt the `attendance_logs` schema — replaced the broken `lateness_minutes` GENERATED column (referenced a non-existent `scheduled_start`) with a real `scheduled_start` column snapshotted at check-in; lateness is now derived at the reporting layer in **branch-local** time, fixing the ±7h UTC error (BR-38/BR-39). **RV-F01/F02:** defined the loyalty accrual base "Net Total Payable" (VAT-inclusive, after voucher & point redemption) as **BR-69** and the fixed Voucher→Points→VAT→accrual stacking order as **BR-70** (§3.6.7). **RV-C01:** added PDPA / Decree 13/2023 compliance — customer-consent capture at UC-25 (`consent_at`/`consent_version`, BR-71), 24-month PII retention + on-request erasure and 90-day attendance-photo purge (BR-72), and §4.2.6.1 Personal Data Protection. **RV-O17:** recipe lines must use the raw material's exact master unit — no kg↔g conversion, rejected at save (BR-73, UC-18 AT2). | Software Engineering Team | Store Management / Product Owner |
| **1.16** | 2026-06-15 | **Consistency pass** (pre-merge QA, no spec changes): fixed a duplicate business-rule ID — the §3.13 "Loyalty Config Parameters" rule was mis-numbered `BR-57` (which canonically denotes Employee ID Auto-Allocation) and is renumbered **BR-94** (added to §5.1); fixed a duplicate subsection heading — the pre-existing "Cashier Shift Sessions & Multi-Store Attendance Tracking" was renumbered **§3.7.8** (its children 3.7.8.1/3.7.8.2) so it no longer collides with the new §3.7.7 "Fulfilment Resilience & Queue Lifecycle"; and refreshed the Table of Contents to list the §3.2.14/15, §3.7.5a–3.7.8, §3.9.6, and §3.12.4–3.12.9 subsections added in v1.10–v1.15. | Software Engineering Team | Store Management / Product Owner |
| **1.15** | 2026-06-14 | Cleared the **remaining P1** backlog (operations/inventory + compliance/people/NFR) — **all P0 and P1 findings are now resolved**. **VietQR/payment (RV-O01/O02/O06):** UC-51 auto-confirm on callback, RETRY-QR idempotency (one settlement per `order_id`), and late-callback reconciliation (auto-flag refund, no order revival) — BR-84/BR-85, UC-51 AT2/AT3. **Offline (RV-O05/C19):** cash-only degraded mode (no offline card auth) with client-UUID identifiers, append-only sync, conflict surfacing, and `MAX_OFFLINE_HOURS` — BR-86, UC-51 AT4, §4.2.2 rewritten. **Order lifecycle (RV-O03/O04):** new terminal `ABANDONED` state + `READY_ABANDON_TIMEOUT` auto-expiry + SM force-close at shift close (BR-88); KDS/printer offline fallback (BR-87, §3.7.7). **Inventory (RV-O16):** negative-stock / `phantom_usage` ledger instead of clamping to 0 (BR-89, UC-62 AT1). **Staff (RV-C04/C05/C06/C07/C08):** cross-branch assignment by home SM + audit + BR-59 host-visibility exception (BR-90, UC-36 AT3); consolidated the duplicate BR-38; absence/OT/early-leave derivation (BR-91); labour-budget & max-hours/rest scheduling validation (BR-92, UC-36 AT2); attendance PIN uniqueness + mandatory photo (BR-93). **NFR (RV-C16/C17):** capacity expressed per-branch × `MAX_ACTIVE_BRANCHES`; 99.9% uptime measured excluding the scheduled maintenance window (§4.2.2/§4.2.3/§4.2.5). New BRs **BR-84…BR-93**. | Software Engineering Team | Store Management / Product Owner |
| **1.14** | 2026-06-14 | Cleared the **RV-S (fraud & security) P1** backlog cluster, applying the project's "audit-log instead of maker-checker" philosophy consistently. **RV-S05:** mandatory **MFA for HQ roles** (`ceoviewer`/`businessadmin`/`ssadmin`) via email OTP (reusing UC-03/04) or TOTP, parameter `HQ_MFA_REQUIRED` (default on); POS/branch roles exempt — added UC-01 AT4, §3.2.14 MFA Challenge (screen 58), **BR-83**. **RV-S04:** **BR-82** — first `ssadmin` seeded at install (no in-app bootstrap), self-escalation blocked (own role/status change requires a different ssadmin); added UC-12/14 AT3. **RV-S03:** **BR-81** + **UC-83** User Account Change & Access Review report (CEO Viewer, §3.2.15, screen 60) — audits every account create/role-change/deactivate as the SoD compensating control. **RV-S02:** **BR-80** — every checkout voucher application & point redemption written to immutable `AUDIT_LOG` (§3.6.7). **RV-S01:** **UC-82** Cashier Void/Refund Anomaly report (Store Manager + CEO Viewer, §3.12.9, screen 59) + **BR-79** flagging cancel/refund outliers against `CANCEL_REFUND_ALERT_THRESHOLD`; PENDING cancel stays no-PIN (BR-05) and refunds stay SM-authorised (BR-67). Added screens 58–60 to §3.1, UC-82/83 to §2.3, two matrix rows to §5.4, and two security params to §3.13. | Software Engineering Team | Store Management / Product Owner |
| **1.13** | 2026-06-14 | Cleared the **RV-F (financial/reporting) P1** backlog cluster. **RV-F03:** standardised the point-to-cash parameter to `LOYALTY_REDEMPTION_VALUE_PER_POINT` (default 100 VND/point), redemption in multiples of 100, floor-to-VND rounding (**BR-74**; §3.6.5/§3.6.7/§3.13). **RV-F04:** confirmed voucher + point stacking (≤1 voucher, points after voucher, combined cap = Gross Subtotal) via cross-reference to BR-70/BR-50 (§3.6.7). **RV-F05:** added **UC-78** Loyalty Liability & Movement report (CEO Viewer) reporting outstanding points + issued/redeemed/expired movement in points (**BR-75**, §3.12.6). **RV-F06:** added **UC-79** Labour Hours vs Revenue report (CEO Viewer + Store Manager) — a non-monetary staffing-efficiency KPI that stores no wage data, keeping payroll external per §1.2 (**BR-76**, §3.12.7). **RV-F07:** added **UC-80** Worked-Hours Export (Store Manager, own branch) — paired CHECK_IN/CHECK_OUT hours with missing-checkout flagging, feeding external payroll (**BR-77**, §3.9.6). **RV-F08:** added **UC-81** Daily Z-Report (Store Manager) consolidating all of a day's shifts into one branch statement (**BR-78**, §3.12.8). Added screens 54–57 to §3.1, UC-78/79/80/81 to §2.3, four matrix rows to §5.4. | Software Engineering Team | Store Management / Product Owner |
| **1.17** | 2026-06-16 | Removed Section 3.3.7 (Two-Level Item Availability Model) as it does not represent a standalone screen. Consolidated its availability logic into the functional overview of §3.3 Menu Management and relocated BR-62 definition to §3.4.4.2 Delete Category. | Software Engineering Team | Store Management / Product Owner |



# Table of Contents

1. [Product Overview](#1-product-overview)
   - 1.1 Product Purpose & Objectives
   - 1.2 Product Scope
   - 1.3 System Context Diagram

2. [User Requirements](#2-user-requirements)
   - 2.1 Actors
   - 2.2 Use Cases
     - 2.2.1 General User & Authentication Use Cases
     - 2.2.2 CEO / Executive Viewer Use Cases
     - 2.2.3 Business Admin Use Cases
     - 2.2.4 System Admin Use Cases
     - 2.2.5 Store Manager Use Cases
     - 2.2.6 Cashier Use Cases
     - 2.2.7 Barista Use Cases

3. [Software Features](#31-functional-overview)

   - **3.1 Functional Overview**
     - 3.1.1 Screens Flow
     - 3.1.2 Screen Descriptions
     - 3.1.3 Screen Authorization
     - 3.1.4 Non-Screen Functions
     - 3.1.5 Entity Relationship Diagram
     - 3.1.6 Entity Details

   - **3.2 System Access & Security**
     - 3.2.1 Login
     - 3.2.2 Logout
     - 3.2.3 Change Password
     - 3.2.4 Forgot Password
     - 3.2.5 Verify OTP
     - 3.2.6 Set New Password
     - 3.2.7 Force Password Change
     - 3.2.8 View Profile
     - 3.2.9 Update Profile
     - 3.2.10 List User Account
     - 3.2.11 View User Details & History
     - 3.2.12 Add User Account
     - 3.2.13 Update/Deactivate User Account
     - 3.2.14 HQ Multi-Factor Authentication Challenge
     - 3.2.15 User Account Change & Access Review Report (UC-83)

   - **3.3 Menu Management**
     - 3.3.1 View Menu Item List
     - 3.3.2 View Menu Item Detail
     - 3.3.3 Add Menu Item
     - 3.3.4 Update Menu Item
     - 3.3.5 Delete Menu Item
     - 3.3.6 Manage Toppings & Options

   - **3.4 Category Management**
     - 3.4.1 View Category List
     - 3.4.2 Add Category
     - 3.4.3 Update Category
     - 3.4.4 Delete Category

   - **3.5 Inventory & Stock Management**
     - 3.5.0 Manage Raw Material Master (Chain-wide)
     - 3.5.1 View Stock List
     - 3.5.2 Import Stock (Nhập kho)
     - 3.5.3 Export Stock (Xuất kho)
     - 3.5.4 View Import/Export History
     - 3.5.5 Perform Inventory Audit (Kiểm kho)
     - 3.5.6 Auto-Deduct Stock on Prep Start (incl. Low Stock Alert)

    - **3.6 POS Transaction**
      - 3.6.1 Open Shift
      - 3.6.2 POS Checkout Grid
      - 3.6.3 Lookup Customer Membership
      - 3.6.4 Apply Voucher (Discount Code)
      - 3.6.5 Redeem Loyalty Points
      - 3.6.6 Process Payment
      - 3.6.7 Discount Priority & Stacking Rules
      - 3.6.8 Issue Invoice
      - 3.6.9 Close Shift

   - **3.7 Order Management**
     - 3.7.1 View Order List
     - 3.7.2 View Order Detail
     - 3.7.3 View Order Queue Display
     - 3.7.4 Print Drink Label (Sticker)
     - 3.7.5 Cancel Order
     - 3.7.5a Refund / Comp After Preparation (UC-75)
     - 3.7.6 Void & Cancellation Audit Logging
     - 3.7.7 Fulfilment Resilience & Queue Lifecycle
     - 3.7.8 Cashier Shift Sessions & Multi-Store Attendance Tracking

   - **3.8 Customer & Membership Management**
     - 3.8.1 List Customer
     - 3.8.2 Add Customer
     - 3.8.3 Update Customer
     - 3.8.4 View Customer History

   - **3.9 Staff Management**
     - 3.9.1 Create Staff Schedule / Shift
     - 3.9.2 View Staff Schedule
     - 3.9.3 Update/Delete Staff Schedule
     - 3.9.4 View Staff Attendance Report
     - 3.9.5 View Branch Staff List
     - 3.9.6 Export Worked-Hours Report (UC-80)

   - **3.10 Promotion & Campaign Management**
     - 3.10.1 List Voucher / Promotion
     - 3.10.2 Add Voucher / Promotion
     - 3.10.3 Update/Delete Voucher / Promotion

   - **3.12 Dashboard & Reporting**
     - 3.12.1 HQ Revenue Dashboard
     - 3.12.2 Export Report
     - 3.12.3 Store Revenue Reports
     - 3.12.4 COGS / Margin & Ingredient Shrinkage Report (UC-76)
     - 3.12.5 Price & Voucher Change History (UC-77)
     - 3.12.6 Loyalty Liability & Movement Report (UC-78)
     - 3.12.7 Labour Hours vs Revenue Report (UC-79)
     - 3.12.8 Daily Z-Report (UC-81)
     - 3.12.9 Cashier Void/Refund Anomaly Report (UC-82)

   - **3.13 System Configuration**
     - 3.13.1 Central System Settings
     - 3.13.2 Branch Local Settings
     - 3.13.3 Branch Management (Add / Edit / Deactivate Branch)

4. [Non-Functional Requirements](#4-non-functional-requirements)
   - 4.1 External Interfaces
     - 4.1.1 User Interfaces
     - 4.1.2 Hardware Interfaces
     - 4.1.3 Software & API Interfaces
   - 4.2 Quality Attributes
     - 4.2.1 Usability
     - 4.2.2 Reliability
     - 4.2.3 Performance
     - 4.2.4 Security & Compliance
     - 4.2.5 Scalability
     - 4.2.6 Data Retention & Archival
     - 4.2.7 Backup & Disaster Recovery
     - 4.2.8 Browser & Device Support

5. [Requirement Appendix & Mapping](#5-requirement-appendix--mapping)
   - 5.1 Business Rules
   - 5.2 Common Requirements
     - 5.2.1 Audit Logging
     - 5.2.2 Datetime Formatting
   - 5.3 Application Messages List
   - 5.4 Feature-Actor Mapping Matrix

