import 'package:dart_application1/Lab6/QuanLyHoaDon.dart';
import 'package:dart_application1/Lab6/HoaDon.dart';
import 'package:dart_application1/Lab6/InputHelper.dart';
import 'package:dart_application1/Lab6/KhachHangCaNhan.dart';
import 'package:dart_application1/Lab6/DaiLyCap1.dart';
import 'package:dart_application1/Lab6/KhachHangCongTy.dart';

void main() {
  QuanLyHoaDon ql = QuanLyHoaDon();

  // Nạp sẵn dữ liệu mẫu phục vụ kiểm thử
  ql.danhSach.add(KhachHangCaNhan.fullPara('KH0001', 'Nguyễn Văn An', 2, 10000000, 8));
  ql.danhSach.add(KhachHangCaNhan.fullPara('KH0002', 'Lê Thị Bình', 3, 12000000, 15));
  ql.danhSach.add(DaiLyCap1.fullPara('KH0003', 'Đại lý Miền Nam', 5, 9000000, 6));
  ql.danhSach.add(KhachHangCongTy.fullPara('KH0004', 'Công ty FPT', 5, 11000000, 6000));
  ql.danhSach.add(KhachHangCongTy.fullPara('KH0005', 'Công ty ABC', 1, 8000000, 500));

  while (true) {
    print('\n========================================');
    print('       QUẢN LÝ HÓA ĐƠN ABC');
    print('1. Nhập danh sách hóa đơn');
    print('2. Xuất danh sách');
    print('3. Tổng thành tiền');
    print('4. Tổng trợ giá');
    print('5. Khách mua nhiều nhất');
    print('6. Tổng chiết khấu khách hàng công ty');
    print('7. Sắp xếp danh sách');
    print('8. Tìm hóa đơn theo mã khách hàng');
    print('0. Thoát');
    print('========================================');

    int chon = InputHelper.nhapInt('Nhập lựa chọn của bạn: ', min: 0);

    if (chon == 0) {
      print('Chương trình kết thúc. Tạm biệt!');
      break;
    }

    switch (chon) {
      case 1:
        ql.nhapDanhSach();
        break;
      case 2:
        ql.xuatDanhSach();
        break;
      case 3:
        print('=> Tổng thành tiền tất cả hóa đơn: ${ql.tinhTongThanhTien()} VNĐ');
        break;
      case 4:
        print('=> Tổng tiền trợ giá công ty đã hỗ trợ: ${ql.tinhTongTroGia()} VNĐ');
        break;
      case 5:
        List<HoaDon> dsMax = ql.timKhachHangMuaNhieuNhat();
        if (dsMax.isEmpty) {
          print('Danh sách đang rỗng!');
        } else {
          print('=> Danh sách hóa đơn có số lượng mua nhiều nhất (${dsMax.first.soLuong} máy):');
          for (HoaDon hd in dsMax) {
            print(hd);
          }
        }
        break;
      case 6:
        print('=> Tổng chiết khấu cho khách hàng công ty: ${ql.tinhTongChietKhauCongTy()} VNĐ');
        break;
      case 7:
        ql.sapXepDanhSach();
        print('=> Đã sắp xếp danh sách (Tăng dần số lượng, nếu bằng nhau thì Giảm dần thành tiền):');
        ql.xuatDanhSach();
        break;
      case 8:
        String ma = InputHelper.nhapChuoi('Nhập mã khách hàng cần tìm: ');
        List<HoaDon> kq = ql.timKiemTheoMaKH(ma);
        if (kq.isEmpty) {
          print('Khách hàng lạ');
        } else {
          print('=> Tìm thấy ${kq.length} hóa đơn của mã $ma:');
          for (HoaDon hd in kq) {
            print(hd);
          }
        }
        break;
      default:
        print('Lựa chọn không hợp lệ, vui lòng chọn lại!');
    }
  }
}
