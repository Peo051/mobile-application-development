import 'package:dart_application1/Lab6/HoaDon.dart';
import 'package:dart_application1/Lab6/KhachHangCaNhan.dart';
import 'package:dart_application1/Lab6/DaiLyCap1.dart';
import 'package:dart_application1/Lab6/KhachHangCongTy.dart';
import 'package:dart_application1/Lab6/InputHelper.dart';

class QuanLyHoaDon {
  List<HoaDon> danhSach = [];

  void nhapDanhSach() {
    while (true) {
      print('\n--- CHỌN LOẠI HÓA ĐƠN ĐỂ NHẬP ---');
      print('1. Khách hàng cá nhân');
      print('2. Đại lý cấp 1');
      print('3. Khách hàng công ty');
      print('0. Dừng nhập');

      int chon = InputHelper.nhapInt('Lựa chọn của bạn: ', min: 0);
      if (chon == 0) {
        break;
      }

      HoaDon? hd;
      if (chon == 1) {
        hd = KhachHangCaNhan();
      } else if (chon == 2) {
        hd = DaiLyCap1();
      } else if (chon == 3) {
        hd = KhachHangCongTy();
      } else {
        print('Lựa chọn không hợp lệ!');
        continue;
      }

      hd.nhapThongTin();
      danhSach.add(hd);
      print('=> Đã thêm hóa đơn thành công!');
    }
  }

  void xuatDanhSach() {
    if (danhSach.isEmpty) {
      print('Danh sách hóa đơn đang rỗng!');
      return;
    }
    print('\n--- DANH SÁCH TẤT CẢ HÓA ĐƠN ---');
    for (HoaDon hd in danhSach) {
      print(hd);
    }
  }

  double tinhTongThanhTien() {
    double tong = 0;
    for (HoaDon hd in danhSach) {
      tong = tong + hd.tinhThanhTien();
    }
    return tong;
  }

  double tinhTongTroGia() {
    double tong = 0;
    for (HoaDon hd in danhSach) {
      tong = tong + hd.tinhTroGia();
    }
    return tong;
  }

  List<HoaDon> timKhachHangMuaNhieuNhat() {
    List<HoaDon> ketQua = [];
    if (danhSach.isEmpty) {
      return ketQua;
    }

    int maxSL = danhSach[0].soLuong;
    for (HoaDon hd in danhSach) {
      if (hd.soLuong > maxSL) {
        maxSL = hd.soLuong;
      }
    }

    for (HoaDon hd in danhSach) {
      if (hd.soLuong == maxSL) {
        ketQua.add(hd);
      }
    }
    return ketQua;
  }

  double tinhTongChietKhauCongTy() {
    double tong = 0;
    for (HoaDon hd in danhSach) {
      if (hd is KhachHangCongTy) {
        tong = tong + hd.tinhChietKhau();
      }
    }
    return tong;
  }

  void sapXepDanhSach() {
    danhSach.sort((a, b) {
      if (a.soLuong != b.soLuong) {
        return a.soLuong.compareTo(b.soLuong);
      } else {
        return b.tinhThanhTien().compareTo(a.tinhThanhTien());
      }
    });
  }

  List<HoaDon> timKiemTheoMaKH(String ma) {
    List<HoaDon> ketQua = [];
    for (HoaDon hd in danhSach) {
      if (hd.maKH.toLowerCase() == ma.trim().toLowerCase()) {
        ketQua.add(hd);
      }
    }
    return ketQua;
  }
}
