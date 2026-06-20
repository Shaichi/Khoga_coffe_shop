### **1.2 Package Diagram**

*\[The overall package diagram shows the decomposition of the system into 18 subsystems (packages). Each package follows the COMET Information Hiding principle, encapsulating its own controller, service, repository, and domain components. The Spring Boot backend is organized under the root package `com.khoga.coffeeshop`. The web frontend uses Thymeleaf templates in `src/main/resources/templates/`. The Flutter application is a separate project `khoga_pos_app/`.\]*

```mermaid
graph TB
    %% Khoga Coffee Shop - Layered Application Package Diagram
    
    subgraph LAYERED["Layered Application"]
        
        subgraph PRESENTATION["Presentation Layer"]
            WEBUI["📁 templates (Web Admin)"]
            FLUTTER["📁 khoga_pos_app (Flutter)"]
        end

        subgraph BUSINESS["Business Layer (Services & Logic)"]
            AUTH["📁 auth"] ~~~ USER["📁 user"] ~~~ CATALOG["📁 catalog"]
            VOUCHER["📁 voucher"] ~~~ CUSTOMER["📁 customer"] ~~~ INVENTORY["📁 inventory"]
            POS["📁 pos"] ~~~ ORDER["📁 order"] ~~~ STAFF["📁 staff"]
            REPORT["📁 report"] ~~~ BRANCH["📁 branch"]
            
            %% Core Business Dependencies
            POS -.->|"<<access>>"| CATALOG
            POS -.->|"<<access>>"| VOUCHER
            POS -.->|"<<access>>"| CUSTOMER
            ORDER -.->|"<<access>>"| POS
            INVENTORY -.->|"<<access>>"| CATALOG
        end

        subgraph DATA["Data Layer"]
            COMMON["📁 common (Entities & Repositories)"]
        end

        subgraph CROSS_CUTTING["Cross Cutting & Infrastructure"]
            AUDIT["📁 audit"]
            INTEGRATION["📁 integration"]
            SCHEDULER["📁 scheduler"]
            CONFIG["📁 config"]
        end
        
    end

    %% Force Vertical Alignment for Layers
    PRESENTATION ~~~ BUSINESS ~~~ DATA

    %% Layer-to-Layer & Cross-Cutting Dependencies
    PRESENTATION -.->|"<<access>>"| BUSINESS
    BUSINESS -.->|"<<import>>"| DATA
    
    %% Specific Cross-Cutting relationships
    BUSINESS -.->|"<<import>>"| INTEGRATION
    BUSINESS -.->|"<<access>>"| AUDIT
    BUSINESS -.->|"<<access>>"| CONFIG
    SCHEDULER -.->|"<<access>>"| BUSINESS
    
    %% Cross-Cutting to Data
    CROSS_CUTTING -.->|"<<import>>"| DATA

    %% Visual Styling
    classDef package fill:#e3f2fd,stroke:#0d47a1,stroke-width:1.5px,color:#0d47a1;
    classDef layer fill:#f8f9fa,stroke:#495057,stroke-width:2px,color:#212529,stroke-dasharray: 5 5;
    classDef mainLayer fill:#e9ecef,stroke:#adb5bd,stroke-width:2px;

    class WEBUI,FLUTTER,AUTH,USER,CATALOG,VOUCHER,CUSTOMER,INVENTORY,POS,ORDER,STAFF,REPORT,BRANCH,COMMON,AUDIT,INTEGRATION,SCHEDULER,CONFIG package;
    class PRESENTATION,BUSINESS,DATA,CROSS_CUTTING layer;
    class LAYERED mainLayer;
```

***Package Descriptions***

