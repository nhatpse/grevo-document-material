# 👨‍💼 API Quản Trị Viên (Admin API)

**Role yêu cầu**: `ADMIN`

---

## 1. Quản Lý Người Dùng (`/api/admin/users`)

### 1.1. Danh Sách Người Dùng

Lấy danh sách tất cả người dùng trong hệ thống (Hỗ trợ phân trang, tìm kiếm, sắp xếp).

#### Request

```http
GET /api/admin/users?search=nguyen&role=CITIZEN&page=0&size=10&sort=createAt,desc
Authorization: Bearer <JWT_TOKEN>
```

**Query Parameters:**
| Param | Type | Default | Mô tả |
|-------|------|---------|-------|
| search | string | null | Tìm kiếm đa trường (Tên, Email, v.v) |
| role | string | null | Lọc theo Role người dùng |
| page | int | 0 | Số trang |
| size | int | 10 | Số lượng bản ghi mỗi trang |
| sort | string | createAt,desc | Cột cần sắp xếp, hướng |

#### Response (200 OK)

Trả về `Page<UserManagementResponse>`.

---

### 1.2. Cập Nhật Người Dùng

Cập nhật thông tin của người dùng bởi Admin.

#### Request

```http
PUT /api/admin/users/{userId}
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:** (AdminUpdateUserRequest)
*(Các trường cần cập nhật tùy thuộc vào implementation cụ thể)*

#### Response (200 OK)

Trả về `UserManagementResponse` sau cập nhật.

---

### 1.3. Xóa Người Dùng

Xóa vĩnh viễn (hoặc soft delete) một người dùng.

#### Request

```http
DELETE /api/admin/users/{userId}
Authorization: Bearer <JWT_TOKEN>
```

#### Response (200 OK)

Không có nội dung trả về (Void).

---

### 1.4. Reset Mật Khẩu

Reset mật khẩu của một người dùng về mặc định (`123456`).

#### Request

```http
POST /api/admin/users/{userId}/reset-password
Authorization: Bearer <JWT_TOKEN>
```

#### Response (200 OK)

```text
Password reset successfully to 123456
```

---

## 2. Quản Lý Doanh Nghiệp (`/api/admin/enterprises`)

### 2.1. Danh Sách Doanh Nghiệp

Lấy toàn bộ danh sách các doanh nghiệp.

#### Request

```http
GET /api/admin/enterprises
Authorization: Bearer <JWT_TOKEN>
```

#### Response (200 OK)

Trả về `List<EnterpriseResponse>`.

---

### 2.2. Cập Nhật Trạng Thái Doanh Nghiệp

Thay đổi trạng thái khối/kích hoạt của một doanh nghiệp.

#### Request

```http
PUT /api/admin/enterprises/{id}/status
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "isActive": true
}
```

#### Response (200 OK)

```json
{
    "message": "Enterprise status updated successfully",
    "isActive": true
}
```

---

## 3. Quản Lý Khu Vực Dịch Vụ Hệ Thống (`/api/admin/areas`)

### 3.1. Danh Sách Khu Vực Hệ Thống

Lấy danh sách tất cả khu vực do hệ thống quản lý.

#### Request

```http
GET /api/admin/areas
Authorization: Bearer <JWT_TOKEN>
```

#### Response (200 OK)

Trả về `List<ServiceAreaResponse>`.

---

### 3.2. Tạo Trực Tiếp / Thêm Bằng Truy Vấn (Query) Khu Vực

Tạo mới khu vực dịch vụ bằng 2 mô hình: Gửi đầy đủ thông tin hoặc truy vấn (từ Map API/Goong).

#### Request

```http
POST /api/admin/areas
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body (Tạo Trực Tiếp):**
```json
{
    "name": "Quận 7",
    "lat": "10.7340",
    "lng": "106.7217",
    "type": "DISTRICT"
}
```

**Hoặc Body (Tạo Từ Query - Map Provider):**
```json
{
    "query": "Quận 1, Hồ Chí Minh"
}
```

#### Response (200 OK)

Trả về `ServiceAreaResponse`.

---

### 3.3. Xóa Khu Vực

#### Request

```http
DELETE /api/admin/areas/{id}
Authorization: Bearer <JWT_TOKEN>
```

#### Response (200 OK)

```json
{
    "message": "Service Area deleted successfully"
}
```

---

## 4. Phân Quyền Khu Vực - Doanh Nghiệp (`/api/admin/enterprises/{enterpriseId}/areas`)

### 4.1. Xem Các Khu Vực Của Doanh Nghiệp

#### Request
```http
GET /api/admin/enterprises/{enterpriseId}/areas
Authorization: Bearer <JWT_TOKEN>
```

#### Response (200 OK)
Trả về `List<EnterpriseArea>`.

---

### 4.2. Thêm Khu Vực Cho Doanh Nghiệp Bằng Truy Vấn (Query)

#### Request

```http
POST /api/admin/enterprises/{enterpriseId}/areas
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

**Body:**
```json
{
    "query": "Phường 14, Quận 10, TP.HCM"
}
```

#### Response (200 OK)

Trả về đối tượng `EnterpriseArea` mới được thêm.

---

### 4.3. Xóa Khu Vực Khỏi Doanh Nghiệp

#### Request

```http
DELETE /api/admin/enterprises/{enterpriseId}/areas/{areaId}
Authorization: Bearer <JWT_TOKEN>
```

#### Response (200 OK)

```json
{
    "message": "Area removed successfully"
}
```

---

## 5. Nhật Ký Hệ Thống (`/api/admin/logs`)

### 5.1. Xem Logs

Lấy danh sách log hệ thống có phân trang và tìm kiếm.

#### Request

```http
GET /api/admin/logs?page=0&size=10&search=Lỗi
Authorization: Bearer <JWT_TOKEN>
```

**Query Parameters:**
| Param | Type | Default | Mô tả |
|-------|------|---------|-------|
| page | int | 0 | Số trang |
| size | int | 10 | Số lượng mỗi trang |
| search | string | null | Tìm trong Level, Action, Message |

#### Response (200 OK)

Trả về `Page<SystemLog>`.

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
