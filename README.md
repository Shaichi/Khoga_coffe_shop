# Software Requirements Specification (SRS) - Coffee Shop Management System

Welcome to the SRS document repository for the **Coffee Shop Management System**. This document specifies all functional and non-functional requirements of the system.

To facilitate collaboration and version control (aligned with the suggested group division), the SRS is split into modular sections.

## Document Directory (Modular Sections)

1. **[Section 1: Product Overview](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/01_product_overview.md)**
   - Objective & Purpose
   - System Scope (In-Scope & Out-of-Scope)
   - System Context Diagram (Mermaid)

2. **[Section 2: User Requirements](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/02_user_requirements.md)**
   - Actors & Roles
   - Use Case Diagrams (Mermaid)
   - Core Use Case Descriptions (Flows & Preconditions)

3. **Section 3: Software Features & Specifications**
   - **[3.1: Functional Overview](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_1_functional_overview.md)**: Screen Flow, Authorization matrix, ERD, and Entity schemas.
   - **[3.2: System Access & Security](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_2_system_access_security.md)**: Login, password recovery, profiles, and account management.
   - **[3.3: Menu Management](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_3_menu_management.md)**: Menu item size configurations and read-only manager access.
   - **[3.4: Category Management](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_4_category_management.md)**: Menu categories.
   - **[3.5: Inventory Management](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_5_inventory_management.md)**: Stock import/export/audit, and multi-line invoice imports.
   - **[3.6: POS Transactions](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_6_pos_transaction.md)**: Cash drawer sessions, payments, and invoicing.
   - **[3.7: Order Management](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_7_order_management.md)**: Order queues, status tracking, and simplified cancellation.
   - **[3.8: Customer CRM](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_8_customer_membership.md)**: Membership point tiers, points expiry rules.
   - **[3.9: Staff Management](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_9_staff_management.md)**: Staff profiles, schedules, and popup-based attendance.
   - **[3.10: Promotions & Vouchers](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_10_promotion_campaign.md)**: Campaigns and vouchers discount caps.
   - **[3.12: Dashboard Reporting](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_12_dashboard_reporting.md)**: Revenue reports.
   - **[3.13: System Configuration](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_13_system_configuration.md)**: Store info settings, taxation settings, hardware printers.

4. **[Section 4: Non-Functional Requirements](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/04_non_functional_requirements.md)**
   - External Interfaces (Hardware details & APIs)
   - Quality Attributes (Usability, Performance, Security)
   - System Reliability & Availability Attributes (SLA & scheduled maintenance details)

5. **[Section 5: Requirement Appendix & Mapping](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/05_appendix_mapping.md)**
   - Core Business Rules
   - Common Error & Success Messages
   - **Feature - Actor Mapping Matrix**

---

## Compiling into a Single Document

If you need a unified single-file markdown document (for printing, exporting to PDF, or sharing), we provide a helper python script:

1. Make sure you have python installed.
2. Run the compiler script:
   ```bash
   python compile_srs.py
   ```
3. A single file named `srs_document_full.md` will be generated in the root of this folder containing the entire compiled document in sequential order.
