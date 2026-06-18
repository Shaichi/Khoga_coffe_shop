$output = "RDS_Khoga_CoffeeShop_v1.0.md"
$contentList = [System.Collections.Generic.List[string]]::new()

$header = @"
**CAPSTONE PROJECT REPORT**

**Report 4 - Software Design Document**

**Khoga Cafe Shop Management System**

Version: 1.0 | Date: 2026-06-18

**Table of Contents**
* [I. Record of Changes](#i-record-of-changes)
* [II. Software Design Document](#ii-software-design-document)
  * [1. System Design](#1-system-design)
    * [1.1 System Architecture](#11-system-architecture)
    * [1.2 Package Diagram](#12-package-diagram)
  * [2. Database Design](#2-database-design)
    * [2.1. Core Sales & POS ERD](#21-core-sales--pos-erd)
    * [2.2. Operations, Staffing & Audit ERD](#22-operations-staffing--audit-erd)
  * [3. Detailed Design](#3-detailed-design)
    * [3.1 System Access & Security](#31-system-access--security)
    * [3.2 User Account Management](#32-user-account-management)
    * [3.3 Menu & Category Management](#33-menu--category-management)
    * [3.4 Voucher Management](#34-voucher-management)
    * [3.5 Customer & Membership Management](#35-customer--membership-management)
    * [3.6 Inventory & Stock Management](#36-inventory--stock-management)
    * [3.7 POS Transaction Management](#37-pos-transaction-management)
    * [3.8 Order & Queue Management](#38-order--queue-management)
    * [3.9 Staff Management](#39-staff-management)
    * [3.10 Reports & Analytics](#310-reports--analytics)
    * [3.11 System Configuration & Branch Management](#311-system-configuration--branch-management)

---


"@

[void]$contentList.Add($header)

$files = @(
    "rds_sections/00_record_of_changes.md",
    "rds_sections/01_system_architecture.md",
    "rds_sections/02_package_diagram.md",
    "rds_sections/03_database_design.md",
    "rds_sections/04_detailed_3_1_system_access_security.md",
    "rds_sections/05_detailed_3_2_user_management.md",
    "rds_sections/06_detailed_3_3_menu_category.md",
    "rds_sections/07_detailed_3_4_voucher.md",
    "rds_sections/08_detailed_3_5_customer_membership.md",
    "rds_sections/09_detailed_3_6_inventory.md",
    "rds_sections/10_detailed_3_7_pos_transaction.md",
    "rds_sections/11_detailed_3_8_order_management.md",
    "rds_sections/12_detailed_3_9_staff_management.md",
    "rds_sections/13_detailed_3_10_reports.md",
    "rds_sections/14_detailed_3_11_config_branch.md"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Adding $file..."
        if ($file -eq "rds_sections/01_system_architecture.md") {
            [void]$contentList.Add("# **II. Software Design Document**`r`n`r`n")
        }
        $content = Get-Content -Raw -Path $file -Encoding utf8
        [void]$contentList.Add($content)
        [void]$contentList.Add("`r`n`r`n")
    } else {
        Write-Host "Warning: $file not found!"
    }
}

$fullContent = [string]::Join("", $contentList)
Set-Content -Path $output -Value $fullContent -Encoding utf8
Write-Host "Compilation finished! Compiled document saved to: $output"
