# 🚛 API Nhân Viên Thu Gom (Collector API)

**Role yêu cầu**: `COLLECTOR`

---

## 1. Quản Lý Nhiệm Vụ

### 1.1. Danh Sách Nhiệm Vụ

Lấy danh sách nhiệm vụ được phân công.

#### Request

```http
GET /api/collector/tasks?status=ASSIGNED,ON_THE_WAY
Authorization: Bearer <JWT_TOKEN>
```

**Query Parameters:**
| Param | Type | Mô tả |
|-------|------|-------|
| status | string[] | Lọc theo trạng thái (optional) |

**Các trạng thái:**
- `ASSIGNED` - Đã phân công, chờ chấp nhận
- `ON_THE_WAY` - Đang trên đường
- `COLLECTED` - Đã thu gom (lịch sử)
- `CANCELLED` - Đã hủy (lịch sử)

#### Response

**Success (200):**
```json
[
    {
        "reportId": 123,
        "title": "Rác thải tái chế khu chung cư",
        "citizenName": "Nguyễn Văn A",
        "citizenPhone": "0901234567",
        "status": "ASSIGNED",
        "wasteType": "RECYCLABLE",
        "wasteQuantity": 3.5,
        "latitude": "10.7769",
        "longitude": "106.7009",
        "createdAt": "2026-01-21T06:30:00",
        "assignedAt": "2026-01-21T08:00:00",
        "imageUrl": "https://cloudinary.com/images/report123.jpg"
    }
]
```

---

### 1.2. Chi Tiết Nhiệm Vụ

Xem chi tiết một nhiệm vụ.

#### Request

```http
GET /api/collector/tasks/{reportId}
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "reportId": 123,
    "title": "Rác thải tái chế khu chung cư",
    "description": "Chai nhựa, thùng carton cần thu gom",
    "status": "ASSIGNED",
    "wasteType": "RECYCLABLE",
    "wasteQuantity": 3.5,
    "qualityScore": null,
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
    "citizen": {
        "citizenId": 1,
        "fullName": "Nguyễn Văn A",
        "phone": "0901234567",
        "email": "user@example.com",
        "address": "123 Đường ABC, Quận 1"
    }
}
```

---

### 1.3. Chấp Nhận Nhiệm Vụ

Chấp nhận nhiệm vụ và bắt đầu thu gom.

#### Request

```http
POST /api/collector/tasks/{reportId}/accept
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "reportId": 123,
    "status": "ON_THE_WAY",
    "message": "Task accepted. You are now on the way!"
}
```

**Error - Không phải nhiệm vụ của bạn (400):**
```json
{
    "error": "This task is not assigned to you"
}
```

---

### 1.4. Từ Chối Nhiệm Vụ

Từ chối nhiệm vụ (trước khi chấp nhận).

#### Request

```http
POST /api/collector/tasks/{reportId}/reject
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "reportId": 123,
    "status": "PENDING",
    "message": "Task rejected. The report is now pending for reassignment."
}
```

---

### 1.5. Hoàn Thành Nhiệm Vụ

Đánh dấu nhiệm vụ đã hoàn thành với hình ảnh xác nhận.

#### Request

```http
POST /api/collector/tasks/{reportId}/complete
Content-Type: multipart/form-data
Authorization: Bearer <JWT_TOKEN>
```

**Form Data:**
| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| images | file[] | ❌ | Hình ảnh xác nhận thu gom |
| rating | int | ✅ | Đánh giá chất lượng rác (1-5) |
| wasteSortedCorrectly | boolean | ✅ | Rác được phân loại đúng không |
| citizenCooperative | boolean | ✅ | Công dân hợp tác không |
| notes | string | ❌ | Ghi chú thêm |

#### Response

**Success (200):**
```json
{
    "reportId": 123,
    "status": "COLLECTED",
    "qualityScore": 4,
    "pointsAwarded": 45,
    "message": "Task completed successfully!"
}
```

