# 📋 Danh Sách Công Việc Khắc Phục Lỗi Logic & Cải Tiến Hệ Thống (To-Do List)

Dựa trên toàn bộ quá trình đọc mã nguồn (`grevo-be-material` + `grevo-fe-material`) và Phân tích Rủi ro, dưới đây là danh sách những việc **CẦN LÀM (Actionable Items)** được sắp xếp theo mức độ Ưu Tiên để dự án đạt chuẩn Thực Tế (Production-ready). 

Có thể dùng check-list này để giao việc cho các thành viên trong đội (Backend, Frontend).

---

## 🔴 1. Ưu Tiên Cao (Critical) - Các Lỗi Chết Người (Làm Ngay)

Đây là những Bug liên quan đến Dữ Liệu và Tiền Tệ có thể bị Hacker lợi dụng để phá sập hệ thống hoặc bòn rút tiền của Doanh nghiệp.

- [ ] **Khóa Dữ Liệu (Race Condition Voucher)**: Bổ sung `@Lock(LockModeType.PESSIMISTIC_WRITE)` vào phương thức trừ điểm lấy Voucher trong Repository để ngăn chặn 1 user bắn 50 request cùng lúc lấy 50 voucher.
- [ ] **Lỗi Cướp Quyền Hủy Đơn (IDOR Task Collector)**: Thêm câu lệnh `if(!task.getAssignedCollector().getId().equals(currentUserId)) throw Exception` vào Controller khi Collector thực hiện `accept`, `complete`, `cancel`.
- [ ] **Lỗi Snapshot Cấu Hình Điểm**: Bắt buộc gắn `PointRule` hiện hành (lưu cứng `basePointsPerKg`) vào Bảng Report lúc chuyển sang trạng thái `ON_THE_WAY`, hoặc cấm sửa Rule đang Active (chỉ cho tạo mới có `validFrom`). Chống việc doanh nghiệp đổi điểm vào phút chót.
- [ ] **Lỗi Đăng Ký Lại (Bonus Exploit)**: Đổi logic API Xóa User từ xóa thật trong DB sang `isDeleted = true` (Xóa mềm). Từ chối cấp điểm tân thủ nếu Email cũ đã đăng ký lại.
- [ ] **Lỗi Chặn Thread Gửi Email**: Sửa hàm `emailService.sendMail()` (Gửi OTP, Quên mật khẩu) thành `@Async` (hoặc cấu hình RabbitMQ) để Java không phải đứng đợi Server Mail làm treo (Timeout) request đăng ký của người dùng.

---

## 🟠 2. Ưu Tiên Trung Bình (High) - Củng Cố Logic Nghiệp Vụ Thực Tế

Đây là những logic hiện tại hoạt động được nhưng "chưa thông minh" hoặc dễ dãi.

- [ ] **Chặn Spam Đánh Giá (Review Bombing)**: Kiểm tra bảng Report đã có cờ `isFeedbackSubmitted = true` chưa, chỉ cho phép đánh giá (POST `/api/feedback`) **1 lần duy nhất** đối với 1 Task.
- [ ] **Dọn rác Vị trí Web (Location Session Bloat)**: Viết 1 file `@Scheduled(cron="0 0/15 * * * *")` quét và Xóa thẳng tay các `LocationSession` có trạng thái `PENDING` và tạo cách đây quá 15 phút.
- [ ] **Lọc Lịch Nghỉ Phép (Collector Availability)**: Sửa API `getEligibleCollectors()` để gạch tên (Exclude) những tài xế đang có bài xin phép (`LeaveRequest = APPROVED/PENDING`) rơi vào ngày hôm nay.
- [ ] **Up Rác Đám Mây (Cloudinary Bandwidth)**: 
  * *Frontend:* Dùng thư viện `browser-image-compression` ép ảnh xuống dưới 1MB trước khi bắn API.
  * *Backend:* Phải thêm Logic xóa ảnh trên Cloudinary nếu thao tác tính điểm ngay sau đó bị `Exception` (Rollback JPA).
- [ ] **Bảo mật Map (Vietmap API Key)**: Vào Dashboard VietMap đăng ký "White-list Domains" chỉ trỏ về đúng 1 tên miền `grevo.com` (chống lộ Key React).

