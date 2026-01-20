# 📊 Sơ Đồ Entity Relationship (ER Diagram)

## Tổng Quan

Hệ thống Grevo Solutions sử dụng **MySQL** làm cơ sở dữ liệu chính với các bảng được thiết kế theo mô hình quan hệ.

---

## Sơ Đồ ER

```mermaid
erDiagram
    USERS ||--o| CITIZENS : "has"
    USERS ||--o| COLLECTORS : "has"
    USERS ||--o| ENTERPRISE : "has"
    
    CITIZENS ||--o{ WASTE_REPORTS : "creates"
    CITIZENS ||--o{ POINT_TRANSACTIONS : "receives"
    CITIZENS ||--o{ VOUCHER_REDEMPTIONS : "redeems"
    CITIZENS ||--o{ FEEDBACK : "gives/receives"
    
    ENTERPRISE ||--o{ COLLECTORS : "manages"
    ENTERPRISE ||--o{ VOUCHERS : "creates"
    ENTERPRISE ||--o{ POINT_RULES : "configures"
    ENTERPRISE ||--o{ ENTERPRISE_AREAS : "assigned"
    
    SERVICE_AREAS ||--o{ ENTERPRISE_AREAS : "has"
    SERVICE_AREAS ||--o{ WASTE_REPORTS : "located_in"
    
    COLLECTORS ||--o{ WASTE_REPORTS : "assigned_to"
    COLLECTORS ||--o{ COLLECTOR_REQUESTS : "has"
    COLLECTORS ||--o{ FEEDBACK : "gives/receives"
    
    WASTE_REPORTS ||--o{ WASTE_REPORT_IMAGES : "has"
    WASTE_REPORTS ||--o{ REPORT_LIFECYCLE : "has"
    WASTE_REPORTS ||--o{ STATUS_HISTORY : "has"
    WASTE_REPORTS ||--o{ POINT_TRANSACTIONS : "generates"
    WASTE_REPORTS ||--o{ FEEDBACK : "has"
    
    VOUCHERS ||--o{ VOUCHER_REDEMPTIONS : "redeemed_as"
    
    FEEDBACK ||--o{ FEEDBACK_IMAGES : "has"
    
    WASTE_TYPES ||--o{ POINT_RULES : "used_by"

    USERS {
        int userId PK
        string googleId UK
        string username UK
        string password
        enum role
        boolean isActive
        boolean isVerified
        datetime createAt
        datetime updateAt
        string fullName
        string email UK
        string phone UK
        string address
        string avatar
    }
    
    CITIZENS {
        int citizenId PK
        int userId FK
        int totalPoints
    }
    
    COLLECTORS {
        int collectorId PK
        int userId FK
        int enterpriseId FK
        string vehicleType
        string vehiclePlate
        int maxCapacity
        string currentStatus
        string leaveReason
        datetime lastActiveAt
        boolean isOnline
    }
    
    ENTERPRISE {
        int enterpriseId PK
        int userId FK
        string companyName
        string companyPhone
        string companyEmail
        string companyAdr
        string taxCode
        int capacity
        boolean isActive
    }
    
    SERVICE_AREAS {
        int areaId PK
        string areaName
        string city
        string district
        string ward
        string latitude
        string longitude
        double radius
        boolean isActive
    }
    
    WASTE_REPORTS {
        int reportId PK
        int citizenId FK
        string title
        text description
        string latitude
        string longitude
        string status
        int qualityScore
        datetime createdAt
        string wasteType
        int areaId FK
        double wasteQuantity
        text itemWeights
        int assignedCollectorId FK
        datetime assignedAt
    }
    
    WASTE_REPORT_IMAGES {
        int imageId PK
        int reportId FK
        string imageUrl
        string sourceType
        datetime createdAt
    }
    
    VOUCHERS {
        int voucherId PK
        int enterpriseId FK
        string title
        text description
        int pointsCost
        int quantity
        int redeemedCount
        datetime validFrom
        datetime validUntil
        boolean isActive
        string imageUrl
        datetime createdAt
    }
    
    VOUCHER_REDEMPTIONS {
        int redemptionId PK
        int voucherId FK
        int citizenId FK
        int pointsSpent
        string redemptionCode
        string status
        datetime redeemedAt
        datetime usedAt
    }
    
    POINT_TRANSACTIONS {
        int transactionId PK
        int citizenId FK
        int reportId FK
        int pointsAwarded
        string reason
        datetime createdAt
    }
    
    POINT_RULES {
        int ruleId PK
        int wasteTypeId FK
        int enterpriseId FK
        string ruleName
        string description
        double basePointsPerKg
        double qualityBonusMultiplier
        double minQuantityForBonus
        int quantityBonus
        boolean isActive
        int priority
        datetime createdAt
        datetime updatedAt
    }
    
    FEEDBACK {
        int feedbackId PK
        int reportId FK
        int fromCitizenId FK
        int toCitizenId FK
        int fromCollectorId FK
        int toCollectorId FK
        int starRating
        text description
        datetime createdAt
    }
    
    FEEDBACK_IMAGES {
        int imageId PK
        int feedbackId FK
        string imageUrl
        datetime createdAt
    }
    
    WASTE_TYPES {
        int wasteTypeId PK
        string typeName
        string description
    }
```

