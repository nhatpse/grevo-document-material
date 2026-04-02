# GREVO — Feature-to-File Mapping

> Tài liệu này liệt kê chi tiết từng chức năng → đi qua những file nào, theo thứ tự flow thực tế.  
> Format: `Feature → Page → Component(s) → Hook(s) → Service(s) → Controller → Service Impl → Repository → Entity`

---

## 📝 Quy ước viết tắt paths

| Prefix | Full Path |
|---|---|
| `P/` | `src/pages/` |
| `C/` | `src/components/` |
| `H/` | `src/hooks/` |
| `S/` | `src/services/` |
| `CX/` | `src/context/` |
| `BE/ctrl/` | `controller/` |
| `BE/svc/` | `service/impl/` |
| `BE/repo/` | `repository/` |
| `BE/ent/` | `entity/` |

---

## 1. AUTHENTICATION

### 1.1 Login (Email/Password)

```
P/Login.jsx
   → C/layout/auth/LoginSection.jsx
      → H/auth/useLoginState.js
      → H/auth/useAuthForm.js
      → H/auth/useAuthUI.js
      → S/authService.js → POST /api/auth/login
         → BE/ctrl/AuthController.java
            → BE/svc/AuthServiceImpl.java
               → BE/repo/UserRepository.java
               → BE/ent/Users.java
   → CX/AuthContext.jsx (set token + user)
   → React Router → /dashboard
```

### 1.2 Register

```
P/Login.jsx (Register tab)
   → C/layout/auth/RegisterSection.jsx
      → H/auth/useRegisterState.js
      → H/auth/useAuthForm.js
      → H/auth/useLoginRegister.js (tab toggle)
      → H/useAddressAutocomplete.js (VietMap address)
      → S/authService.js → POST /api/auth/register
         → BE/ctrl/AuthController.java
            → BE/svc/AuthServiceImpl.java
               → BE/repo/UserRepository.java
               → BE/repo/CitizensRepository.java / CollectorsRepository.java / EnterpriseRepository.java
               → JavaMailSender (send OTP)
```

### 1.3 Google Login

```
P/Login.jsx
   → H/auth/useGoogleAuth.js
      → Google OAuth SDK
      → S/authService.js → POST /api/auth/google
         → BE/ctrl/AuthController.java
            → BE/svc/AuthServiceImpl.java
```

### 1.4 Verify Account

```
P/VerifyAccount.jsx
   → S/authService.js → POST /api/auth/verify
      → BE/ctrl/AuthController.java
         → BE/svc/AuthServiceImpl.java
```

### 1.5 Forgot Password

```
P/ForgotPassword.jsx
   → H/auth/useForgotPassword.js
      → S/authService.js → POST /api/auth/forgot-password
         → BE/ctrl/AuthController.java
            → BE/svc/AuthServiceImpl.java → JavaMailSender
```

### 1.6 Reset Password

```
P/ResetPassword.jsx
   → H/auth/useResetPassword.js
      → S/authService.js → POST /api/auth/reset-password
         → BE/ctrl/AuthController.java
            → BE/svc/AuthServiceImpl.java
```

---

## 2. CITIZEN FEATURES

### 2.1 Citizen Dashboard

```
P/Dashboard.jsx
   → C/sections/dashboard/CitizenDashboard.jsx
      → C/sections/dashboard/StatsSection.jsx
         → H/citizen/useActiveCollections.js
         → S/wasteReportService.js → GET /api/reports/stats
      → C/sections/dashboard/active-request/ActiveRequestContent.jsx
         → H/citizen/useActiveCollections.js
         → S/wasteReportService.js → GET /api/reports/my-reports?status=ON_THE_WAY
         → C/common/report/MiniMap.jsx
            → H/location/useMapInstance.js
            → H/location/mapConfig.js
      → C/sections/dashboard/RecentActivitySection.jsx
         → S/wasteReportService.js → GET /api/reports/my-reports
      → C/sections/dashboard/RewardsSection.jsx
         → S/leaderboardService.js → GET /api/leaderboard
         → S/wasteReportService.js → GET /api/reports/stats
```

