# 👨‍💼 API Quản Trị Viên (Admin API)

**Role yêu cầu**: `ADMIN`

---

## 1. Quản Lý Người Dùng

### 1.1. Danh Sách Người Dùng

Lấy danh sách tất cả người dùng trong hệ thống.

#### Request

```http
GET /api/admin/users?search=nguyen&role=CITIZEN&page=0&size=10&sort=createAt,desc
Authorization: Bearer <JWT_TOKEN>
```

**Query Parameters:**
| Param | Type | Default | Mô tả |
|-------|------|---------|-------|
| search | string | null | Tìm theo tên/email |
| role | string | null | Lọc theo role |
| page | int | 0 | Số trang |
| size | int | 10 | Số lượng mỗi trang |
| sort | string | createAt,desc | Sắp xếp |

#### Response

**Success (200):**
```json
{
    "content": [
        {
            "userId": 1,
            "fullName": "Nguyễn Văn A",
            "email": "user@example.com",
            "phone": "0901234567",
            "role": "CITIZEN",
            "isActive": true,
            "isVerified": true,
            "avatar": "https://cloudinary.com/avatars/user1.jpg",
            "createAt": "2026-01-01T00:00:00",
            "updateAt": "2026-01-20T10:00:00"
        }
    ],
    "totalPages": 10,
    "totalElements": 95,
    "number": 0
}
```

---

### 1.2. Cập Nhật Người Dùng

#### Request

```http
PUT /api/admin/users/{userId}
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "fullName": "Nguyễn Văn A",
    "email": "updated@example.com",
    "phone": "0909123456",
    "role": "CITIZEN",
    "isActive": true
}
```

#### Response

**Success (200):**
```json
{
    "userId": 1,
    "fullName": "Nguyễn Văn A",
    "email": "updated@example.com",
    "role": "CITIZEN",
    "isActive": true
}
```

---

### 1.3. Xóa Người Dùng

#### Request

```http
DELETE /api/admin/users/{userId}
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):** No content

---

### 1.4. Reset Mật Khẩu

Reset mật khẩu về mặc định `123456`.

#### Request

```http
POST /api/admin/users/{userId}/reset-password
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```
Password reset successfully to 123456
```

---

## 2. Quản Lý Doanh Nghiệp

### 2.1. Danh Sách Doanh Nghiệp

#### Request

```http
GET /api/admin/enterprises
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
[
    {
        "enterpriseId": 1,
        "companyName": "Công ty Thu Gom ABC",
        "companyPhone": "028-1234567",
        "companyEmail": "contact@abc.vn",
        "companyAddress": "456 Đường XYZ, Quận 3",
        "taxCode": "0123456789",
        "capacity": 1000,
        "isActive": true,
        "user": {
            "userId": 5,
            "fullName": "Người quản lý",
            "email": "manager@abc.vn"
        },
        "collectorCount": 15,
        "totalReports": 500
    }
]
```

---

## 3. Quản Lý Khu Vực Dịch Vụ

### 3.1. Danh Sách Khu Vực

#### Request

```http
GET /api/admin/service-areas
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
[
    {
        "areaId": 1,
        "areaName": "Quận 1",
        "city": "TP. Hồ Chí Minh",
        "district": "Quận 1",
        "ward": null,
        "latitude": "10.7769",
        "longitude": "106.7009",
        "radius": 5.0,
        "isActive": true,
        "enterpriseCount": 3,
        "reportCount": 150
    }
]
```

---

### 3.2. Tạo Khu Vực Mới

#### Request

```http
POST /api/admin/service-areas
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "areaName": "Quận 7",
    "city": "TP. Hồ Chí Minh",
    "district": "Quận 7",
    "ward": null,
    "latitude": "10.7340",
    "longitude": "106.7217",
    "radius": 3.0,
    "isActive": true
}
```

#### Response

**Success (200):**
```json
{
    "areaId": 10,
    "areaName": "Quận 7",
    "message": "Service area created successfully"
}
```

---

### 3.3. Cập Nhật Khu Vực

#### Request

```http
PUT /api/admin/service-areas/{areaId}
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

---

### 3.4. Xóa Khu Vực

#### Request

```http
DELETE /api/admin/service-areas/{areaId}
Authorization: Bearer <JWT_TOKEN>
```

---

## 4. Phân Quyền Khu Vực - Doanh Nghiệp

### 4.1. Gán Doanh Nghiệp Cho Khu Vực

#### Request

```http
POST /api/admin/enterprise-areas
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "enterpriseId": 1,
    "areaId": 5
}
```

---

### 4.2. Xóa Phân Quyền

#### Request

```http
DELETE /api/admin/enterprise-areas/{enterpriseAreaId}
Authorization: Bearer <JWT_TOKEN>
```

---

## 5. Nhật Ký Hệ Thống

### 5.1. Xem Nhật Ký

#### Request

```http
GET /api/admin/system-logs?page=0&size=50
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "content": [
        {
            "logId": 1,
            "action": "USER_LOGIN",
            "userId": 5,
            "userName": "Nguyễn Văn A",
            "ipAddress": "192.168.1.100",
            "details": "Login successful",
            "createdAt": "2026-01-21T10:00:00"
        }
    ],
    "totalPages": 100,
    "totalElements": 5000,
    "number": 0
}
```

---

## Bảng Điều Khiển Admin

### Dashboard Statistics

Thống kê tổng quan hệ thống.

#### Request

```http
GET /api/admin/dashboard/stats
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "totalUsers": 1500,
    "totalCitizens": 1200,
    "totalEnterprises": 25,
    "totalCollectors": 275,
    "totalReports": 8500,
    "pendingReports": 150,
    "completedReports": 7800,
    "totalPointsAwarded": 250000,
    "totalVouchersRedeemed": 450
}
```

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
