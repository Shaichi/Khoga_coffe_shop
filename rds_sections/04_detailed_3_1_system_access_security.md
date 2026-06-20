## **3\. Detailed Design**

### **3.1 System Access & Security**

*\[Provide the detailed design for System Access & Security, covering UC-01→UC-09 (Authentication, MFA, Forgot Password, Force Password Change, Profile Management). Actor: User (all 6 roles). For features with the same class structure, the class diagram is provided once and referenced from related features. The class diagram below covers UC-01→UC-09 collectively; each sequence diagram covers one specific use case flow.\]*

#### ***3.1.1 Class Diagram***

*\[This part presents the class diagram for the System Access & Security feature. COMET stereotypes applied: LoginForm, MfaChallengeForm, ForgotPasswordForm, OtpVerificationForm, SetNewPasswordForm, ForcePasswordChangeForm, ProfileView, EditProfileForm, ChangePasswordForm («boundary»), EmailServiceProxy («boundary» external); AuthenticationCoordinator, ProfileCoordinator («control»); PasswordPolicyValidator («application logic»); OtpExpiryTimer («timer»); User («entity»).\]*

```mermaid
classDiagram
    class LoginForm {
        <<boundary>>
        +username: String
        +password: String
        +loginButton: Button
        +forgotPasswordLink: Link
        +submitLogin()
    }
    class MfaChallengeForm {
        <<boundary>>
        +otpInput: TextField
        +submitButton: Button
        +submitOtp()
    }
    class ForgotPasswordForm {
        <<boundary>>
        +email: String
        +submitEmail()
    }
    class OtpVerificationForm {
        <<boundary>>
        +otpCode: String
        +submitOtp()
    }
    class SetNewPasswordForm {
        <<boundary>>
        +newPassword: String
        +confirmPassword: String
        +submitNewPassword()
    }
    class ForcePasswordChangeForm {
        <<boundary>>
        +newPassword: String
        +confirmPassword: String
        +submitChange()
    }
    class ProfileView {
        <<boundary>>
        +displayProfile()
    }
    class EditProfileForm {
        <<boundary>>
        +phone: String
        +email: String
        +submitUpdate()
    }
    class ChangePasswordForm {
        <<boundary>>
        +currentPassword: String
        +newPassword: String
        +submitChange()
    }
    class AuthenticationCoordinator {
        <<control>>
        +login(req): LoginResponse
        +logout(token): void
        +sendOtp(email): void
        +verifyOtp(otp): Boolean
        +forceChangePassword(userId, newPwd): void
        +validateMfa(code): Boolean
    }
    class ProfileCoordinator {
        <<control>>
        +viewProfile(userId): UserDto
        +updateProfile(userId, dto): void
        +changePassword(userId, dto): void
    }
    class PasswordPolicyValidator {
        <<application logic>>
        +validate(password): Boolean
        +checkComplexity(password): ValidationResult
    }
    class OtpExpiryTimer {
        <<timer>>
        +startTimer(durationMin: 10)
        +onExpiry(): void
    }
    class EmailServiceProxy {
        <<boundary>>
        +sendOtpEmail(to, otp): void
        +sendWelcomeEmail(to, tempPwd): void
    }
    class User {
        <<entity>>
        +id: UUID
        +username: String
        +passwordHash: String
        +role: Role
        +fullName: String
        +email: String
        +phone: String
        +storeId: UUID
        +isActive: Boolean
        +mustChangePassword: Boolean
        +attendancePin: String
        +failedAttempts: Integer
        +lockExpiryAt: DateTime
        +passwordLastChangedAt: DateTime
        +createdAt: DateTime
        +lastLoginAt: DateTime
    }

    LoginForm ..> AuthenticationCoordinator
    MfaChallengeForm ..> AuthenticationCoordinator
    ForgotPasswordForm ..> AuthenticationCoordinator
    OtpVerificationForm ..> AuthenticationCoordinator
    SetNewPasswordForm ..> AuthenticationCoordinator
    ForcePasswordChangeForm ..> AuthenticationCoordinator
    EditProfileForm ..> ProfileCoordinator
    ChangePasswordForm ..> ProfileCoordinator
    AuthenticationCoordinator --> PasswordPolicyValidator
    AuthenticationCoordinator --> OtpExpiryTimer
    AuthenticationCoordinator --> EmailServiceProxy
    AuthenticationCoordinator --> User
    ProfileCoordinator --> PasswordPolicyValidator
    ProfileCoordinator --> User
```

#### ***3.1.2 UC-01 Login (including MFA for HQ Roles)***