### 2.2 Report Waste

```
P/ReportWaste.jsx
   → H/report/useReportWastePage.js
      → H/report/useReportWaste.js
         → H/report/useReportState.js
         → H/report/useReportSubmit.js
         → H/report/useEvidenceHandlers.js
      → C/sections/report/LocationSection.jsx
         → C/common/report/MiniMap.jsx
         → H/location/useLocationSection.js
            → H/location/useAddressSearch.js
            → H/location/useAddressForm.js
            → H/location/useAddressState.js
            → H/location/useLocationFetch.js
            → S/location/geolocation.js
            → S/location/mapApi.js (VietMap)
         → H/profile/useSavedLocations.js
            → S/profile/savedLocationApi.js
      → C/sections/report/EvidenceSection.jsx
         → C/sections/report/evidence/…
      → S/wasteReportService.js → POST /api/reports (multipart/form-data)
         → BE/ctrl/WasteReportController.java
            → BE/svc/WasteReportServiceImpl.java
               → BE/repo/WasteReportsRepository.java
               → BE/repo/WasteReportImageRepository.java
               → Cloudinary upload
               → BE/ent/WasteReports.java
               → BE/ent/WasteReportImage.java
```

### 2.3 Citizen History

```
P/CitizenHistory.jsx
   → H/citizen/useCitizenHistoryPage.js
      → H/citizen/useCitizenHistory.js
         → H/citizen/useHistoryState.js
         → H/citizen/useHistoryFetch.js
      → C/sections/citizen/CitizenStatsOverview.jsx
      → C/sections/citizen/CitizenReportFilter.jsx
      → C/sections/citizen/CitizenPointsStats.jsx
      → C/sections/citizen/CitizenReportList.jsx
         → C/sections/citizen/CitizenReportCard.jsx
            → C/sections/citizen/CitizenReportDetailModal.jsx
      → S/wasteReportService.js → GET /api/reports/my-reports
         → BE/ctrl/WasteReportController.java
            → BE/svc/WasteReportServiceImpl.java
```

### 2.4 Points & Rewards

```
P/citizen/PointHistory.jsx
   → C/sections/citizen/PointHistoryTab.jsx
      → S/wasteReportService.js → GET /api/citizen/point-history
         → BE/ctrl/PointHistoryController.java
            → BE/svc/PointHistoryServiceImpl.java
               → BE/repo/PointTransactionRepository.java
   → C/sections/citizen/RewardsStoreTab.jsx
      → C/sections/citizen/RedeemModal.jsx
      → S/voucherService.js → GET /api/rewards/vouchers
      → S/voucherService.js → POST /api/rewards/redeem/{voucherId}
         → BE/ctrl/RewardsController.java
            → BE/svc/RewardsServiceImpl.java
               → BE/repo/VoucherRepository.java
               → BE/repo/VoucherRedemptionRepository.java
               → BE/ent/Voucher.java
               → BE/ent/VoucherRedemption.java
   → C/sections/citizen/MyVouchersTab.jsx
      → S/voucherService.js → GET /api/rewards/my-vouchers
   → C/sections/citizen/LeaderboardTab.jsx
      → S/leaderboardService.js → GET /api/leaderboard
         → BE/ctrl/LeaderboardController.java
            → BE/svc/LeaderboardServiceImpl.java
               → BE/repo/PointTransactionRepository.java
```

---

## 3. ENTERPRISE FEATURES

### 3.1 Enterprise Dashboard

```
P/Dashboard.jsx
   → C/sections/enterprise/EnterpriseDashboardHome.jsx
      → C/sections/enterprise/EnterpriseStatsGrid.jsx
      → C/sections/enterprise/stats/EnterpriseCollectorChart.jsx
      → C/sections/enterprise/stats/EnterpriseRevenueChart.jsx
      → C/sections/enterprise/EnterpriseRecentActivity.jsx
      → H/enterprise/useEnterpriseStats.js
         → S/enterpriseService.js → GET /api/reports/enterprise/stats
         → S/enterpriseService.js → GET /api/enterprises/me/collectors
```

### 3.2 Waste Reports Management

