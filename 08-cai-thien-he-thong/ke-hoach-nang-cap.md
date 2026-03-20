# 🚀 Kế Hoạch Nâng Cấp & Cải Thiện Hệ Thống Lên Chuẩn Thực Tế

Chào bạn, dựa trên việc phân tích rất sâu vào 23 Controllers, cấu trúc React frontend, cũng như Business Rules của **Grevo Solutions**, tôi đánh giá đây là một hệ thống đã có thiết kế rất tốt, logic chặt chẽ.

Tuy nhiên, để dự án thực sự hoạt động trong môi trường **Thực Tế (Production)** với hàng ngàn người dùng song song, chúng ta cần cải thiện và bổ sung một số điểm chí mạng dưới đây.

---

## 1. Nghiệp Vụ Thực Tế (Business Logic)

### 1.1. Luồng Báo Cáo Rác (Waste Report)
- **Giới hạn số lượng (Rate Limiting):** Hiện tại công dân có thể tạo liên tục miễn là báo cáo cũ đã xong. Ở thực tế, nên giới hạn: *Citizen chỉ được gửi tối đa 3-5 báo cáo/ngày* để chống Spam (DDOS bằng reports).
- **Hệ thống phạt (Penalty System):** Nếu một Citizen liên tục báo cáo rác "ảo" (Collector đến nơi nhưng không thấy rác/rác sai mô tả) → Cần có cơ chế cho Collector báo cáo ngược lại. Nếu bị báo cáo 3 lần, account Citizen sẽ bị khóa tạm thời 7 ngày hoặc bị trừ điểm nặng.
- **Tự động hủy (Auto-expiration):** Các report nằm ở trạng thái `PENDING` quá 48h không có doanh nghiệp nào nhận cần tự động hủy (Chạy Spring Boot `@Scheduled` cron job) và gửi thông báo xin lỗi đến Citizen.

### 1.2. Kỷ Luật Nhân Viên Thu Gom (Collector)
- **Cooldown Hủy Task:** Nếu một Collector bấm "Hủy nhiệm vụ" (Cancel), họ sẽ không thể nhận bất kỳ task nào khác trong vòng 30-60 phút tiếp theo. Tránh tình trạng lựa chọn "chọn việc nhẹ, chừa việc nặng".
- **Tracking GPS di chuyển:** Hiện tại hệ thống chỉ gửi tọa độ khi báo cáo rác. Để đúng thực tế, khi Collector chọn "ON_THE_WAY", App Web của họ cần định kỳ (5-10 phút/lần) report vị trí về server để Enterprise dễ dàng quản lý đoạn đường.

### 1.3. Luồng Quản Lý Doanh Nghiệp (Enterprise)
- **Quy trình duyệt Doanh Nghiệp (Approval Flow):** Bất cứ ai đăng ký làm Enterprise cũng có thể vào hệ thống. Ở thực tế, Admin phải kiểm duyệt giấy phép kinh doanh, mã số thuế trước khi set `isActive = true`.

---

## 2. Hiệu Năng & Tối Ưu Backend (Backend & Performance)

### 2.1. Caching
- **Redis Cache:** Các thông số như `PointRules`, danh sách Voucher còn khả dụng trên hệ thống cực kỳ ít thay đổi nhưng lại được load rất nhiều (bởi mọi Citizen). Cần đưa các API này vào `@Cacheable` (với Redis) để giảm tải cho MySQL.
- **Leaderboard Calculation:** API tạo Leaderboard hiện tại lặp qua tất cả Citizen và PointTransactions. Khi có 10,000 công dân, API này sẽ gây sập server. => **Giải pháp**: Tính toán điểm hàng ngày 1 lần vào lúc 0:00 sáng bằng Scheduler, lưu xuống bảng `weekly_leaderboard_cache` hoặc Redis Sorted Sets.

### 2.2. Tránh Lỗi N+1 Query (JPA)
- Khi gọi các list chứa quan hệ `@OneToMany` hoặc `@ManyToOne` (như list Voucher, list Report kèm citizen), JPA sẽ sinh ra hàng loạt câu lệnh SELECT nhỏ. Nên dùng `@EntityGraph` hoặc `JOIN FETCH` trong các Repository interface để gom Query.

### 2.3. Xử Lý Bất Đồng Bộ (Asynchronous)
- Cập nhật điểm, gởi email duyệt nghỉ phép, email Reset Password đang chạy đồng bộ (Synchronous). Nên dùng `@Async` hoặc đẩy vào **Message Queue** (RabbitMQ/Kafka) để API trả phản hồi ngay lập tức cho client.

---

## 3. Bảo Mật & An Toàn (Security)

### 3.1. Chống Brute-Force & Account Lockout
- Khóa tài khoản sau 5 lần nhập sai mật khẩu liên tiếp trong 15 phút.

### 3.2. Quản Lý Session Dữ Liệu
- Hỗ trợ Force Logout từ mọi thiết bị nếu người dùng phát hiện bị lộ thông tin, bằng cách tích hợp Token Blacklist hoặc cấu trúc phiên trên Redis.

### 3.3. Audit Log (Lịch Sử Thao Tác)
- Mọi thao tác đổi Điểm quy đổi rác (Point Rules) của Enterprise, hay thao tác xóa/ban User của Admin phải được ghi log chặt chẽ bới Entity `AuditLog` để truy vết trách nhiệm sau này (Ai, làm gì, lúc nào).

---

## 4. UI/UX (Frontend)

### 4.1. Trải Nghiem Tải Dữ Liệu
- Khi mạng chậm, nếu bấm "Get Eligible Collectors", user không biết app đang làm gì. Cần bổ sung UI Skeleton (Giao diện khung xương) hoặc Loading spinner.

### 4.2. Quản Lý Lỗi Thông Minh (Graceful Error Handling)
- Các lỗi như 401 Unauthorized phải tự động redirect user ra trang Login, xóa token cũ thay vì hiển thị màn hình trắng.
- Nếu token hết hạn, có thể cần thiết kế tính năng `Refresh Token` để user không phải liên tục đăng nhập lại mỗi ngày.

### 4.3. Nén Hình Ảnh Phía Client
- Upload ảnh bằng Cloudinary ở Backend. Cần nén dung lượng ảnh (compress) xuống dưới 1-2MB ngay tại trình duyệt trước khi gởi lên server (Dùng React `browser-image-compression`) để tiết kiệm băng thông.

---

## Lộ Trình Đề Xuất (Roadmap)
Để biến dự án từ mức "Cơ Bản (MVP)" sang "Production Ready", bạn nên làm theo thứ tự sau:

1. **Tuần 1:** Xây dựng tính năng "Khoá Tài Khoản", "Audit Log" và "Rate Limiting". Cải thiện Exception Handling toàn cầu cho Backend (Trả JSON Error code thay vì Runtime Exception).
2. **Tuần 2:** Sửa toàn bộ lỗi N+1 Query JPA, Nén ảnh ở Frontend trước khi gửi đi, và Refactor thêm phần gửi email sang luồng Asynchronous.
3. **Tuần 3:** Thay đổi logic Leaderboard bằng crontab/Scheduled jobs lưu vào bảng phụ nhằm tối ưu DB. Tích hợp tính năng Penalty trừ điểm nếu rác rởm.
4. **Tuần 4:** Tích hợp Redis để Caching các Point rules, Danh sách Voucher, Cấu hình chung.

*Chúc dự án của bạn phát triển thành công và có khả năng scale tốt!*
