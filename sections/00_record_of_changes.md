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

# Table of Contents

1. [Product Overview](#1-product-overview)
   - 1.1 Product Purpose & Objectives
   - 1.2 Product Scope
   - 1.3 System Context Diagram

2. [User Requirements](#2-user-requirements)
   - 2.1 Actors
   - 2.2 Use Cases
     - 2.2.1 General User & Authentication Use Cases
     - 2.2.2 Admin Use Cases
     - 2.2.3 Store Manager Use Cases
     - 2.2.4 Cashier Use Cases
     - 2.2.5 Barista Use Cases

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
     - 3.5.1 View Stock List
     - 3.5.2 Import Stock (Nhập kho)
     - 3.5.3 Export Stock (Xuất kho)
     - 3.5.4 View Import/Export History
     - 3.5.5 Perform Inventory Audit (Kiểm kho)
     - 3.5.6 Low Stock Alert
     - 3.5.7 Automated Recipe-Based Stock Deduction

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
     - 3.7.3 Update Order Status
     - 3.7.4 Print Drink Label (Sticker)
     - 3.7.5 View Order Queue Display
     - 3.7.6 Cancel Order
     - 3.7.7 Export Order List

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

   - **3.10 Promotion & Campaign Management**
     - 3.10.1 List Voucher / Promotion
     - 3.10.2 Add Voucher / Promotion
     - 3.10.3 Update/Delete Voucher / Promotion

   - **3.11 Delivery Partner Revenue Integration**
     - 3.11.1 Consolidated Revenue Integration
     - 3.11.2 Error Handling & Retry Policy

   - **3.12 Dashboard & Reporting**
     - 3.12.1 HQ Revenue Dashboard
     - 3.12.2 Export Report
     - 3.12.3 Store Revenue Reports

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

