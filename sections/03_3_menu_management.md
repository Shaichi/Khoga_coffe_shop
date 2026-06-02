# 3.3 Menu Management

This section details specifications for viewing, adding, updating, and deactivating menu items and optional toppings.

---

## 3.3.1 F13 - View Menu Item List / UC-15 View Menu & Categories List

### 3.3.1.1 Screen Mock-up (Desktop Landscape)
```
+---------------------------------------------------------------------------------+
| HQ Admin Portal > Menu Management                                               |
+---------------------------------------------------------------------------------+
|  Search: [ Espresso            ]   Category: [ All Categories ] [v]             |
|                                                                                 |
|  +-----+-------------------+-----------------+------------+------------------+  |
|  | ID  | Product Name      | Category        | Price      | Availability     |  |
|  +-----+-------------------+-----------------+------------+------------------+  |
|  | 001 | Espresso          | Coffee          | 30,000 VND | Available        |  |
|  | 002 | Peach Tea         | Tea             | 35,000 VND | Out of Stock     |  |
|  +-----+-------------------+-----------------+------------+------------------+  |
|  [Page 1 of 3]                                            [ + Add Menu Item ]  |
+---------------------------------------------------------------------------------+
```

#### Table 3-14: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Search | Text | No | 100 | Filter catalog items by product name or code. |
| 2 | Category | Dropdown | No | | Filter catalog items by selected product category. |
| 3 | Menu Grid | Grid | | | Displays item listings including name, category, price, and status. |
| 4 | Add Menu Item | Button | | | Navigates to Add Menu Item view. |

### 3.3.1.2 Use Case Description

| Use Case ID | UC-15 | Use Case Name | View Menu & Categories List |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin, Cashier (POS View) |
| **Description** | Allows users to view the complete catalog of beverages and food items. |
| **Precondition** | User is logged in. |
| **Trigger** | User opens the product catalog list view. |
| **Post-Condition** | Complete list of active catalog items is displayed. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | User | Opens the Menu list screen. |
| 2 | Portal | Displays the complete menu catalog grid with pricing, categories, and status indicators. |
| 3 | User | Filters by category or searches by keyword query. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-24 | Items list shows search autocomplete results and real-time category filtering. |
| BR-25 | Availability states must indicate `Available` or `Out of Stock` based on active quantities or flags. |

---

## 3.3.2 F14 - View Menu Item Detail / UC-15 View Menu & Categories List

### 3.3.2.1 Screen Mock-up (Desktop Landscape Detail Card)
```
+---------------------------------------------------------------------------------+
| HQ Admin Portal > Menu Management > Item Details                                |
+---------------------------------------------------------------------------------+
|  Name: Espresso          Category: Coffee          Price: 30,000 VND            |
|  Barcode: 89311111111    Abbreviation: esp         Status: Available            |
|  Image: espresso.png                                                            |
|                                                                                 |
|  Description: Strong traditional black coffee...                                |
|  Recipe Formulation:                                                            |
|  - 18g Espresso Beans (Stock Item ID: STK-01)                                   |
|  Associated Toppings: Extra Shot, Milk Option.                                  |
|                                                                                 |
|                                                  [ Edit Item ]    [ Back ]      |
+---------------------------------------------------------------------------------+
```

#### Table 3-15: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Edit Item | Button | | | Navigates to Edit Menu Item view. |
| 2 | Back | Button | | | Returns to Menu Item List screen. |

### 3.3.2.2 Use Case Description

| Use Case ID | UC-15a | Use Case Name | View Menu Item Detail |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin |
| **Description** | Displays the detailed card of a specific menu item, including its ingredients recipe and options. |
| **Precondition** | Admin is logged in. |
| **Trigger** | Admin clicks on a specific product listing row. |
| **Post-Condition** | Product recipe details, unit cost, and toppings mappings are displayed. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Admin | Selects an item from the menu grid. |
| 2 | Portal | Displays detailed properties: pricing, description, abbreviation, custom toppings list, and recipe mappings. |

---

## 3.3.3 F15 - Add Menu Item / UC-18 Add Menu Item & Recipe

### 3.3.3.1 Screen Mock-up (Desktop Landscape)
```
+---------------------------------------------------------------------------------+
| HQ Admin Portal > Menu Management > Add Menu Item                               |
+---------------------------------------------------------------------------------+
|  Product Name:  [                              ]   Category: [ Coffee     ] [v] |
|  Base Price:    [ 35,000 VND                   ]   Barcode:  [ 8930000000000  ] |
|                                                                                 |
|  Description:                                                                   |
|  +---------------------------------------------------------------------------+  |
|  | Rich traditional Vietnamese drip coffee...                                |  |
|  +---------------------------------------------------------------------------+  |
|                                                                                 |
|  [ ] Available (Show on POS & Delivery Apps)                                    |
|  Image Upload:  [ Choose File ] (No file chosen)                                |
|                                                                                 |
|  Linked Toppings:                                                               |
|  [x] Extra Espresso Shot (+10k)    [ ] Oat Milk (+10k)    [ ] Tapioca (+5k)     |
|                                                                                 |
|                                [ Save Item ]    [ Cancel ]                      |
+---------------------------------------------------------------------------------+
```