*\[Describes the login flow. HQ roles (ceoviewer, businessadmin, ssadmin) require MFA via email OTP after password verification (BR-83). Branch roles (storemanager, cashier, barista) login with username/password only. After successful login, if must_change_password = true, user is redirected to Force Password Change screen (UC-06).\]*

```mermaid
sequenceDiagram
    actor User
participant LoginForm as "«boundary»<br/>LoginForm"
participant AuthCoordinator as "«control»<br/>AuthCoordinator"
participant UserDB as "«entity»<br/>User (DB)"
participant EmailSvc as "«boundary»<br/>EmailServiceProxy"
participant MfaForm as "«boundary»<br/>MfaChallengeForm"

    User->>LoginForm: inputCredentials(username, password)
    LoginForm->>AuthCoordinator: submitLogin(username, password)
    AuthCoordinator->>UserDB: findByUsername(username)
    UserDB-->>AuthCoordinator: userRecord
    AuthCoordinator->>AuthCoordinator: verifyBCryptHash(password, hash)
    AuthCoordinator->>AuthCoordinator: checkIsActive()

    alt HQ Role (ceoviewer / businessadmin / ssadmin)
        AuthCoordinator->>AuthCoordinator: generateOtp()
        AuthCoordinator->>EmailSvc: sendOtpEmail(email, otp)
        AuthCoordinator-->>LoginForm: showMfaForm()
        LoginForm-->>User: displayMfaChallenge()

        User->>MfaForm: inputOtp(otp)
        MfaForm->>AuthCoordinator: submitOtp(otp)
        AuthCoordinator->>AuthCoordinator: verifyOtp() + checkExpiry(10min)
    end

    alt mustChangePassword = true
        AuthCoordinator-->>LoginForm: redirectToForceChange()
    else
        AuthCoordinator->>AuthCoordinator: generateJWT(userId, role)
        AuthCoordinator-->>LoginForm: return JWT + portal redirect
        LoginForm-->>User: redirectToPortal()
    end
```

#### ***3.1.3 UC-03/04/05 Forgot Password → OTP → Reset Password***

*\[Describes the password recovery flow. User submits registered email → system generates OTP and sends via email → OTP timer set to 10 minutes (BR-16) → user verifies OTP → user sets new password meeting complexity policy.\]*

```mermaid
sequenceDiagram
    actor User
participant ForgotForm as "«boundary»<br/>ForgotPasswordForm"
participant AuthCoordinator as "«control»<br/>AuthCoordinator"
participant UserDB as "«entity»<br/>User (DB)"
participant EmailSvc as "«boundary»<br/>EmailServiceProxy"
participant OtpTimer as "«timer»<br/>OtpExpiryTimer"
participant OtpForm as "«boundary»<br/>OtpVerificationForm"
participant SetPassForm as "«boundary»<br/>SetNewPasswordForm"
participant Validator as "«application logic»<br/>PasswordPolicyValidator"

    User->>ForgotForm: inputEmail(email) address
    ForgotForm->>AuthCoordinator: submitEmail(email)
    AuthCoordinator->>UserDB: findByEmail(email)
    UserDB-->>AuthCoordinator: userRecord
    AuthCoordinator->>AuthCoordinator: generateOtp()
    AuthCoordinator->>OtpTimer: startTimer(10min)
    AuthCoordinator->>EmailSvc: sendOtpEmail(email, otp)
    AuthCoordinator-->>ForgotForm: showOtpVerificationForm()
    ForgotForm-->>User: display OTP Verification Form

    User->>OtpForm: inputOtp(otp) code
    OtpForm->>AuthCoordinator: submitOtp(otp)
    AuthCoordinator->>AuthCoordinator: verifyOtp() + checkExpiry()
    AuthCoordinator-->>OtpForm: showSetNewPasswordForm()
    OtpForm-->>User: displaySetNewPassword()

    User->>SetPassForm: enter new password
    SetPassForm->>AuthCoordinator: submitNewPassword(newPwd)
    AuthCoordinator->>Validator: validate(newPwd)
    Validator-->>AuthCoordinator: validationResult
    AuthCoordinator->>UserDB: updatePasswordHash(BCrypt(newPwd))
    AuthCoordinator-->>SetPassForm: redirectToLogin()
    SetPassForm-->>User: redirect to Login Screen
```

#### ***3.1.4 UC-06 Force Password Change (First Login)***

*\[When must_change_password = true (set on account creation by ssadmin), the user is redirected to Force Password Change screen immediately after first login. The user cannot access the portal until they complete this step.\]*

