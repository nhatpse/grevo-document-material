# 🚛 Luồng Thu Gom Rác Thải

## Tổng Quan

Luồng thu gom mô tả quy trình từ khi doanh nghiệp phân công collector đến khi hoàn thành thu gom.

---

## Sơ Đồ Luồng Phân Công

```mermaid
sequenceDiagram
    participant E as Doanh nghiệp
    participant BE as Backend
    participant DB as Database
    participant CO as Collector
    
    E->>BE: GET /api/reports/enterprise (pending reports)
    BE->>DB: Query reports in area
    DB-->>BE: List reports
    BE-->>E: Danh sách báo cáo chờ
    
    E->>BE: GET /api/reports/{id}/eligible-collectors
    BE->>DB: Query available collectors
    DB-->>BE: List collectors
    BE-->>E: Danh sách collector phù hợp
    
    E->>BE: POST /api/reports/{id}/assign {collectorId}
    BE->>DB: Update report (assignedCollectorId, status: ASSIGNED)
    DB-->>BE: Updated
    BE-->>E: Success response
    
    Note over CO: Collector nhận thông báo nhiệm vụ mới
```

---

## Sơ Đồ Luồng Thu Gom

```mermaid
sequenceDiagram
    participant CO as Collector
    participant FE as Frontend
    participant BE as Backend
    participant DB as Database
    participant CL as Cloudinary
    participant C as Công dân
    
    CO->>FE: Xem chi tiết nhiệm vụ
    FE->>BE: GET /api/collector/tasks/{reportId}
    BE->>DB: Query report details
    DB-->>BE: Report data
    BE-->>FE: Task details
    FE-->>CO: Hiển thị thông tin báo cáo
    
    CO->>FE: Chấp nhận nhiệm vụ
    FE->>BE: POST /api/collector/tasks/{id}/accept
    BE->>DB: Update status = ON_THE_WAY
    DB-->>BE: Updated
    BE-->>FE: Success
    FE-->>CO: "Bạn đang trên đường"
    
    Note over CO: Collector di chuyển đến địa điểm
    
    CO->>FE: Chụp ảnh xác nhận thu gom
    CO->>FE: Đánh giá chất lượng rác
    CO->>FE: Nhấn "Hoàn thành"
    
    FE->>BE: POST /api/collector/tasks/{id}/complete
    BE->>CL: Upload ảnh xác nhận
    CL-->>BE: Image URLs
    BE->>DB: Update status = COLLECTED
    BE->>DB: Save collector images
    BE->>DB: Calculate & award points to citizen
    DB-->>BE: Completed
    BE-->>FE: Success + points awarded
    FE-->>CO: "Thu gom hoàn tất"
    
    Note over C: Công dân nhận thông báo + điểm thưởng
```

---

## Chi Tiết Các Bước

### Bước 1: Doanh Nghiệp Phân Công

**Actor**: Doanh nghiệp (ENTERPRISE)

**Hành động:**
1. Xem danh sách báo cáo `PENDING` trong khu vực
2. Xem chi tiết báo cáo (vị trí, loại rác, hình ảnh)
3. Lấy danh sách collector phù hợp
4. Chọn và phân công collector

**Tiêu chí chọn collector:**
- Đang online (`isOnline = true`)
- Trạng thái sẵn sàng (`currentStatus = AVAILABLE`)
- Thuộc cùng doanh nghiệp
- Phương tiện phù hợp với khối lượng

---

### Bước 2: Collector Nhận Nhiệm Vụ

**Actor**: Collector

**Trạng thái báo cáo**: `ASSIGNED`

**Lựa chọn của collector:**

| Hành động | API | Kết quả |
|-----------|-----|---------|
| Chấp nhận | POST .../accept | Status → ON_THE_WAY |
| Từ chối | POST .../reject | Status → PENDING, collector = null |

---

### Bước 3: Collector Di Chuyển

**Trạng thái báo cáo**: `ON_THE_WAY`

- Collector có thể xem địa chỉ, bản đồ
- Liên hệ công dân qua số điện thoại
- Có thể hủy nếu không thể hoàn thành

---

### Bước 4: Hoàn Thành Thu Gom

**Actor**: Collector

**Dữ liệu đầu vào:**
| Trường | Bắt buộc | Mô tả |
|--------|----------|-------|
| images | ❌ | Ảnh xác nhận thu gom |
| rating | ✅ | Đánh giá chất lượng rác (1-5) |
| wasteSortedCorrectly | ✅ | Rác được phân loại đúng không |
| citizenCooperative | ✅ | Công dân hợp tác không |
| notes | ❌ | Ghi chú |

**Xử lý Server:**
1. Upload ảnh collector lên Cloudinary
2. Lưu ảnh với sourceType = `COLLECTOR`
3. Tính quality score từ survey
4. Cập nhật status = `COLLECTED`
5. Tính điểm thưởng cho công dân
6. Tạo PointTransaction

---

## Công Thức Tính Điểm

```
Điểm = (Khối lượng × Điểm cơ bản) × Hệ số chất lượng + Bonus

Trong đó:
- Điểm cơ bản: 10 điểm/kg (có thể cấu hình)
- Hệ số chất lượng: 1.0 - 3.0 (dựa trên quality score)
- Bonus: Điểm thưởng nếu đạt khối lượng tối thiểu
```

**Ví dụ:**
- Khối lượng: 5kg
- Điểm cơ bản: 10
- Quality score: 4/5 → Hệ số: 1.5
- Bonus (>= 5kg): 20 điểm

```
Điểm = (5 × 10) × 1.5 + 20 = 75 + 20 = 95 điểm
```

---

## Các Trường Hợp Đặc Biệt

### Collector Từ Chối

```mermaid
sequenceDiagram
    participant CO as Collector
    participant BE as Backend
    participant E as Enterprise
    
    CO->>BE: POST /tasks/{id}/reject
    BE->>BE: Update status = PENDING
    BE->>BE: Clear assignedCollector
    BE-->>CO: Success
    
    Note over E: Báo cáo quay lại hàng đợi,<br/>cần phân công lại
```

### Collector Hủy Giữa Chừng

```mermaid
sequenceDiagram
    participant CO as Collector
    participant BE as Backend
    
    CO->>BE: POST /tasks/{id}/cancel
    BE->>BE: Update status = CANCELLED
    BE-->>CO: Success
    
    Note over CO: Báo cáo bị hủy,<br/>có thể ảnh hưởng đánh giá collector
```

---

## Timeline Mẫu

```
09:00 - Công dân tạo báo cáo → PENDING
09:15 - Doanh nghiệp phân công → ASSIGNED
09:20 - Collector chấp nhận → ON_THE_WAY
09:45 - Collector đến nơi
09:50 - Thu gom xong, chụp ảnh
09:52 - Hoàn thành → COLLECTED
09:52 - Công dân nhận 95 điểm
```

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
