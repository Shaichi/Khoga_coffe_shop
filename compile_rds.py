import os

# Order of files to concatenate for RDS
rds_files = [
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
]

output_filename = "RDS_Khoga_CoffeeShop_v1.0.md"

def compile_rds():
    print("Compiling Software Design Document (RDS)...")
    compiled_content = []
    
    # Title Header for the compiled document
    compiled_content.append("**CAPSTONE PROJECT REPORT**\n")
    compiled_content.append("**Report 4 – Software Design Document**\n")
    compiled_content.append("**Khoga Café Shop Management System**\n")
    compiled_content.append("Version: 1.0 | Date: 2026-06-18\n")
    
    compiled_content.append("**Table of Contents**")
    compiled_content.append("* [I. Record of Changes](#i-record-of-changes)")
    compiled_content.append("* [II. Software Design Document](#ii-software-design-document)")
    compiled_content.append("  * [1. System Design](#1-system-design)")
    compiled_content.append("    * [1.1 System Architecture](#11-system-architecture)")
    compiled_content.append("    * [1.2 Package Diagram](#12-package-diagram)")
    compiled_content.append("  * [2. Database Design](#2-database-design)")
    compiled_content.append("    * [2.1. Core Sales & POS ERD](#21-core-sales--pos-erd)")
    compiled_content.append("    * [2.2. Operations, Staffing & Audit ERD](#22-operations-staffing--audit-erd)")
    compiled_content.append("  * [3. Detailed Design](#3-detailed-design)")
    compiled_content.append("    * [3.1 System Access & Security](#31-system-access--security)")
    compiled_content.append("    * [3.2 User Account Management](#32-user-account-management)")
    compiled_content.append("    * [3.3 Menu & Category Management](#33-menu--category-management)")
    compiled_content.append("    * [3.4 Voucher Management](#34-voucher-management)")
    compiled_content.append("    * [3.5 Customer & Membership Management](#35-customer--membership-management)")
    compiled_content.append("    * [3.6 Inventory & Stock Management](#36-inventory--stock-management)")
    compiled_content.append("    * [3.7 POS Transaction Management](#37-pos-transaction-management)")
    compiled_content.append("    * [3.8 Order & Queue Management](#38-order--queue-management)")
    compiled_content.append("    * [3.9 Staff Management](#39-staff-management)")
    compiled_content.append("    * [3.10 Reports & Analytics](#310-reports--analytics)")
    compiled_content.append("    * [3.11 System Configuration & Branch Management](#311-system-configuration--branch-management)")
    compiled_content.append("\n---\n")
    
    for relative_path in rds_files:
        if not os.path.exists(relative_path):
            print(f"Warning: File {relative_path} not found. Skipping...")
            continue
            
        print(f"Adding {relative_path}...")
        
        # Inject II. Software Design Document title before 01_system_architecture.md
        if relative_path == "rds_sections/01_system_architecture.md":
            compiled_content.append("# **II. Software Design Document**\n")
            
        with open(relative_path, "r", encoding="utf-8") as f:
            content = f.read()
            compiled_content.append(content)
            
        # Add newlines between sections
        compiled_content.append("\n\n")
            
    # Write to final file
    with open(output_filename, "w", encoding="utf-8", newline="\n") as out:
        out.write("\n".join(compiled_content))
        
    print(f"Compilation finished! Compiled document saved to: {output_filename}")

if __name__ == "__main__":
    compile_rds()
