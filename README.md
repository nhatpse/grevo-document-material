# Grevo Solutions - Tài Liệu Dự Án

## Thông Tin Dự Án

| Thông tin | Chi tiết |
|-----------|----------|
| **Tên dự án** | Grevo Solutions |
| **Pháp nhân** | Grevo Team |
| **Người phát triển** | Grevo Team |
| **Email liên hệ** | pnhat.se@gmail.com |
| **Phiên bản** | 1.0.0 |
| **Ngày cập nhật** | 21/01/2026 |

---

## Giới Thiệu

**Grevo Solutions** là một nền tảng quản lý thu gom rác thải thông minh, kết nối giữa:
- **Công dân (Citizens)**: Người dân báo cáo rác thải cần thu gom
- **Doanh nghiệp (Enterprises)**: Đơn vị quản lý và điều phối thu gom
- **Nhân viên thu gom (Collectors)**: Người thực hiện thu gom rác thải
- **Quản trị viên (Admin)**: Người quản lý toàn bộ hệ thống

---

## Tính Năng Chính

### Dành Cho Công Dân
- Đăng ký/Đăng nhập (Email hoặc Google OAuth)
- Báo cáo rác thải với hình ảnh, vị trí GPS
- Theo dõi trạng thái báo cáo
- Tích điểm thưởng sau mỗi lần thu gom thành công
- Đổi điểm lấy voucher
- Đánh giá nhân viên thu gom
- Xem bảng xếp hạng công dân

### Dành Cho Doanh Nghiệp
- Quản lý báo cáo rác thải trong khu vực phụ trách
- Phân công nhân viên thu gom
- Quản lý nhân viên thu gom
- Tạo và quản lý voucher
- Cấu hình quy tắc tính điểm
- Xem lịch sử thu gom

### Dành Cho Nhân Viên Thu Gom
- Xem danh sách nhiệm vụ được phân công
- Chấp nhận/Từ chối nhiệm vụ
- Cập nhật trạng thái thu gom
- Chụp ảnh xác nhận hoàn thành
- Đánh giá công dân

### Dành Cho Quản Trị Viên
- Quản lý tài khoản người dùng
- Quản lý khu vực dịch vụ
- Quản lý doanh nghiệp
- Xem nhật ký hệ thống

---

## Cấu Trúc Tài Liệu

```
grevo-document-material/
├── README.md                           # Tổng quan dự án
├── 01-tong-quan-he-thong/
│   ├── kien-truc-he-thong.md          # Kiến trúc hệ thống
│   └── cong-nghe-su-dung.md           # Công nghệ sử dụng
├── 02-api-documentation/
│   ├── tong-quan-api.md               # Tổng quan API
│   ├── auth-api.md                    # API Xác thực
│   ├── citizen-api.md                 # API Công dân
│   ├── enterprise-api.md              # API Doanh nghiệp
│   ├── collector-api.md               # API Nhân viên thu gom
│   └── admin-api.md                   # API Quản trị viên
├── 03-co-so-du-lieu/
│   ├── er-diagram.md                  # Sơ đồ ER
│   └── mo-ta-bang-du-lieu.md          # Mô tả bảng dữ liệu
├── 04-luong-xu-ly/
│   ├── luong-bao-cao-rac.md           # Luồng báo cáo rác
│   ├── luong-thu-gom.md               # Luồng thu gom
│   ├── luong-tich-diem.md             # Luồng tích điểm
│   └── luong-doi-voucher.md           # Luồng đổi voucher
├── 05-huong-dan/
│   ├── huong-dan-cai-dat.md           # Hướng dẫn cài đặt
│   └── huong-dan-deploy.md            # Hướng dẫn triển khai
└── 06-phu-luc/
    ├── ma-loi.md                      # Bảng mã lỗi
    └── thuat-ngu.md                   # Thuật ngữ
```

---

## Liên Hệ

Mọi thắc mắc xin liên hệ:
- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
