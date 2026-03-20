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

## ⚠️ Phân Tích Rủi Ro & Bug Logic Tiềm Ẩn (Dự Đoán)

Quá trình rà soát kiến trúc cho thấy dự án thiết kế rất tốt, nhưng khi đưa lên môi trường **Thực tế (Production) với nhiều người dùng đồng thời**, các chức năng sau có nguy cơ xảy ra lỗi logic nghiêm trọng nếu không xử lý kỹ:

### 1. Chức năng Báo cáo Rác (Citizen)
*   **Spam Báo cáo Ảo (Troll/Abuse):** Thiếu cơ chế giới hạn (Rate Limiting) và hệ thống Phạt (Penalty). Công dân có thể nhấn tạo báo cáo liên tục, khiến Collector chạy đến rồi về không trong tình trạng thiếu rác, gây lãng phí xăng cộ.
*   **Sai lệch Khối lượng & Phương tiện:** Người dùng gõ "1000kg" rác nhưng hệ thống không có cảnh báo. Nếu Enterprise gán cho xe máy 50kg (do Backend chưa ràng buộc ENUM loại xe), Collector đến nơi sẽ không thể chở được.

### 2. Chức năng Phân công (Enterprise)
*   **Xung đột Trạng thái Kép (State Conflict):** Enterprise vừa nhấn `Assign` trên màn hình. Cùng phần nghìn giây đó, Citizen đổi ý nhấn `Cancel`. Trạng thái DB ghi đè nhau hỗn loạn. Cần bọc bằng Optimistic/Pessimistic Lock thay vì hàm `status = ...` thủ công.
*   **Tắc nghẽn Đơn lớn (Bất cập cấu trúc 1:1):** 1 Báo Cáo 200kg không thể được gán cho 2 xe tải nhỏ (100kg/xe) vì quan hệ DB hiện tại là 1 Report - 1 Collector.

### 3. Chức năng Thu gom (Collector)
*   **Lỗ hổng Cướp quyền (IDOR - Insecure Direct Object Reference):** Collector A truyền lên ID `task_id=999` (vốn là đơn của Collector B). Nếu hàm `completeTask()` không check câu lệnh `if (task.collectorId != currentUser.id)`, thì A có thể bấm hoàn thành/hủy thay rác của B.
*   **Rác Không Gian Mạng (Orphan Image Cloudinary):** Collector upload ảnh thành công lên Cloudinary, nhận URL. Khổ nỗi giây tiếp theo lưu xuống MySQL bị Throw Exception (vì rớt kết nối DB). DB thì Rollback hủy thay đổi, nhưng ảnh trên Cloud thì mãi mãi bị kẹt lại không ai xóa.

### 4. Chức năng Đổi Thưởng Điểm - Voucher
*   **Lỗ hổng Cạnh Tranh (Race Condition Hacking):** Công dân viết Script bắn 50 Request đổi Voucher cùng 1 phần nghìn giây. Hệ thống đọc `$points >= 500` thả phanh qua cho cả 50 Request trước khi nghiệp vụ trừ điểm lưu xong. Kết quả: User lấy được 50 Voucher, và điểm có thể bị âm. Cần dùng **Pessimistic Write Lock (`@Lock`)** ở Repository khi trừ điểm.

### 5. Chức năng Vị trí hiển thị (QR Scan Session)
*   **Phình to Database (Data Bloat):** Bọn Hacker dùng tools F5 trang Web Desktop 1 triệu lần. API sả ra 1 triệu Session Location rác nằm PENDING trong Database. Nếu không có CronJob quét xóa sau 15 phút hoặc dùng Redis TTL, DB sẽ sập.

