# 📋 Mô Tả Bảng Dữ Liệu

## 1. USERS - Người Dùng

Bảng chứa thông tin tất cả người dùng trong hệ thống.

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| userId | INT | NO | PK, Auto increment |
| googleId | VARCHAR(255) | YES | UK, Google OAuth ID |
| username | VARCHAR(255) | NO | UK, Tên đăng nhập/Email |
| password | VARCHAR(255) | NO | Mật khẩu đã mã hóa |
| role | ENUM | NO | CITIZEN, ENTERPRISE, COLLECTOR, ADMIN |
| isActive | BOOLEAN | YES | Trạng thái hoạt động (default: true) |
| isVerified | BOOLEAN | YES | Đã xác thực email (default: false) |
| createAt | DATETIME | YES | Ngày tạo |
| updateAt | DATETIME | YES | Ngày cập nhật |
| fullName | VARCHAR(255) | YES | Họ và tên |
| email | VARCHAR(255) | YES | UK, Email |
| phone | VARCHAR(20) | YES | UK, Số điện thoại |
| address | TEXT | YES | Địa chỉ |
| rsPasswordToken | VARCHAR(255) | YES | Token reset password |
| rsPasswordTExpiry | DATETIME | YES | Hạn token reset |
| avatar | VARCHAR(500) | YES | URL avatar |

---

## 2. CITIZENS - Công Dân

Bảng mở rộng thông tin cho user có role CITIZEN.

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| citizenId | INT | NO | PK, Auto increment |
| userId | INT | NO | FK → users.userId |
| totalPoints | INT | YES | Tổng điểm tích lũy (default: 0) |

---

## 3. COLLECTORS - Nhân Viên Thu Gom

Bảng mở rộng thông tin cho user có role COLLECTOR.

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| collectorId | INT | NO | PK, Auto increment |
| userId | INT | NO | FK → users.userId |
| enterpriseId | INT | YES | FK → enterprise.enterpriseId |
| vehicleType | VARCHAR(100) | YES | Loại phương tiện |
| vehiclePlate | VARCHAR(20) | YES | Biển số xe |
| maxCapacity | INT | YES | Tải trọng tối đa (kg) |
| currentStatus | VARCHAR(50) | YES | Trạng thái hiện tại |
| leaveReason | TEXT | YES | Lý do nghỉ phép |
| lastActiveAt | DATETIME | YES | Hoạt động lần cuối |
| isOnline | BOOLEAN | YES | Đang online (default: false) |

**Các giá trị currentStatus:**
- `AVAILABLE` - Sẵn sàng nhận việc
- `BUSY` - Đang thực hiện nhiệm vụ
- `PENDING` - Chờ duyệt gia nhập doanh nghiệp
- `PENDING_LEAVE` - Chờ duyệt nghỉ phép
- `ON_LEAVE` - Đang nghỉ phép
- `INACTIVE` - Không hoạt động

---

## 4. ENTERPRISE - Doanh Nghiệp

Bảng mở rộng thông tin cho user có role ENTERPRISE.

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| enterpriseId | INT | NO | PK, Auto increment |
| userId | INT | NO | FK → users.userId |
| companyName | VARCHAR(255) | YES | Tên công ty |
| companyPhone | VARCHAR(20) | YES | Số điện thoại công ty |
| companyEmail | VARCHAR(255) | YES | Email công ty |
| companyAdr | TEXT | YES | Địa chỉ công ty |
| taxCode | VARCHAR(50) | YES | Mã số thuế |
| capacity | INT | YES | Năng lực thu gom |
| isActive | BOOLEAN | YES | Trạng thái (default: true) |

---

## 5. SERVICE_AREAS - Khu Vực Dịch Vụ

