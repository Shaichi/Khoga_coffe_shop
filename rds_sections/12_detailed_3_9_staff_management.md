### **3.9 Staff Management**

*\[Provide the detailed design for Staff Management, covering UC-35→UC-39 (View/Create/Update/Delete Schedule, View Attendance Report), UC-66 (Attendance Check-in/out with PIN + Photo Capture), and UC-80 (Export Worked Hours). Actors: storemanager (schedule CRUD + attendance oversight), cashier/barista (self check-in at branch). Key PDPA design: attendance photos are stored on server filesystem (path only in DB), automatically purged by PhotoAutoDeleteScheduler after 90 days (BR-72).\]*

#### ***3.9.1 Class Diagram***

*\[Class diagram for Staff Management. COMET stereotypes: ScheduleCalendarView, CreateScheduleForm, AttendanceCheckInScreen, AttendanceReportView («boundary»); ScheduleCoordinator, AttendanceCoordinator («control»); AttendancePhotoManager («application logic»); PhotoAutoDeleteScheduler («timer»); StaffSchedule, AttendanceLog, User («entity»).\]*

```mermaid
classDiagram
    class ScheduleCalendarView {
        <<boundary>>
        +weekView: CalendarGrid
        +storeId: UUID
        +displaySchedule()
    }
    class CreateScheduleForm {
        <<boundary>>
        +employeeId: UUID
        +date: Date
        +shiftType: ShiftType
        +startTime: Time
        +endTime: Time
        +posRegisterId: Integer
        +submitSchedule()
    }
    class AttendanceCheckInScreen {
        <<boundary>>
        +employeeId: UUID
        +pin: TextField
        +cameraCapture: CameraWidget
        +submitCheckIn()
        +submitCheckOut()
    }
    class AttendanceReportView {
        <<boundary>>
        +storeId: UUID
        +dateRange: DateRange
        +displayReport()
        +exportExcel()
    }
    class ScheduleCoordinator {
        <<control>>
        +getSchedule(storeId, week): List~ScheduleDto~
        +createSchedule(dto): StaffSchedule
        +updateSchedule(id, dto): StaffSchedule
        +deleteSchedule(id): void
    }
    class AttendanceCoordinator {
        <<control>>
        +checkIn(employeeId, pin, photo): AttendanceLog
        +checkOut(attendanceId, pin): AttendanceLog
        +getAttendanceReport(storeId, range): ReportDto
        +exportWorkedHours(storeId, range): ExcelFile
    }
    class AttendancePhotoManager {
        <<application logic>>
        +savePhotoToFilesystem(photoData): String
        +getPhotoPath(attendanceId): String
        +validatePhotoFormat(data): Boolean
    }
    class PhotoAutoDeleteScheduler {
        <<timer>>
        +schedule: "0 2 * * *" (daily 02:00)
        +purgePhotosOlderThan(days: 90): void
    }
    class StaffSchedule {
        <<entity>>
        +id: UUID
        +storeId: UUID
        +userId: UUID
        +date: Date
        +shiftType: ShiftType
        +startTime: Time
        +endTime: Time
        +posRegisterId: Integer
    }
    class AttendanceLog {
        <<entity>>
        +id: UUID
        +storeId: UUID
        +userId: UUID
        +scheduledDate: Date
        +checkInTime: DateTime
        +checkOutTime: DateTime
        +status: AttendanceStatus
        +photoPath: String
        +lateMinutes: Integer
    }
    class User {
        <<entity>>
        +id: UUID
        +pin: String
        +fullName: String
        +role: Role
    }

    ScheduleCalendarView ..> ScheduleCoordinator
    CreateScheduleForm ..> ScheduleCoordinator
    AttendanceCheckInScreen ..> AttendanceCoordinator
    AttendanceReportView ..> AttendanceCoordinator
    AttendanceCoordinator --> AttendancePhotoManager
    AttendanceCoordinator --> AttendanceLog
    AttendanceCoordinator --> User
    ScheduleCoordinator --> StaffSchedule
    ScheduleCoordinator --> User
    PhotoAutoDeleteScheduler --> AttendanceLog
```

#### ***3.9.2 UC-36 Create Staff Schedule***

*\[storemanager creates a schedule entry for a specific employee in the branch. System validates the employee belongs to the branch and detects scheduling conflicts (same employee, overlapping dates/shifts). POS register ID is optionally assigned to cashier shifts.\]*

