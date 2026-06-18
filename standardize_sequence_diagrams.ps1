$rds_files = @(
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

$replacements = @{
    # General & Authentication
    "enter username + password" = "inputCredentials(username, password)"
    "display MFA Challenge Form" = "displayMfaChallenge()"
    "enter OTP" = "inputOtp(otp)"
    "redirect to role-specific portal" = "redirectToPortal()"
    "enter new password + confirm" = "inputNewPassword(newPassword, confirmPassword)"
    "redirect to portal" = "redirectToPortal()"
    "enter email" = "inputEmail(email)"
    "display OTP verification form" = "displayOtpVerification()"
    "display Set New Password Form" = "displaySetNewPassword()"
    "redirect to login" = "redirectToLogin()"
    "click `"Edit Profile`"" = "editProfile()"
    "display Edit Profile Form" = "displayEditProfile()"
    "edit name, email, phone + submit" = "inputProfileDetails(name, email, phone)"
    "display success + profile updated" = "displaySuccess()"
    
    # User Management
    "fill form (name, username, role, email, phone, storeId)" = "inputUserDetails(name, username, role, email, phone, storeId)"
    "display success + user created" = "displaySuccess()"
    "edit name, role, email, phone, storeId + submit" = "inputUserDetails(name, username, role, email, phone, storeId)"
    "display success + user updated" = "displaySuccess()"
    "click `"Deactivate`" on user" = "deactivateUser(userId)"
    "display success + user deactivated" = "displaySuccess()"
    
    # Menu & Category
    "fill form (name, categoryId, price, description, toppings, recipe)" = "inputMenuItemDetails(name, categoryId, price, description, toppings, recipe)"
    "fill form (name, price, barcode, recipe lines)" = "inputMenuItemDetails(name, price, barcode, recipeLines)"
    "display success" = "displaySuccess()"
    "select item + enter topping (name, price, recipe lines)" = "inputToppingDetails(name, price, recipeLines)"
    "display updated topping list" = "displayToppingList()"
    "submit action (ADD / UPDATE / DELETE)" = "submitAction(dto)"
    "display updated category list" = "displayCategoryList()"
    "open Raw Material Master" = "openRawMaterialMaster()"
    "display material grid" = "displayMaterialGrid()"
    "submit add/edit (code, name, unit, cost)" = "inputMaterialDetails(code, name, unit, cost)"
    "display updated material list" = "displayMaterialList()"
    "edit name, categoryId, price, description, toppings, recipe + submit" = "inputMenuItemDetails(name, categoryId, price, description, toppings, recipe)"
    "display success + item updated" = "displaySuccess()"
    "click `"Delete`" on menu item" = "deleteMenuItem(itemId)"
    "display success + item deleted" = "displaySuccess()"
    "select category, enter name, description" = "inputCategoryDetails(name, description)"
    "display success + category created" = "displaySuccess()"
    "edit name, description + submit" = "inputCategoryDetails(name, description)"
    "display success + category updated" = "displaySuccess()"
    "click `"Delete`" on category" = "deleteCategory(categoryId)"
    "display success + category deleted" = "displaySuccess()"
    
    # Vouchers
    "fill form (code, discountType, value, cap, validity, limits)" = "inputVoucherDetails(code, discountType, discountValue, capAmount, validity, limits)"
    "display updated voucher list" = "displayVoucherList()"
    
    # Customers
    "enter phone, name, email" = "inputCustomerDetails(phone, name, email)"
    "display success + customer registered" = "displaySuccess()"
    "edit phone, name, email + submit" = "inputCustomerDetails(phone, name, email)"
    "display success + customer updated" = "displaySuccess()"
    "fill form (name, phone, email, birthDate) + tick PDPA checkbox" = "inputCustomerDetails(name, phone, email, birthDate)"
    "display customer card (0 points)" = "displayCustomerCard()"
    "enter customerId + pointsToRedeem" = "inputRedemptionDetails(customerId, pointsToRedeem)"
    "display balance (N points)" = "displayPointsBalance(points)"
    "confirm redemption" = "confirmRedemption()"
    "display updated balance" = "displayUpdatedBalance(remainingPoints)"
    
    # Inventory
    "select raw material, quantity, reason" = "inputStockTransactionDetails(rawMaterialId, quantity, reason)"
    "display success + stock transaction logged" = "displaySuccess()"
    "select raw material, enter physical quantity" = "inputPhysicalStockDetails(rawMaterialId, physicalQuantity)"
    "display success + adjustment logged" = "displaySuccess()"
    
    # POS Checkout
    "enter opening cash float" = "inputOpeningCashFloat(openingCash)"
    "show success + POS unlocked" = "displaySuccess()"
    "select item, enter quantity" = "addItemToCart(itemId, quantity)"
    "display updated cart + total" = "displayCartDetails()"
    "enter customer phone" = "inputCustomerPhone(phone)"
    "display customer name + points" = "displayCustomerDetails()"
    "enter voucher code" = "inputVoucherCode(code)"
    "display discounted total" = "displayDiscountedTotal()"
    "tap `"Checkout`"" = "checkout()"
    "display VietQR code + print receipt" = "displayVietQrAndPrintReceipt()"
    "enter closing cash float" = "inputClosingCashFloat(closingCash)"
    "show Z-Report (total sales, discrepancy, shift summary)" = "displayZReport(ZReportDto)"
    
    # Orders
    "tap `"Cancel`" on PENDING order" = "cancelOrder(orderId, reason)"
    "display success + order CANCELLED" = "displaySuccess()"
    "tap `"Start Preparing`"" = "startPreparation(orderId)"
    "status changes to PREPARING" = "displayUpdatedQueue()"
    "tap `"Ready`"" = "completePreparation(orderId)"
    "status changes to READY" = "displayUpdatedQueue()"
    "tap `"Deliver`" on READY order" = "confirmPickup(orderId)"
    "status changes to COMPLETED" = "displayUpdatedQueue()"
    "select order, enter refund reason, SM PIN" = "inputRefundDetails(orderId, reason, smPin)"
    "display success + refund processed" = "displaySuccess()"
    "select order + choose reason + enter notes" = "inputCancellationDetails(orderId, reason, notes)"
    "display confirmed cancellation" = "displaySuccess()"
    "select order + choose refundType (REFUND/COMP) + enter amount" = "inputRefundDetails(orderId, refundType, amount)"
    "request SM authorization PIN" = "requestSmPin()"
    "enter SM PIN" = "inputSmPin(smPin)"
    "display refund/comp confirmation" = "displaySuccess()"
    
    # Staff Management
    "select staff, date, shift type" = "inputScheduleDetails(userId, date, shiftType)"
    "display success + schedule saved" = "displaySuccess()"
    "select schedule, edit date, shift type + submit" = "inputScheduleDetails(userId, date, shiftType)"
    "display success + schedule updated" = "displaySuccess()"
    "enter PIN + look at camera" = "inputPinAndCapturePhoto(pin, photo)"
    "display success + checked-in" = "displaySuccess()"
    "fill schedule (employeeId, date, shiftType, posRegisterId)" = "inputScheduleDetails(employeeId, date, shiftType, posRegisterId)"
    "refresh calendar view" = "refreshCalendarView()"
    "enter PIN + capture photo via camera" = "inputPinAndCapturePhoto(pin, photoData)"
    "display ON_TIME / LATE confirmation" = "displaySuccess()"
    
    # Reports
    "click `"View HQ Dashboard`"" = "requestHqDashboard()"
    "display charts (sales, top items, revenue)" = "displayDashboard()"
    "select date range + click `"Generate COGS`"" = "requestCogsReport(startDate, endDate)"
    "display COGS, margin, and standard cost deviation" = "displayCogsReport()"
    "select date range + click `"Generate Change History`"" = "requestChangeHistoryReport(startDate, endDate)"
    "display audit log of price & voucher changes" = "displayChangeHistoryReport()"
    "select date range + click `"Generate Labor Efficiency`"" = "requestLaborEfficiencyReport(startDate, endDate)"
    "display staff worked hours, sales per hour, efficiency" = "displayLaborEfficiencyReport()"
    "select date range + (optional) branch filter" = "selectDateRangeAndBranchFilter(dateRange, branchFilter)"
    "display consolidated dashboard + branch comparison chart" = "displayDashboardAndComparisonChart()"
    "click Export" = "clickExport()"
    "download Excel file" = "downloadExcelFile()"
    "select date range + open COGS Report tab" = "requestCogsReport(dateRange)"
    "show COGS and margin breakdown" = "displayCogsReport()"
    "open Anomaly Report tab" = "requestAnomalyReport()"
    "display flagged anomalies by branch with severity levels" = "displayAnomalyReport()"
    "select menu item" = "selectMenuItem(menuItemId)"
    "display price change timeline (table + sparkline chart)" = "displayPriceChangeTimeline()"
    
    # Branch & Configuration
    "enter branch details (name, address, phone)" = "inputBranchDetails(name, address, phone)"
    "display success + branch added" = "displaySuccess()"
    "edit branch details + submit" = "inputBranchDetails(name, address, phone)"
    "display success + branch updated" = "displaySuccess()"
    "edit config value + submit" = "inputConfigDetails(configKey, configValue)"
    "display success + config updated" = "displaySuccess()"
    "edit override value + submit" = "inputConfigDetails(configKey, configValue)"
    "display success + config overridden" = "displaySuccess()"
    "open System Config panel" = "openConfigPanel()"
    "display config grid" = "displayConfigGrid()"
    "edit value (e.g. taxRate=10%, loyaltyEarnRate=1pt/10000)" = "inputConfigValue(key, value)"
    "display updated config grid" = "displayUpdatedConfigGrid()"
    "submit branch action (ADD / EDIT / DEACTIVATE)" = "submitBranchAction(dto)"
    "refresh branch list" = "refreshBranchList()"
}

Write-Host "Standardizing sequence diagram message signatures to UML standard..."
foreach ($file in $rds_files) {
    if (Test-Path $file) {
        Write-Host "Processing $file..."
        $content = Get-Content -Raw -Path $file -Encoding utf8
        $original = $content
        
        foreach ($key in $replacements.Keys) {
            $fromStr = ": $key"
            $toStr = ": " + $replacements[$key]
            $content = $content.Replace($fromStr, $toStr)
        }
        
        if ($content -ne $original) {
            Set-Content -Path $file -Value $content -Encoding utf8
            Write-Host "-> Standardized $file"
        }
    } else {
        Write-Host "Skipping $file (not found)"
    }
}