---

## Quan Hệ Giữa Các Bảng

### 1. Users & Role-specific Tables

| Quan hệ | Mô tả |
|---------|-------|
| `USERS` → `CITIZENS` | 1:1, User có role CITIZEN |
| `USERS` → `COLLECTORS` | 1:1, User có role COLLECTOR |
| `USERS` → `ENTERPRISE` | 1:1, User có role ENTERPRISE |

### 2. Enterprise & Collectors

| Quan hệ | Mô tả |
|---------|-------|
| `ENTERPRISE` → `COLLECTORS` | 1:N, Doanh nghiệp có nhiều collector |
| `COLLECTORS` → `COLLECTOR_REQUESTS` | 1:N, Collector có nhiều yêu cầu |

### 3. Waste Reports

| Quan hệ | Mô tả |
|---------|-------|
| `CITIZENS` → `WASTE_REPORTS` | 1:N, Citizen tạo nhiều báo cáo |
| `COLLECTORS` → `WASTE_REPORTS` | 1:N, Collector được phân công nhiều báo cáo |
| `SERVICE_AREAS` → `WASTE_REPORTS` | 1:N, Khu vực có nhiều báo cáo |
| `WASTE_REPORTS` → `WASTE_REPORT_IMAGES` | 1:N, Báo cáo có nhiều hình ảnh |

### 4. Points & Rewards

| Quan hệ | Mô tả |
|---------|-------|
| `CITIZENS` → `POINT_TRANSACTIONS` | 1:N, Citizen có nhiều giao dịch điểm |
| `WASTE_REPORTS` → `POINT_TRANSACTIONS` | 1:N, Báo cáo tạo ra điểm |
| `VOUCHERS` → `VOUCHER_REDEMPTIONS` | 1:N, Voucher được đổi nhiều lần |

### 5. Feedback

| Quan hệ | Mô tả |
|---------|-------|
| `WASTE_REPORTS` → `FEEDBACK` | 1:N, Báo cáo có feedback |
| `FEEDBACK` → `FEEDBACK_IMAGES` | 1:N, Feedback có hình ảnh |

---

## Enum Values

### Role (trong USERS)

```
CITIZEN     - Công dân
ENTERPRISE  - Doanh nghiệp
COLLECTOR   - Nhân viên thu gom
ADMIN       - Quản trị viên
```

### Report Status (trong WASTE_REPORTS)

```
PENDING     - Chờ xử lý
ASSIGNED    - Đã phân công
ON_THE_WAY  - Đang trên đường
COLLECTED   - Đã thu gom
CANCELLED   - Đã hủy
```

### Waste Type

```
ORGANIC     - Rác hữu cơ
RECYCLABLE  - Rác tái chế
HAZARDOUS   - Rác nguy hại
GENERAL     - Rác thông thường
```

### Voucher Redemption Status

```
ACTIVE      - Đang hoạt động
USED        - Đã sử dụng
EXPIRED     - Hết hạn
```

### Collector Status

```
AVAILABLE   - Sẵn sàng
BUSY        - Đang bận
PENDING     - Chờ duyệt
PENDING_LEAVE - Chờ duyệt nghỉ phép
ON_LEAVE    - Đang nghỉ
INACTIVE    - Không hoạt động
```

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
