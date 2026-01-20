# ⚠️ Bảng Mã Lỗi (Error Codes)

Tài liệu này liệt kê các mã lỗi chuẩn của hệ thống Grevo API.

---

## 1. HTTP Status Codes

| Code | Message | Ý nghĩa |
|------|---------|---------|
| **200** | OK | Request thành công |
| **201** | Created | Tài nguyên mới đã được tạo thành công |
| **204** | No Content | Xử lý thành công nhưng không có dữ liệu trả về |
| **400** | Bad Request | Dữ liệu gửi lên không hợp lệ (validation fail, sai format) |
| **401** | Unauthorized | Chưa xác thực (thiếu token hoặc token hết hạn) |
| **403** | Forbidden | Không có quyền truy cập tài nguyên này |
| **404** | Not Found | Không tìm thấy tài nguyên |
| **409** | Conflict | Xung đột dữ liệu (ví dụ: trùng email) |
| **500** | Internal Server Error | Lỗi không xác định từ phía server |

---

## 2. Thông Báo Lỗi Nghiệp Vụ (Business Errors)

Hệ thống trả về JSON lỗi có định dạng:
```json
{
    "message": "Nội dung lỗi chi tiết",
    "errorCode": "ERR_XXX" 
}
```
*(Lưu ý: errorCode là optional và đang được cập nhật)*

### Auth Module

| Message | Nguyên nhân | Gợi ý khắc phục |
|---------|-------------|-----------------|
| `Email already exists` | Đăng ký với email đã có trong DB | Dùng email khác hoặc Đăng nhập |
| `Username or Password is wrong` | Sai thông tin đăng nhập | Kiểm tra lại pass/email |
| `Account is disabled` | Tài khoản bị khóa bởi Admin | Liên hệ hỗ trợ |
| `Invalid Google Token` | Token Google gửi lên không hợp lệ | Đăng nhập lại Google |

### Waste Report Module

| Message | Nguyên nhân | Gợi ý khắc phục |
|---------|-------------|-----------------|
| `Report not found` | ID báo cáo không tồn tại | Kiểm tra ID |
| `This task is not assigned to you` | Collector cố thao tác task của người khác | Kiểm tra danh sách task |
| `Can only complete tasks that are ON_THE_WAY` | Sai trạng thái khi complete | Phải accept task trước |

### Voucher Module

| Message | Nguyên nhân | Gợi ý khắc phục |
|---------|-------------|-----------------|
| `Insufficient points` | Không đủ điểm đổi voucher | Tích thêm điểm |
| `Voucher not found` | Voucher ID sai | Kiểm tra ID |
| `Voucher is not available` | Voucher hết hạn hoặc hết số lượng | Chọn voucher khác |

---

## 3. Lỗi Validation

Khi gặp lỗi 400 do validation, response sẽ có dạng:

```json
{
    "title": "must not be blank",
    "description": "must not be blank"
}
```
*(Hoặc map chi tiết field)*

Các lỗi thường gặp:
- `NotNull`: Trường bắt buộc bị thiếu
- `Email`: Định dạng email sai
- `Size`: Độ dài chuỗi không hợp lệ
- `Min/Max`: Giá trị số không nằm trong khoảng cho phép

---

© 2026 Grevo Solutions.
