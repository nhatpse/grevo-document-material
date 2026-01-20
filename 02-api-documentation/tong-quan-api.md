# Tổng Quan API

## Thông Tin Chung

| Thông tin | Chi tiết |
|-----------|----------|
| **Base URL** | `https://api.grevo.com/api` (Production) |
| **Base URL Dev** | `http://localhost:8080/api` (Development) |
| **Định dạng** | JSON |
| **Encoding** | UTF-8 |
| **Authentication** | Bearer Token (JWT) |

---

## Headers Yêu Cầu

### Requests không cần xác thực
```http
Content-Type: application/json
```

### Requests cần xác thực
```http
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
```

### Requests upload file
```http
Content-Type: multipart/form-data
Authorization: Bearer <JWT_TOKEN>
```

---

## Danh Sách Endpoints

### 🔐 Authentication (`/api/auth`)
| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| POST | `/register` | Đăng ký tài khoản | ❌ |
| POST | `/login` | Đăng nhập | ❌ |
| POST | `/google-login` | Đăng nhập Google | ❌ |
| POST | `/logout` | Đăng xuất | ✅ |

### 🏠 Citizen Reports (`/api/reports`)
| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| POST | `/` | Tạo báo cáo rác mới | ✅ CITIZEN |
| GET | `/my-reports` | Lấy danh sách báo cáo của tôi | ✅ CITIZEN |
| GET | `/{reportId}` | Chi tiết báo cáo | ✅ CITIZEN |
| GET | `/stats` | Thống kê công dân | ✅ CITIZEN |

### 🏢 Enterprise Reports (`/api/reports`)
| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| GET | `/enterprise` | Lấy báo cáo chờ xử lý | ✅ ENTERPRISE |
| GET | `/enterprise/history` | Lịch sử báo cáo | ✅ ENTERPRISE |
| GET | `/enterprise/{reportId}` | Chi tiết báo cáo | ✅ ENTERPRISE |
| GET | `/enterprise/{reportId}/eligible-collectors` | Collector phù hợp | ✅ ENTERPRISE |
| POST | `/enterprise/{reportId}/assign` | Phân công collector | ✅ ENTERPRISE |
| PUT | `/enterprise/{reportId}/status` | Cập nhật trạng thái | ✅ ENTERPRISE |

### 🚛 Collector Tasks (`/api/collector/tasks`)
| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| GET | `/` | Danh sách nhiệm vụ | ✅ COLLECTOR |
| GET | `/{reportId}` | Chi tiết nhiệm vụ | ✅ COLLECTOR |
| POST | `/{reportId}/accept` | Chấp nhận nhiệm vụ | ✅ COLLECTOR |
| POST | `/{reportId}/reject` | Từ chối nhiệm vụ | ✅ COLLECTOR |
| POST | `/{reportId}/complete` | Hoàn thành nhiệm vụ | ✅ COLLECTOR |
| POST | `/{reportId}/cancel` | Hủy nhiệm vụ | ✅ COLLECTOR |

### 👥 Enterprise Collector Management (`/api/enterprise/collectors`)
| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| GET | `/` | Danh sách collector | ✅ ENTERPRISE |
| POST | `/{collectorId}/approve` | Duyệt yêu cầu | ✅ ENTERPRISE |
| DELETE | `/{collectorId}` | Từ chối/Xóa collector | ✅ ENTERPRISE |
| POST | `/{collectorId}/approve-leave` | Duyệt nghỉ phép | ✅ ENTERPRISE |
| POST | `/{collectorId}/reject-leave` | Từ chối nghỉ phép | ✅ ENTERPRISE |

### ⭐ Feedback (`/api/feedback`)
| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| POST | `/citizen/{reportId}` | Công dân đánh giá collector | ✅ CITIZEN |
| POST | `/collector/{reportId}` | Collector đánh giá công dân | ✅ COLLECTOR |
| GET | `/report/{reportId}` | Lấy feedback của report | ✅ |
| GET | `/collector/{collectorId}/rating` | Rating của collector | ✅ |
| GET | `/citizen/{citizenId}/rating` | Rating của công dân | ✅ |

### 🎁 Enterprise Vouchers (`/api/enterprise/vouchers`)
| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| GET | `/` | Danh sách voucher | ✅ ENTERPRISE |
| POST | `/` | Tạo voucher mới | ✅ ENTERPRISE |
| PUT | `/{voucherId}` | Cập nhật voucher | ✅ ENTERPRISE |
| DELETE | `/{voucherId}` | Xóa voucher | ✅ ENTERPRISE |
| GET | `/{voucherId}/redemptions` | Lịch sử đổi voucher | ✅ ENTERPRISE |

### 🏆 Rewards (`/api/rewards`)
| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| GET | `/vouchers` | Voucher có sẵn | ✅ CITIZEN |
| POST | `/redeem/{voucherId}` | Đổi voucher | ✅ CITIZEN |
| GET | `/my-vouchers` | Voucher đã đổi | ✅ CITIZEN |

### 📊 Point History (`/api/citizen/point-history`)
| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| GET | `/` | Lịch sử điểm | ✅ CITIZEN |
| GET | `/summary` | Tổng kết điểm | ✅ CITIZEN |

### 🏅 Leaderboard (`/api/leaderboard`)
| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| GET | `/` | Bảng xếp hạng toàn hệ thống | ✅ |
| GET | `/area/{areaId}` | Bảng xếp hạng theo khu vực | ✅ |

### 📏 Point Rules (`/api/enterprise/point-rules`)
| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| GET | `/` | Danh sách quy tắc | ✅ ENTERPRISE |
| GET | `/{ruleId}` | Chi tiết quy tắc | ✅ ENTERPRISE |
| POST | `/` | Tạo quy tắc mới | ✅ ENTERPRISE |
| PUT | `/{ruleId}` | Cập nhật quy tắc | ✅ ENTERPRISE |
| DELETE | `/{ruleId}` | Xóa quy tắc | ✅ ENTERPRISE |

### 👨‍💼 Admin Users (`/api/admin/users`)
| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| GET | `/` | Danh sách người dùng | ✅ ADMIN |
| PUT | `/{userId}` | Cập nhật người dùng | ✅ ADMIN |
| DELETE | `/{userId}` | Xóa người dùng | ✅ ADMIN |
| POST | `/{userId}/reset-password` | Reset mật khẩu | ✅ ADMIN |

### 🏢 Admin Enterprises (`/api/admin/enterprises`)
| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| GET | `/` | Danh sách doanh nghiệp | ✅ ADMIN |

### 📍 Admin Service Areas (`/api/admin/service-areas`)
| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| GET | `/` | Danh sách khu vực | ✅ ADMIN |
| POST | `/` | Tạo khu vực mới | ✅ ADMIN |
| PUT | `/{areaId}` | Cập nhật khu vực | ✅ ADMIN |
| DELETE | `/{areaId}` | Xóa khu vực | ✅ ADMIN |

---

## Response Format

### Thành công
```json
{
    "field1": "value1",
    "field2": "value2"
}
```

### Thành công với phân trang
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
    "error": "Mô tả lỗi",
    "message": "Chi tiết lỗi (optional)"
}
```

---

## HTTP Status Codes

| Code | Ý nghĩa |
|------|---------|
| 200 | Thành công |
| 201 | Tạo mới thành công |
| 204 | Xóa thành công |
| 400 | Yêu cầu không hợp lệ |
| 401 | Chưa xác thực |
| 403 | Không có quyền |
| 404 | Không tìm thấy |
| 500 | Lỗi server |

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
