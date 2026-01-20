# 🏠 API Công Dân (Citizen API)

**Role yêu cầu**: `CITIZEN`

---

## 1. Báo Cáo Rác Thải

### 1.1. Tạo Báo Cáo Mới

Công dân tạo báo cáo rác thải mới với hình ảnh và vị trí.

#### Request

```http
POST /api/reports
Content-Type: multipart/form-data
Authorization: Bearer <JWT_TOKEN>
```

**Form Data:**
| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| title | string | ✅ | Tiêu đề báo cáo |
| description | string | ❌ | Mô tả chi tiết |
| latitude | string | ✅ | Vĩ độ (GPS) |
| longitude | string | ✅ | Kinh độ (GPS) |
| wasteType | string | ✅ | Loại rác: `ORGANIC`, `RECYCLABLE`, `HAZARDOUS`, `GENERAL` |
| wasteQuantity | double | ❌ | Khối lượng ước tính (kg) |
| itemWeights | string | ❌ | JSON chi tiết từng loại rác |
| images | file[] | ❌ | Danh sách hình ảnh (max 5) |

**Ví dụ itemWeights:**
```json
[
    {"type": "Nhựa", "weight": 2.5, "description": "Chai nhựa"},
    {"type": "Giấy", "weight": 1.0, "description": "Thùng carton"}
]
```

#### Response

**Success (200):**
```json
{
    "reportId": 123,
    "title": "Rác thải tái chế khu chung cư",
    "wasteType": "RECYCLABLE",
    "status": "PENDING",
    "createdAt": "2026-01-21T06:30:00"
}
```

---

### 1.2. Lấy Danh Sách Báo Cáo Của Tôi

Xem danh sách tất cả báo cáo đã tạo.

#### Request

```http
GET /api/reports/my-reports?page=0&size=10&status=PENDING,ASSIGNED
Authorization: Bearer <JWT_TOKEN>
```

**Query Parameters:**
| Param | Type | Default | Mô tả |
|-------|------|---------|-------|
| page | int | 0 | Số trang (bắt đầu từ 0) |
| size | int | 10 | Số lượng mỗi trang |
| status | string[] | null | Lọc theo trạng thái |

**Các trạng thái báo cáo:**
- `PENDING` - Chờ xử lý
- `ASSIGNED` - Đã phân công
- `ON_THE_WAY` - Đang trên đường
- `COLLECTED` - Đã thu gom
- `CANCELLED` - Đã hủy

#### Response

**Success (200):**
```json
{
    "content": [
        {
            "reportId": 123,
            "title": "Rác thải tái chế",
            "status": "PENDING",
            "wasteType": "RECYCLABLE",
            "latitude": "10.7769",
            "longitude": "106.7009",
            "createdAt": "2026-01-21T06:30:00",
            "imageUrl": "https://cloudinary.com/images/report123.jpg"
        }
    ],
    "totalPages": 5,
    "totalElements": 45,
    "number": 0
}
```

---

### 1.3. Chi Tiết Báo Cáo

Xem chi tiết một báo cáo cụ thể.

#### Request

```http
GET /api/reports/{reportId}
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "reportId": 123,
    "title": "Rác thải tái chế khu chung cư",
    "description": "Các chai nhựa, thùng carton cần thu gom",
    "status": "ASSIGNED",
    "wasteType": "RECYCLABLE",
    "wasteQuantity": 3.5,
    "qualityScore": 4,
    "latitude": "10.7769",
    "longitude": "106.7009",
    "createdAt": "2026-01-21T06:30:00",
    "assignedAt": "2026-01-21T08:00:00",
    "itemWeights": [
        {"type": "Nhựa", "weight": 2.5, "description": "Chai nhựa"},
        {"type": "Giấy", "weight": 1.0, "description": "Thùng carton"}
    ],
    "citizenImages": [
        "https://cloudinary.com/images/citizen_1.jpg",
        "https://cloudinary.com/images/citizen_2.jpg"
    ],
    "collectorImages": [],
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

### 1.4. Thống Kê Công Dân

Lấy thống kê tổng quan của công dân.

#### Request

```http
GET /api/reports/stats
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "totalReports": 25,
    "pendingReports": 2,
    "completedReports": 20,
    "cancelledReports": 3,
    "totalWasteKg": 150.5,
    "totalPoints": 1505
}
```

---

## 2. Điểm Thưởng

### 2.1. Lịch Sử Điểm

Xem lịch sử giao dịch điểm.

#### Request

```http
GET /api/citizen/point-history?page=0&size=20
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "content": [
        {
            "transactionId": 1,
            "reportId": 123,
            "reportTitle": "Rác thải tái chế",
            "pointsAwarded": 35,
            "reason": "Thu gom thành công - Recyclable - 3.5kg",
            "createdAt": "2026-01-21T10:00:00"
        },
        {
            "transactionId": 2,
            "reportId": null,
            "reportTitle": null,
            "pointsAwarded": -100,
            "reason": "Đổi voucher - Giảm 50k tại ABC Mart",
            "createdAt": "2026-01-20T15:30:00"
        }
    ],
    "totalPages": 3,
    "totalElements": 50,
    "currentPage": 0
}
```

---

### 2.2. Tổng Kết Điểm

Xem tổng kết điểm theo tuần/tháng.

#### Request

```http
GET /api/citizen/point-history/summary
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "totalPoints": 1505,
    "weeklyPoints": 150,
    "monthlyPoints": 520,
    "transactionCount": 50
}
```

---

## 3. Phần Thưởng (Rewards)

### 3.1. Voucher Có Sẵn

Xem danh sách voucher có thể đổi.

#### Request

```http
GET /api/rewards/vouchers
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

