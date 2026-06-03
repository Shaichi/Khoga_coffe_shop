import os

# Order of files to concatenate
srs_files = [
    "sections/00_record_of_changes.md",
    "sections/01_product_overview.md",
    "sections/02_user_requirements.md",
    "sections/03_1_functional_overview.md",
    "sections/03_2_system_access_security.md",
    "sections/03_3_menu_management.md",
    "sections/03_4_category_management.md",
    "sections/03_5_inventory_management.md",
    "sections/03_6_pos_transaction.md",
    "sections/03_7_order_management.md",
    "sections/03_8_customer_membership.md",
    "sections/03_9_staff_management.md",
    "sections/03_10_promotion_campaign.md",
    "sections/03_12_dashboard_reporting.md",
    "sections/03_13_system_configuration.md",
    "sections/04_non_functional_requirements.md",
    "sections/05_appendix_mapping.md"
]

output_filename = "srs_document_full.md"

def compile_srs():
    print("Compiling Software Requirements Specification...")
    compiled_content = []
    
    # Title Header for the compiled document
    compiled_content.append("# SOFTWARE REQUIREMENT SPECIFICATION")
    compiled_content.append("## Coffee Shop Management System")
    compiled_content.append("\n---\n")
    
    for relative_path in srs_files:
        if not os.path.exists(relative_path):
            print(f"Warning: File {relative_path} not found. Skipping...")
            continue
            
        print(f"Adding {relative_path}...")
        with open(relative_path, "r", encoding="utf-8") as f:
            content = f.read()
            compiled_content.append(content)
            compiled_content.append("\n\n---\n\n") # Separator between sections
            
    # Write to final file
    with open(output_filename, "w", encoding="utf-8") as out:
        out.write("\n".join(compiled_content))
        
    print(f"Compilation finished! Compiled document saved to: {output_filename}")

if __name__ == "__main__":
    compile_srs()