```mermaid
sequenceDiagram
    actor User
participant LoginForm as "«boundary»<br/>LoginForm"
participant AuthCoordinator as "«control»<br/>AuthCoordinator"
participant ForceChangeForm as "«boundary»<br/>ForcePasswordChangeForm"
participant Validator as "«application logic»<br/>PasswordPolicyValidator"
participant UserDB as "«entity»<br/>User (DB)"

    User->>LoginForm: login with temp credentials
    LoginForm->>AuthCoordinator: submitLogin(username, tempPwd)
    AuthCoordinator->>UserDB: findByUsername()
    UserDB-->>AuthCoordinator: userRecord (mustChangePassword = true)
    AuthCoordinator-->>LoginForm: redirectToForceChange()
    LoginForm-->>User: display Force Password Change Form

    User->>ForceChangeForm: inputNewPassword(newPassword, confirmPassword)
    ForceChangeForm->>AuthCoordinator: submitChange(newPwd)
    AuthCoordinator->>Validator: validate(newPwd)
    Validator-->>AuthCoordinator: validationResult (OK)
    AuthCoordinator->>UserDB: updatePassword(BCrypt(newPwd)) + set mustChangePassword=false
    AuthCoordinator->>AuthCoordinator: generateJWT(userId, role)
    AuthCoordinator-->>ForceChangeForm: redirectToPortal()
    ForceChangeForm-->>User: redirectToPortal()
```

#### ***3.1.5 UC-07/08/09 View Profile / Update Profile / Change Password***

*\[Profile management use cases share the ProfileCoordinator. All roles can view and update their own contact information. Change Password requires the current password for identity verification before allowing the update.\]*

```mermaid
sequenceDiagram
    actor User
participant ProfileView as "«boundary»<br/>ProfileView"
participant EditProfileForm as "«boundary»<br/>EditProfileForm"
participant ChangePassForm as "«boundary»<br/>ChangePasswordForm"
participant ProfileCoordinator as "«control»<br/>ProfileCoordinator"
participant Validator as "«application logic»<br/>PasswordPolicyValidator"
participant UserDB as "«entity»<br/>User (DB)"

    User->>ProfileView: open Profile Screen
    ProfileView->>ProfileCoordinator: viewProfile(userId)
    ProfileCoordinator->>UserDB: findById(userId)
    UserDB-->>ProfileCoordinator: userRecord
    ProfileCoordinator-->>ProfileView: return UserDto
    ProfileView-->>User: display profile info

    alt Update Profile (UC-08)
        User->>EditProfileForm: update phone/email + submit
        EditProfileForm->>ProfileCoordinator: updateProfile(userId, dto)
        ProfileCoordinator->>UserDB: updateContact(userId, phone, email)
        ProfileCoordinator-->>EditProfileForm: showSuccess()
    end

    alt Change Password (UC-09)
        User->>ChangePassForm: enter currentPwd + newPwd + submit
        ChangePassForm->>ProfileCoordinator: changePassword(userId, currentPwd, newPwd)
        ProfileCoordinator->>UserDB: verifyCurrentPassword(userId, currentPwd)
        ProfileCoordinator->>Validator: validate(newPwd)
        Validator-->>ProfileCoordinator: validationResult (OK)
        ProfileCoordinator->>UserDB: updatePasswordHash(BCrypt(newPwd))
        ProfileCoordinator-->>ChangePassForm: showSuccess()
    end
```

#### ***3.1.6 USER Account Statechart***

*\[The User account lifecycle has 4 states. The CREATED state forces a password change on first login. ACTIVE is the normal operational state. LOCKED occurs after 5 consecutive failed login attempts and is a time-bound 15-minute suspension that auto-clears (BR-11); an ssadmin may also unlock manually. INACTIVE results from manual deactivation by ssadmin or storemanager (own branch staff only).\]*

```mermaid
stateDiagram-v2
    [*] --> CREATED : createAccount() / setMustChangePassword(true)

    CREATED --> OPERATIONAL : login() [mustChangePassword == true] / forcePasswordChange()

    state OPERATIONAL {
        [*] --> ACTIVE
        ACTIVE --> LOCKED : loginFailed() [consecutiveFailures >= 5] / lockAccount(15min)
        LOCKED --> ACTIVE : timeTrigger [suspensionElapsed >= 15min] / resetFailedAttempts()
        LOCKED --> ACTIVE : unlock() [isSSAdmin == true] / resetFailedAttempts()
    }

    OPERATIONAL --> INACTIVE_BY_SM : deactivate() [isSM == true && isOwnBranch == true] / deactivateAccount()
    OPERATIONAL --> INACTIVE_BY_ADMIN : deactivate() [isSSAdmin == true] / deactivateAccount()

    INACTIVE_BY_SM --> OPERATIONAL : reactivate() [isSSAdmin == true] / activateAccount()
    INACTIVE_BY_ADMIN --> OPERATIONAL : reactivate() [isSSAdmin == true] / activateAccount()
```