### 3.2. Đổi Voucher

Sử dụng điểm để đổi voucher.

#### Request

```http
POST /api/rewards/redeem/{voucherId}
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "message": "Voucher redeemed successfully",
    "redemptionCode": "ABC123XYZ789",
    "pointsSpent": 500,
    "remainingPoints": 1005
}
```

**Error - Không đủ điểm (400):**
```json
{
    "error": "Insufficient points",
    "required": 500,
    "available": 300
}
```

**Error - Voucher không khả dụng (400):**
```json
{
    "error": "Voucher is not available"
}
```

---

### 3.3. Voucher Đã Đổi

Xem danh sách voucher đã đổi.

#### Request

```http
GET /api/rewards/my-vouchers
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
[
    {
        "redemptionId": 1,
        "voucherTitle": "Giảm 50,000đ",
        "voucherDescription": "Áp dụng cho đơn hàng từ 200,000đ",
        "voucherImageUrl": "https://cloudinary.com/vouchers/abc_mart.jpg",
        "enterpriseName": "ABC Mart",
        "pointsSpent": 500,
        "redemptionCode": "ABC123XYZ789",
        "status": "ACTIVE",
        "redeemedAt": "2026-01-20T15:30:00",
        "usedAt": null,
        "validUntil": "2026-12-31"
    }
]
```

---

## 4. Đánh Giá (Feedback)

### 4.1. Đánh Giá Nhân Viên Thu Gom

Sau khi thu gom thành công, công dân có thể đánh giá collector.

#### Request

```http
POST /api/feedback/citizen/{reportId}
Content-Type: multipart/form-data
Authorization: Bearer <JWT_TOKEN>
```

**Form Data:**
| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| starRating | int | ✅ | Đánh giá sao (1-5) |
| description | string | ❌ | Nhận xét |
| images | file[] | ❌ | Hình ảnh (nếu có) |

#### Response

**Success (200):**
```json
{
    "feedbackId": 1,
    "reportId": 123,
    "starRating": 5,
    "description": "Nhân viên rất nhiệt tình, đúng giờ!",
    "createdAt": "2026-01-21T11:00:00"
}
```

---

## 5. Bảng Xếp Hạng

### 5.1. Bảng Xếp Hạng Toàn Hệ Thống

Xem top 10 công dân có điểm tuần cao nhất.

#### Request

```http
GET /api/leaderboard
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
[
    {
        "rank": 1,
        "citizenId": 10,
        "citizenName": "Nguyễn Văn A",
        "avatarUrl": "https://cloudinary.com/avatars/user10.jpg",
        "totalPoints": 520,
        "areaName": null,
        "isCurrentUser": false
    },
    {
        "rank": 2,
        "citizenId": 15,
        "citizenName": "Trần Thị B",
        "avatarUrl": null,
        "totalPoints": 480,
        "areaName": null,
        "isCurrentUser": true
    }
]
```

---

### 5.2. Bảng Xếp Hạng Theo Khu Vực

Xem top 10 trong một khu vực cụ thể.

#### Request

```http
GET /api/leaderboard/area/{areaId}
Authorization: Bearer <JWT_TOKEN>
```

#### Response

Tương tự bảng xếp hạng toàn hệ thống.

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
