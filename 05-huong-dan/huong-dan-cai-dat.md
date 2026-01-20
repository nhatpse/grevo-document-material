# 💻 Hướng Dẫn Cài Đặt (Installation Guide)

## Yêu Cầu Hệ Thống

Trước khi cài đặt, đảm bảo máy tính của bạn đáp ứng các yêu cầu sau:

- **Java JDK**: phiên bản 21 trở lên
- **Node.js**: phiên bản 18 trở lên
- **MySQL**: phiên bản 8.0 trở lên
- **Maven**: phiên bản 3.9 trở lên
- **Git**: phiên bản mới nhất

---

## 1. Cài Đặt Backend

### Bước 1: Clone Repository

```bash
git clone https://github.com/grevo-team/grevo-be-material.git
cd grevo-be-material
```

### Bước 2: Cấu Hình Database

1. Tạo database MySQL:
```sql
CREATE DATABASE grevo_db;
```

2. Cấu hình file `src/main/resources/application.properties` (hoặc `.env`):

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/grevo_db
spring.datasource.username=root
spring.datasource.password=your_password

# JWT Secret Key (tạo chuỗi random dài)
application.security.jwt.secret-key=your_very_long_secret_key_here_at_least_256_bits
application.security.jwt.expiration=86400000

# Google OAuth2
google.client.id=your_google_client_id
```

### Bước 3: Cài Đặt Dependencies

```bash
mvn clean install
```

### Bước 4: Chạy Ứng Dụng

```bash
mvn spring-boot:run
```

Backend sẽ khởi chạy tại: `http://localhost:8080`

---

## 2. Cài Đặt Frontend

### Bước 1: Clone Repository

```bash
git clone https://github.com/grevo-team/grevo-fe-material.git
cd grevo-fe-material
```

### Bước 2: Cài Đặt Dependencies

```bash
npm install
```

### Bước 3: Cấu Hình Môi Trường

Tạo file `.env` từ `.env.example`:

```env
VITE_API_URL=http://localhost:8080/api
VITE_GOOGLE_CLIENT_ID=your_google_client_id
VITE_CLOUDINARY_CLOUD_NAME=your_cloud_name
```

### Bước 4: Chạy Ứng Dụng (Development)

```bash
npm run dev
```

Frontend sẽ khởi chạy tại: `http://localhost:5173`

---

## 3. Kiểm Tra Cài Đặt

1. Truy cập `http://localhost:5173`
2. Đăng nhập bằng tài khoản Admin mặc định (nếu có seed data) hoặc đăng ký tài khoản mới.
3. Kiểm tra kết nối API bằng cách thực hiện một thao tác (ví dụ: xem profile).

---

## Các Vấn Đề Thường Gặp

### Lỗi kết nối Database
> `java.sql.SQLNonTransientConnectionException: Could not create connection to database server.`

**Khắc phục**:
- Kiểm tra MySQL service đã chạy chưa.
- Kiểm tra username/password trong `application.properties`.
- Đảm bảo database `grevo_db` đã được tạo.

### Lỗi CORS
> `Access to XMLHttpRequest at '...' from origin '...' has been blocked by CORS policy`

**Khắc phục**:
- Kiểm tra cấu hình CORS trong Backend (`SecurityConfig.java` hoặc `WebConfig.java`).
- Đảm bảo `VITE_API_URL` trỏ đúng port Backend đang chạy.

### Lỗi Google Login
> `Error 400: invalid_request`

**Khắc phục**:
- Kiểm tra `VITE_GOOGLE_CLIENT_ID` đã đúng chưa.
- Trong Google Cloud Console, đảm bảo đã thêm `http://localhost:5173` vào "Authorized JavaScript origins".

---

## Liên Hệ Hỗ Trợ

Nếu gặp vấn đề không thể giải quyết, vui lòng liên hệ:
- **Email**: pnhat.se@gmail.com
- **Đội ngũ**: Grevo Tech Team

---

© 2026 Grevo Solutions.