### 6. Quản Lý File & Cloudinary (Production Limits)
*   **Cháy băng thông / File độc hại:** Gói Cloudinary Free bị giới hạn băng thông và dung lượng. Nếu 1000 Collector mỗi ngày up 5 ảnh (5MB/ảnh) chụp bằng cam điện thoại nét cao, tài khoản sẽ bị ngưng vĩnh viễn (Suspended) trong vài ngày. **Bắt buộc** phải có thư viện tự động nén ảnh phía React (Image Compression) xuống dưới 1MB trước khi gọi API, đồng thời Backend phải check kỹ MIME Type để tránh upload mã độc `.sh` giả danh đuôi `.jpg`.

### 7. Hệ Thống Email & Chặn Luồng (Thread Blocking)
*   **Gửi Email Đồng Bộ (Synchronous SMTP):** Gọi hàm đăng ký / quên mật khẩu, Java sẽ đứng đợi máy chủ Mail (như Sendgrid/Hostinger) báo thành công thì mới trả về Frontend. Nếu server Mail lag 10 giây, người dùng bấm nút Đăng ký sẽ thấy màn hình đơ 10 giây (và họ sẽ bấm thêm chục lần nữa gây loạn data). **Bắt buộc** bọc API gửi mail trong `@Async` hoặc đẩy vào Message Queue (RabbitMQ).

### 8. Authentication & Cướp JWT (Token Theft)
*   **Không có Blacklist Token:** Khi Admin khóa account của 1 user (Ban), hoặc user đổi mật khẩu/bị trộm điện thoại, cái JWT Token cũ vốn đang nằm trong bộ nhớ máy kia **chưa hề hết hạn** và vẫn xài được trong vài tuần. Để đúng thực tế On-site, phải check sự hợp lệ của token (ví dụ lưu `issuedAt` và check `passwordLastChangedAt`, hoặc đẩy Token bị hủy vào Redis Blacklist).

### 9. Rò Rỉ API Key Bản Đồ (VietMap Key Leaking)
*   **Mất tiền API Key Frontend:** Các React API key để trên Web luôn public với tất cả mọi người (Bấm F12 mạng là thấy). Nếu đối thủ sao chép Key VietMap của dự án mang về web họ gắn, họ sẽ chạy hết Quota trả phí của mình. **Bắt buộc** phải cài đặt White-list Domain trong Dashboard của Vietmap, chỉ cho phép tên miền `grevo.com` gọi key đó.

### 10. Trải nghiệm Realtime của Collector (Cháy Service)
*   **Điểm mù thời gian thực (Missing Push Notification):** Khi Doanh nghiệp phân công (Assign) 1 báo cáo, ứng dụng của Collector làm sao biết có đơn nổ mà mở App? Hiện tại phải F5 mới thấy. Ở thực tế (On-site), bắt buộc phải tích hợp Firebase Cloud Messaging (FCM) hoặc WebSockets / Server-Sent Events (SSE) để bắn Noti rung điện thoại tài xế ngay lập tức (Giống Grab/Gojek).

---

## 🎨 Phân Tích Lỗi Giao Diện & Trải Nghiệm Người Dùng (UI/UX Bugs)

Ngoài các lỗi hệ thống thì phần Giao diện Frontend (React) cũng sẽ gặp **7 lỗi UX "chết người"** khi mang ra sử dụng nội bộ (On-site) hoặc Public cho Citizen:

### 1. Bay Màu Form Dữ Liệu do Token (Sudden Logout Data Loss)
*   **Kịch bản:** Citizen đang cẩn thận gõ mô tả rác, chụp 5 tấm hình tốn mất 15 phút. Vừa bấm nút "Gửi", đúng lúc JWT Token vừa hết hạn (Expire).
*   **Bug UI:** API trả về `401 Unauthorized`. Frontend thường code là `if (error.status === 401) { navigate('/login') }`. Kết quả: Người dùng bị văng ra màn Login, khi quay lại thì trắng màn hình, mất sạch 15 phút gõ data và ảnh. **Bắt buộc** phải có cơ chế `Refresh Token` chạy ngầm, hoặc Popup xin mật khẩu tại chỗ thay vì redirect thẳng tay.

