# Tổng Quan API

Tài liệu này cung cấp cái nhìn tổng quan về toàn bộ hệ thống API của Grevo Project. Để xem chi tiết request/response của từng API, vui lòng chọn file tương ứng trong thư mục `02-api-documentation`.

## Thông Tin Chung

| Thông tin | Chi tiết |
|-----------|----------|
| **Base URL** | `https://api.grevo.com/api` (Production) |
| **Base URL Dev** | `http://localhost:8080/api` (Development) |
| **Định dạng** | JSON |
| **Encoding** | UTF-8 |
| **Authentication** | Bearer Token (JWT) |

---

## Các Module API Chi Tiết

Hệ thống API được chia thành các file tài liệu sau dựa trên đối tượng sử dụng:

1. **[Authentication API (Xác thực)](auth-api.md)**
   - Đăng nhập, Đăng nhập Google, Đăng ký.
   - Quản lý phiên làm việc (Logout).
   - Quên mật khẩu, đặt lại mật khẩu, mã OTP.

2. **[Admin API (Quản trị viên)](admin-api.md)**
   - Role yêu cầu: `ADMIN`.
   - Quản lý người dùng, tài khoản doanh nghiệp.
   - Quản lý khu vực cung cấp dịch vụ (Service Areas) và nhật ký hệ thống (System Logs).

3. **[Citizen API (Công dân)](citizen-api.md)**
   - Role yêu cầu: `CITIZEN`.
   - Báo cáo rác thải, theo dõi trạng thái.
   - Kho lưu trữ vị trí cá nhân.
   - Theo dõi lịch sử điểm thưởng, đổi voucher quà tặng.
   - Đánh giá chất lượng dịch vụ của nhân viên thu gom.

4. **[Enterprise API (Doanh nghiệp)](enterprise-api.md)**
   - Role yêu cầu: `ENTERPRISE`.
   - Cập nhật hồ sơ doanh nghiệp, phạm vi hoạt động.
   - Tiếp nhận báo cáo rác, phân công nhân viên (Collector).
   - Quản lý nhân sự: duyệt đơn xin việc, duyệt phép, sa thải.
   - Cấu hình quy tắc tính điểm báo cáo, quản lý voucher đổi điểm.

5. **[Collector API (Nhân viên)](collector-api.md)**
   - Role yêu cầu: `COLLECTOR`.
   - Xem và phản hồi nhiệm vụ (Chấp nhận, Từ chối, Hoàn thành, Hủy).
   - Quản lý hồ sơ cá nhân, khoang chứa rác.
   - Tương tác với Doanh nghiệp (Xin việc, nghỉ phép, rời công ty).

6. **[Shared API (Dùng chung)](shared-api.md)**
   - Role yêu cầu: Tất cả or Public.
   - Cập nhật ảnh đại diện, đổi mật khẩu, quản lý hồ sơ chung.
   - VietMap API (Autocomplete, Reverse Geocoding, Geocode, Static Maps).
   - Location Session (Mã QR kết nối Mobile-Desktop).
   - Bảng Xếp Hạng (Leaderboard) toàn hệ thống và theo khu vực.

---

## Phân Quyền (Roles & Authorities)

Hệ thống Grevo sử dụng 4 Role chính được cấp phát trong JWT Token:

- `CITIZEN`: Công dân báo cáo rác thải.
- `ENTERPRISE`: Doanh nghiệp tái chế/thu gom.
- `COLLECTOR`: Nhân viên lấy rác (thường thuộc một Doanh nghiệp cụ thể).
- `ADMIN`: Quản trị viên hệ thống.

---

## Response Format Chuẩn

### Thành công
```json
{
    "success": true,
    "message": "Chi tiết (tùy chọn)",
    "data": { ... } // (tùy từng endpoint đặc thù có thể trả raw data)
}
```

### Thành công với phân trang (Pageable)
```json
{
    "content": [...],
    "totalPages": 10,
    "totalElements": 100,
    "currentPage": 0
}
```

### Lỗi
```json
{
    "error": "Tên lỗi (Bad Request, Unauthorized, v.v)",
    "message": "Mô tả chi tiết nguyên nhân lỗi"
}
```

---

## HTTP Status Codes

| Code | Ý nghĩa |
|------|---------|
| 200 | Thành công |
| 201 | Tạo mới thành công (Nhiều API cũ vẫn dùng 200 cho tạo mới) |
| 204 | Xóa thành công |
| 400 | Yêu cầu không hợp lệ (Bad Request) |
| 401 | Chưa xác thực (Token sai hoặc hết hạn) |
| 403 | Không có quyền (Sai Role) |
| 404 | Không tìm thấy Resource |
| 500 | Lỗi server (Internal Server Error) |

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
