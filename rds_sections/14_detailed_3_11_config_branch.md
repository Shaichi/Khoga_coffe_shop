### **3.11 System Configuration & Branch Management**

*\[Provide the detailed design for System Configuration & Branch Management, covering UC-30 (Central System Config by ssadmin), UC-42 (Branch-Local Config Override by storemanager), and UC-63→UC-65 (Branch Lifecycle: Add/Edit/Deactivate). Key constraints: Adding a branch is blocked if MAX_ACTIVE_BRANCHES is reached (BR-54). Deactivating a branch is blocked if the branch has OPEN shift sessions OR any orders in non-terminal states (PENDING/PREPARING/HOLD/READY) per BR-55, and on success cascades per BR-56 (deactivate branch staff + delete future schedules with notification). All config changes are audit-logged. NOTE: `SystemConfig` is an infrastructure-level key-value store (config_key/config_value/scope), intentionally outside the 21-entity business ERD of Section 2; it persists central parameters editable via UC-30 with updatedBy/updatedAt for the audit trail.\]*

#### ***3.11.1 Class Diagram***

*\[Class diagram for Config & Branch Management. COMET stereotypes: SystemConfigForm, BranchLocalConfigForm, AddBranchForm, EditBranchForm, BranchListView («boundary»); SystemConfigCoordinator, BranchCoordinator («control»); SystemConfig, Store, AuditLog («entity»).\]*

```mermaid
classDiagram
    class SystemConfigForm {
        <<boundary>>
        +configKey: String
        +configValue: String
        +scope: ConfigScope
        +submitUpdate()
    }
    class BranchLocalConfigForm {
        <<boundary>>
        +storeId: UUID
        +configKey: String
        +overrideValue: String
        +submitOverride()
    }
    class AddBranchForm {
        <<boundary>>
        +name: String
        +address: String
        +phone: String
        +managerUserId: UUID
        +submitCreate()
    }
    class EditBranchForm {
        <<boundary>>
        +storeId: UUID
        +updateFields: StoreDto
        +submitChanges()
    }
    class BranchListView {
        <<boundary>>
        +displayBranches()
        +searchFilter: String
    }
    class SystemConfigCoordinator {
        <<control>>
        +getSystemConfig(key): ConfigDto
        +updateSystemConfig(key, value): void
        +getBranchLocalConfig(storeId, key): ConfigDto
        +updateBranchLocalConfig(storeId, key, value): void
    }
    class BranchCoordinator {
        <<control>>
        +listBranches(filter): List~StoreDto~
        +addBranch(dto): Store
        +updateBranch(id, dto): Store
        +deactivateBranch(id): void
    }
    class SystemConfig {
        <<entity>>
        +id: UUID
        +configKey: String
        +configValue: String
        +scope: ConfigScope
        +storeId: UUID
        +updatedBy: UUID
        +updatedAt: DateTime
    }
    class Store {
        <<entity>>
        +id: UUID
        +name: String
        +address: String
        +phone: String
        +isActive: Boolean
        +createdAt: DateTime
    }
    class AuditLog {
        <<entity>>
        +writeLog(actionType, entity, old, new)
    }

    SystemConfigForm ..> SystemConfigCoordinator
    BranchLocalConfigForm ..> SystemConfigCoordinator
    AddBranchForm ..> BranchCoordinator
    EditBranchForm ..> BranchCoordinator
    BranchListView ..> BranchCoordinator
    SystemConfigCoordinator --> SystemConfig
    SystemConfigCoordinator --> AuditLog
    BranchCoordinator --> Store
    BranchCoordinator --> AuditLog
```

#### ***3.11.2 UC-30 Central System Configuration***

*\[ssadmin manages central system-wide configurations: tax rate (BR-45), loyalty earn/redemption parameters (BR-94), VietQR API credentials, MAX_ACTIVE_BRANCHES (BR-54), and other global parameters held in the `SystemConfig` infrastructure key-value store. Every change is audit-logged. Config values are loaded fresh from the store on each request (no restart needed), applying to new orders per BR-46.\]*

