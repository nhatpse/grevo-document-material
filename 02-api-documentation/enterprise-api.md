# 🏢 API Doanh Nghiệp (Enterprise API)

**Role yêu cầu**: `ENTERPRISE`

---

## 1. Thông Tin Doanh Nghiệp (Profile & Scope)

### 1.1. Xem Thông Tin Hồ Sơ Tâm Cỡ

#### Request

```http
GET /api/enterprises/me
Authorization: Bearer <JWT_TOKEN>
```

#### Response (200 OK)

```json
{
    "enterpriseId": 1,
    "userId": 10,
    "companyName": "Công ty Thu Gom ABC",
    "companyPhone": "028-1234567",
    "companyEmail": "contact@abc-thugom.vn",
    "companyAdr": "456 Đường XYZ, Quận 3, TP.HCM",
    "taxCode": "0123456789",
    "capacity": 1000,
    "logoUrl": "https://cloudinary.com/...",
    "status": "ACTIVE",
    "isActive": true
}
```

---

### 1.2. Cập Nhật Hồ Sơ

#### Request

```http
PUT /api/enterprises/me
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "companyName": "Công ty Thu Gom ABC Mới",
    "companyPhone": "028-9999999",
    "capacity": 1500
}
```

#### Response (200 OK)
Trả về đối tượng Enterprise đã cập nhật.

---

### 1.3. Cập Nhật Logo

#### Request

```http
POST /api/enterprises/me/logo
Content-Type: multipart/form-data
Authorization: Bearer <JWT_TOKEN>
```

**Form Data:**
- `logo` (file): File hình ảnh

---

### 1.4. Lấy Khu Vực Hoạt Động (Scope)

#### Request

```http
GET /api/enterprises/me/scope
Authorization: Bearer <JWT_TOKEN>
```

#### Response (200 OK)
```json
[
    {
        "areaId": 1,
        "areaName": "Quận 1, TP.HCM",
        "boundaryData": "..."
    }
]
```

---

### 1.5. Thêm Khu Vực Hoạt Động

#### Request

```http
POST /api/enterprises/me/scope
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "areaId": 2
}
```

---

### 1.6. Xóa Khu Vực Khỏi Hoạt Động

#### Request

```http
DELETE /api/enterprises/me/scope/{areaId}
Authorization: Bearer <JWT_TOKEN>
```

---

## 2. Quản Lý Báo Cáo Rác Thải

### 2.1. Thống Kê Báo Cáo Của Doanh Nghiệp

#### Request

```http
GET /api/reports/enterprise/stats
Authorization: Bearer <JWT_TOKEN>
```

#### Response (200 OK)
```json
{
    "totalPending": 5,
    "totalAssigned": 10,
    "totalCompleted": 150,
    "totalCollectors": 20
}
```

*(Các endpoint GET reports, GET history, GET chi tiết báo cáo, POST assign, PUT status... giữ nguyên phần còn lại của API reports)*

### 2.2. Báo Cáo Chờ Xử Lý
```http
GET /api/reports/enterprise?page=0&size=10&sortBy=createdAt&sortDir=desc
```

### 2.3. Lịch Sử Báo Cáo
```http
GET /api/reports/enterprise/history?page=0&size=10
```

### 2.4. Chi Tiết Báo Cáo
```http
GET /api/reports/enterprise/{reportId}
```

### 2.5. Collector Phù Hợp
```http
GET /api/reports/enterprise/{reportId}/eligible-collectors
```

### 2.6. Phân Công Collector
```http
POST /api/reports/enterprise/{reportId}/assign
```

### 2.7. Phân Công Nhiều Collector
```http
POST /api/reports/enterprise/{reportId}/multi-assign
```

### 2.8. Cập Nhật Trạng Thái Báo Cáo
```http
PUT /api/reports/enterprise/{reportId}/status
```

---

## 3. Quản Lý Nhân Viên Thu Gom

### 3.1. Danh Sách Collector

#### Request

```http
GET /api/enterprises/me/collectors?status=ACTIVE&search=Trần
Authorization: Bearer <JWT_TOKEN>
```

**Query Parameters:**
| Param | Type | Mô tả |
|-------|------|-------|
| status | string | `ACTIVE`, `PENDING`, `LEAVE_REQUESTED` |
| search | string | Tìm theo tên, email, phone |

#### Response (200 OK)
```json
[
    {
        "id": 5,
        "userId": 10,
        "fullName": "Trần Văn B",
        "email": "tranvanb@email.com",
        "phone": "0909123456",
        "vehicleType": "Xe máy",
        "vehiclePlate": "59A1-12345",
        "maxCapacity": 50,
        "currentStatus": "ACTIVE",
        "status": "APPROVED",
        "lastActiveAt": "2026-01-21T10:00:00"
    }
]
```

---

### 3.2. Duyệt Yêu Cầu Tham Gia

#### Request

```http
POST /api/enterprises/me/collectors/{collectorId}/approve
Authorization: Bearer <JWT_TOKEN>
```

---

### 3.3. Từ Chối Yêu Cầu Tham Gia / Xóa Collector

#### Request

```http
POST /api/enterprises/me/collectors/{collectorId}/reject
Authorization: Bearer <JWT_TOKEN>
```

---

### 3.4. Duyệt Nghỉ Phép

#### Request

```http
POST /api/enterprises/me/collectors/{collectorId}/approve-leave
Authorization: Bearer <JWT_TOKEN>
```

---

### 3.5. Từ Chối Nghỉ Phép

#### Request

```http
POST /api/enterprises/me/collectors/{collectorId}/reject-leave
Authorization: Bearer <JWT_TOKEN>
```

---

## 4. Quản Lý Voucher

*(Quản lý voucher sử dụng chung endpoint `/api/enterprise/vouchers`)*

### 4.1. Danh Sách Voucher
```http
GET /api/enterprise/vouchers
```

### 4.2. Tạo Voucher Mới
```http
POST /api/enterprise/vouchers
```

### 4.3. Cập Nhật Voucher
```http
PUT /api/enterprise/vouchers/{voucherId}
```

### 4.4. Xóa Voucher
```http
DELETE /api/enterprise/vouchers/{voucherId}
```

### 4.5. Lịch Sử Đổi Voucher
```http
GET /api/enterprise/vouchers/{voucherId}/redemptions
```

---

## 5. Quy Tắc Tính Điểm

*(Quy tắc điểm sử dụng chung endpoint `/api/enterprise/point-rules`)*

### 5.1. Danh Sách Quy Tắc
```http
GET /api/enterprise/point-rules
```

### 5.2. Tạo Quy Tắc Mới
```http
POST /api/enterprise/point-rules
```

### 5.3. Cập Nhật Quy Tắc
```http
PUT /api/enterprise/point-rules/{ruleId}
```

### 5.4. Xóa Quy Tắc
```http
DELETE /api/enterprise/point-rules/{ruleId}
```

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
