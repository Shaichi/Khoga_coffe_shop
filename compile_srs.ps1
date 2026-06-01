$output = "srs_document_full.md"
$contentList = [System.Collections.Generic.List[string]]::new()
$contentList.Add("# SOFTWARE REQUIREMENT SPECIFICATION`r`n## Coffee Shop Management System`r`n`r`n---`r`n`r`n")

$files = @(
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
    "sections/03_11_delivery_partner.md",
    "sections/03_12_dashboard_reporting.md",
    "sections/03_13_system_configuration.md",
    "sections/04_non_functional_requirements.md",
    "sections/05_appendix_mapping.md"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Adding $file..."
        $content = Get-Content -Raw -Path $file -Encoding utf8
        [void]$contentList.Add($content)
        [void]$contentList.Add("`r`n`r`n---`r`n`r`n")
    } else {
        Write-Host "Warning: $file not found!"
    }
}

$fullContent = [string]::Join("", $contentList)
Set-Content -Path $output -Value $fullContent -Encoding utf8
Write-Host "Compilation finished! Compiled document saved to: $output"