#### Table 3-16: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Product Name | Text | Yes | 100 | Name of the food or beverage. |
| 2 | Category | Dropdown | Yes | | Category selection from existing categories list. |
| 3 | Base Price | Decimal | Yes | | Base sales price in VND. |
| 4 | Barcode | Text | No | 50 | Optional barcode for scanner check. |
| 5 | Description | Text | No | 500 | Description of the item. |
| 6 | Available | Checkbox | Yes | | Flag indicating if item is active for sale (Default: Checked). |
| 7 | Image Upload | File | No | | Upload item thumbnail (formats: png, jpg; max 2MB). |
| 8 | Linked Toppings | Checkboxes | No | | Selection list of modifiers allowed for this item. |
| 9 | Save Item | Button | | | Submits details and adds product to central catalog. |
| 10 | Cancel | Button | | | Returns to Menu Item List without saving. |

### 3.3.3.2 Use Case Description

| Use Case ID | UC-18 | Use Case Name | Add Menu Item & Recipe |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin |
| **Description** | Adds a new product to the central sales catalog. |
| **Precondition** | Admin is logged in. |
| **Trigger** | Admin clicks "+ Add Menu Item". |
| **Post-Condition** | New menu item registers in the system. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Admin | Enters Name, Base Price, Category, and checks associated toppings. Clicks "Save Item". |
| 2 | Portal | Validates uniqueness of product name and positive price. |
| 3 | Portal | Saves new item, auto-generates search abbreviation, and returns to menu list. |