```
P/enterprise/WasteReports.jsx
   → H/enterprise/useWasteReportsPage.js
      → H/enterprise/useEnterpriseReports.js
      → H/enterprise/useViewReportModal.js
   → C/sections/enterprise/WasteReportsTable.jsx
   → C/sections/enterprise/ViewReportModal.jsx
      → C/sections/enterprise/report-modal/ReportHeader.jsx
      → C/sections/enterprise/report-modal/MiniMapWithRoute.jsx
         → H/location/useMapInstance.js
      → C/sections/enterprise/report-modal/ParticipantSection.jsx
      → C/sections/enterprise/report-modal/ProfileQuickView.jsx
      → C/sections/enterprise/report-modal/ReportActionPanel.jsx
         → H/enterprise/useReportActions.js
         → H/enterprise/useReportDetailData.js
   → S/wasteReportService.js
      → GET /api/reports/enterprise (list)
      → GET /api/reports/enterprise/{id} (detail)
      → GET /api/reports/enterprise/{id}/eligible-collectors
      → POST /api/reports/enterprise/{id}/multi-assign
      → PUT /api/reports/enterprise/{id}/status
         → BE/ctrl/WasteReportController.java
            → BE/svc/WasteReportServiceImpl.java
               → BE/repo/WasteReportsRepository.java
               → BE/repo/CollectorAssignmentRepository.java
               → BE/repo/CollectorsRepository.java
               → BE/ent/CollectorAssignment.java
```

### 3.3 Collector Management

```
P/enterprise/CollectorManagement.jsx
   → H/enterprise/useCollectorManagementPage.js
      → H/enterprise/useCollectorManagement.js
         → H/enterprise/useCollectorState.js
         → H/enterprise/useCollectorData.js
         → H/enterprise/useCollectorActions.js
   → C/sections/enterprise/CollectorStats.jsx
   → C/sections/enterprise/CollectorList.jsx
   → C/sections/enterprise/InviteCollectorModal.jsx
   → C/sections/enterprise/ViewCollectorModal.jsx
      → C/sections/enterprise/collector-modal/CollectorModalHeader.jsx
      → C/sections/enterprise/collector-modal/CollectorModalInfo.jsx
   → C/sections/enterprise/PendingRequestsList.jsx
   → C/sections/enterprise/LeaveRequestsList.jsx
   → S/enterpriseService.js
      → GET /api/enterprises/me/collectors
      → POST /api/enterprises/me/collectors/invite
      → POST /api/enterprises/me/collectors/{id}/accept
      → POST /api/enterprises/me/collectors/{id}/reject
      → DELETE /api/enterprises/me/collectors/{id}
         → BE/ctrl/EnterpriseCollectorController.java
            → BE/svc/EnterpriseCollectorServiceImpl.java
               → BE/repo/CollectorRequestRepository.java
               → BE/repo/CollectorsRepository.java
               → BE/ent/CollectorRequest.java
```

### 3.4 Rewards Management

```
P/enterprise/RewardsManagement.jsx
   → C/sections/rewards/RewardsStats.jsx
   → C/sections/rewards/VoucherContent.jsx
      → H/rewards/useVoucherManager.js
      → S/voucherService.js → CRUD /api/enterprise/vouchers
         → BE/ctrl/VoucherController.java
            → BE/svc/VoucherServiceImpl.java
               → BE/repo/VoucherRepository.java
               → BE/ent/Voucher.java
   → C/sections/rewards/PointRulesContent.jsx
      → H/rewards/usePointRulesManager.js
      → S/pointRulesService.js → CRUD /api/enterprise/point-rules
         → BE/ctrl/PointRulesController.java
            → BE/svc/PointRulesServiceImpl.java
               → BE/repo/PointRulesRepository.java
               → BE/ent/PointRules.java
   → C/sections/rewards/LeaderboardContent.jsx
      → S/leaderboardService.js → GET /api/leaderboard
```

### 3.5 Enterprise Leaderboard

```
P/enterprise/EnterpriseLeaderboard.jsx
   → C/sections/rewards/LeaderboardContent.jsx
      → S/leaderboardService.js → GET /api/leaderboard
```