### 2. Double-Submit (Nút Bấm Vô Tri)
*   **Kịch bản:** Do Backend xử lý upload Cloudinary và phân bổ điểm hơi chậm (tốn 3-5 giây). Khi người dùng bấm "Gửi báo cáo", nút bấm không đổi trạng thái.
*   **Bug UI:** Theo thói quen, user sẽ bực mình và "Spam click" nút Gửi 5 lần. Axios sẽ bắn lên 5 Request y hệt nhau, tạo ra 5 Báo cáo rác trùng lặp trong DB. **Bắt buộc** phải Disable nút Submit và chuyển thành Icon Loading (Spinner) ngay sau cú click đầu tiên.

### 3. Văng Ứng Dụng do Mất Mạng (Offline Crash)
*   **Kịch bản:** Collector bưng rác xuống tầng hầm chung cư để gởi xe, ở đó không có sóng 4G. Họ bấm "Hoàn Thành".
*   **Bug UI:** Axios ném lỗi `Network Error`. Nếu Frontend không bọc `try/catch` có xử lý UI đàng hoàng, màn hình sẽ hiển thị trắng bóc (White Screen of Death) hoặc báo lỗi kỹ thuật mã code. Cần bắn Toast: *"Mạng yếu, vui lòng di chuyển ra nơi có sóng để thao tác"*.

### 4. Rò Rỉ Bộ Nhớ Màn Hình Bản Đồ (WebGL Context Leak)
*   **Kịch bản:** Trang Admin/Enterprise xem báo cáo, mỗi Modal mở lên là 1 map VietMap (MapLibre GL). Admin mở tắt Modal bản đồ 20 lần để xem các nhà khác nhau.
*   **Bug UI:** Mỗi lần Component Map Unmount, nếu React không gọi hàm `map.remove()`, trình duyệt Chrome sẽ không giải phóng `WebGL Context` (Tối đa 16 context). Mở đến lần thứ 17, bản đồ đen xì hoặc trình duyệt Crash Out-Of-Memory.

### 5. Overload DOM (Vỡ Giao Diện Do Không Có Phân Trang)
*   **Kịch bản:** Sau 1 tháng, Doanh nghiệp có 5,000 báo cáo rác (Lịch sử). Màn hình "Quản lý Báo cáo" gọi API lấy toàn bộ 5000 dòng đổ vào Table.
*   **Bug UI:** Trình duyệt React phải render 5000 Node HTML DOM cùng lúc. Máy tính của Admin sẽ đơ lag (Freeze) trong 10 giây mỗi khi mở trang này. **Bắt buộc** UI phải yêu cầu API làm **Pagination** (Phân trang 10 dòng/trang) hoặc **Infinite Scroll** (Cuộn tới đâu load tới đó).

### 6. Rác Giao Diện Khung Nhìn Cờ Cáp (Responsive Break)
*   **Kịch bản:** Các Bảng (Table) Quản lý Doanh Nghiệp, Quản lý Voucher có 7-8 cột (Mã, Tên, Trạng thái, Ngày tạo, Hành động...).
*   **Bug UI:** Khi người dùng mở bằng Điện thoại (Mobile), cái bảng sẽ thu hẹp lại đè text lên nhau vỡ bung bét, hoặc mất nút bấm. Cần chuyển từ Table sang giao diện Dạng Thẻ (Card View) khi màn hình dưới 768px (`@media max-width: 768px`).

### 7. Optimistic UI (Thiếu Phản Hồi Tức Thì)
*   **Kịch bản:** Công dân chọn đổi Voucher (Trừ 500 điểm). API phản hồi mất 2 giây.
*   **Bug UI:** Giao diện đứng im 2 giây làm người dùng hoang mang. Ở các App hiện đại (như Shopee), khi bấm đổi, số điểm UI phải tự giảm ngay lập tức `-500` (Optimistic Update) để tạo cảm giác "mượt/không độ trễ", dù ở dưới nền Background API vẫn đang âm thầm gọi. Nếu API fail, UI mới Undo lại số điểm. Đây là quy chuẩn UX hiện đại.

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