```mermaid
sequenceDiagram
    actor ssadmin
participant ConfigForm as "«boundary»<br/>SystemConfigForm"
participant ConfigCoord as "«control»<br/>SystemConfigCoordinator"
participant ConfigDB as "«entity»<br/>SystemConfig (DB)"
participant AuditDB as "«entity»<br/>AuditLog (DB)"

    ssadmin->>ConfigForm: openConfigPanel()
    ConfigForm->>ConfigCoord: getSystemConfig(key="*")
    ConfigCoord->>ConfigDB: findAllGlobalConfigs()
    ConfigDB-->>ConfigCoord: configList[]
    ConfigCoord-->>ConfigForm: displayConfigGrid()

    ssadmin->>ConfigForm: inputConfigValue(key, value)
    ConfigForm->>ConfigCoord: updateSystemConfig(key, newValue, scope=GLOBAL)
    ConfigCoord->>ConfigDB: findByKey(key)
    ConfigDB-->>ConfigCoord: oldConfig
    ConfigCoord->>ConfigDB: updateConfig(key, newValue, updatedBy=ssadmin.id, updatedAt=now)
    ConfigCoord->>AuditDB: writeAuditLog(UPDATE, system_configs, oldConfig, newConfig)
    ConfigCoord-->>ConfigForm: showSuccess(key, newValue)
    ConfigForm-->>ssadmin: displayUpdatedConfigGrid()
```

#### ***3.11.3 UC-63/64/65 Branch Lifecycle Management***

*\[ssadmin creates, updates, or deactivates branch records. Adding a branch checks MAX_ACTIVE_BRANCHES constraint (BR-54). Deactivating a branch checks that no OPEN shift sessions AND no non-terminal orders exist (BR-55); on success it cascades per BR-56 (deactivate branch staff + terminate their sessions, delete future schedules with notification; historical records preserved read-only). All operations are audit-logged.\]*

```mermaid
sequenceDiagram
    actor ssadmin
participant BranchForm as "«boundary»<br/>AddBranchForm / EditBranchForm"
participant BranchCoord as "«control»<br/>BranchCoordinator"
    participant ConfigDB as SystemConfig (KV store)
participant ShiftDB as "«entity»<br/>ShiftSession (DB)"
participant OrderDB as "«entity»<br/>Order (DB)"
participant StoreDB as "«entity»<br/>Store (DB)"
participant UserDB as "«entity»<br/>User (DB)"
participant ScheduleDB as "«entity»<br/>StaffSchedule (DB)"
participant AuditDB as "«entity»<br/>AuditLog (DB)"

    ssadmin->>BranchForm: submitBranchAction(dto)
    BranchForm->>BranchCoord: submitAction(dto)

    alt ADD Branch (UC-64)
        BranchCoord->>ConfigDB: getConfig(MAX_ACTIVE_BRANCHES)
        ConfigDB-->>BranchCoord: maxBranches = N
        BranchCoord->>StoreDB: countActiveBranches()
        StoreDB-->>BranchCoord: currentCount = C
        BranchCoord->>BranchCoord: validate(C < N) — blocked if C >= N (BR-54)
        BranchCoord->>StoreDB: createStore(dto, isActive=true)
        StoreDB-->>BranchCoord: newStore
        BranchCoord->>AuditDB: writeAuditLog(CREATE, stores, null, newStore)
    else EDIT Branch (UC-65 Update)
        BranchCoord->>StoreDB: findById(storeId)
        StoreDB-->>BranchCoord: oldStoreRecord
        BranchCoord->>StoreDB: updateStore(storeId, dto)
        BranchCoord->>AuditDB: writeAuditLog(UPDATE, stores, oldRecord, newRecord)
    else DEACTIVATE Branch (UC-65 Deactivate)
        BranchCoord->>ShiftDB: findOpenShifts(storeId)
        ShiftDB-->>BranchCoord: openShiftsList (must be empty)
        BranchCoord->>OrderDB: findNonTerminalOrders(storeId)
        OrderDB-->>BranchCoord: activeOrders (must be empty — BR-55)
        BranchCoord->>BranchCoord: validate(openShifts.isEmpty() && activeOrders.isEmpty()) — else block
        BranchCoord->>StoreDB: setIsActive(storeId, false)
        Note over BranchCoord, ScheduleDB: Cascade per BR-56
        BranchCoord->>UserDB: deactivateBranchStaff(storeId) + terminateSessions()
        BranchCoord->>ScheduleDB: deleteFutureSchedules(storeId) + notifyEmployees()
        BranchCoord->>AuditDB: writeAuditLog(UPDATE, stores, isActive=true, isActive=false)
    end

    BranchCoord-->>BranchForm: showSuccess()
    BranchForm-->>ssadmin: refreshBranchList()
```

