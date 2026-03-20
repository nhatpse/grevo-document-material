# 🔄 Tổng Quan Luồng Xử Lý

Tài liệu này tổng hợp các luồng xử lý chính (Process Flows) trong hệ thống Grevo. Vui lòng chọn file tương ứng để xem chi tiết sơ đồ luồng (Sequence Diagrams) và các bước kỹ thuật.

## Danh Sách Luồng Hiện Có

1. **[Luồng Báo Cáo Rác Thải](luong-bao-cao-rac.md)**
   - Mô tả quá trình công dân (Citizen) chụp ảnh, điền thông tin và gửi báo cáo rác thải.
   - Các trạng thái báo cáo (Pending, Assigned, v.v.).

2. **[Luồng Chia Sẻ Vị Trí (QR Scan)](luong-quet-qr-vi-tri.md)**
   - Tiện ích cho phép công dân quét mã QR trên màn hình trình duyệt máy tính bằng điện thoại di động.
   - Cơ chế polling và đồng bộ tọa độ GPS từ Mobile lên Desktop (Location Session).

3. **[Luồng Thu Gom Rác Thải](luong-thu-gom.md)**
   - Quá trình doanh nghiệp (Enterprise) phân công báo cáo cho nhân viên thu gom (Collector).
   - Quá trình Collector tiếp nhận, di chuyển, cập nhật hình ảnh xác nhận, và đánh giá chất lượng.

4. **[Luồng Tích Điểm](luong-tich-diem.md)**
   - Logic tính toán điểm thưởng cho công dân dựa trên khối lượng rác, hệ số chất lượng (từ đánh giá của Collector), và quy tắc điểm (Point Rules) được cấu hình bởi doanh nghiệp.

5. **[Luồng Đổi Voucher](luong-doi-voucher.md)**
   - Quá trình công dân sử dụng điểm thưởng đã tích lũy để đổi các mã giảm giá, voucher từ doanh nghiệp.
   - Logic tạo mã QR code voucher và trạng thái voucher (Active, Used, Expired).

---

## Kiến Trúc Giao Tiếp (Client-Server)

Trong tất cả các luồng xử lý:
- **Frontend** (React) đóng vai trò là Client, gửi request HTTP thông qua thư viện Axios (đính kèm JWT authorization header).
- **Backend** (Spring Boot) chịu trách nhiệm xác thực request, Validate dữ liệu, gọi API dịch vụ bên thứ ba (như Cloudinary để lưu ảnh, VietMap để biên dịch tọa độ), và Persist dữ liệu xuống Database (PostgreSQL).

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