---

## 🟡 3. Ưu Tiên Thấp (Medium) - Nâng Cấp UX/UI

- [ ] **Ngăn Nút Vô Tri (Double-Submit React)**: Khóa (Disabled) nút "Gửi Báo Cáo", hiển thị Spinner Loading trong lúc chờ `Axios.post` xử lý, ngăn user nhấn 5 lần đẻ ra 5 báo cáo.
- [ ] **Tránh Văng Mất Mạng (Offline Graceful Error)**: Bọc khối lệnh gửi Request trong React bằng Check Network hoặc bắt mã lỗi Timeout, hiển thị Toast "Mất mạng, vui lòng tìm khu vực có sóng" thay vì màn hình trắng vỡ DOM.
- [ ] **Chống Sập DOM với Bản đồ (WebGL Leak)**: Thêm phương thức `map.remove()` trong hàm `useEffect(..., return() => {})` (cleanup function) của Component Bản đồ.
- [ ] **Cuộn Dữ Liệu (Pagination/Lazy Load)**: Sửa tất cả các API Get List (Get Reports) của Enterprise thành dạng `Pageable`. Trên FrontEnd chuyển Table thành Infinite Scroll (Cuộn tới đâu load tới đó).

---

## 🟢 4. Nâng Cấp Dự Án Trọng Điểm (Next Milestones)

- [ ] **Thông Báo Cháy Máy (Realtime Noti)**: Tích hợp `Firebase Cloud Messaging (FCM)` bằng cách lấy FCM-Token từ Mobile Collector, để khi Enterprise nhấn `Assign`, API sẽ bắn thẳng lệnh Rung điện thoại tài xế mà không cần họ F5 (Kéo mới).
- [ ] **Bài Toán Chia Chở Hàng (Partial Assignment)**: Tái cấu trúc cơ sở dữ liệu `WasteReport` - `CollectorTask` từ **1:1** sang **1:N**. Thiết kế giao diện cho phép Admin gán báo cáo 200kg rác cho tổ hợp 1 xe Tải 100kg và 2 xe máy 50kg đến lấy.
- [ ] **Thuật Toán Điểm Cứu Hộ (Surge Pricing / Ghép Đơn)**: Tự động cộng hệ số `BonusPoint x2` cho Báo Cáo bị treo quá 8 tiếng (Khu vực vắng). Bổ sung hàm tính gom 3 báo cáo có Vĩ độ/Kinh độ gần nhau thành 1 Route.
- [ ] **Báo Cáo Sự Cố Trên Đường (Incidents Handling)**: Xây dựng Endpoint / Nút bấm cho phép Collector đang đi đường nổ lốp xe. Hệ thống báo cho Citizen chờ thêm và gỡ đơn chuyển sang tài xế khác.

## 🟣 5. Vận Hành, Giám Sát & Pháp Lý (DevOps & Compliance)

Đây là những hạng mục mang tính sống còn khi dự án thực sự "lên sóng" (Go-Live) mà một hệ thống Sinh viên MVP thường bỏ sót, nhưng Doanh nghiệp thực thụ bắt buộc phải có:

