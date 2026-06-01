# 4. Non-Functional Requirements

This section describes system behaviors, attributes, constraints, and external interface properties that the Coffee Shop Management System must satisfy.

## 4.1 External Interfaces

This section provides information to ensure that the system will communicate properly with users and with external hardware or software/system elements.

### 4.1.1 User Interfaces
- **POS Terminal**: Touchscreen-optimized interface designed for high-speed cashier operations. Form layouts, buttons, and checkout workflows must fit fully on a single screen without vertical or horizontal scrolling.
- **Admin & Manager Portals**: Web-based responsive dashboards with clear menus, tables, and forms, supporting dark/light mode toggles and structured navigation grids.

### 4.1.2 Hardware Interfaces
- **POS Receipt Printer**: Connection via standard USB port or local network port using receipt print formatting.
- **Barista Label Sticker Printer**: Connection via USB or network port to print beverage and item sticker details.
- **POS Cash Drawer**: Placed in the cashier area, connected directly to the POS receipt printer via standard ports, popping open automatically upon cash transactions validation.

### 4.1.3 Software & API Interfaces
- **Payment Gateways**: API integration with bank systems (dynamic VietQR bank transfers) and payment services to receive instant payment confirmations.
- **Third-Party Delivery APIs**: Webhook endpoints integration to receive orders and sync catalog menu availability details.

---

## 4.2 Quality Attributes

This section details the required system characteristics and quality standards.

### 4.2.1 Usability

This section includes all requirements affecting usability, user productivity, task efficiency, and usability standards.

- **User Training & Productivity**:
  - **Normal Users (Cashiers, Baristas)**: A normal user must be able to operate basic features (e.g., login, select item, apply voucher, payment, or update preparation queue) productively after **less than 15 minutes** of training.
  - **Power Users (Store Managers, HQ Admins)**: A power user must be able to perform scheduling, inventory logs, and view sales metrics productively after **less than 1 hour** of training.
- **Measurable Task Times (Typical Tasks)**:
  - **POS checkout**: Cashier selects items, applies loyalty lookup, and opens payment options: **under 15 seconds** (typical task time).
  - **Menu lookup**: Filtering menu catalog items: **under 1 second**.
  - **Generate local reports**: Loading sales summaries on screen: **under 2 seconds**.
- **Usability Standards**:
  - All touchscreen interfaces must conform to standard touchscreen usability guidelines, with interactive buttons measuring at least **48x48 pixels** to prevent accidental clicks.
  - Form fields must feature inline validation messages and keyboard tabbing layouts in conformity with common desktop interface design standards.

### 4.2.2 Reliability

Requirements for system reliability, availability, fault tolerance, and bug rates.

- **Availability**:
  - **System Availability**: The cloud system and APIs must maintain at least **99.9% uptime** over a 24/7/365 operational schedule.
  - **Maintenance Access**: System maintenance must be scheduled during low-traffic periods (02:00 AM to 04:00 AM on Sundays) and must not exceed **2 hours** per month.
  - **Degraded Mode Operations (Offline POS)**:
    > [!IMPORTANT]
    > If the local store internet connection drops, the POS cashier terminal must continue to function. It will store orders locally in secure local storage.
    - Offline operations allow cash and card checkouts. Online wallet validation and live VietQR transfers are suspended.
    - Loyalty points redemptions and online voucher verifications are suspended; only preloaded local vouchers can be verified.
    - Synchronizing queued offline orders to the cloud database must trigger automatically within **60 seconds** after internet connection recovery.
- **Mean Time Between Failures (MTBF)**:
  - The MTBF for POS client applications must be at least **8,000 hours** of continuous run-time.
  - The MTBF for server-side components must be at least **10,000 hours**.
- **Mean Time To Repair (MTTR)**:
  - In the event of a system failure, the MTTR for critical cloud services must be **under 2 hours**.
  - The MTTR for cashier hardware errors at a branch (e.g., POS printer failure) must be **under 15 minutes** using backup local devices.
- **Accuracy**:
  - All monetary and pricing calculations must be 100% accurate, rounded to the nearest integer for VND currency values.
  - Loyalty point accrual must calculate to exactly two decimal places before being rounded down to the nearest integer.
