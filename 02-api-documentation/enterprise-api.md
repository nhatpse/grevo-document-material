# 🏢 API Doanh Nghiệp (Enterprise API)

**Role yêu cầu**: `ENTERPRISE`

---

## 1. Quản Lý Báo Cáo Rác Thải

### 1.1. Báo Cáo Chờ Xử Lý

Lấy danh sách báo cáo cần phân công trong khu vực phụ trách.

#### Request

```http
GET /api/reports/enterprise?page=0&size=10&sortBy=createdAt&sortDir=desc
Authorization: Bearer <JWT_TOKEN>
```

**Query Parameters:**
| Param | Type | Default | Mô tả |
|-------|------|---------|-------|
| page | int | 0 | Số trang |
| size | int | 10 | Số lượng mỗi trang |
| sortBy | string | createdAt | Sắp xếp theo trường |
| sortDir | string | desc | Hướng sắp xếp: `asc`, `desc` |

#### Response

**Success (200):**
```json
{
    "content": [
        {
            "reportId": 123,
            "title": "Rác thải tái chế khu chung cư",
            "citizenName": "Nguyễn Văn A",
            "citizenPhone": "0901234567",
            "status": "PENDING",
            "wasteType": "RECYCLABLE",
            "wasteQuantity": 3.5,
            "latitude": "10.7769",
            "longitude": "106.7009",
            "createdAt": "2026-01-21T06:30:00",
            "imageUrl": "https://cloudinary.com/images/report123.jpg"
        }
    ],
    "totalPages": 5,
    "totalElements": 42,
    "number": 0
}
```

---

### 1.2. Lịch Sử Báo Cáo

Xem lịch sử các báo cáo đã hoàn thành hoặc hủy.

#### Request

```http
GET /api/reports/enterprise/history?page=0&size=10
Authorization: Bearer <JWT_TOKEN>
```

#### Response

Tương tự như báo cáo chờ xử lý với các trạng thái `COLLECTED` hoặc `CANCELLED`.

---

### 1.3. Chi Tiết Báo Cáo

Xem chi tiết một báo cáo.

#### Request

```http
GET /api/reports/enterprise/{reportId}
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "reportId": 123,
    "title": "Rác thải tái chế khu chung cư",
    "description": "Chai nhựa, thùng carton",
    "status": "ASSIGNED",
    "wasteType": "RECYCLABLE",
    "wasteQuantity": 3.5,
    "qualityScore": null,
    "latitude": "10.7769",
    "longitude": "106.7009",
    "createdAt": "2026-01-21T06:30:00",
    "assignedAt": "2026-01-21T08:00:00",
    "itemWeights": [...],
    "citizenImages": [...],
    "collectorImages": [...],
    "citizen": {
        "citizenId": 1,
        "fullName": "Nguyễn Văn A",
        "phone": "0901234567",
        "email": "user@example.com"
    },
    "collector": {
        "collectorId": 5,
        "fullName": "Trần Văn B",
        "phone": "0909123456",
        "vehicleType": "Xe máy",
        "vehiclePlate": "59A1-12345"
    }
}
```

---

### 1.4. Collector Phù Hợp

Lấy danh sách collector có thể phân công cho báo cáo.

#### Request

```http
GET /api/reports/enterprise/{reportId}/eligible-collectors
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
[
    {
        "collectorId": 5,
        "fullName": "Trần Văn B",
        "phone": "0909123456",
        "vehicleType": "Xe máy",
        "vehiclePlate": "59A1-12345",
        "maxCapacity": 50,
        "currentStatus": "AVAILABLE",
        "isOnline": true,
        "rating": 4.5,
        "completedTasks": 120
    }
]
```

---

### 1.5. Phân Công Collector

Phân công collector cho một báo cáo.

#### Request

```http
POST /api/reports/enterprise/{reportId}/assign
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "collectorId": 5
}
```

#### Response

**Success (200):**
```json
{
    "reportId": 123,
    "status": "ASSIGNED",
    "assignedAt": "2026-01-21T08:00:00",
    "collector": {
        "collectorId": 5,
        "fullName": "Trần Văn B"
    }
}
```

---

### 1.6. Cập Nhật Trạng Thái Báo Cáo

Cập nhật trạng thái báo cáo thủ công.

#### Request

```http
PUT /api/reports/enterprise/{reportId}/status
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "status": "CANCELLED"
}
```

**Các trạng thái hợp lệ:**
- `PENDING`
- `CANCELLED`

---

## 2. Quản Lý Nhân Viên Thu Gom

### 2.1. Danh Sách Collector

Lấy danh sách collector thuộc doanh nghiệp.

#### Request

```http
GET /api/enterprise/collectors?status=ACTIVE&search=Trần
Authorization: Bearer <JWT_TOKEN>
```

**Query Parameters:**
| Param | Type | Mô tả |
|-------|------|-------|
| status | string | `ACTIVE`, `PENDING`, `PENDING_LEAVE`, `INACTIVE` |
| search | string | Tìm theo tên |

#### Response

