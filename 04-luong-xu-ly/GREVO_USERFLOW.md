# GREVO — Toàn Bộ UserFlow (4 Roles)

> Tài liệu này mô tả toàn bộ luồng hoạt động (user flow) của hệ thống GREVO cho tất cả các vai trò: **Admin**, **Enterprise**, **Collector**, **Citizen**, và các luồng **Public/Auth**.

---

## 1. TỔNG QUAN HỆ THỐNG

```mermaid
flowchart TB
    subgraph Public["🌐 Public Pages"]
        HOME[Landing Page]
        TERMS[Terms of Service]
        PRIVACY[Privacy Policy]
    end

    subgraph Auth["🔐 Authentication"]
        LOGIN[Login / Register]
        VERIFY[Verify Account]
        FORGOT[Forgot Password]
        RESET[Reset Password]
        GOOGLE[Google OAuth]
    end

    subgraph Roles["👥 Role-Based Dashboards"]
        ADMIN["🛡 Admin Dashboard"]
        ENT["🏭 Enterprise Dashboard"]
        COL["🚛 Collector Dashboard"]
        CIT["👤 Citizen Dashboard"]
    end

    HOME --> LOGIN
    LOGIN --> VERIFY --> LOGIN
    LOGIN --> FORGOT --> RESET --> LOGIN
    LOGIN --> GOOGLE --> VERIFY

    LOGIN -->|role=ADMIN| ADMIN
    LOGIN -->|role=ENTERPRISE| ENT
    LOGIN -->|role=COLLECTOR| COL
    LOGIN -->|role=CITIZEN| CIT
```

---

## 2. AUTHENTICATION FLOW

```mermaid
flowchart TD
    A[User mở /login] --> B{Có tài khoản?}
    B -->|Có| C[Nhập email + password]
    B -->|Không| D[Chuyển tab Register]

    C --> E{Đã verify email?}
    E -->|Chưa| F[Redirect /verify-account]
    E -->|Rồi| G{Check role}

    D --> H[Nhập full_name + email + password + phone + address + role]
    H --> I[POST /api/auth/register]
    I --> J[Gửi verification code qua email]
    J --> F

    F --> K[Nhập OTP 6 số]
    K --> L[POST /api/auth/verify]
    L -->|Thành công| M[Redirect /login]
    L -->|Sai/Hết hạn| N[Resend OTP]

    G -->|CITIZEN| CIT["/dashboard"]
    G -->|ENTERPRISE| ENT["/dashboard"]
    G -->|COLLECTOR| COL["/dashboard"]
    G -->|ADMIN| ADM["/dashboard"]

    C2[Google Sign-In] --> C3[POST /api/auth/google]
    C3 --> C4{User tồn tại?}
    C4 -->|Có| G
    C4 -->|Không| C5[Tạo user mới + auto-verify]
    C5 --> G

    FP[Forgot Password] --> FP1[Nhập email]
    FP1 --> FP2[POST /api/auth/forgot-password]
    FP2 --> FP3[Gửi reset link qua email]
    FP3 --> FP4[User click link → /reset-password?token=xxx]
    FP4 --> FP5[Nhập new password]
    FP5 --> FP6[POST /api/auth/reset-password]
    FP6 --> M
```

---

## 3. CITIZEN USERFLOW

```mermaid
flowchart TD
    subgraph CitDash["🏠 Citizen Dashboard /dashboard"]
        CS[Stats Section<br/>Tổng report, Pending, Collected, Points]
        CA[Active Request Card<br/>Hiện report đang xử lý + Map collector]
        CR[Recent Activity<br/>5 report gần nhất]
        CRW[Rewards Section<br/>Vouchers, Points]
    end

    subgraph Report["📝 Report Waste /report-waste"]
        R1[Chọn vị trí trên Map / GPS / Saved Location]
        R2[Chọn Waste Type + Size + Quantity]
        R3[Upload ảnh rác]
        R4[Ghi chú mô tả]
        R5[Submit → POST /api/reports]
    end

    subgraph History["📋 History /history"]
        H1[Xem danh sách report]
        H2[Filter theo status: All, Pending, Assigned, On The Way, Collected]
        H3[Sort: Newest, Oldest]
        H4[Search theo address/description]
        H5[Click report → Modal chi tiết]
        H6[Thấy: ảnh, vị trí, collector info, rating, timeline]
    end

    subgraph Points["⭐ Points & Rewards /points"]
        P1[Tab Point History<br/>Lịch sử tích điểm + tổng hợp tuần]
        P2[Tab Rewards Store<br/>Duyệt voucher available]
        P3[Tab My Vouchers<br/>Voucher đã đổi]
        P4[Tab Leaderboard<br/>Xếp hạng citizen theo điểm tuần]
        P5[Redeem Voucher<br/>POST /api/rewards/redeem/:voucherId]
    end

    subgraph Profile["👤 Profile /profile"]
        PF1[Xem Profile Info]
        PF2[Edit Profile → Modal]
        PF3[Upload Avatar]
        PF4[Saved Locations: Add / Delete]
        PF5[Enterprise Section cho collector]
    end

    subgraph Settings["⚙️ Settings /settings"]
        S1[Change Password]
        S2[Change Email + OTP Verify]
        S3[Delete Account]
    end

    subgraph Feedback["💬 System Feedback"]
        FB1[Submit Feedback → POST /api/system-feedbacks]
        FB2[View My Feedback History]
        FB3[Xem Admin Response]
    end

    CitDash --> Report
    CitDash --> History
    CitDash --> Points
    CitDash --> Profile
    CitDash --> Settings
    CitDash --> Feedback

    R1 --> R2 --> R3 --> R4 --> R5
    R5 -->|Thành công| H1

    P2 --> P5
    P5 -->|Đủ điểm| P3
```

