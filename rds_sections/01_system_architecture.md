## **1\. System Design**

### **1.1 System Architecture**

*\[The content of this section includes the overall diagram which includes the sub-systems, the external systems, and the relationship/connection among them. The explanation for each of the diagram components (modules, sub-systems, external systems, etc.) is provided in the component descriptions table below. The system adopts a 4-Tier MVC architecture combined with COMET EBC (Entity–Boundary–Control) design method.\]*

```mermaid
graph TB
    subgraph PRESENTATION["PRESENTATION TIER"]
        direction LR
        subgraph WEB["HTML + JavaScript"]
            HQ["HQ Admin Portal (ceoviewer / businessadmin / ssadmin)"]
            MGR["Store Manager Console (storemanager)"]
        end
        subgraph FLUTTER["Flutter (Dart)"]
            POS["POS Terminal (cashier)"]
            BAR["Barista Queue Monitor (barista)"]
        end
    end

    subgraph APP["APPLICATION TIER — Spring Boot 3.x (Java 17+)"]
        direction TB
        CTRL["RestController Layer (API Gateway)"]
        SVC["Service Layer (Business Logic Coordinators)"]
        LOGIC["Application Logic Components (Business Rules)"]
        SCHED["Scheduled Tasks (Background Timers)"]
    end

    subgraph DOMAIN["DOMAIN TIER — JPA @Entity (21 entities)"]
        ENT["JPA Domain Entities"]
        REPO["@Repository Interfaces — Spring Data JPA"]
    end

    subgraph DB["DATABASE TIER"]
        MYSQL["MySQL 8.x — 21 tables — InnoDB — utf8mb4"]
    end

    subgraph EXT["EXTERNAL SYSTEMS"]
        VIETQR["VietQR Payment Gateway (REST callback)"]
        EMAIL["SMTP Email Server (OTP / Alerts)"]
        PRINTER["ESC/POS Receipt and Label Printer (USB/Network)"]
    end

    WEB -->|"HTTPS/JSON /api/v1/"| CTRL
    FLUTTER -->|"HTTPS/JSON /api/v1/"| CTRL
    CTRL --> SVC
    SVC --> LOGIC
    SVC --> SCHED
    SVC --> ENT
    ENT --> REPO
    REPO --> MYSQL
    CTRL -->|"REST webhook"| VIETQR
    SVC -->|"SMTP"| EMAIL
    APP -->|"ESC/POS"| PRINTER
```

***Diagram Component Descriptions***

| No | Component | COMET Type | Description |
| :---: | ----- | ----- | ----- |
| 01 | HTML + JavaScript Web Frontend | «boundary» (UI) | Web frontend for HQ Admin Portal (roles: ceoviewer, businessadmin, ssadmin) and Store Manager Console (role: storemanager). Communicates with backend via REST API calls over HTTPS/JSON. |
| 02 | Flutter (Dart) Mobile/Tablet App | «boundary» (UI) | Mobile/tablet frontend for POS Terminal (role: cashier) and Barista Queue Monitor (role: barista). Supports offline mode via sqflite SQLite for cash-only transactions (BR-86). |
| 03 | @RestController Layer | «boundary» (API Gateway) | Spring Boot REST controllers. Receive HTTP requests, validate inputs using Bean Validation, apply JWT authentication, and delegate to @Service layer. All endpoints prefixed `/api/v1/`. |
| 04 | @Service Layer | «control» (Coordinator) | Business logic orchestration. Each service coordinates domain entities, calls application logic components, and manages transactions via @Transactional. |
| 05 | Application Logic Components | «application logic» | Stateless business rule engines: DiscountStackingEngine (BR-70), RecipeDeductionEngine (BR-89), LoyaltyPointCalculator, COGSCalculator, AnomalyDetector, AttendancePhotoManager (PDPA). |
| 06 | @Scheduled Tasks | «timer» | Spring @Scheduled background timers: OrderTimeoutTimer (15 min), ShiftAutoCloseTimer (23:59 cron), LowStockAlertTimer (22:00 cron), PhotoAutoDeleteTimer (02:00 cron — PDPA 90-day purge BR-72), OtpExpiryTimer (10 min). |
| 07 | @Entity / @Repository (Domain Tier) | «entity» | 21 JPA domain entities mapped to MySQL 8.x tables via Spring Data JPA repositories. All PK are UUID VARCHAR(36). |
| 08 | MySQL 8.x | Database | Relational database with InnoDB engine, ACID transactions, utf8mb4 charset. 21 tables. |
| 09 | VietQR Payment Gateway | External System | Vietnamese QR payment provider. Integrated via REST webhook callback with idempotency key (orderId) to prevent duplicate charges (BR-84/BR-85). |
| 10 | SMTP Email Server | External System | Email delivery service for: OTP delivery (BR-16), low stock daily alerts (22:00), and welcome email for new staff accounts. |
| 11 | ESC/POS Printer | External System | Receipt and cup label printers connected via USB/Network to POS Terminal (Flutter) and Barista tablets. Triggered by PrinterServiceProxy after order completion. |

***COMET EBC Stereotype → Spring Boot MVC Mapping***

| COMET Stereotype | Spring Boot Implementation | Examples |
| ----- | ----- | ----- |
| «boundary» (UI Screen) | View: HTML/JS pages, Flutter Widgets | LoginForm, PosCheckoutGrid, BaristaQueueMonitor |
| «boundary» (API Endpoint) | Controller: @RestController | AuthController, OrderController, PosController |
| «boundary» (External Proxy) | Adapter: RestTemplate / WebClient | VietQRClient, EmailService, PrinterService |
| «control» (Coordinator) | Service: @Service (business orchestration) | AuthService, CheckoutService, OrderQueueService |
| «application logic» (Engine) | Component: @Component (pure business rules) | DiscountStackingEngine, RecipeDeductionEngine |
| «entity» (Domain Object) | Model: @Entity + @Repository | User, Order, MenuItem, StockItem, AuditLog |
| «timer» (Scheduled Task) | Scheduler: @Scheduled / @Async | OrderTimeoutScheduler, ShiftAutoCloseScheduler |