### 3.6 Operating Scope

```
(Inside Dashboard + Profile)
   → C/sections/enterprise/OperatingScopeSection.jsx
      → H/enterprise/useOperatingScope.js
         → H/enterprise/useOperatingScopeData.js
         → H/enterprise/useOperatingScopeActions.js
      → S/enterpriseService.js
         → GET /api/enterprises/me/scope/areas
         → POST /api/enterprises/me/scope/request-area
            → BE/ctrl/EnterpriseScopeController.java
               → BE/svc/EnterpriseScopeServiceImpl.java
```

---

## 4. COLLECTOR FEATURES

### 4.1 Collector Dashboard

```
P/Dashboard.jsx
   → C/sections/collector/CollectorDashboardHome.jsx
      → C/sections/collector/CollectorStatsSection.jsx
      → C/sections/collector/CollectorStatusCard.jsx
      → C/sections/collector/CollectorIdentity.jsx
      → C/sections/collector/MyTasksCard.jsx
      → C/sections/collector/CollectorActiveTask.jsx
         → C/common/report/MiniMap.jsx
      → C/sections/collector/CollectorRecentCollections.jsx
      → H/collector/useCollectorProfileData.js
         → S/collectorService.js → GET /api/collector/profile
            → BE/ctrl/CollectorProfileController.java
               → BE/svc/CollectorProfileServiceImpl.java
      → H/collector/useCollectorTasks.js
         → S/collectorTaskService.js → GET /api/collector/tasks
```

### 4.2 My Tasks

```
P/collector/CollectorTasks.jsx
   → H/collector/useCollectorTasksLogic.js
      → H/collector/useCollectorTasks.js
   → C/sections/collector/CollectorTaskCard.jsx
   → C/sections/collector/TaskDetailContent.jsx
   → S/collectorTaskService.js
      → GET /api/collector/tasks (list by status)
      → GET /api/collector/tasks/{id} (detail)
      → POST /api/collector/tasks/{id}/accept
      → POST /api/collector/tasks/{id}/reject
         → BE/ctrl/CollectorTaskController.java
            → BE/svc/CollectorTaskServiceImpl.java
               → BE/repo/CollectorAssignmentRepository.java
               → BE/repo/WasteReportsRepository.java
               → BE/ent/CollectorAssignment.java
               → BE/ent/WasteReports.java
```

### 4.3 Route Map & Navigation

```
P/collector/CollectorRouteMap.jsx
   → P/collector/route-map/useRouteMap.js
      → S/collectorTaskService.js → GET /api/collector/tasks?status=ON_THE_WAY
      → S/location/mapApi.js → GraphHopper route API
      → H/location/useMapInstance.js
      → H/location/mapConfig.js
   → P/collector/route-map/AddressInput.jsx
      → H/useAddressAutocomplete.js → VietMap autocomplete
   → P/collector/route-map/TaskSelector.jsx
   → P/collector/route-map/DirectionsPanel.jsx
      → P/collector/route-map/constants.js
      → S/collectorTaskService.js → POST /api/collector/tasks/{id}/reject
```

### 4.4 Complete Task

```
(From Route Map)
   → C/sections/collector/CompleteTaskModal.jsx
      → S/collectorTaskService.js → POST /api/collector/tasks/{id}/complete (multipart)
         → BE/ctrl/CollectorTaskController.java
            → BE/svc/CollectorTaskServiceImpl.java
               → evaluateAndFinalizeReport() → evaluateReportTerminalState()
               → updateLegacyAssignedCollector()
               → BE/svc/PointRulesServiceImpl.java → calculateAndAwardPoints()
               → Cloudinary upload (proof image)
               → BE/repo/FeedbackRepository.java
               → BE/repo/CollectorAssignmentRepository.java
               → BE/repo/WasteReportsRepository.java
               → BE/repo/PointTransactionRepository.java
               → BE/ent/Feedback.java
               → BE/ent/PointTransaction.java
```

### 4.5 My Enterprise