- [ ] **Bảo Mật Dữ Liệu Cá Nhân (Data Privacy - PDPA):** Hệ thống đang lưu trữ SĐT, Địa chỉ nhà, và Số Dư Thu Thập Rác của công dân dưới dạng rõ (Plaintext). Thực tế phải mã hóa AES-256 các trường nhạy cảm này trong Database, đồng thời bắt buộc có checkbox "Đồng ý với Điều khoản và Thu thập dữ liệu" ở Màn hình Đăng ký.
- [ ] **Giám Sát Mã Lỗi Hiện Trường (Error Tracking):** Nếu App bị Crash ở máy của công dân, Dev làm sao biết? Bắt buộc tích hợp `Sentry.io` hoặc Firebase Crashlytics để tự động bắn Log lỗi từ Client/Server lên một màn hình giám sát trung tâm thay vì bắt user chụp ảnh màn hình gửi email.
- [ ] **Sao Lưu Dữ Liệu Tự Động (Automated DB Backups):** Chẳng may server bị vỡ ổ cứng hay nhân viên cũ lỡ tay xóa nhầm MySQL (`DROP DATABASE grevo_db`). Bắt buộc viết Script `mysqldump` chạy lúc 3h sáng mỗi ngày, nén lại và ném đường dẫn lưu trữ sang Google Drive hoặc Cụm Amazon S3. 
- [ ] **Quản Lý Rác Log Server (Log Rotation):** File Log của Spring Boot cứ chạy 1 tháng nó bự lên 5GB, 1 năm sau ổ cứng server đầy 100% -> Sập toàn hệ thống. Cần cấu hình `Logback` để tự động cắt nhỏ file log theo ngày, tối đa lưu 30 ngày rồi tự xoá.
- [ ] **Bot Cảnh Báo Sập Nguồn (Health Check & Uptime):** Tích hợp màn hình theo dõi sức khỏe (`Spring Boot Actuator`) và cài đặt Webhook. Khi API chết rớt cấu hình, Server tự động bắn tin nhắn hú còi 🚨 qua nhóm Slack/Zalo/Telegram của nhóm Phát triển ngay trong đêm.

## 🕵️‍♂️ 6. Trưởng Lớn Hơn Cơ Sở Dữ Liệu: Vận Hành Kinh Doanh (QA, BI & Security)

Để một dự án "Sống lâu dài" (Sustainable) và "Gọi Vốn" (Fundable), nhà đầu tư/ban giám đốc sẽ đòi hỏi 3 hệ thống cuối cùng này mà hầu hết kỹ sư ít khi nghĩ tới từ đầu:

- [ ] **Khóa Network Chống Quét API ngầm (WAF/Rate-Limiter):** Hiện tại API `/api/auth/login` đang mở toang. Nếu đối thủ dùng `JMeter` dội 10.000 request/giây để Brute-force mật khẩu bằng botnet, cả con VPS lẫn DB MySQL sẽ chết cứng `Connection Refused`. **Bắt buộc** cấu hình `limit_req` trong `nginx.conf` (ví dụ: cấm 1 IP gọi API quá 10 lần/1 giây) hoặc dùng thư viện Bucket4j trong Spring Boot để giới hạn IP (DDoS Protection).
- [ ] **Bảo Quản Logic Cốt Lõi bằng Unit Test (QA / Testing):** Nếu tháng sau có Dev mới vào sửa luồng `completeTask()` hoặc đổi quy tắc tính điểm `PointRule`, làm sao biết họ không vô tình làm hỏng (Break) code cũ tính sai điểm của ngàn người? **Bắt buộc** phải có Unit Test (dùng JUnit & Mockito) phủ 100% các lớp logic tính điểm thưởng và luồng xác thực chữ ký Voucher.
- [ ] **Góc Nhìn Khách Hàng 360 Độ (Customer Support Identity):** Nếu một ông cụ 60 tuổi gọi lên tổng đài: *"Tôi đi đổ rác trưa nay nhưng app của tôi chưa thấy cộng điểm"*, Admin hiện tại làm sao kiểm tra? Việc mở MySQL tra từng dòng PointTransaction theo tên là không tưởng. Admin bắt buộc phải có nút **"Impersonate" (Đóng vai User)** hoặc Bảng "Customer 360 View" để tra ngược tất tần tật mọi lịch sử hành động, log lỗi API từng giờ của cụ ông đó để giải quyết khiếu nại.
- [ ] **Báo Cáo Tình Báo Kinh Doanh (Business Intelligence - BI):** Quản lý doanh nghiệp không thu rác vì đam mê, họ cần tối ưu lợi nhuận (xăng xe - nhân sự). Hệ thống đang thiếu màn hình phân tích Dữ liệu Nhiệt độ Heatmap (`Chỗ nào nhiều rác nhất?`), Time-series (`Khung giờ nào công dân tạo đơn rác nhiều nhất để điều xe lớn chở đi 1 lượt?`). Việc tích hợp thư viện vẽ biểu đồ (`Chart.js`/`Recharts`) kết hợp API gom cụm dữ liệu phân lớp (Aggregation) là Mỏ Vàng của dự án này.

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