**Success (200):**
```json
[
    {
        "collectorId": 5,
        "userId": 10,
        "fullName": "Trần Văn B",
        "email": "tranvanb@email.com",
        "phone": "0909123456",
        "avatar": "https://cloudinary.com/avatars/user10.jpg",
        "vehicleType": "Xe máy",
        "vehiclePlate": "59A1-12345",
        "maxCapacity": 50,
        "currentStatus": "AVAILABLE",
        "isOnline": true,
        "leaveReason": null,
        "rating": 4.5,
        "completedTasks": 120
    }
]
```

---

### 2.2. Duyệt Yêu Cầu Tham Gia

Duyệt collector muốn gia nhập doanh nghiệp.

#### Request

```http
POST /api/enterprise/collectors/{collectorId}/approve
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "message": "Collector approved successfully",
    "collectorId": 5
}
```

---

### 2.3. Từ Chối/Xóa Collector

Từ chối yêu cầu hoặc xóa collector khỏi doanh nghiệp.

#### Request

```http
DELETE /api/enterprise/collectors/{collectorId}
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "message": "Collector removed successfully"
}
```

---

### 2.4. Duyệt Nghỉ Phép

Duyệt yêu cầu nghỉ phép của collector.

#### Request

```http
POST /api/enterprise/collectors/{collectorId}/approve-leave
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "message": "Leave request approved"
}
```

---

### 2.5. Từ Chối Nghỉ Phép

#### Request

```http
POST /api/enterprise/collectors/{collectorId}/reject-leave
Authorization: Bearer <JWT_TOKEN>
```

---

## 3. Quản Lý Voucher

### 3.1. Danh Sách Voucher

Lấy danh sách voucher của doanh nghiệp.

#### Request

```http
GET /api/enterprise/vouchers
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
[
    {
        "voucherId": 1,
        "enterpriseName": "ABC Mart",
        "title": "Giảm 50,000đ",
        "description": "Áp dụng cho đơn hàng từ 200,000đ",
        "pointsCost": 500,
        "quantity": 100,
        "redeemedCount": 45,
        "remainingStock": 55,
        "validFrom": "2026-01-01",
        "validUntil": "2026-12-31",
        "isActive": true,
        "isAvailable": true,
        "imageUrl": "https://cloudinary.com/vouchers/abc_mart.jpg",
        "createdAt": "2026-01-01T00:00:00"
    }
]
```

---

### 3.2. Tạo Voucher Mới

#### Request

```http
POST /api/enterprise/vouchers
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "title": "Giảm 100,000đ",
    "description": "Áp dụng cho đơn hàng từ 500,000đ",
    "pointsCost": 1000,
    "quantity": 50,
    "validFrom": "2026-02-01",
    "validUntil": "2026-06-30",
    "isActive": true,
    "imageUrl": "https://cloudinary.com/vouchers/new_voucher.jpg"
}
```

---

### 3.3. Cập Nhật Voucher

#### Request

```http
PUT /api/enterprise/vouchers/{voucherId}
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

---

### 3.4. Xóa Voucher

#### Request

```http
DELETE /api/enterprise/vouchers/{voucherId}
Authorization: Bearer <JWT_TOKEN>
```

---

### 3.5. Lịch Sử Đổi Voucher

Xem lịch sử công dân đổi voucher.

#### Request

```http
GET /api/enterprise/vouchers/{voucherId}/redemptions
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
[
    {
        "redemptionId": 1,
        "voucherTitle": "Giảm 50,000đ",
        "voucherDescription": "...",
        "citizenName": "Nguyễn Văn A",
        "pointsSpent": 500,
        "redemptionCode": "ABC123XYZ789",
        "status": "ACTIVE",
        "redeemedAt": "2026-01-20T15:30:00",
        "usedAt": null
    }
]
```

---

## 4. Quy Tắc Tính Điểm

### 4.1. Danh Sách Quy Tắc

#### Request

```http
GET /api/enterprise/point-rules
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
[
    {
        "ruleId": 1,
        "ruleName": "Điểm cơ bản cho rác tái chế",
        "description": "Tính điểm cho mỗi kg rác tái chế",
        "wasteTypeName": "RECYCLABLE",
        "basePointsPerKg": 10.0,
        "qualityBonusMultiplier": 1.5,
        "minQuantityForBonus": 5.0,
        "quantityBonus": 20,
        "isActive": true,
        "priority": 1,
        "createdAt": "2026-01-01T00:00:00"
    }
]
```

---

### 4.2. Tạo Quy Tắc Mới

#### Request

```http
POST /api/enterprise/point-rules
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "ruleName": "Điểm bonus cho rác nguy hại",
    "description": "Bonus thêm cho rác nguy hại được phân loại đúng",
    "wasteTypeId": 3,
    "basePointsPerKg": 15.0,
    "qualityBonusMultiplier": 2.0,
    "minQuantityForBonus": 2.0,
    "quantityBonus": 30,
    "isActive": true,
    "priority": 2
}
```

---

### 4.3. Cập Nhật Quy Tắc

#### Request

```http
PUT /api/enterprise/point-rules/{ruleId}
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

---

### 4.4. Xóa Quy Tắc

#### Request

```http
DELETE /api/enterprise/point-rules/{ruleId}
Authorization: Bearer <JWT_TOKEN>
```

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