```
P/collector/MyEnterprise.jsx
   → H/collector/useMyEnterprisePage.js
      → H/collector/useMyEnterprise.js
      → H/collector/useEnterpriseStatus.js
      → H/collector/useEnterpriseSearch.js
      → H/collector/useEnterpriseActions.js
   → C/sections/collector/EnterpriseInfoCard.jsx
   → C/sections/collector/EnterpriseDetailModal.jsx
   → C/sections/collector/SearchEnterpriseSection.jsx
   → C/sections/collector/JoinEnterpriseModal.jsx
   → C/sections/collector/LeaveRequestModal.jsx
   → C/sections/collector/CancelRequestModal.jsx
   → C/sections/collector/PendingRequestCard.jsx
   → C/sections/collector/InvitationCard.jsx
   → S/collectorService.js
      → GET /api/collector/enterprise
      → POST /api/collector/enterprise/join
      → POST /api/collector/enterprise/leave
      → DELETE /api/collector/enterprise/cancel-request
      → S/enterpriseService.js → GET /api/enterprises/search
         → BE/ctrl/CollectorEnterpriseController.java
            → BE/svc/CollectorEnterpriseServiceImpl.java
               → BE/repo/CollectorRequestRepository.java
               → BE/repo/EnterpriseRepository.java
               → BE/ent/CollectorRequest.java
```

### 4.6 Collector Info

```
P/collector/CollectorInfo.jsx
   → C/sections/collector/CollectorInfoForm.jsx
      → H/collector/useCollectorForm.js
         → H/collector/useCollectorInfo.js
      → S/collectorService.js → PUT /api/collector/profile
         → BE/ctrl/CollectorProfileController.java
            → BE/svc/CollectorProfileServiceImpl.java
               → BE/repo/CollectorsRepository.java
```

---

## 5. ADMIN FEATURES

### 5.1 Admin Dashboard

```
P/Dashboard.jsx
   → C/sections/admin/AdminDashboardHome.jsx
      → C/sections/admin/AdminStatsSection.jsx
      → C/sections/admin/AdminRoleDistribution.jsx
      → C/sections/admin/AdminAreasMap.jsx
         → H/location/useMapInstance.js
      → C/sections/admin/AdminRecentLogs.jsx
   → S/adminService.js
      → GET /api/admin/users (stats)
      → GET /api/admin/areas
      → GET /api/admin/logs
```

### 5.2 User Management

```
P/admin/UserManagement.jsx
   → H/admin/users/useUserManagement.js
      → H/admin/users/useUserFetch.js
      → H/admin/users/useUserFilters.js
      → H/admin/users/useUserActions.js
   → C/sections/admin/user-management/…
   → C/sections/admin/EditUserModal.jsx
      → H/admin/useEditUserModal.js
   → H/useBulkSelection.js
   → H/useDebouncedSearch.js
   → S/adminService.js
      → GET /api/admin/users
      → PUT /api/admin/users/{id}/status
      → POST /api/admin/users/bulk-delete
         → BE/ctrl/AdminUserController.java
            → BE/svc/AdminUserServiceImpl.java
               → BE/repo/UserRepository.java
```

### 5.3 System Areas

```
P/admin/SystemAreas.jsx
   → H/admin/useSystemAreas.js
   → C/sections/admin/AdminAreasMap.jsx
      → H/location/useMapInstance.js
   → S/systemAreaService.js
      → GET /api/admin/areas
      → POST /api/admin/areas
      → DELETE /api/admin/areas/{id}
         → BE/ctrl/AdminServiceAreaController.java
            → BE/svc/AdminServiceAreaServiceImpl.java
               → BE/repo/ServiceAreasRepository.java
               → BE/ent/ServiceAreas.java
```

### 5.4 Enterprise Control