- **Maximum Bug & Defect Rate**:
  - The software release must not exceed **0.5 bugs per thousand lines of code (KLOC)** prior to deployment.
- **Defect Severity Categorization**:
  - **Minor**: Minor alignment issues, spelling typos, or cosmetic errors.
  - **Significant**: A functional feature has a workaround but doesn't block the core sales path (e.g., optional image thumbnail not displaying).
  - **Critical**: Defect causing complete data loss, security breach, or total inability to use core system features (e.g., POS checkout not responding, login page crashing). No critical bugs are permitted in production releases.

### 4.2.3 Performance

The system's performance characteristics, transaction response times, and capacity metrics.

- **Transaction Response Times**:
  - **UC-01 Login**: Average response time **under 1.0 second**, maximum response time **under 3.0 seconds**.
  - **UC-45 Add Item to Order**: Adding catalog items to POS checkout cart must respond in **under 100 milliseconds**.
  - **UC-51 Process Payment**: Processing cash checkout or starting QR code display must respond in **under 1.5 seconds**, with payment gateway callback validation in **under 5.0 seconds**.
  - **UC-28 View Consolidated Business Reports**: Central report compilation and display must load in **under 2.0 seconds** average, **under 5.0 seconds** maximum.
- **Throughput**:
  - The backend APIs must handle a minimum throughput of **100 transactions per second (TPS)** globally without degradation.
- **Capacity**:
  - The system must accommodate up to **5 branches** and **100 concurrent active cashier POS sessions**.
  - The central database must handle up to **10,000 daily order transactions**.
- **Resource Utilization**:
  - **POS client memory**: The active application must consume **less than 512MB RAM** on terminal devices.
  - **Local storage disk footprint**: Local cached orders and master catalog data must require **less than 2GB of disk storage**.
  - **Network bandwidth**: API communications must be compressed, consuming **less than 10KB of payload data** per standard order transaction.

### 4.2.4 Security & Compliance
- **Data Encryption**: All network traffic must run over HTTPS using TLS 1.3 protocol. Passwords must be securely hashed before being saved.
- **Session Tokens & Silent Refresh**: 
  - Expiration limits of 8 hours for cashiers/baristas and 2 hours for administrators.
  - To prevent active cashiers from being logged out mid-shift, a background token refresh request executes every time the token has less than 30 minutes of remaining validity, provided there is active user interaction. If the user is idle for more than 30 minutes, they will be automatically logged out.
- **Access Control**: Strict role-based access control (RBAC) enforced on all resource endpoints. Unauthorised attempts to access administrative features will return access denied errors.

### 4.2.5 Scalability
- The system architecture must support horizontal scaling to accommodate up to **5 branches** without requiring architectural redesign.
- A single branch deployment must handle a minimum of **500 transactions per day** and **50 concurrent active users** without performance degradation.

### 4.2.6 Data Retention & Archival
- **Transaction Records** (Orders, Payments): Retained for a minimum of **5 years** to comply with financial audit requirements.
- **Audit Logs**: Retained for a minimum of **2 years**.
- **Shift Sessions**: Retained for **1 year**, then archived to cold storage.
- Data older than retention limits may be archived to a read-only cold storage tier and will not appear in active reports.

### 4.2.7 Backup & Disaster Recovery
- **Recovery Point Objective (RPO)**: Maximum data loss tolerance is **1 hour**. Automated database backups must run every 60 minutes.
- **Recovery Time Objective (RTO)**: System must be restorable and operational within **4 hours** of a declared disaster event.
- Backups must be stored in a geographically separate location from the primary server.

### 4.2.8 Browser & Device Support
- **Admin Dashboard**: Must support the latest two stable versions of Google Chrome, Mozilla Firefox, and Microsoft Edge on Windows/macOS desktop.
- **POS Terminal & Mobile Application**: Built using Flutter, supporting:
  - Android mobile and tablet devices (Android 9.0 / API 28 and above).
  - iOS mobile and tablet devices (iOS 14.0 and above).
  - Windows 10+ for desktop touchscreen terminals.
- **Minimum Screen Resolution**:
  - Mobile (Portrait): 720×1280px.
  - Tablet (Landscape): 1280×800px.
  - Desktop Terminal: 1366×768px.
