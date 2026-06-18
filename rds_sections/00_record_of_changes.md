# **I. Record of Changes**

| Date | A\*M, D | In charge | Change Description |
| ----- | ----- | ----- | ----- |
| 2026-06-18 | A | Software Engineering Team | Initial creation of RDS v1.0 — Iteration A: Section I (Record of Changes), Section 1.1 (System Architecture), Section 1.2 (Package Diagram), Section 2 (Database Design — 21 tables). |
| 2026-06-18 | A | Software Engineering Team | Iteration B: Section 3.1 (System Access & Security), Section 3.2 (User Management), Section 3.3 (Menu & Category Management), Section 3.4 (Voucher Management). |
| 2026-06-18 | A | Software Engineering Team | Iteration B cont.: Section 3.5 (Customer & Membership), Section 3.6 (Inventory & Stock), Section 3.7 (POS Transaction), Section 3.8 (Order Management). |
| 2026-06-18 | A | Software Engineering Team | Iteration B cont.: Section 3.9 (Staff Management), Section 3.10 (Reports & Analytics), Section 3.11 (System Configuration & Branch Management). |
| 2026-06-18 | M | Software Engineering Team | Simplified Section 1.2 Package Diagram to follow the core MVC 6-package structure (bean, view, controller, filter, dao, util). |
| 2026-06-18 | M | Software Engineering Team | Rebuilt Section 2 (Database Design) ERD to display full column definitions (PK, FK, types) inside each entity, matching Visual Paradigm format. Restored all 21 SRS entities with exact columns from SRS §3.1.6. |
| 2026-06-18 | M | Software Engineering Team | Split Section 2 Database Design ERD into 2 diagrams (Core Sales & POS, Operations/Staffing/Audit) to prevent cluttering and improve readability. |
| 2026-06-18 | M | Software Engineering Team | Translated Section 2.1 & 2.2 titles/descriptions to English and unified font formatting (monospace inline code blocks) for database tables, columns, PK, FK, enums, data types, and roles. |
| 2026-06-18 | M | Software Engineering Team | Standardized Section 1.2 Package Diagram to UML package diagram conventions (Visual Paradigm style), organizing 18 subsystems into structured tiers with explicit dependency stereotypes (use, import, access). |
| 2026-06-18 | M | Software Engineering Team | Standardized all 4 Statechart diagrams (USER, VOUCHER, SHIFT, ORDER lifecycles) to UML-compliant syntax matching Visual Paradigm layout (Trigger [Guard] / Action format). |
| 2026-06-18 | M | Software Engineering Team | Standardized all 32 Sequence diagrams to UML method signature conventions, converting free-text labels to formal API/event operation calls. |
| 2026-06-18 | M | Software Engineering Team | SRS-consistency review fixes: corrected mis-mapped use-case numbers in section/sequence titles (UC-51/53 in §3.7, UC-55 cancel in §3.8, UC-49 redeem in §3.5, UC-76/77 in §3.10, dropped wrong UC-66/UC-73 labels); fixed wrong business-rule citations (BR-11/42/54/68/81/88) across §3.1/3.2/3.4/3.7/3.10/3.11 and the Package Diagram. |
| 2026-06-18 | M | Software Engineering Team | Reconciled class diagrams to the 21-table schema: removed non-schema attributes (Customer.birthDate/isActive, StockItem.unit, Order.notes, StockTransaction before/after) and aligned types (pos_register_id String, OrderRefund.shift_session_id added). Standardized enums to SRS (payment_status COMPLETED not PAID; audit action_type UPDATE; voucher state SCHEDULED). |
| 2026-06-18 | M | Software Engineering Team | Closed business-logic gaps: USER lockout 15-min auto-clear (BR-11); ORDER READY→ABANDONED via timeout + SM force-close (BR-88); SM cash-refund debits open drawer + loyalty reversal (BR-09/BR-08/BR-67); branch deactivation checks non-terminal orders + cascade (BR-55/BR-56). Documented `SystemConfig` as an infrastructure key-value store outside the 21-entity business ERD. |
|  |  |  |  |

\*A – Added   M – Modified   D – Deleted