Bảng quản lý các khu vực được phục vụ.

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| areaId | INT | NO | PK, Auto increment |
| areaName | VARCHAR(255) | NO | Tên khu vực |
| city | VARCHAR(100) | YES | Thành phố |
| district | VARCHAR(100) | YES | Quận/Huyện |
| ward | VARCHAR(100) | YES | Phường/Xã |
| latitude | VARCHAR(50) | YES | Vĩ độ tâm |
| longitude | VARCHAR(50) | YES | Kinh độ tâm |
| radius | DOUBLE | YES | Bán kính phục vụ (km) |
| isActive | BOOLEAN | YES | Trạng thái |

---

## 6. ENTERPRISE_AREAS - Phân Công Khu Vực

Bảng liên kết doanh nghiệp với khu vực phụ trách.

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| id | INT | NO | PK, Auto increment |
| enterpriseId | INT | NO | FK → enterprise.enterpriseId |
| areaId | INT | NO | FK → service_areas.areaId |
| assignedAt | DATETIME | YES | Ngày phân công |

---

## 7. WASTE_REPORTS - Báo Cáo Rác Thải

Bảng chứa thông tin các báo cáo rác thải.

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| reportId | INT | NO | PK, Auto increment |
| citizenId | INT | NO | FK → citizens.citizenId |
| title | VARCHAR(255) | YES | Tiêu đề báo cáo |
| description | TEXT | YES | Mô tả chi tiết |
| latitude | VARCHAR(50) | YES | Vĩ độ vị trí |
| longitude | VARCHAR(50) | YES | Kinh độ vị trí |
| status | VARCHAR(50) | YES | Trạng thái báo cáo |
| qualityScore | INT | YES | Điểm chất lượng (1-5) |
| createdAt | DATETIME | YES | Ngày tạo |
| wasteType | VARCHAR(50) | YES | Loại rác |
| areaId | INT | YES | FK → service_areas.areaId |
| wasteQuantity | DOUBLE | YES | Khối lượng (kg) |
| itemWeights | TEXT | YES | JSON chi tiết từng loại |
| assignedCollectorId | INT | YES | FK → collectors.collectorId |
| assignedAt | DATETIME | YES | Ngày phân công |

**Các giá trị status:**
- `PENDING` - Chờ xử lý
- `ASSIGNED` - Đã phân công
- `ON_THE_WAY` - Đang trên đường
- `COLLECTED` - Đã thu gom
- `CANCELLED` - Đã hủy

**Các giá trị wasteType:**
- `ORGANIC` - Rác hữu cơ
- `RECYCLABLE` - Rác tái chế
- `HAZARDOUS` - Rác nguy hại
- `GENERAL` - Rác thông thường

---

## 8. WASTE_REPORT_IMAGES - Hình Ảnh Báo Cáo

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| imageId | INT | NO | PK, Auto increment |
| reportId | INT | NO | FK → waste_reports.reportId |
| imageUrl | VARCHAR(500) | NO | URL hình ảnh |
| sourceType | VARCHAR(20) | YES | CITIZEN hoặc COLLECTOR |
| createdAt | DATETIME | YES | Ngày tạo |

---

## 9. WASTE_TYPES - Loại Rác

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| wasteTypeId | INT | NO | PK, Auto increment |
| typeName | VARCHAR(100) | NO | Tên loại rác |
| description | TEXT | YES | Mô tả |

---

## 10. VOUCHERS - Voucher

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| voucherId | INT | NO | PK, Auto increment |
| enterpriseId | INT | NO | FK → enterprise.enterpriseId |
| title | VARCHAR(255) | NO | Tiêu đề voucher |
| description | TEXT | YES | Mô tả |
| pointsCost | INT | NO | Điểm cần để đổi |
| quantity | INT | YES | Số lượng (null = không giới hạn) |
| redeemedCount | INT | YES | Số đã đổi (default: 0) |
| validFrom | DATETIME | YES | Hiệu lực từ |
| validUntil | DATETIME | YES | Hiệu lực đến |
| isActive | BOOLEAN | YES | Trạng thái (default: true) |
| imageUrl | VARCHAR(500) | YES | Hình ảnh voucher |
| createdAt | DATETIME | YES | Ngày tạo |

---

