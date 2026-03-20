# Công Nghệ Sử Dụng

## Backend

### Framework & Runtime

| Công nghệ | Phiên bản | Mục đích |
|-----------|-----------|----------|
| **Java** | 21 (LTS) | Ngôn ngữ lập trình chính |
| **Spring Boot** | 3.3.0 | Framework phát triển backend |
| **Spring Security** | - | Bảo mật, xác thực |
| **Spring Data JPA** | - | ORM, tương tác database |
| **Spring Validation** | - | Validate dữ liệu đầu vào |

### Database

| Công nghệ | Mục đích |
|-----------|----------|
| **MySQL** | Database production |
| **H2 Database** | Database development/testing |

### Authentication & Authorization

| Công nghệ | Phiên bản | Mục đích |
|-----------|-----------|----------|
| **JWT (jjwt)** | 0.12.5 | Token-based authentication |
| **Google OAuth 2.0** | - | Đăng nhập bằng Google |
| **Spring Security OAuth2 Client** | - | OAuth2 integration |

### Utilities

| Công nghệ | Phiên bản | Mục đích |
|-----------|-----------|----------|
| **Lombok** | - | Giảm boilerplate code |
| **SpringDoc OpenAPI** | 2.5.0 | Swagger API documentation |
| **Cloudinary** | 1.36.0 | Lưu trữ hình ảnh cloud |

### Build & Development

| Công nghệ | Mục đích |
|-----------|----------|
| **Maven** | Build tool, dependency management |
| **Spring Boot DevTools** | Hot reload trong development |

---

## Frontend

### Framework & Runtime

| Công nghệ | Phiên bản | Mục đích |
|-----------|-----------|----------|
| **React** | 18.2.0 | UI library chính |
| **Vite** | 5.0.8 | Build tool, dev server |
| **React Router DOM** | 6.30.3 | Client-side routing |

### UI & Styling

| Công nghệ | Phiên bản | Mục đích |
|-----------|-----------|----------|
| **TailwindCSS** | 3.4.0 | CSS framework |
| **PostCSS** | 8.4.32 | CSS processor |
| **Autoprefixer** | 10.4.16 | CSS vendor prefixes |

### Animation & UX

| Công nghệ | Phiên bản | Mục đích |
|-----------|-----------|----------|
| **Framer Motion** | 12.26.2 | Animation library |
| **Lenis** | 1.3.17 | Smooth scrolling |

### External Services

| Công nghệ | Phiên bản | Mục đích |
|-----------|-----------|----------|
| **@react-oauth/google** | 0.13.4 | Google OAuth integration |
| **Axios** | 1.13.2 | HTTP client |
| **MapLibre GL** | 5.16.0 | Map display (GPS location) |

---

## Infrastructure & Deployment

### Containerization

| Công nghệ | Mục đích |
|-----------|----------|
| **Docker** | Container hóa ứng dụng |
| **Nginx** | Web server cho frontend |

### CI/CD

| Công nghệ | Mục đích |
|-----------|----------|
| **Jenkins** | CI/CD pipeline |

### Hosting

| Platform | Mục đích |
|----------|----------|
| **Vercel** | Frontend hosting (option) |
| **Cloud Server** | Backend hosting |

---

## Cấu Trúc Dependencies

### Backend (pom.xml)

```xml
<dependencies>
    <!-- Spring Boot Starters -->
    <dependency>spring-boot-starter-web</dependency>
    <dependency>spring-boot-starter-security</dependency>
    <dependency>spring-boot-starter-data-jpa</dependency>
    <dependency>spring-boot-starter-validation</dependency>
    
    <!-- Database -->
    <dependency>h2 (runtime)</dependency>
    <dependency>mysql-connector-j (runtime)</dependency>
    
    <!-- JWT -->
    <dependency>jjwt-api (0.12.5)</dependency>
    <dependency>jjwt-impl (0.12.5)</dependency>
    <dependency>jjwt-jackson (0.12.5)</dependency>
    
    <!-- Google OAuth -->
    <dependency>google-api-client (2.2.0)</dependency>
    <dependency>google-auth-library-oauth2-http (1.19.0)</dependency>
    
    <!-- Utilities -->
    <dependency>lombok</dependency>
    <dependency>springdoc-openapi-starter-webmvc-ui (2.5.0)</dependency>
    <dependency>cloudinary-http44 (1.36.0)</dependency>
</dependencies>
```

### Frontend (package.json)

```json
{
  "dependencies": {
    "@react-oauth/google": "^0.13.4",
    "axios": "^1.13.2",
    "framer-motion": "^12.26.2",
    "lenis": "^1.3.17",
    "maplibre-gl": "^5.16.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.30.3"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.2.1",
    "tailwindcss": "^3.4.0",
    "vite": "^5.0.8"
  }
}
```

---

## System Requirements

### Development

| Requirement | Minimum |
|-------------|---------|
| **Java JDK** | 21+ |
| **Node.js** | 18+ |
| **npm** | 9+ |
| **Maven** | 3.9+ |
| **RAM** | 8GB |
| **Storage** | 2GB |

### Production

| Requirement | Recommend |
|-------------|-----------|
| **CPU** | 2 cores |
| **RAM** | 4GB |
| **Storage** | 20GB |
| **MySQL** | 8.0+ |

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