| No | Package | Description |
| :---: | ----- | ----- |
| 01 | `com.khoga.auth` | Authentication subsystem. Manages JWT token lifecycle, MFA (Email OTP), and password policy enforcement. Contains `AuthController` («boundary»), `AuthService` («control»), `JwtTokenProvider`, `MfaService`, `OtpService` («application logic»). Coordinates UC-01→UC-06. |
| 02 | `com.khoga.user` | User account management for ssadmin. Contains `UserController` («boundary»), `UserService` («control»), `PasswordPolicyValidator` («application logic»). Coordinates UC-10→UC-14. |
| 03 | `com.khoga.catalog` | Chain-wide menu catalog: menu items, categories, option toppings, raw material master catalog, and recipe formulation. Contains controllers and services for Menu, Category, Topping, RawMaterial, Recipe. Coordinates UC-15→UC-19, UC-68→UC-74. |
| 04 | `com.khoga.voucher` | Promotional voucher CRUD and checkout validation. Contains `VoucherController` («boundary»), `VoucherService` («control»). Coordinates UC-20→UC-23. |
| 05 | `com.khoga.customer` | Customer CRM registry and loyalty point calculation. Contains `CustomerController` («boundary»), `CustomerService` («control»), `LoyaltyPointService` («application logic»). Coordinates UC-24→UC-27, UC-49. |
| 06 | `com.khoga.inventory` | Branch stock management: import, export, physical audit, and recipe-based automatic stock deduction when orders transition to PREPARING. Contains `StockController` («boundary»), `StockService` («control»), `RecipeDeductionService` («application logic»). Coordinates UC-31→UC-34, UC-61, UC-62. |
| 07 | `com.khoga.pos` | POS terminal management: shift open/close, full checkout pipeline (cart building, discount/voucher/loyalty application), VietQR payment integration, shift cash reconciliation. Contains `PosController` («boundary»), multiple service classes («control»), `DiscountStackingService`, `ShiftReconciliationService` («application logic»). Coordinates UC-44→UC-55, UC-75. |
| 08 | `com.khoga.order` | Order lifecycle: queue display, barista status update, cashier cancellation (PENDING only), SM-authorized refund/comp. Contains `OrderController` («boundary»), `OrderService`, `OrderQueueService`, `CancellationService`, `RefundService` («control»). Coordinates UC-55→UC-60, UC-73, UC-75. |
| 09 | `com.khoga.staff` | Staff scheduling and attendance tracking. Schedule CRUD by storemanager. Attendance check-in with PIN + camera photo (PDPA-compliant BR-72). Worked-hours export. Contains schedule/attendance controllers and services, `AttendancePhotoManager` («application logic»). Coordinates UC-35→UC-39, UC-66, UC-80. |
| 10 | `com.khoga.report` | All reporting and analytics: HQ consolidated dashboard, COGS/margin, price change history, loyalty liability, labour efficiency, Z-report archive, anomaly detection. Contains `ReportController` («boundary»), multiple report service classes («application logic»). Coordinates UC-28→UC-29, UC-40→UC-41, UC-76→UC-83. |
| 11 | `com.khoga.branch` | Branch lifecycle management: add, edit, deactivate. Enforces MAX_ACTIVE_BRANCHES constraint (BR-54). Contains `BranchController` («boundary»), `BranchService` («control»). Coordinates UC-63→UC-65. |
| 12 | `com.khoga.config` | Central system configuration (tax rate, loyalty rates, VietQR credentials) managed by ssadmin, and branch-local overrides by storemanager. Contains `ConfigController` («boundary»), `SystemConfigService` («control»). Coordinates UC-30, UC-42. |
| 13 | `com.khoga.audit` | Immutable audit log service auto-triggered by @EntityListeners for: price changes, voucher mutations, user account changes, checkout voucher/loyalty usage. Contains `AuditLogService`. Supports BR-68, BR-80, BR-81. |
| 14 | `com.khoga.integration` | External system adapters («boundary» external proxies): `VietQRClient` + `VietQRSettlementHandler` (payment gateway), `EmailService` (SMTP OTP/alerts), `PrinterService` (ESC/POS receipt and cup label). |
| 15 | `com.khoga.common` | Shared persistence layer: all 21 JPA `@Entity` classes, `@Repository` interfaces, request/response DTOs, custom exceptions, `@ControllerAdvice`, and input validators. Classified as «entity» (data) subsystem. |
| 16 | `com.khoga.scheduler` | Spring `@Scheduled` background timer tasks («timer» subsystem): `OrderTimeoutScheduler` (READY→ABANDONED after `READY_ABANDON_TIMEOUT`, BR-88), `ShiftAutoCloseScheduler` (23:59 cron, BR-88), `LowStockAlertScheduler` (22:00 cron), `OtpExpiryScheduler` (10-min), `PhotoAutoDeleteScheduler` (02:00 cron — PDPA BR-72). |
| 17 | `src/main/resources/templates/` | Thymeleaf server-side rendered web frontend for HQ Admin Portal and Store Manager Console. Views are rendered by Spring MVC controllers and delivered as HTML. Static assets (CSS/JS/images) reside in `src/main/resources/static/`. Classified as «boundary» (UI Web) subsystem. |
| 18 | `khoga_pos_app/` | Flutter application for POS Terminal and Barista Queue Monitor. Communicates via `dio` HTTP client over HTTPS/JSON. Always-online; requires active network connection to process transactions. Classified as «boundary» (UI Flutter) subsystem. |

