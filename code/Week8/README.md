# Week 8 — Notification và File

Đây là Flutter project độc lập cho các bài thực hành trong `../../docs/Bai08_NotificationVaFile.pdf`. Project không import hoặc phụ thuộc vào mã nguồn của Week7.

## Chạy ứng dụng

Mở terminal tại thư mục `code/Week8`, sau đó chạy:

```powershell
flutter pub get
flutter run
```

Ứng dụng yêu cầu Android để dùng đầy đủ local notification và lưu tệp. Các tệp dữ liệu được lưu trong thư mục documents riêng của ứng dụng.

## Quyền thông báo trên Android

- Android 13 trở lên: cho phép ứng dụng gửi thông báo khi hệ thống hỏi.
- Để lời nhắc chạy đúng giờ trên Android 12 trở lên, cho phép **Alarms & reminders** trong phần cài đặt của ứng dụng.

Ứng dụng vẫn báo rõ nếu quyền thông báo bị từ chối; lời nhắc không thể hiện ra ngoài cho đến khi quyền được cấp.
