# 🚀 Hướng Dẫn Triển Khai (Deployment Guide)

## Tổng Quan

Tài liệu này hướng dẫn quy trình deploy hệ thống Grevo lên môi trường Production.

---

## 1. Chuẩn Bị Môi Trường Server

**Yêu cầu Server (VPS/Cloud):**
- Ubuntu 22.04 LTS (Recommended)
- RAM: 4GB+
- CPU: 2 Cores+
- Disk: 40GB+

### Cài đặt các gói cần thiết

```bash
# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Cài đặt Java 21
sudo apt install openjdk-21-jdk -y

# Cài đặt MySQL
sudo apt install mysql-server -y

# Cài đặt Nginx
sudo apt install nginx -y

# Cài đặt Docker (nếu dùng Docker)
sudo apt install docker.io -y
```

---

## 2. Deploy Backend (Spring Boot)

### Cách 1: Chạy file JAR trực tiếp

1. **Build file JAR:**
   Tại máy local:
   ```bash
   mvn clean package -DskipTests
   ```
   File `grevo-be-material-0.0.1-SNAPSHOT.jar` sẽ được tạo trong thư mục `target/`.

2. **Upload lên Server:**
   Sử dụng SCP hoặc FileZilla để upload file JAR lên server (ví dụ: `/var/www/grevo-backend/`).

3. **Tạo Systemd Service (để chạy background):**
   
   Tạo file `/etc/systemd/system/grevo-backend.service`:

   ```ini
   [Unit]
   Description=Grevo Backend Service
   After=network.target mysql.service

   [Service]
   User=root
   WorkingDirectory=/var/www/grevo-backend
   ExecStart=/usr/bin/java -jar grevo-be-material-0.0.1-SNAPSHOT.jar
   SuccessExitStatus=143
   Restart=always
   RestartSec=10

   [Install]
   WantedBy=multi-user.target
   ```

4. **Khởi động service:**

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable grevo-backend
   sudo systemctl start grevo-backend
   ```

### Cách 2: Sử Dụng Docker

1. **Tạo Dockerfile:**

   ```dockerfile
   FROM openjdk:21-jdk-slim
   COPY target/grevo-be-material-0.0.1-SNAPSHOT.jar app.jar
   ENTRYPOINT ["java","-jar","/app.jar"]
   ```

2. **Build & Run:**

   ```bash
   docker build -t grevo-backend .
   docker run -d -p 8080:8080 --name grevo-backend grevo-backend
   ```

---

## 3. Deploy Frontend (React + Vite)

1. **Build Production:**
   Tại máy local:

   ```bash
   npm run build
   ```
   Thư mục `dist/` sẽ được tạo ra.

2. **Upload lên Server:**
   Upload toàn bộ nội dung trong `dist/` lên thư mục `/var/www/grevo-frontend/`.

3. **Cấu hình Nginx:**
   
   Tạo file cấu hình `/etc/nginx/sites-available/grevo`:

   ```nginx
   server {
       listen 80;
       server_name grevo.com www.grevo.com;

       root /var/www/grevo-frontend;
       index index.html;

       # Frontend Routing (Fix 404 on refresh)
       location / {
           try_files $uri $uri/ /index.html;
       }

       # Proxy API requests to Backend
       location /api {
           proxy_pass http://localhost:8080;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

4. **Kích hoạt & Restart Nginx:**

   ```bash
   sudo ln -s /etc/nginx/sites-available/grevo /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
   ```

---

## 4. Cấu Hình Tên Miền & SSL

### Trỏ tên miền
- Cấu hình DNS A Record trỏ về IP của Server.

### Cài đặt SSL (Let's Encrypt)

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d grevo.com -d www.grevo.com
```

---

## 5. CI/CD Pipeline (Tham Khảo)

Nếu sử dụng Jenkins hoặc GitHub Actions:

**Quy trình:**
1. Push code lên GitHub.
2. CI trigger build (test, package).
3. CD SSH vào server:
   - Pull code mới/Download artifact.
   - Restart service (Backend).
   - Copy file build (Frontend).

---

## Liên Hệ

- **DevOps**: pnhat.se@gmail.com
- **Grevo Team**

---

© 2026 Grevo Solutions.