---

## 4. ENTERPRISE USERFLOW

```mermaid
flowchart TD
    subgraph EntDash["🏠 Enterprise Dashboard /dashboard"]
        ES[Stats Grid<br/>Collectors, Reports, Collected Today, Avg Rating]
        EC[Collector Chart<br/>Online vs Offline]
        ER[Revenue Chart<br/>Reports theo thời gian]
        EA[Recent Activity<br/>Last 10 events]
    end

    subgraph Reports["📊 Waste Reports /enterprise/reports"]
        WR1[Xem bảng reports trong khu vực quản lý]
        WR2[Filter: status, waste type, area]
        WR3[Search theo citizen name / address]
        WR4[Sort: newest, oldest, weight]
        WR5[Click report → View Report Modal]
    end

    subgraph ReportDetail["📋 Report Detail Modal"]
        RD1[Header: status badge, timestamps]
        RD2[Mini Map with Route: citizen → collector]
        RD3[Participants: Citizen + Collector cards]
        RD4[Multi-collector dropdown list]
        RD5[Action Panel: Assign Collector]
    end

    subgraph Assign["🚛 Assign Collector"]
        AS1[Xem danh sách Eligible Collectors]
        AS2[Auto-suggest: Fill smallest first]
        AS3[Manual: chọn collectors + allocate weight]
        AS4[Single assign: 1 collector, full weight]
        AS5[Multi assign: N collectors, split weight]
        AS6[POST /api/reports/enterprise/:id/multi-assign]
    end

    subgraph Collectors["👷 Collector Management /enterprise/collectors"]
        CM1[Xem danh sách collectors]
        CM2[Stats: Total, Online, Offline, Pending]
        CM3[Filter: All, Online, Offline, Pending Requests]
        CM4[Invite Collector → Modal nhập email]
        CM5[View Collector Detail Modal]
        CM6[Accept / Reject join request]
        CM7[Remove collector]
        CM8[Bulk delete collectors]
    end

    subgraph Rewards["🎁 Rewards Management /enterprise/rewards"]
        RW1[Tab Vouchers: CRUD vouchers + upload image]
        RW2[Tab Point Rules: CRUD point calculation rules]
        RW3[Tab Leaderboard: xem citizen rankings]
        RW4[Stats: Total vouchers, Active, Redeemed, Rules]
        RW5[View Redemption History per voucher]
    end

    subgraph Scope["🗺 Operating Scope"]
        SC1[Xem assigned areas trên map]
        SC2[Danh sách areas từ Admin]
    end

    subgraph EntProfile["🏢 Enterprise Profile /profile"]
        EP1[Company Info: name, email, phone, tax, logo]
        EP2[Edit Company Profile]
        EP3[Upload Company Logo]
    end

    EntDash --> Reports
    EntDash --> Collectors
    EntDash --> Rewards
    EntDash --> Scope
    EntDash --> EntProfile

    WR5 --> ReportDetail
    RD5 --> Assign

    AS1 --> AS2
    AS2 --> AS3
    AS3 --> AS6
    AS4 --> AS6
```

---

## 5. COLLECTOR USERFLOW