***Subsystem-level Package Diagram***

*\[A typical backend subsystem (e.g., `com.khoga.auth`, `com.khoga.inventory`) follows the package structure diagram below, encapsulating its controller, service, repository, and model packages. This organization isolates the data access, business coordination, and interface boundary logic inside each package, conforming to the COMET information hiding principles.\]*

```mermaid
graph TB
    subgraph SUBSYSTEM["📁 com.khoga.[subsystem]"]
        direction TB
        CTRL["📁 controller<br/>(Boundary - RestControllers)"]
        SVC["📁 service<br/>(Control & Application Logic)"]
        REPO["📁 repository<br/>(Entity - JPA Repositories)"]
        MODEL["📁 model<br/>(Entity - JPA Entities & DTOs)"]

        CTRL -.->|"<<use>>"| SVC
        SVC -.->|"<<use>>"| REPO
        REPO -.->|"<<access>>"| MODEL
        CTRL -.->|"<<access>>"| MODEL
        SVC -.->|"<<access>>"| MODEL
    end
```

***Package and Class Naming Conventions***

| Stereotype / Element | Package / Location | Naming Pattern / Suffix | Examples | Description |
| :--- | :--- | :--- | :--- | :--- |
| **Subsystem Package** | `com.khoga.*` | Lowercase singular/plural nouns representing functional domains. | `com.khoga.auth`, `com.khoga.inventory`, `com.khoga.pos` | Flat package layout grouping all domain-specific EBC classes together. |
| **«boundary» (API)** | `com.khoga.*.controller` | `[Feature]Controller` | `AuthController`, `PosController`, `OrderController` | Spring Boot `@RestController` mapping endpoints under `/api/v1/`. |
| **«boundary» (UI Web)** | `src/main/resources/templates/` | `[Feature/Role]_[Action].html` or PascalCase widgets | `login_web.html`, `materials_web.html`, `branch_add_web.html` | Thymeleaf templates for server-side rendered admin portals. |
| **«boundary» (UI Flutter)** | `khoga_pos_app/` | `[Feature][Form/Grid/Monitor]` in PascalCase | `LoginForm`, `PosCheckoutGrid`, `BaristaQueueMonitor` | Flutter UI widgets for cashier and barista terminals. |
| **«boundary» (External Proxy)** | `com.khoga.integration` | `[Service]Client` or `[Service]ServiceProxy` | `VietQRClient`, `EmailService`, `PrinterService` | External service integration gateways and adapters. |
| **«control» (Service)** | `com.khoga.*.service` | `[Feature]Service` or `[Feature]Coordinator` | `AuthService`, `UserService`, `UserManagementCoordinator` | Spring `@Service` managing transactions and workflow orchestration. |
| **«application logic»** | `com.khoga.*.service` | `[Feature][Engine/Calculator/Validator/Manager]` | `DiscountStackingEngine`, `LoyaltyPointCalculator`, `PasswordPolicyValidator`, `AttendancePhotoManager` | Stateless helper components containing pure business calculations or validations. |
| **«entity» (JPA Entity)** | `com.khoga.common` (mapped in `com.khoga.*.model`) | PascalCase singular nouns matching database tables | `User`, `MenuItem`, `StockTransaction`, `AuditLog` | `@Entity` classes representing the database relational schema. |
| **«entity» (Repository)** | `com.khoga.common` (mapped in `com.khoga.*.repository`) | `[EntityName]Repository` | `UserRepository`, `MenuItemRepository`, `StockItemRepository` | `@Repository` interfaces extending Spring Data JPA repositories. |
| **«timer» (Scheduler)** | `com.khoga.scheduler` | `[Task]Scheduler` or `[Task]Timer` | `OrderTimeoutScheduler`, `ShiftAutoCloseScheduler`, `OtpExpiryTimer` | Spring `@Scheduled` background timers handling automated cron jobs. |