#### Alternative Flows
##### AT1: Validation Errors
- **Trigger**: At step 2, price is non-positive or name duplicates an existing item.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"Price must be a positive number greater than zero."` or `"A menu item with this name already exists."` |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-26 | Abbreviation is automatically created based on first letters of words in the unsignified name (e.g. "Cà phê đá" -> "cfd") and updates if name is modified. |

---

## 3.3.4 F16 - Update Menu Item / UC-19 Update Menu Item & Recipe

### 3.3.4.1 Screen Mock-up (Desktop Landscape)
```
+---------------------------------------------------------------------------------+
| HQ Admin Portal > Menu Management > Edit Menu Item                              |
+---------------------------------------------------------------------------------+
|  Product Name:  [ Espresso                   ]   Category: [ Coffee     ] [v] |
|  Base Price:    [ 30,000 VND                 ]   Barcode:  [ 89311111111    ] |
|                                                                                 |
|  Description:                                                                   |
|  +---------------------------------------------------------------------------+  |
|  | Strong traditional black coffee...                                        |  |
|  +---------------------------------------------------------------------------+  |
|                                                                                 |
|  [x] Available (Show on POS & Delivery Apps)                                    |
|  Image Upload:  [ Choose File ] (espresso.png)                                  |
|                                                                                 |
|  Linked Toppings:                                                               |
|  [x] Extra Espresso Shot (+10k)    [ ] Oat Milk (+10k)    [ ] Tapioca (+5k)     |
|                                                                                 |
|                                [ Save Changes ]    [ Cancel ]                   |
+---------------------------------------------------------------------------------+
```

#### Table 3-17: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Product Name | Text | Yes | 100 | Name of the food or beverage. |
| 2 | Category | Dropdown | Yes | | Category selection. |
| 3 | Base Price | Decimal | Yes | | Unit price in VND. |
| 4 | Barcode | Text | No | 50 | Barcode/SKU value. |
| 5 | Description | Text | No | 500 | Description. |
| 6 | Available | Checkbox | Yes | | Availability status. |
| 7 | Image Upload | File | No | | Upload/replace image. |
| 8 | Linked Toppings | Checkboxes | No | | Modifier selections. |
| 9 | Save Changes | Button | | | Saves modified properties. |
| 10 | Cancel | Button | | | Discards edits. |

### 3.3.4.2 Use Case Description

| Use Case ID | UC-19 | Use Case Name | Update Menu Item & Recipe |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin, Store Manager |
| **Description** | Modifies properties of an existing item. |
| **Precondition** | Menu item exists. |
| **Trigger** | Admin clicks "Edit Item" on detail panel. Store Manager may toggle item Availability only. |
| **Post-Condition** | Product listings are modified. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Admin | Edits product fields and clicks "Save Changes". |
| 2 | Portal | Validates inputs. |
| 3 | Portal | Updates parameters, re-generates abbreviation if name changed, and returns to detail card. |

#### Alternative Flows
##### AT1: Validation Errors
- **Trigger**: At step 2, name duplicates another product or price <= 0.

| Sub-step | Actor | Action |
|---|---|---|
| 2.1 | Portal | Displays error message: `"Price must be a positive number greater than zero."` or `"A menu item with this name already exists."` |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-27 | Deactivating (`Availability = false`) triggers automatic removal from online delivery partner channels. |
| BR-26 | Abbreviation is automatically created based on first letters of words in the unsignified (diacritic-removed) name (e.g. "Cà phê đá" → "cfd") and updates if name is modified. **Collision handling:** If the generated abbreviation already exists in the catalog, a numeric suffix is appended incrementally (e.g. "cfd2", "cfd3") until a unique value is found. |

---

## 3.3.5 F17 - Delete Menu Item / UC-19 Update Menu Item & Recipe

### 3.3.5.1 Screen Mock-up (Desktop Landscape Modal)
```
+--------------------------------------------------------+
| Delete Menu Item Confirmation                          |
|                                                        |
|   Are you sure you want to delete 'Espresso'?          |
|   This item will be soft-deleted to preserve           |
|   historical sales reports.                            |
|                                                        |
|                [ Cancel ]     [ Confirm Delete ]       |
+--------------------------------------------------------+
```

#### Table 3-18: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Cancel | Button | | | Cancels soft deletion and closes modal. |
| 2 | Confirm Delete | Button | | | Performs soft delete. |

### 3.3.5.2 Use Case Description

| Use Case ID | UC-19a | Use Case Name | Delete Menu Item |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin |
| **Description** | Performs a soft delete (sets availability and visibility flag to false) on a menu item. |
| **Precondition** | Menu item exists. |
| **Trigger** | Admin clicks "Delete Menu Item" button. |
| **Post-Condition** | Product is removed from catalogs but retained in audit tables. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Admin | Clicks "Delete" button. |
| 2 | Portal | Displays Delete Menu Item Confirmation modal. |
| 3 | Admin | Clicks "Confirm Delete". |
| 4 | Portal | Deactivates visibility, removes from active POS/web registers, and redirects to list. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-28 | Menu items are never permanently deleted from database to preserve historical sales reports. |

---

## 3.3.6 F18 - Manage Toppings & Options / UC-18/19 Topping Setup

### 3.3.6.1 Screen Mock-up (Desktop Landscape)
```
+---------------------------------------------------------------------------------+
| HQ Admin Portal > Menu Management > Manage Toppings                             |
+---------------------------------------------------------------------------------+
|  + Add New Topping:                                                             |
|  Name: [ Tapioca Pearls     ]  Price: [ 5,000 VND    ]  [ Add Topping ]         |
|                                                                                 |
|  Active Modifier list:                                                          |
|  1. Extra Espresso Shot (Price: 10,000 VND)                         [ Delete ]  |
|  2. Oat Milk (Price: 10,000 VND)                                    [ Delete ]  |
|  3. Tapioca Pearls (Price: 5,000 VND)                               [ Delete ]  |
+---------------------------------------------------------------------------------+
```

#### Table 3-19: Screen Definition
| # | Field Name | Type | Mandatory | Max Length | Description |
|---|---|---|---|---|---|
| 1 | Name | Text | Yes | 100 | Name of the topping option. |
| 2 | Price | Decimal | Yes | | Price of the topping modifier in VND. |
| 3 | Add Topping | Button | | | Saves topping modifier. |
| 4 | Delete | Button | | | Soft deletes specific topping modifier. |

### 3.3.6.2 Use Case Description

| Use Case ID | UC-18a | Use Case Name | Manage Toppings & Options |
|---|---|---|---|
| **Author** | Antigravity | **Version** | 1.0 |
| **Date** | 2026-05-24 | | |

| Field | Description |
|---|---|
| **Actor** | Admin |
| **Description** | Configures modifiers that customers can add to their drinks. |
| **Precondition** | Admin is logged in. |
| **Trigger** | Admin navigates to Toppings and Options management page. |
| **Post-Condition** | Toppings options list is updated. |

#### Main Flows
| Step | Actor | Action |
|---|---|---|
| 1 | Admin | Enters Name and Price, and clicks "Add Topping". |
| 2 | Portal | Validates inputs (non-negative price, non-empty name). |
| 3 | Portal | Saves new topping and updates grid list. |

#### Business Rules
| ID | Rule Description |
|---|---|
| BR-29 | Price can be 0 for standard options (e.g. "No Ice", "No Sugar"). Toppings can be linked globally or selectively to drinks. |




