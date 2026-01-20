# Kiến Trúc Hệ Thống Grevo Solutions

## Tổng Quan Kiến Trúc

Grevo Solutions được xây dựng theo mô hình **Client-Server Architecture** với **RESTful API**.

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                             │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │   Web Browser   │  │   Mobile App    │  │   Admin Panel   │  │
│  │  (React + Vite) │  │    (Future)     │  │  (React + Vite) │  │
│  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘  │
└───────────┼────────────────────┼───────────────────┼────────────┘
            │                    │                   │
            ▼                    ▼                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                      API GATEWAY LAYER                          │
├─────────────────────────────────────────────────────────────────┤
│                      HTTPS / REST API                           │
│                   JWT Token Authentication                      │
│                     CORS Configuration                          │
└─────────────────────────────────┬───────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                      BACKEND LAYER                              │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              SPRING BOOT APPLICATION                    │    │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │    │
│  │  │  Controller  │  │   Service    │  │  Repository  │   │    │
│  │  │    Layer     │──│    Layer     │──│    Layer     │   │    │
│  │  └──────────────┘  └──────────────┘  └──────────────┘   │    │
│  │                                                         │    │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │    │
│  │  │   Security   │  │   DTO/Model  │  │   Config     │   │    │
│  │  │  (JWT+OAuth) │  │    Mapping   │  │              │   │    │
│  │  └──────────────┘  └──────────────┘  └──────────────┘   │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────┬───────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                    DATABASE & STORAGE LAYER                     │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐                       │
│  │     MySQL       │  │   Cloudinary    │                       │
│  │  (Primary DB)   │  │ (Image Storage) │                       │
│  └─────────────────┘  └─────────────────┘                       │
└─────────────────────────────────────────────────────────────────┘
```

---

## Mô Hình Kiến Trúc Backend

### 1. Controller Layer
Xử lý HTTP request và response, mapping endpoints.

| Controller | Chức năng |
|------------|-----------|
| `AuthController` | Xác thực người dùng |
| `WasteReportController` | Quản lý báo cáo rác |
| `CollectorTaskController` | Quản lý nhiệm vụ thu gom |
| `EnterpriseCollectorController` | Quản lý nhân viên thu gom |
| `FeedbackController` | Quản lý đánh giá |
| `VoucherController` | Quản lý voucher doanh nghiệp |
| `RewardsController` | Đổi thưởng công dân |
| `PointHistoryController` | Lịch sử điểm |
| `LeaderboardController` | Bảng xếp hạng |
| `PointRulesController` | Quy tắc tính điểm |
| `AdminUserController` | Quản lý người dùng (Admin) |
| `AdminEnterpriseController` | Quản lý doanh nghiệp (Admin) |
| `AdminServiceAreaController` | Quản lý khu vực (Admin) |

### 2. Service Layer
Chứa logic nghiệp vụ chính.

| Service | Chức năng |
|---------|-----------|
| `AuthService` | Xác thực, tạo token JWT |
| `WasteReportService` | Xử lý báo cáo rác |
| `UserService` | Quản lý người dùng |
| `PointRulesService` | Tính điểm thưởng |
| `CloudinaryService` | Upload hình ảnh |

### 3. Repository Layer
Tương tác với cơ sở dữ liệu thông qua Spring Data JPA.

---

## Mô Hình Kiến Trúc Frontend

```
┌─────────────────────────────────────────────────────────────────┐
│                    FRONTEND ARCHITECTURE                        │
├─────────────────────────────────────────────────────────────────┤
│  src/                                                           │
│  ├── components/           # Các component UI tái sử dụng       │
│  │   ├── common/          # Button, Input, Modal, Card...       │
│  │   ├── layout/          # Header, Sidebar, Footer             │
│  │   ├── animations/      # Các animation component             │
│  │   └── sections/        # Các section theo trang              │
│  │       ├── citizen/     # Section cho công dân                │
│  │       ├── collector/   # Section cho nhân viên thu gom       │
│  │       ├── enterprise/  # Section cho doanh nghiệp            │
│  │       └── admin/       # Section cho quản trị viên           │
│  │                                                              │
│  ├── pages/               # Các trang của ứng dụng              │
│  │   ├── citizen/         # Dashboard, History, ReportWaste     │
│  │   ├── collector/       # Tasks, History, Profile             │
│  │   ├── enterprise/      # Reports, Collectors, Vouchers       │
│  │   └── admin/           # Users, Enterprises, ServiceAreas    │
│  │                                                              │
│  ├── hooks/               # Custom React hooks                   │
│  │   ├── citizen/         # useCitizenReports, usePoints        │
│  │   ├── collector/       # useCollectorTasks, useProfile       │
│  │   └── enterprise/      # useEnterpriseReports, useVouchers   │
│  │                                                              │
│  ├── services/            # API service layer                    │
│  │   ├── authService.js   # Xác thực                            │
│  │   ├── wasteReportService.js                                  │
│  │   ├── collectorService.js                                    │
│  │   └── enterpriseService.js                                   │
│  │                                                              │
│  ├── context/             # React Context (Auth, Theme)          │
│  ├── routes/              # Route configuration                  │
│  └── utils/               # Utilities, constants                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Luồng Xử Lý Request

```
┌──────────┐    HTTP     ┌──────────────┐    ┌──────────────┐
│  Client  │ ──────────► │  Controller  │ ─► │ JWT Filter   │
└──────────┘             └──────────────┘    └──────────────┘
                                                     │
                                                     ▼
                            ┌──────────────┐    ┌──────────────┐
                            │   Service    │ ◄─ │   Security   │
                            └──────────────┘    │   Context    │
                                   │            └──────────────┘
                                   ▼
                            ┌──────────────┐
                            │  Repository  │
                            └──────────────┘
                                   │
                                   ▼
                            ┌──────────────┐
                            │   Database   │
                            └──────────────┘
```

---

## Bảo Mật

### JWT Authentication Flow

```
┌──────────┐                    ┌──────────────┐                 ┌──────────┐
│  Client  │                    │    Server    │                 │ Database │
└────┬─────┘                    └──────┬───────┘                 └────┬─────┘
     │                                 │                              │
     │ 1. POST /api/auth/login         │                              │
     │ (username, password)            │                              │
     │ ────────────────────────────►   │                              │
     │                                 │  2. Verify credentials       │
     │                                 │ ─────────────────────────►   │
     │                                 │                              │
     │                                 │  3. User data                │
     │                                 │ ◄─────────────────────────   │
     │                                 │                              │
     │ 4. Return JWT Token             │                              │
     │ ◄────────────────────────────   │                              │
     │                                 │                              │
     │ 5. Request with Bearer Token    │                              │
     │ ────────────────────────────►   │                              │
     │                                 │  6. Validate token           │
     │                                 │  7. Process request          │
     │                                 │                              │
     │ 8. Response                     │                              │
     │ ◄────────────────────────────   │                              │
     │                                 │                              │
```

### Phân Quyền Theo Role

| Role | Quyền hạn |
|------|-----------|
| **CITIZEN** | Báo cáo rác, xem lịch sử, đổi điểm, đánh giá |
| **COLLECTOR** | Nhận nhiệm vụ, cập nhật trạng thái, đánh giá công dân |
| **ENTERPRISE** | Quản lý collector, phân công nhiệm vụ, tạo voucher, cấu hình điểm |
| **ADMIN** | Toàn quyền: quản lý user, enterprise, service area |

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
