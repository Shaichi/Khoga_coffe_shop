import os

rds_files = [
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

# Mapping of free text labels to standard UML signatures
replacements = {
    # 04_detailed_3_1_system_access_security.md
    "enter username + password": "inputCredentials(username, password)",
    "display MFA Challenge Form": "displayMfaChallenge()",
    "enter OTP": "inputOtp(otp)",
    "redirect to role-specific portal": "redirectToPortal()",
    "enter new password + confirm": "inputNewPassword(newPassword, confirmPassword)",
    "redirect to portal": "redirectToPortal()",
    "enter email": "inputEmail(email)",
    "display OTP verification form": "displayOtpVerification()",
    "display Set New Password Form": "displaySetNewPassword()",
    "redirect to login": "redirectToLogin()",
    "click \"Edit Profile\"": "editProfile()",
    "display Edit Profile Form": "displayEditProfile()",
    "edit name, email, phone + submit": "inputProfileDetails(name, email, phone)",
    "display success + profile updated": "displaySuccess()",
    
    # 05_detailed_3_2_user_management.md
    "fill form (name, username, role, email, phone, storeId)": "inputUserDetails(name, username, role, email, phone, storeId)",
    "display success + user created": "displaySuccess()",
    "edit name, role, email, phone, storeId + submit": "inputUserDetails(name, username, role, email, phone, storeId)",
    "display success + user updated": "displaySuccess()",
    "click \"Deactivate\" on user": "deactivateUser(userId)",
    "display success + user deactivated": "displaySuccess()",
    
    # 06_detailed_3_3_menu_category.md
    "fill form (name, categoryId, price, description, toppings, recipe)": "inputMenuItemDetails(name, categoryId, price, description, toppings, recipe)",
    "display success + item created": "displaySuccess()",
    "edit name, categoryId, price, description, toppings, recipe + submit": "inputMenuItemDetails(name, categoryId, price, description, toppings, recipe)",
    "display success + item updated": "displaySuccess()",
    "click \"Delete\" on menu item": "deleteMenuItem(itemId)",
    "display success + item deleted": "displaySuccess()",
    "select category, enter name, description": "inputCategoryDetails(name, description)",
    "display success + category created": "displaySuccess()",
    "edit name, description + submit": "inputCategoryDetails(name, description)",
    "display success + category updated": "displaySuccess()",
    "click \"Delete\" on category": "deleteCategory(categoryId)",
    "display success + category deleted": "displaySuccess()",
    
    # 07_detailed_3_4_voucher.md
    "fill form (code, discountType, value, cap, validity, limits)": "inputVoucherDetails(code, discountType, discountValue, capAmount, validity, limits)",
    "display updated voucher list": "displayVoucherList()",
    
    # 08_detailed_3_5_customer_membership.md
    "enter phone, name, email": "inputCustomerDetails(phone, name, email)",
    "display success + customer registered": "displaySuccess()",
    "edit phone, name, email + submit": "inputCustomerDetails(phone, name, email)",
    "display success + customer updated": "displaySuccess()",
    
    # 09_detailed_3_6_inventory.md
    "select raw material, quantity, reason": "inputStockTransactionDetails(rawMaterialId, quantity, reason)",
    "display success + stock transaction logged": "displaySuccess()",
    "select raw material, enter physical quantity": "inputPhysicalStockDetails(rawMaterialId, physicalQuantity)",
    "display success + adjustment logged": "displaySuccess()",
    
    # 10_detailed_3_7_pos_transaction.md
    "enter opening cash float": "inputOpeningCashFloat(openingCash)",
    "show success + POS unlocked": "displaySuccess()",
    "select item, enter quantity": "addItemToCart(itemId, quantity)",
    "display updated cart + total": "displayCartDetails()",
    "enter customer phone": "inputCustomerPhone(phone)",
    "display customer name + points": "displayCustomerDetails()",
    "enter voucher code": "inputVoucherCode(code)",
    "display discounted total": "displayDiscountedTotal()",
    "tap \"Checkout\"": "checkout()",
    "display VietQR code + print receipt": "displayVietQrAndPrintReceipt()",
    "enter closing cash float": "inputClosingCashFloat(closingCash)",
    "show Z-Report (total sales, discrepancy, shift summary)": "displayZReport(ZReportDto)",
    
    # 11_detailed_3_8_order_management.md
    "tap \"Cancel\" on PENDING order": "cancelOrder(orderId, reason)",
    "display success + order CANCELLED": "displaySuccess()",
    "tap \"Start Preparing\"": "startPreparation(orderId)",
    "status changes to PREPARING": "displayUpdatedQueue()",
    "tap \"Ready\"": "completePreparation(orderId)",
    "status changes to READY": "displayUpdatedQueue()",
    "tap \"Deliver\" on READY order": "confirmPickup(orderId)",
    "status changes to COMPLETED": "displayUpdatedQueue()",
    "select order, enter refund reason, SM PIN": "inputRefundDetails(orderId, reason, smPin)",
    "display success + refund processed": "displaySuccess()",
    
    # 12_detailed_3_9_staff_management.md
    "select staff, date, shift type": "inputScheduleDetails(userId, date, shiftType)",
    "display success + schedule saved": "displaySuccess()",
    "select schedule, edit date, shift type + submit": "inputScheduleDetails(userId, date, shiftType)",
    "display success + schedule updated": "displaySuccess()",
    "enter PIN + look at camera": "inputPinAndCapturePhoto(pin, photo)",
    "display success + checked-in": "displaySuccess()",
    
    # 13_detailed_3_10_reports.md
    "click \"View HQ Dashboard\"": "requestHqDashboard()",
    "display charts (sales, top items, revenue)": "displayDashboard()",
    "select date range + click \"Generate COGS\"": "requestCogsReport(startDate, endDate)",
    "display COGS, margin, and standard cost deviation": "displayCogsReport()",
    "select date range + click \"Generate Change History\"": "requestChangeHistoryReport(startDate, endDate)",
    "display audit log of price & voucher changes": "displayChangeHistoryReport()",
    "select date range + click \"Generate Labor Efficiency\"": "requestLaborEfficiencyReport(startDate, endDate)",
    "display staff worked hours, sales per hour, efficiency": "displayLaborEfficiencyReport()",
    
    # 14_detailed_3_11_config_branch.md
    "enter branch details (name, address, phone)": "inputBranchDetails(name, address, phone)",
    "display success + branch added": "displaySuccess()",
    "edit branch details + submit": "inputBranchDetails(name, address, phone)",
    "display success + branch updated": "displaySuccess()",
    "edit config value + submit": "inputConfigDetails(configKey, configValue)",
    "display success + config updated": "displaySuccess()",
    "edit override value + submit": "inputConfigDetails(configKey, configValue)",
    "display success + config overridden": "displaySuccess()",
}

def standardize_files():
    print("Standardizing sequence diagram message signatures to UML standard...")
    for file_path in rds_files:
        if not os.path.exists(file_path):
            print(f"Skipping {file_path} (not found)")
            continue
            
        print(f"Processing {file_path}...")
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()
            
        original_content = content
        for txt, rep in replacements.items():
            content = content.replace(f": {txt}", f": {rep}")
            
        if content != original_content:
            with open(file_path, "w", encoding="utf-8", newline="\n") as f:
                f.write(content)
            print(f"-> Standardized {file_path}")
            
if __name__ == "__main__":
    standardize_files()
