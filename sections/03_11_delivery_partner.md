# 3.11 Delivery Partner Revenue Integration

This section details specifications for background sales and revenue synchronization from third-party delivery partners.

---

## 3.11.1 F50 - Consolidated Revenue Integration / UC-67 Fetch Delivery Partner Sales

### 3.11.1.1 Use Case Description

| Use Case ID | UC-67 | Use Case Name | Fetch Delivery Partner Sales |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.2 |
| **Date** | 2026-06-02 | | |

| Field | Description |
|---|---|
| **Actor** | System (automated) |
| **Description** | Automatically fetches daily consolidated revenue and sales figures from delivery partner APIs. |
| **Precondition** | Secure API integration keys/tokens are configured in the system settings. |
| **Trigger** | Nightly scheduler runs automatically at 23:00. |
| **Post-Condition** | Consolidated sales data is stored and displayed on the HQ consolidated dashboards. |

#### Main Flows (Fetch and Store Consolidated Sales)
| Step | Actor | Action |
|---|---|---|
| 1 | System | Initiates secure API requests to registered delivery partners (e.g. GrabFood, ShopeeFood). |
| 2 | System | Authenticates requests using configured access tokens (BR-60). |
| 3 | System | Receives sales payloads containing daily consolidated transaction counts, item quantities, and gross totals. |
| 4 | System | Processes and saves records into the reporting database, mapping sales figures to corresponding physical store branches. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-60 | **Delivery Partner Authentication**: All outbound requests to delivery partner endpoints must include valid, encrypted authorization headers generated from active integration keys configured by HQ Admin. |
| BR-61 | **Data Reconciliation**: Consolidated delivery sales records are flagged as external transactions. They bypass local drawer cash calculations and shift session totals, but are included in store performance reports. |

---

## 3.11.2 Error Handling & Retry Policy
- **Connection Timeout**: If a delivery partner API does not respond within 15 seconds, the request times out.
- **Retry Schedule**: Failed synchronization requests are retried every hour up to 3 times. If all retries fail, a system alert is sent to the Admin dashboard and logged.
