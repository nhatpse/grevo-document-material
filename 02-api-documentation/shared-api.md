# 🌐 API Dùng Chung (Shared API)

**Role yêu cầu**: Có thể public hoặc yêu cầu xác thực (`CITIZEN`, `COLLECTOR`, `ENTERPRISE`, hoặc `ADMIN`) tùy endpoint.

---

## 1. Người Dùng (User Profile)

Quản lý thông tin tài khoản chung cho mọi role.

### 1.1. Lấy Thông Tin Cá Nhân

#### Request

```http
GET /api/users/profile
Authorization: Bearer <JWT_TOKEN>
```

#### Response (200 OK)

```json
{
    "id": 10,
    "fullName": "Nguyễn Văn A",
    "email": "user@example.com",
    "phone": "0901234567",
    "address": "123 Đường ABC, Quận 1",
    "avatar": "https://cloudinary.com/avatars/user10.jpg",
    "role": "CITIZEN",
    "isActive": true
}
```

---

### 1.2. Cập Nhật Hồ Sơ

#### Request

```http
PUT /api/users/profile
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "fullName": "Nguyễn Văn A Mới",
    "phone": "0909999999",
    "address": "456 Đường XYZ"
}
```

---

### 1.3. Thay Đổi Mật Khẩu (OTP)

#### Yêu Cầu OTP
```http
POST /api/users/change-password/request
Authorization: Bearer <JWT_TOKEN>
```

#### Xác Nhận Đổi Mật Khẩu
```http
POST /api/users/change-password/verify
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```
**Body:**
```json
{
    "otp": "123456",
    "newPassword": "newSecurePassword123"
}
```

---

### 1.4. Thay Đổi Email (OTP)

#### Yêu Cầu OTP
```http
POST /api/users/change-email/request
Authorization: Bearer <JWT_TOKEN>
```
**Body:**
```json
{
    "newEmail": "newemail@example.com"
}
```

#### Xác Nhận Email Mới
```http
POST /api/users/change-email/verify
Authorization: Bearer <JWT_TOKEN>
```
**Body:**
```json
{
    "otp": "123456"
}
```

---

### 1.5. Cập Nhật Ảnh Đại Diện

#### Request

```http
POST /api/users/avatar
Content-Type: multipart/form-data
Authorization: Bearer <JWT_TOKEN>
```
**Form Data:**
- `avatar` (file): Ảnh đại diện mới

#### Tham khảo Xóa Ảnh:
```http
DELETE /api/users/avatar
Authorization: Bearer <JWT_TOKEN>
```

---

### 1.6. Xóa Tài Khoản

#### Request

```http
DELETE /api/users/account
Authorization: Bearer <JWT_TOKEN>
```

---

## 2. API Bản Đồ & Định Vị (VietMap Integration)

Các API gọi đến dịch vụ bản đồ.

### 2.1. Tìm kiếm địa chỉ (Autocomplete)

#### Request

```http
GET /api/location/autocomplete?text=Ben+Thanh&session_token=randomTokenString
```

---

### 2.2. Chi tiết địa điểm

#### Request

```http
GET /api/location/details?ids=ref_id_from_autocomplete&session_token=randomTokenString
```

---

### 2.3. Reverse Geocode (Tọa độ -> Địa chỉ)

#### Request

```http
POST /api/location
Content-Type: application/json
```
**Body:**
```json
{
    "lat": 10.7769,
    "lng": 106.7009
}
```

---

### 2.4. Static Map (Ảnh bản đồ tĩnh)

#### Request

```http
GET /api/location/static-map?lat=10.7769&lng=106.7009
```
Trả về URL của ảnh bản đồ tĩnh tại tọa độ chỉ định.

---

### 2.5. Forward Geocode (Địa chỉ -> Tọa độ)

#### Request

```http
GET /api/location/geocode?address=123+Le+Loi&lat=10.7&lng=106.7
```

---

## 3. Location Sessions (Chia sẻ vị trí Live)

Sử dụng bởi thiết bị di động quét mã QR và gửi vị trí live lên thiết bị desktop/web.

### 3.1. Tạo Session Mới
*(Desktop Client gọi trước khi hiện QR)*

```http
POST /api/location-sessions
```
Trả về SessionID và QR Code Data.

### 3.2. Lấy Trạng Thái Session
*(Desktop Client poll liên tục)*

```http
GET /api/location-sessions/{sessionId}
```

### 3.3. Submit Vị Trí (Gửi từ Mobile)

```http
PUT /api/location-sessions/{sessionId}/location
Content-Type: application/json
```
**Body:**
```json
{
    "latitude": 10.7769,
    "longitude": 106.7009
}
```

---

## 4. Bảng Xếp Hạng (Leaderboard)

### 4.1. Bảng Xếp Hạng Toàn Hệ Thống

Lấy top 10 công dân có điểm tuần cao nhất trên toàn hệ thống.

#### Request

```http
GET /api/leaderboard
Authorization: Bearer <JWT_TOKEN>
```

#### Response (200 OK)

```json
[
    {
        "rank": 1,
        "citizenId": 10,
        "citizenName": "Nguyễn Văn A",
        "avatarUrl": "https://cloudinary.com/avatars/user10.jpg",
        "totalPoints": 520,
        "isCurrentUser": false
    }
]
```

---

### 4.2. Bảng Xếp Hạng Theo Khu Vực

Lấy top 10 công dân trong một khu vực (Area) cụ thể.

#### Request

```http
GET /api/leaderboard/area/{areaId}
Authorization: Bearer <JWT_TOKEN>
```

#### Response (200 OK)
Tương tự cấu trúc Bảng xếp hạng toàn hệ thống.

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
