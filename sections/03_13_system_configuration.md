# 3.13 System Configuration

This section details specifications for system settings, store branding profiles, taxation rules, invoice layouts, and local hardware connections.

---

## 3.13.1 F53 - Central System Settings / UC-30 Configure Central System Settings

### 3.13.1.1 Screen Mock-up (Desktop Landscape)
```
+---------------------------------------------------------------------------------+
| HQ Admin Portal > Central System Settings                                       |
+---------------------------------------------------------------------------------+
|  Brand Name:    [ Coffee Zone                  ]                                |
|  License Key:   [ CZ-2026-X892-K981            ] (Read-only)                    |
|  Currency:      [ VND (Vietnamese Dong)        ] (Read-only)                    |
|                                                                                 |
|  Global Tax & Invoice Settings:                                                 |
|  Default VAT:   [ 10.0         ] %                                              |
|  Header Title:  [ Welcome to Coffee Zone                                      ] |
|  Footer Message:[ Thank you! See you again.                                   ] |
|                                                                                 |
|                                                     [ Save Settings ] [ Cancel ] |
+---------------------------------------------------------------------------------+
```

#### Table 3-54: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Brand Name | Text | Yes | 100 | The name of the brand/HQ coffee shop. |
| 2 | License Key | Text | | | Software activation license key (read-only). |
| 3 | Currency | Text | | | Base currency system symbol (read-only). |
| 4 | Default VAT | Decimal | Yes | 5 | Percentage value for VAT rate calculation (0% to 20%). |
| 5 | Header Title | Text | Yes | 150 | Text printed at the top of POS receipts. |
| 6 | Footer Message | Text | Yes | 250 | Text printed at the bottom of POS receipts. |
| 7 | Save Settings | Button | | | Commits and saves global brand changes. |
| 8 | Cancel | Button | | | Discards edits and returns to dashboard home. |

### 3.13.1.2 Use Case Description

| Use Case ID | UC-30 | Use Case Name | Configure Central System Settings |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin |
| **Description** | Configures global parameters including brand name, tax rate, and receipt templates. |
| **Precondition** | Admin is logged in. |
| **Trigger** | Admin navigates to Central System Settings. |
| **Post-Condition** | Central configuration parameters are updated. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Admin | Updates the Brand Name, Default VAT, Header Title, or Footer Message. |
| 2 | Admin | Clicks "Save Settings". |
| 3 | Portal | Validates the input values. |
| 4 | Portal | Saves the updated configurations. |

#### Alternative Flows
##### AT1: Validation Errors
- **Trigger**: Admin inputs invalid values.

| Sub-step | Actor | Action |
|---|---|---|
| 3.1 | Portal | If Brand Name is empty, displays message: `"Brand name cannot be empty."` |
| 3.2 | Portal | If Default VAT is not between 0 and 20, displays message: `"VAT rate must be a numeric value between 0 and 20."` |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-45 | Default VAT rate must be between 0% and 20%. |
| BR-46 | Saving changes updates the receipt calculation engine and template layouts immediately. **VAT rate changes apply to new orders created after the save action. Orders already in progress (PENDING, PREPARING, READY) within the current shift session retain the VAT rate that was active when they were created.** |

---

## 3.13.2 F54 - Branch Local Settings / UC-42 Configure Local Branch Settings

### 3.13.2.1 Screen Mock-up (Mobile Portrait)
```
+------------------------------------+
|       Branch Local Settings        |
|                                    |
|  Branch Name                       |
|  [ Coffee Zone - District 1      ] |
|                                    |
|  Timezone                          |
|  [ Asia/Ho_Chi_Minh           ][v] |
|                                    |
|  Hotline Phone                     |
|  [ 0283930001                    ] |
|                                    |
|  Email                             |
|  [ d1@coffeezone.vn              ] |
|                                    |
|  Address                           |
|  [ 123 Nguyen Hue, District 1... ] |
|                                    |
|  Logo Image                        |
|  [ Choose File ] (logo_d1.png)     |
|  [ x Delete Logo ]                 |
|                                    |
|  Hardware Configuration:           |
|  POS Printer IP/Port:              |
|  [ 192.168.1.150                 ] |
|         [ Test POS Printer ]       |
|                                    |
|  Kitchen Label IP/Port:            |
|  [ COM3                          ] |
|      [ Test Kitchen Printer ]      |
|                                    |
|  [ Save Settings ]  [ Cancel ]     |
+------------------------------------+
```

#### Table 3-55: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Branch Name | Text | Yes | 100 | Local name for the branch. |
| 2 | Timezone | Dropdown | Yes | | Standard timezone ID for local time conversions (e.g. `Asia/Ho_Chi_Minh`). |
| 3 | Hotline Phone | Text | Yes | 12 | The local contact phone number (10-12 digits). |
| 4 | Email | Text | Yes | 100 | The local email address (must be valid email format). |
| 5 | Address | Text | Yes | 200 | The physical address of the store branch. |
| 6 | Logo Image | File | No | | Upload logo image (formats: PNG, JPG; max 2MB). |
| 7 | POS Printer | Text | No | 50 | IP Address or COM port of POS printer. |
| 8 | Test POS Printer | Button | | | Sends test print slip to verification port. |
| 9 | Kitchen Label | Text | No | 50 | IP Address or COM port of kitchen drink sticker printer. |
| 10 | Test Kitchen Printer | Button | | | Sends test print sticker to kitchen printer. |
| 11 | Save Settings | Button | | | Commits and saves branch-specific changes. |
| 12 | Cancel | Button | | | Discards edits and returns to dashboard. |

### 3.13.2.2 Use Case Description

| Use Case ID | UC-42 | Use Case Name | Configure Local Branch Settings |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Store Manager |
| **Description** | Manages local branch contact details, timezone settings, and hardware devices. |
| **Precondition** | Store Manager is logged in. |
| **Trigger** | Store Manager navigates to Branch Local Settings. |
| **Post-Condition** | Local branch settings and device profiles are updated. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Store Manager | Modifies local contact details, address, or printer device attributes. |
| 2 | Store Manager | Clicks "Save Settings". |
| 3 | Portal | Validates inputs (e.g. hotline length, email structure). |
| 4 | Portal | Saves the updated branch-level configurations. |

#### Alternative Flows
##### AT1: Validation Errors
- **Trigger**: Store Manager inputs invalid contact info.

| Sub-step | Actor | Action |
|---|---|---|
| 3.1 | Portal | If Hotline is not 10-12 digits, displays message: `"Please enter a valid store hotline number."` |
| 3.2 | Portal | If Branch Name or Address is empty, displays message: `"Store name and address cannot be empty."` |
| 3.3 | Portal | If Email is invalid, displays message: `"Please enter a valid email address."` |

##### AT2: Hardware Connection Test
- **Trigger**: Store Manager clicks connection test.

| Sub-step | Actor | Action |
|---|---|---|
| 1 | Store Manager | Clicks "Test POS Printer" or "Test Kitchen Printer". |
| 2 | Portal | Sends print packet command to the configured IP/COM port. |
| 3 | Portal | If connection is successful, device prints slip: `"PRINTER CONNECTION OK"`. |
| 4 | Portal | If connection fails, displays message: `"Unable to connect to printer at [IP/Port]. Please check device power and connection."` |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-47 | Store Managers have access to configure branch settings. Admins also have permissions to view and update branch configurations. |
| BR-48 | Device configuration fields can accept TCP/IP addresses or Serial COM ports. |