```
P/admin/EnterpriseControl.jsx
   → H/admin/useEnterpriseControl.js
   → H/admin/useEditEnterpriseModal.js
   → S/adminService.js
      → GET /api/admin/enterprises
      → PUT /api/admin/enterprises/{id}/status
      → POST /api/admin/enterprises/bulk-delete
      → POST /api/admin/enterprises/{id}/areas (assign area)
      → DELETE /api/admin/enterprises/{id}/areas/{areaId}
      → GET /api/admin/enterprises/{id}/areas
         → BE/ctrl/AdminEnterpriseController.java
         → BE/ctrl/AdminEnterpriseAreaController.java
            → BE/svc/AdminEnterpriseServiceImpl.java
               → BE/repo/EnterpriseRepository.java
               → BE/repo/EnterpriseAreaRepository.java
               → BE/ent/Enterprise.java
               → BE/ent/EnterpriseArea.java
```

### 5.5 System Logs

```
P/admin/SystemLogs.jsx
   → H/admin/useSystemLogs.js
   → C/sections/admin/SystemLogsTable.jsx
   → H/useAutoRefresh.js
   → S/adminService.js → GET /api/admin/logs
      → BE/ctrl/SystemLogController.java
         → BE/svc/SystemLogServiceImpl.java
            → BE/repo/SystemLogRepository.java
            → BE/ent/SystemLog.java
```

### 5.6 System Feedbacks

```
P/admin/SystemFeedbacks.jsx
   → C/sections/admin/SystemFeedbacksTable.jsx
   → C/sections/admin/SystemFeedbackModal.jsx
   → S/adminService.js
      → GET /api/admin/system-feedbacks
      → PUT /api/admin/system-feedbacks/{id}/status
      → POST /api/admin/system-feedbacks/{id}/respond
      → DELETE /api/admin/system-feedbacks/bulk
         → BE/ctrl/SystemFeedbackController.java
            → BE/svc/SystemFeedbackServiceImpl.java
               → BE/repo/SystemFeedbackRepository.java
               → BE/ent/SystemFeedback.java
```

---

## 6. SHARED FEATURES (All Roles)

### 6.1 Profile

```
P/Profile.jsx
   → C/sections/profile/ProfileSidebar.jsx
      → C/sections/profile/sidebar/…
      → H/profile/useProfileHeader.js
      → H/profile/useProfileCompletion.js
      → H/profile/useAvatarUpload.js
   → C/sections/profile/EditProfileModal.jsx
      → H/profile/useEditProfileForm.js
      → H/useAddressAutocomplete.js
   → C/sections/profile/SavedLocationsSection.jsx
      → H/profile/useSavedLocations.js
         → S/profile/savedLocationApi.js
            → CRUD /api/users/saved-locations
   → C/sections/profile/EnterpriseProfileSection.jsx (Enterprise only)
      → H/enterprise/useEnterpriseProfile.js
         → H/enterprise/useEnterpriseProfileData.js
         → H/enterprise/useEnterpriseProfileForm.js
      → S/enterpriseService.js → PUT /api/enterprises/me/profile
   → C/sections/profile/CollectorEnterpriseSection.jsx (Collector only)
   → C/sections/profile/CollectorVehicleSection.jsx (Collector only)
   → S/profile/profileApi.js
      → GET /api/users/profile
      → PUT /api/users/profile
      → POST /api/users/avatar
      → DELETE /api/users/avatar
         → BE/ctrl/UserController.java
            → BE/svc/UserServiceImpl.java
```

### 6.2 Settings

```
P/Settings.jsx
   → C/sections/profile/SecuritySettings.jsx
      → C/sections/profile/ChangePasswordModal.jsx
         → H/profile/useChangePasswordForm.js
         → S/profile/profileApi.js
            → POST /api/users/change-password/request
            → POST /api/users/change-password/verify
   → C/sections/profile/NotificationSettings.jsx
   → C/sections/profile/DangerZone.jsx
      → C/sections/profile/DeleteAccountModal.jsx
         → H/profile/useAccountSettings.js
         → S/profile/profileApi.js → DELETE /api/users/account
```

### 6.3 System Feedback (User Side)

```
(Any dashboard)
   → C/feedback/FeedbackModal.jsx
      → C/feedback/FeedbackRating.jsx
      → C/feedback/FeedbackImageUpload.jsx
      → H/feedback/useFeedback.js
         → H/feedback/useFeedbackForm.js
         → H/feedback/useFeedbackActions.js
         → H/feedback/useFeedbackData.js
      → S/systemFeedbackService.js
         → POST /api/system-feedbacks
         → GET /api/system-feedbacks/me
            → BE/ctrl/SystemFeedbackController.java
               → BE/svc/SystemFeedbackServiceImpl.java
```