## 11. VOUCHER_REDEMPTIONS - Lịch Sử Đổi Voucher

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| redemptionId | INT | NO | PK, Auto increment |
| voucherId | INT | NO | FK → vouchers.voucherId |
| citizenId | INT | NO | FK → citizens.citizenId |
| pointsSpent | INT | NO | Điểm đã tiêu |
| redemptionCode | VARCHAR(20) | NO | UK, Mã đổi thưởng |
| status | VARCHAR(20) | YES | ACTIVE/USED/EXPIRED |
| redeemedAt | DATETIME | YES | Ngày đổi |
| usedAt | DATETIME | YES | Ngày sử dụng |

---

## 12. POINT_TRANSACTIONS - Giao Dịch Điểm

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| transactionId | INT | NO | PK, Auto increment |
| citizenId | INT | NO | FK → citizens.citizenId |
| reportId | INT | YES | FK → waste_reports.reportId |
| pointsAwarded | INT | NO | Số điểm (có thể âm) |
| reason | TEXT | YES | Lý do |
| createdAt | DATETIME | YES | Ngày giao dịch |

---

## 13. POINT_RULES - Quy Tắc Tính Điểm

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| ruleId | INT | NO | PK, Auto increment |
| wasteTypeId | INT | YES | FK → waste_types.wasteTypeId |
| enterpriseId | INT | YES | FK → enterprise.enterpriseId |
| ruleName | VARCHAR(255) | NO | Tên quy tắc |
| description | TEXT | YES | Mô tả |
| basePointsPerKg | DOUBLE | NO | Điểm cơ bản/kg (default: 10) |
| qualityBonusMultiplier | DOUBLE | NO | Hệ số chất lượng (default: 1.0) |
| minQuantityForBonus | DOUBLE | YES | Khối lượng tối thiểu để bonus |
| quantityBonus | INT | YES | Điểm bonus (default: 0) |
| isActive | BOOLEAN | NO | Trạng thái (default: true) |
| priority | INT | YES | Độ ưu tiên (default: 0) |
| createdAt | DATETIME | YES | Ngày tạo |
| updatedAt | DATETIME | YES | Ngày cập nhật |

---

## 14. FEEDBACK - Đánh Giá

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| feedbackId | INT | NO | PK, Auto increment |
| reportId | INT | NO | FK → waste_reports.reportId |
| fromCitizenId | INT | YES | FK → citizens.citizenId |
| toCitizenId | INT | YES | FK → citizens.citizenId |
| fromCollectorId | INT | YES | FK → collectors.collectorId |
| toCollectorId | INT | YES | FK → collectors.collectorId |
| starRating | INT | NO | Số sao (1-5) |
| description | TEXT | YES | Nhận xét |
| createdAt | DATETIME | YES | Ngày đánh giá |

---

## 15. FEEDBACK_IMAGES - Hình Ảnh Đánh Giá

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| imageId | INT | NO | PK, Auto increment |
| feedbackId | INT | NO | FK → feedback.feedbackId |
| imageUrl | VARCHAR(500) | NO | URL hình ảnh |
| createdAt | DATETIME | YES | Ngày tạo |

---

## 16. COLLECTOR_REQUEST - Yêu Cầu Collector

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| requestId | INT | NO | PK, Auto increment |
| collectorId | INT | NO | FK → collectors.collectorId |
| enterpriseId | INT | NO | FK → enterprise.enterpriseId |
| requestType | ENUM | NO | JOIN, LEAVE |
| status | ENUM | NO | PENDING, APPROVED, REJECTED |
| message | TEXT | YES | Tin nhắn |
| createdAt | DATETIME | YES | Ngày tạo |
| processedAt | DATETIME | YES | Ngày xử lý |

---

## 17. SYSTEM_LOG - Nhật Ký Hệ Thống

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| logId | INT | NO | PK, Auto increment |
| action | VARCHAR(100) | NO | Hành động |
| userId | INT | YES | FK → users.userId |
| ipAddress | VARCHAR(45) | YES | Địa chỉ IP |
| details | TEXT | YES | Chi tiết |
| createdAt | DATETIME | YES | Thời gian |

