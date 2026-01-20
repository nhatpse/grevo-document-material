# API Xác Thực (Authentication)

**Base Path**: `/api/auth`

---

## 1. Đăng Ký Tài Khoản

Đăng ký tài khoản mới trong hệ thống.

### Request

```http
POST /api/auth/register
Content-Type: application/json
```

**Body:**
```json
{
    "username": "user@example.com",
    "password": "securePassword123",
    "fullName": "Nguyễn Văn A",
    "email": "user@example.com",
    "phone": "0901234567",
    "address": "123 Đường ABC, Quận 1, TP.HCM",
    "role": "CITIZEN"
}
```

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| username | string | ✅ | Email hoặc username |
| password | string | ✅ | Mật khẩu (tối thiểu 6 ký tự) |
| fullName | string | ✅ | Họ và tên |
| email | string | ✅ | Email |
| phone | string | ❌ | Số điện thoại |
| address | string | ❌ | Địa chỉ |
| role | string | ✅ | Role: `CITIZEN`, `ENTERPRISE`, `COLLECTOR` |

### Response

**Success (200):**
```json
{
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "userId": 1,
    "fullName": "Nguyễn Văn A",
    "email": "user@example.com",
    "role": "CITIZEN",
    "avatar": null,
    "phone": "0901234567",
    "address": "123 Đường ABC, Quận 1, TP.HCM"
}
```

**Error (400):**
```json
{
    "message": "Register unsuccessful: Email already exists"
}
```

---

## 2. Đăng Nhập

Đăng nhập vào hệ thống.

### Request

```http
POST /api/auth/login
Content-Type: application/json
```

**Body:**
```json
{
    "username": "user@example.com",
    "password": "securePassword123"
}
```

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| username | string | ✅ | Email hoặc username |
| password | string | ✅ | Mật khẩu |

### Response

**Success (200):**
```json
{
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "userId": 1,
    "fullName": "Nguyễn Văn A",
    "email": "user@example.com",
    "role": "CITIZEN",
    "avatar": "https://cloudinary.com/avatar/user1.jpg",
    "phone": "0901234567",
    "address": "123 Đường ABC, Quận 1, TP.HCM"
}
```

**Error - Sai thông tin (400):**
```json
{
    "message": "Username or Password is wrong"
}
```

**Error - Tài khoản bị vô hiệu hóa (403):**
```json
{
    "message": "Account is disabled"
}
```

---

## 3. Đăng Nhập Bằng Google

Đăng nhập sử dụng Google OAuth 2.0.

### Request

```http
POST /api/auth/google-login
Content-Type: application/json
```

**Body:**
```json
{
    "token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| token | string | ✅ | Google ID Token từ frontend |

### Response

**Success (200):**
```json
{
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "userId": 1,
    "fullName": "Nguyễn Văn A",
    "email": "user@gmail.com",
    "role": "CITIZEN",
    "avatar": "https://lh3.googleusercontent.com/a/...",
    "phone": null,
    "address": null
}
```

**Error - Token không hợp lệ (401):**
```json
{
    "message": "Invalid Google Token"
}
```

**Error - Tài khoản bị vô hiệu hóa (403):**
```json
{
    "message": "Account is disabled!"
}
```

---

## 4. Đăng Xuất

Đăng xuất khỏi hệ thống.

### Request

```http
POST /api/auth/logout
Authorization: Bearer <JWT_TOKEN>
```

### Response

**Success (200):**
```json
{
    "success": true,
    "message": "Logged out successfully"
}
```

---

## JWT Token Structure

Token được trả về có cấu trúc JWT chuẩn:

### Header
```json
{
    "alg": "HS256",
    "typ": "JWT"
}
```

### Payload
```json
{
    "sub": "user@example.com",
    "role": "CITIZEN",
    "iat": 1642000000,
    "exp": 1642086400
}
```

| Field | Mô tả |
|-------|-------|
| sub | Username/Email |
| role | Role của người dùng |
| iat | Thời gian tạo token |
| exp | Thời gian hết hạn |

### Thời hạn token

Token có hiệu lực trong **24 giờ** kể từ khi tạo.

---

## Các Role Trong Hệ Thống

| Role | Mô tả |
|------|-------|
| `CITIZEN` | Công dân - Người báo cáo rác thải |
| `ENTERPRISE` | Doanh nghiệp - Đơn vị quản lý thu gom |
| `COLLECTOR` | Nhân viên thu gom |
| `ADMIN` | Quản trị viên hệ thống |

---

## Lưu Ý Quan Trọng

1. **Bảo mật**: Không lưu trữ token ở nơi không an toàn (localStorage nên thay bằng secure cookie).
2. **Refresh Token**: Hiện tại hệ thống chưa hỗ trợ refresh token, người dùng cần đăng nhập lại khi token hết hạn.
3. **Google OAuth**: Yêu cầu cấu hình Google Client ID đúng trên cả frontend và backend.

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