```mermaid
flowchart TD
    subgraph ColDash["🏠 Collector Dashboard /dashboard"]
        CDS[Stats: Today Collections, Capacity, Rating, Tasks]
        CDC[Status Card: Online/Offline toggle]
        CDI[Identity Card: name, vehicle, enterprise]
        CDT[My Tasks Card: shortcut to tasks]
        CDA[Active Task: current ON_THE_WAY task with map]
        CDR[Recent Collections: last 5 completed]
    end

    subgraph Tasks["📋 My Tasks /collector/tasks"]
        T1[Tabs: Assigned / On The Way / Collected]
        T2[Task Cards: address, weight, distance, status]
        T3[Click card → Task Detail expandable]
        T4[Task Detail: citizen info, waste info, evidence, map]
    end

    subgraph TaskActions["⚡ Task Actions"]
        TA1[Accept Task → POST /api/collector/tasks/:id/accept]
        TA2[Assignment status → ON_THE_WAY]
        TA3[Navigate to Route Map]
        TA4[Reject Task → POST /api/collector/tasks/:id/reject]
        TA5[Assignment status → CANCELLED]
    end

    subgraph RouteMap["🗺 Route Map /collector/route-map"]
        RM1[Single Dest Mode: từ task accept URL params]
        RM2[Multi Dest Mode: fetch all ON_THE_WAY tasks]
        RM3[Address Input: set origin location]
        RM4[Task Selector: checkbox multiple tasks]
        RM5[Calculate Route via GraphHopper API]
        RM6[Display route on MapLibre GL map]
        RM7[Turn-by-turn directions panel]
        RM8[Navigation mode: step-by-step]
    end

    subgraph Complete["✅ Complete Task"]
        CP1[Click Collected button]
        CP2[Complete Task Modal]
        CP3[Upload proof photo]
        CP4[Rate citizen 1-5 stars]
        CP5[Survey: waste sorted? citizen cooperative?]
        CP6[GPS auto-capture location]
        CP7[POST /api/collector/tasks/:id/complete]
        CP8[Backend: evaluate terminal state]
        CP9{All assignments terminal?}
        CP10[Report → COLLECTED + Award Points]
        CP11[Report stays ON_THE_WAY]
    end

    subgraph Enterprise["🏭 My Enterprise /collector/enterprise"]
        ME1[Xem Enterprise info card]
        ME2[Search Enterprise để join]
        ME3[Send Join Request → POST /api/collector/enterprise/join]
        ME4[View Pending Request status]
        ME5[Cancel Pending Request]
        ME6[Leave Enterprise → POST /api/collector/enterprise/leave]
        ME7[View Invitations + Accept/Reject]
    end

    subgraph ColInfo["ℹ️ Collector Info /collector/info"]
        CI1[Fill: vehicle type, plate number, max capacity]
        CI2[PUT /api/collector/profile]
    end

    ColDash --> Tasks
    ColDash --> RouteMap
    ColDash --> Enterprise
    ColDash --> ColInfo

    T3 --> TaskActions
    TA1 --> TA2 --> TA3
    TA3 --> RouteMap

    RM1 --> RM5
    RM2 --> RM4 --> RM5
    RM5 --> RM6 --> RM7 --> RM8

    RM7 --> CP1 --> CP2
    CP2 --> CP3 --> CP4 --> CP5 --> CP7
    CP7 --> CP8 --> CP9
    CP9 -->|Yes + fully collected| CP10
    CP9 -->|No / partial| CP11
```

---

## 6. ADMIN USERFLOW

```mermaid
flowchart TD
    subgraph AdminDash["🏠 Admin Dashboard /dashboard"]
        ADS[Stats: Total Users, Active, Enterprise, Reports]
        ADR[Role Distribution: pie chart]
        ADM2[Areas Map: tất cả service areas]
        ADL[Recent Logs: 5 logs gần nhất]
    end

    subgraph Users["👥 User Management /admin/users"]
        UM1[Bảng tất cả users, paginated]
        UM2[Tabs: All, Citizen, Enterprise, Collector, Admin]
        UM3[Search by name/email/phone]
        UM4[Click user → Edit User Modal]
        UM5[Toggle active/inactive status]
        UM6[Bulk select + Bulk delete]
        UM7[Stats: Total, Active, Verified, Disabled]
    end

    subgraph Areas["🗺 System Areas /admin/areas"]
        SA1[Bảng service areas]
        SA2[Create area: name + code + polygon trên map]
        SA3[MapLibre draw polygon]
        SA4[Edit area]
        SA5[Delete area]
    end

    subgraph EntControl["🏭 Enterprise Control /admin/enterprises"]
        EC1[Bảng tất cả enterprises]
        EC2[Stats: Total, Active, Inactive, Areas Count]
        EC3[Tabs: All, Active, Inactive]
        EC4[Search by company name]
        EC5[Toggle enterprise status]
        EC6[Assign Area to Enterprise]
        EC7[Remove Area from Enterprise]
        EC8[Bulk delete enterprises]
    end

    subgraph Logs["📜 System Logs /admin/logs"]
        SL1[Bảng activity logs]
        SL2[Filter: All, Info, Warning, Error]
        SL3[Search by action/message]
        SL4[Auto-refresh]
    end

    subgraph SysFeedback["💬 System Feedbacks /admin/feedbacks"]
        SF1[Bảng user feedbacks]
        SF2[Tabs: All, New, Reviewed]
        SF3[Click → Feedback Detail Modal]
        SF4[Change status NEW → REVIEWED]
        SF5[Write admin response]
        SF6[Bulk delete feedbacks]
    end

    AdminDash --> Users
    AdminDash --> Areas
    AdminDash --> EntControl
    AdminDash --> Logs
    AdminDash --> SysFeedback

    EC6 -->|POST admin/enterprises/:id/areas| SA1
    EC7 -->|DELETE admin/enterprises/:id/areas/:areaId| SA1
```