---

## 18. COLLECTOR_ASSIGNMENTS - Phân Công Thu Gom

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| assignmentId | INT | NO | PK, Auto increment |
| report_id | INT | NO | FK → waste_reports.reportId |
| collector_id | INT | NO | FK → collectors.collectorId |
| allocatedWeight | DOUBLE | NO | Khối lượng được giao (kg) |
| status | VARCHAR(255) | NO | Trạng thái (ASSIGNED, ON_THE_WAY, COLLECTED, CANCELLED) |
| assignedAt | DATETIME | YES | Ngày giờ phân công |
| completedAt | DATETIME | YES | Ngày giờ hoàn thành |

---

## 19. LOCATION_SESSIONS - Phiên Vị Trí

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| sessionId | VARCHAR(36) | NO | PK, ID phiên vị trí |
| latitude | DOUBLE | YES | Vĩ độ |
| longitude | DOUBLE | YES | Kinh độ |
| address | VARCHAR(500) | YES | Địa chỉ chi tiết |
| status | ENUM | NO | Trạng thái (WAITING) |
| createdAt | DATETIME | NO | Thời gian tạo |
| expiresAt | DATETIME | NO | Thời gian hết hạn |
| userId | BIGINT | YES | ID người dùng |

---

## 20. NOTIFICATION - Thông Báo

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| id | INT | NO | PK, Auto increment |
| user_id | INT | NO | FK → users.userId |
| title | VARCHAR(255) | YES | Tiêu đề thông báo |
| message | TEXT | YES | Nội dung thông báo |
| isRead | BOOLEAN | YES | Đã đọc (default: false) |
| type | VARCHAR(255) | YES | Loại thông báo |

---

## 21. REPORT_LIFECYCLE - Vòng Đời Báo Cáo

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| lifecycleId | INT | NO | PK, Auto increment |
| collector_id | INT | YES | FK → collectors.collectorId |
| report_id | INT | NO | FK → waste_reports.reportId |
| enterprise_id | INT | YES | FK → enterprise.enterpriseId |
| acceptedAt | DATETIME | YES | Thời gian collector chấp nhận |
| assignedAt | DATETIME | YES | Thời gian phân công |
| collectedAt | DATETIME | YES | Thời gian thu gom xong |

---

## 22. REWARDS - Phần Thưởng

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| rewardId | INT | NO | PK, Auto increment |
| citizen_id | INT | NO | FK → citizens.citizenId |
| report_id | INT | YES | FK → waste_reports.reportId |
| points | INT | YES | Điểm thưởng |
| createdAt | DATETIME | YES | Thời gian nhận thưởng |

---

## 23. SAVED_LOCATIONS - Vị Trí Đã Lưu

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| id | INT | NO | PK, Auto increment |
| user_id | INT | NO | FK → users.userId |
| label | VARCHAR(255) | NO | Nhãn vị trí |
| address | VARCHAR(255) | NO | Địa chỉ chi tiết |
| latitude | VARCHAR(255) | YES | Vĩ độ |
| longitude | VARCHAR(255) | YES | Kinh độ |
| createdAt | DATETIME | YES | Thời gian lưu |

---

## 24. STATUS_HISTORY - Lịch Sử Trạng Thái

| Cột | Kiểu dữ liệu | Null | Mô tả |
|-----|--------------|------|-------|
| historyId | INT | NO | PK, Auto increment |
| report_id | INT | NO | FK → waste_reports.reportId |
| oldStatus | VARCHAR(255) | YES | Trạng thái cũ |
| newStatus | VARCHAR(255) | YES | Trạng thái mới |
| changedAt | DATETIME | YES | Thời gian thay đổi |

---

## Liên Hệ

- **Email**: pnhat.se@gmail.com
- **Đơn vị phát triển**: Grevo Team

---

© 2026 Grevo Solutions. Bảo lưu mọi quyền.
