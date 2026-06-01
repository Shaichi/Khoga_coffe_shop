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
   - **[3.3, 3.4 & 3.10: Menu, Categories & Promotions](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_3_menu_category_promotion.md)**: Menu catalog, modifier groups, categories, and vouchers.
   - **[3.5 & 3.9: Inventory & Staff Management](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_5_inventory_staff.md)**: Stock import/export/audit, shift schedules, and attendance.
   - **[3.6 & 3.7: POS Transactions & Orders](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_6_pos_order_transaction.md)**: Cash drawer sessions, payments, invoicing, order queues, and stickers.
   - **[3.8, 3.11 & 3.12: Customer CRM, Delivery Webhooks & Dashboards](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_8_customer_delivery_dashboard.md)**: Membership point tiers, GrabFood/ShopeeFood integrations, revenue reports.
   - **[3.13: System Configuration](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/03_13_system_configuration.md)**: Store info settings, taxation settings, hardware printers.

4. **[Section 4: Non-Functional Requirements](file:///C:/Users/pc/.gemini/antigravity-ide/scratch/coffee_shop_srs/sections/04_non_functional_requirements.md)**
   - External Interfaces (Hardware details & APIs)
   - Quality Attributes (Usability, Performance, Security)
   - **Offline POS Resilience Mode** (Offline local caching & auto-syncing)

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
