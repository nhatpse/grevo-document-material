# 📜 Quy Chuẩn Lập Trình (Coding Conventions & Rules)

Dựa trên cách tổ chức thư mục, mã nguồn và kiến trúc hiện tại của dự án **Grevo**, dưới đây là bộ **Quy Chuẩn Lập Trình (Coding Rules)** chính thức dành cho Team. 

Mọi lập trình viên tham gia phát triển dự án bắt buộc phải tuân theo các nguyên tắc ngầm này để đảm bảo mã nguồn đồng nhất, dễ mở rộng và dễ bảo trì.

---

## 🟢 PHẦN 1: QUY CHUẨN BACKEND (JAVA SPRING BOOT)

### 1. Kiến Trúc Nhiều Tầng (Layered Architecture)
Toàn bộ logic phải tuân thủ luồng dữ liệu 1 chiều: `Controller` ➔ `Service` ➔ `Repository`.
*   **Controller (`@RestController`):** Chỉ làm nhiệm vụ điều phối. Định tuyến API, lấy tham số `Request`, xác thực tham số (`@Valid`) và gọi Service. **Tuyệt đối không viết thuật toán tính toán ở Controller.**
*   **Service (Interface):** Luôn tách Interface và Implementation. VD: Cần tạo `WasteReportService`, phần xử lý thực tế viết tại `WasteReportServiceImpl` (gắn `@Service`).
*   **Repository (`@Repository`):** Chỉ dùng interface kế thừa `JpaRepository`. Các câu Query phức tạp dùng `@Query` hoặc method name query của Spring Data.

### 2. Mô Hình DTO (Data Transfer Object)
*   **Tuyệt đối không trả `Entity` (Bảng Database) trực tiếp ra API.** Vì nó làm lộ cấu trúc DB và có thể gây lỗi `LazyInitializationException` hoặc Đệ quy vô hạn (Infinite Recursion) khi parse JSON.
*   **Input (Request):** Phải tạo các class Request (VD: `LoginRequest`, `CreateReportRequest`) ở thư mục `dto/request`.
*   **Output (Response):** Phải tạo các class Response (VD: `AuthResponse`, `ReportDetailResponse`) ở thư mục `dto/response`.
*   Luôn bọc Response trả về trong cục `ResponseEntity<ApiResponse<T>>` để đảm bảo chuỗi JSON luôn có cấu trúc đồng nhất (cả thành công lẫn thất bại).

### 3. Tối Ưu Code với Lombok
*   Không được tự Generate (Gen tay) các hàm `Getters/Setters` và `Constructors`.
*   Luôn dùng các Annotation của Lombok: `@Data`, `@NoArgsConstructor`, `@AllArgsConstructor`, `@Builder` ở trên đầu file Enity/DTO để code Java ngắn gọn và sạch sẽ.

### 4. Bắt Lỗi Xuyên Suốt (Global Exception Handling)
*   Không được rải `try-catch` lộn xộn trong Controller.
*   Chỉ cần `throw new CustomException("Lỗi gì đó")` hoặc các Expection kế thừa `RuntimeException`.
*   Log sẽ bị lớp `@RestControllerAdvice` (thường là `GlobalExceptionHandler`) tóm lại và chuyển mã lỗi về cấu trúc chuẩn: `{ "timestamp", "status", "error", "message" }`.

### 5. Validate Dữ Liệu Tự Động (Bean Validation)
*   Tội gì phải viết `if(password == null)`? Hãy dùng Annotation chặn ngay tại DTO.
*   Gắn `@NotBlank`, `@Email`, `@Size(min=8)`, `@Min(0)` vào các 필드 của DTO.
*   Ở hàm Controller, phải gắn cờ `@Valid` trước biến request: `public ResponseEntity<?> login(@Valid @RequestBody LoginRequest req)`.

### 6. Qui Định Về Naming Convention (Đặt Tên)
*   **Package:** Viết chữ thường, chữ đơn, không dấu gạch ngang (`com.grevo.controller`).
*   **Class/Interface:** `PascalCase` chữ cái đầu viết hoa (`WasteReportController`).
*   **Method/Variable/Object:** `camelCase` chữ cái đầu viết thường (`getWasteReport()`, `reportId`).
*   **Hằng số (Constant)/Enum:** `UPPER_SNAKE_CASE` toàn bộ viết hoa (`ON_THE_WAY`, `MAX_ATTEMPTS`).