### 6.4 Citizen↔Collector Feedback (Rating)

```
(After task completion — Citizen side)
C/sections/citizen/CitizenReportDetailModal.jsx
   → C/feedback/FeedbackModal.jsx
   → S/feedbackService.js → POST /api/feedback
      → BE/ctrl/FeedbackController.java
         → BE/svc/FeedbackServiceImpl.java
            → BE/repo/FeedbackRepository.java
            → BE/ent/Feedback.java

(After task completion — Collector side)
C/sections/collector/CompleteTaskModal.jsx
   → Built-in rating in complete form
   → S/collectorTaskService.js → POST /api/collector/tasks/{id}/complete
      → BE/svc/CollectorTaskServiceImpl.java → save Feedback
```

---

## 7. LAYOUT & NAVIGATION

### 7.1 Public Layout

```
P/Home.jsx
   → C/layout/Layout.jsx
      → C/layout/Navbar.jsx
         → C/layout/navbar/…
      → C/layout/Footer.jsx
      → C/layout/PageTransition.jsx
   → C/sections/HeroSection.jsx
   → C/sections/FeaturesSection.jsx
   → C/sections/ProcessSection.jsx
   → C/sections/HowItWorksSection.jsx
   → C/sections/FaqSection.jsx
   → C/sections/CtaSection.jsx
```

### 7.2 Dashboard Layout

```
Any dashboard page
   → C/layout/DashboardLayout.jsx
      → C/layout/DashboardNavbar.jsx
      → C/layout/Sidebar.jsx
         → C/layout/sidebar/SidebarLogo.jsx
         → C/layout/sidebar/SidebarMenu.jsx
         → C/layout/sidebar/SidebarFooter.jsx
         → H/layout/useSidebar.js
   → CX/AuthContext.jsx (check auth + role)
   → CX/ToastContext.jsx (notifications)
   → CX/RefreshContext.jsx (auto-refresh)
   → CX/LanguageContext.jsx (i18n placeholder)
```

---

## 8. INFRASTRUCTURE FILES

### 8.1 API Layer

```
S/apiClient.js → Axios instance (base URL, JWT interceptor, error handling)
S/authService.js → Auth endpoints
S/wasteReportService.js → Report endpoints (citizen + enterprise)
S/collectorTaskService.js → Collector task endpoints
S/collectorService.js → Collector profile + enterprise
S/enterpriseService.js → Enterprise management
S/adminService.js → Admin endpoints
S/feedbackService.js → Citizen↔Collector feedback
S/systemFeedbackService.js → System feedback
S/voucherService.js → Voucher CRUD + redeem
S/pointRulesService.js → Point rules CRUD
S/leaderboardService.js → Leaderboard
S/systemAreaService.js → Service areas
S/location/index.js → Location services
S/location/geolocation.js → Browser GPS
S/location/mapApi.js → VietMap + GraphHopper
S/location/utils.js → Utilities
S/profile/profileApi.js → Profile CRUD
S/profile/savedLocationApi.js → Saved locations
```

### 8.2 Common Components

```
C/common/ConfirmModal.jsx → Confirm dialog
C/common/CustomAreaDropdown.jsx → Area filter dropdown
C/common/CustomSortDropdown.jsx → Sort dropdown
C/common/EmptyState.jsx → Empty state placeholder
C/common/GlassCard.jsx → Glass morphism card
C/common/InfoModal.jsx → Info dialog
C/common/LoadingSpinner.jsx → Loading indicator
C/common/ModalWrapper.jsx → Modal wrapper (portal)
C/common/Pagination.jsx → Page navigation
C/common/ScrollToTop.jsx → Auto scroll to top
C/common/StatCards.jsx → Stats card component
C/common/report/MiniMap.jsx → Map thumbnail
C/common/report/PersonCard.jsx → Person info card
```