---

## 7. SHARED / CROSS-ROLE FLOWS

```mermaid
flowchart TD
    subgraph WasteReport["🔄 Waste Report Lifecycle"]
        WR_PENDING[PENDING<br/>Citizen tạo report]
        WR_ASSIGNED[ASSIGNED<br/>Enterprise gán collector]
        WR_OTW[ON_THE_WAY<br/>Collector accept task]
        WR_COLLECTED[COLLECTED<br/>Tất cả collector hoàn thành]
        WR_CANCELLED[CANCELLED<br/>Enterprise cancel]

        WR_PENDING --> WR_ASSIGNED
        WR_ASSIGNED --> WR_OTW
        WR_OTW --> WR_COLLECTED
        WR_ASSIGNED --> WR_CANCELLED
        WR_OTW --> WR_CANCELLED
    end

    subgraph MultiCollector["🔀 Multi-Collector Assignment"]
        MC1[Enterprise chọn N collectors]
        MC2[Phân chia weight cho mỗi collector]
        MC3[Mỗi collector có assignment riêng]
        MC4[Collector A hoàn thành → checked]
        MC5[Collector B hoàn thành → checked]
        MC6{Sum weight ≥ report weight?}
        MC7[Report → COLLECTED]
        MC8[Report stays ON_THE_WAY<br/>Enterprise re-assign gap]

        MC1 --> MC2 --> MC3
        MC3 --> MC4
        MC3 --> MC5
        MC4 --> MC6
        MC5 --> MC6
        MC6 -->|Yes| MC7
        MC6 -->|No gap| MC8
    end

    subgraph LocationFlow["📍 Location QR Scan"]
        LQ1[Citizen scan QR code chứa /report-waste?session=xxx]
        LQ2[Backend: create LocationSession]
        LQ3[Citizen: update GPS → PUT session/location]
        LQ4[Auto-fill address vào report form]
        LQ5[Session expires sau 15 phút]

        LQ1 --> LQ2 --> LQ3 --> LQ4
        LQ2 --> LQ5
    end

    subgraph PointsCycle["💰 Points Cycle"]
        PC1[Report COLLECTED]
        PC2[Backend: calculateAndAwardPoints]
        PC3[Match Point Rules by enterprise + waste type]
        PC4[Calculate: base × weight × quality bonus]
        PC5[Award points to citizen]
        PC6[Create PointTransaction record]
        PC7[Citizen xem điểm → Redeem voucher]

        PC1 --> PC2 --> PC3 --> PC4 --> PC5 --> PC6 --> PC7
    end

    subgraph CollectorJoin["🤝 Collector ↔ Enterprise"]
        CJ1[Collector search enterprise]
        CJ2[Send join request]
        CJ3[Enterprise review request]
        CJ4{Accept or Reject?}
        CJ5[Collector thuộc enterprise]
        CJ6[Rejected → thông báo]
        CJ7[Enterprise invite collector]
        CJ8[Collector xem invitation]
        CJ9[Accept invitation]

        CJ1 --> CJ2 --> CJ3 --> CJ4
        CJ4 -->|Accept| CJ5
        CJ4 -->|Reject| CJ6
        CJ7 --> CJ8 --> CJ9 --> CJ5
    end
```

---

## 8. PROFILE & SETTINGS FLOW (Shared All Roles)

```mermaid
flowchart TD
    subgraph ProfileFlow["👤 Profile Management"]
        P_VIEW[Xem Profile Sidebar]
        P_EDIT[Edit Profile Modal<br/>name, phone, address]
        P_AVATAR[Upload / Remove Avatar]
        P_LOC[Saved Locations<br/>CRUD + address autocomplete]
        P_COMPLETION[Profile Completion %<br/>Hiện progress bar]
    end

    subgraph SettingsFlow["⚙️ Settings"]
        S_PWD[Change Password<br/>verify old → set new]
        S_EMAIL[Change Email<br/>send code → verify OTP]
        S_DELETE[Delete Account<br/>confirm password]
    end

    subgraph FeedbackFlow["💬 System Feedback"]
        F_SUBMIT[Submit: category + rating + subject + description + images]
        F_HISTORY[Xem feedback history]
        F_RESPONSE[Xem admin response]
    end

    P_VIEW --> P_EDIT
    P_VIEW --> P_AVATAR
    P_VIEW --> P_LOC
```