---

## 🔵 PHẦN 2: QUY CHUẨN FRONTEND (REACT.JS / VITE)

### 1. Tổ Chức Thư Mục Mạch Lạc
Bám sát cấu trúc src hiện có:
*   `/components`: Chứa Component ruột có thể xài lại (VD: `Button.jsx`, `Modal.jsx`). Tên file phải là `PascalCase`.
*   `/pages`: Chứa Component Màn hình (VD: `HomePage.jsx`, `Dashboard.jsx`). Mỗi route ứng với 1 page.
*   `/services` (hoặc `/api`): Nơi ném các file cấu hình Axios (VD: `auth.service.js`).
*   `/hooks`: Nơi chứa Custom Hook gọi logic (VD: `useAuth.js`).
*   `/context`: Chứa các bộ State Global.

### 2. Giao Tiếp API (Axios Interceptors)
*   **Không gọi thẳng `axios.get` lộn xộn ở nội bộ Component.**
*   Phải gọi qua 1 file Axios Instance được wrap cấu hình sẵn (`api.js` hoặc `axiosClient.js`).
*   Trong instance này, phải có **Interceptor** làm nhiệm vụ duy nhất: *"Đính kèm `Authorization: Bearer <token>` lấy từ LocalStorage vào Header của TẤT CẢ các Request bắn lên Server"*.

### 3. Quản Lý Trạng Thái UI (State Management)
*   Sử dụng **React Context** để quản lý Role và Data phiên đăng nhập (User Login). 
*   Khi lấy Token về thì tống vào `LocalStorage`, AuthContext sẽ tự parse và nhận diện ông này là `ADMIN` hay `CITIZEN` để xài hàm che giấu Route bảo mật (Protected Routes).
*   State Local của Form thì dùng `useState`. Không nên dùng Redux vì source hiện tại quá cồng kềnh với Redux.

### 4. Định Dạng Giao Diện (Tailwind CSS)
*   **Quy tắc:** Thiết kế Giao diện (Styling) 100% bằng Class `Tailwind CSS`. 
*   **Cấm:** Cấm tuyệt đối việc tạo file `.css` song song với File `.jsx` (CSS Modules / Plain CSS) để định dạng Button hay Container, ngoại trừ file `index.css` chứa các biến gốc Toàn hệ thống (`@apply`).
*   Về Animation, ưu tiên dùng `Framer Motion` được cài kèm trên Vite để tạo hiệu ứng mượt mà.

### 5. Quy Chuẩn Đặt Tên React
*   Tên File `.jsx`: Luôn viết Hoa chữ đầu (`PascalCase`). Ví dụ: `CitizenProfile.jsx`.
*   Tên File `.js` (logic, hook, api): Luôn viết thường chữ đầu (`camelCase`). Ví dụ: `formatDate.js`, `vietmapApi.js`.
*   Các biến React State mô tả Bool: Có chữ `is`, `has`, `should` đứng đầu (VD: `isLoading`, `hasError`).

---

## 📋 YÊU CẦU CHUNG (GIT & REVIEW CODE)
1. **Pull Request (PR):** Mỗi tính năng tạo 1 nhánh nhánh riêng lẻ (VD: `feature/create-voucher`). Xong thì tạo Pull Request gộp vào `main`.
2. **Comment Code (Chú thích):** Chỉ Comment để giải thích **TẠI SAO (Why)** hàm này ra đời (Logics kinh doanh phức tạp). Hạn chế comment **CÁI GÌ (What)** (Vì tên hàm `calculatePoints()` đã nói lên tất cả).
3. **Mã Nguồn Mở (Clean Code):** Dòng code phải Tự Làm Tài Liệu. Xóa toàn bộ biến `console.log()` và Import thư viện thừa (Unused Imports) trước khi Commit. Mọi cấu hình nhạy cảm (Key Cloudinary, SQL user, VietmapKey) phải tống vào file `.env` và add vào `.gitignore`.