**Error - Trạng thái không hợp lệ (400):**
```json
{
    "error": "Can only complete tasks that are ON_THE_WAY"
}
```

---

### 1.6. Hủy Nhiệm Vụ

Hủy nhiệm vụ (khi không thể hoàn thành).

#### Request

```http
POST /api/collector/tasks/{reportId}/cancel
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "reportId": 123,
    "status": "CANCELLED",
    "message": "Task cancelled. The report will be reassigned."
}
```

---

## 2. Hồ Sơ Collector

### 2.1. Xem Thông Tin Cá Nhân

#### Request

```http
GET /api/collector/profile
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
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
    "enterprise": {
        "enterpriseId": 1,
        "companyName": "Công ty Thu Gom ABC",
        "companyPhone": "028-1234567"
    },
    "rating": 4.5,
    "totalCompletedTasks": 120,
    "lastActiveAt": "2026-01-21T10:00:00"
}
```

---

### 2.2. Cập Nhật Trạng Thái Online

#### Request

```http
PUT /api/collector/profile/status
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "isOnline": true
}
```

#### Response

**Success (200):**
```json
{
    "message": "Status updated",
    "isOnline": true
}
```

---

### 2.3. Xin Nghỉ Phép

Gửi yêu cầu nghỉ phép.

#### Request

```http
POST /api/collector/profile/request-leave
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "reason": "Việc gia đình"
}
```

#### Response

**Success (200):**
```json
{
    "message": "Leave request submitted",
    "currentStatus": "PENDING_LEAVE"
}
```

---

## 3. Doanh Nghiệp

### 3.1. Xem Doanh Nghiệp Hiện Tại

#### Request

```http
GET /api/collector/enterprise
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "enterpriseId": 1,
    "companyName": "Công ty Thu Gom ABC",
    "companyPhone": "028-1234567",
    "companyEmail": "contact@abc-thugom.vn",
    "companyAddress": "456 Đường XYZ, Quận 3, TP.HCM"
}
```

---

### 3.2. Tìm Kiếm Doanh Nghiệp

Tìm doanh nghiệp để xin gia nhập.

#### Request

```http
GET /api/collector/enterprise/search?keyword=ABC
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
        "collectorCount": 15
    }
]
```

---

### 3.3. Xin Gia Nhập Doanh Nghiệp

#### Request

```http
POST /api/collector/enterprise/request
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "enterpriseId": 1,
    "message": "Tôi muốn gia nhập công ty"
}
```

#### Response

**Success (200):**
```json
{
    "message": "Request submitted successfully",
    "requestStatus": "PENDING"
}
```

---

### 3.4. Rời Doanh Nghiệp

#### Request

```http
POST /api/collector/enterprise/leave
Authorization: Bearer <JWT_TOKEN>
```

#### Response

**Success (200):**
```json
{
    "message": "You have left the enterprise"
}
```

---

## 4. Đánh Giá Công Dân

### 4.1. Đánh Giá Sau Thu Gom

#### Request

```http
POST /api/feedback/collector/{reportId}
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
    "feedbackId": 2,
    "reportId": 123,
    "starRating": 4,
    "description": "Công dân hợp tác tốt, rác được phân loại sẵn",
    "createdAt": "2026-01-21T11:30:00"
}
```

---

## Workflow Thu Gom

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   ASSIGNED   │────►│  ON_THE_WAY  │────►│  COLLECTED   │
│  (Chờ nhận)  │     │ (Đang đi)    │     │ (Hoàn thành) │
└──────────────┘     └──────────────┘     └──────────────┘
       │                    │
       │ reject             │ cancel
       ▼                    ▼
┌──────────────┐     ┌──────────────┐
│   PENDING    │     │  CANCELLED   │
│ (Trả lại)    │     │   (Hủy)      │
└──────────────┘     └──────────────┘
```

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
