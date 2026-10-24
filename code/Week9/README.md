# Week 9 - Làm việc với cơ sở dữ liệu SQLite

Sinh viên: Trần Dương Gia Bảo - 2001240039 - 15DHTH02.

Project Flutter độc lập, cùng cách tổ chức theo tuần của repo. Các bài dùng MVC: `lib/models`, `lib/controllers`, `lib/utils` và `lib/views` theo đề Bài 09.

## Chạy trên Android

Mở thư mục `Week9` trong VS Code hoặc Android Studio. Bật máy ảo Android hoặc kết nối điện thoại, sau đó chạy:

```powershell
flutter pub get
flutter run
```

Project được tạo với Flutter 3.47.7 / Dart 3.13.5, cùng phiên bản metadata của Week8. Dùng Android để chạy đầy đủ SQLite. Nhấn nút Back hoặc vuốt quay lại của Android để trở về màn hình chọn bài.

## Các bài đã làm

- Bài hướng dẫn và tại lớp 1: Task List, thêm, xóa công việc cuối danh sách; Task Details cập nhật Completed và quay lại.
- Bài tại lớp 2: tìm kiếm, thêm, cập nhật, xóa sinh viên theo giao diện mẫu.
- Bài về nhà 1: thêm, sửa, xóa khoản chi với nội dung, số tiền, ghi chú.
- Bài về nhà 2: đăng ký và đăng nhập bằng tài khoản lưu trong SQLite.

Dữ liệu nằm trong `week9.db` ở thư mục riêng của ứng dụng. Lần đầu mở ứng dụng, các danh sách và tài khoản đều trống. Logo sinh viên lấy từ tài liệu Bài 09; không cần tải ảnh qua mạng.

## Kiểm tra

```powershell
flutter analyze
flutter test
```

Các bài kiểm tra dùng SQLite FFI để kiểm tra thao tác dữ liệu và việc đọc lại sau khi đóng database.