```mermaid
sequenceDiagram
    actor storemanager
    participant CreateForm as CreateScheduleForm
    participant ScheduleCoord as ScheduleCoordinator
    participant UserDB as User (DB)
    participant ScheduleDB as StaffSchedule (DB)

    storemanager->>CreateForm: inputScheduleDetails(employeeId, date, shiftType, posRegisterId)
    CreateForm->>ScheduleCoord: createSchedule(dto)
    ScheduleCoord->>UserDB: verifyEmployeeInBranch(employeeId, storeId)
    UserDB-->>ScheduleCoord: employee confirmed
    ScheduleCoord->>ScheduleDB: checkConflict(employeeId, date, startTime, endTime)
    ScheduleDB-->>ScheduleCoord: noConflict
    ScheduleCoord->>ScheduleDB: createSchedule(dto)
    ScheduleDB-->>ScheduleCoord: newSchedule
    ScheduleCoord-->>CreateForm: showSuccess()
    CreateForm-->>storemanager: refreshCalendarView()
```

#### ***3.9.3 UC-66 Attendance Check-In with Photo (PDPA-Compliant)***

*\[Employee clocks in at branch using their 4-digit PIN + camera photo capture (BR-93). System validates PIN, saves photo to server filesystem (only the path is stored in DB), computes lateness against scheduled start time, and creates an AttendanceLog record. PDPA compliance: photos are auto-purged after 90 days by PhotoAutoDeleteScheduler (BR-72).\]*

```mermaid
sequenceDiagram
    actor employee
    participant CheckInScreen as AttendanceCheckInScreen
    participant AttendCoord as AttendanceCoordinator
    participant PhotoMgr as AttendancePhotoManager
    participant UserDB as User (DB)
    participant ScheduleDB as StaffSchedule (DB)
    participant AttendDB as AttendanceLog (DB)

    employee->>CheckInScreen: inputPinAndCapturePhoto(pin, photoData)
    CheckInScreen->>AttendCoord: checkIn(employeeId, pin, photoData)
    AttendCoord->>UserDB: verifyPin(employeeId, pin)
    UserDB-->>AttendCoord: verified
    AttendCoord->>PhotoMgr: validatePhotoFormat(photoData)
    PhotoMgr-->>AttendCoord: valid
    AttendCoord->>PhotoMgr: savePhotoToFilesystem(photoData)
    PhotoMgr-->>AttendCoord: photoPath (server filesystem path)
    Note over AttendCoord,AttendDB: Actual photo stored on server filesystem.\nOnly path string saved in DB. (BR-72 PDPA)
    AttendCoord->>ScheduleDB: findTodaySchedule(employeeId, storeId)
    ScheduleDB-->>AttendCoord: scheduleRecord (startTime)
    AttendCoord->>AttendCoord: computeLateMinutes(checkInTime, startTime)
    AttendCoord->>AttendCoord: determineStatus(ON_TIME / LATE)
    AttendCoord->>AttendDB: createAttendanceLog(employeeId, checkInTime, photoPath, status, lateMinutes)
    AttendDB-->>AttendCoord: attendanceRecord
    AttendCoord-->>CheckInScreen: showCheckInSuccess(status)
    CheckInScreen-->>employee: displaySuccess()
```

#### ***3.9.4 PDPA Photo Auto-Deletion (PhotoAutoDeleteScheduler)***

*\[PhotoAutoDeleteScheduler runs every day at 02:00 (cron). It finds all attendance log records with non-null photo paths older than 90 days, deletes the physical files from the server filesystem, and sets photoPath to null in the database. This satisfies BR-72 (PDPA data minimization).\]*

```mermaid
sequenceDiagram
    participant PhotoScheduler as PhotoAutoDeleteScheduler
    participant AttendDB as AttendanceLog (DB)
    participant Filesystem as Server Filesystem

    Note over PhotoScheduler: Triggered at 02:00 daily (cron: 0 2 * * *)
    PhotoScheduler->>AttendDB: findLogsWithPhotosOlderThan(90 days)
    AttendDB-->>PhotoScheduler: expiredLogsList[]

    loop for each attendanceLog in expiredLogsList
        PhotoScheduler->>Filesystem: deleteFile(log.photoPath)
        Filesystem-->>PhotoScheduler: deleted OK
        PhotoScheduler->>AttendDB: setPhotoPath(log.id, null)
    end

    Note over PhotoScheduler: PDPA BR-72 compliance satisfied
```

