import 'package:dart_application1/Lab6/HoaDon.dart';
import 'package:dart_application1/Lab6/InputHelper.dart';

class KhachHangCongTy extends HoaDon {
  int _soNhanVien = 0;

  KhachHangCongTy() : super() {
    _soNhanVien = 0;
  }

  KhachHangCongTy.fullPara(
    String maKH,
    String tenKH,
    int soLuong,
    double giaBan,
    int soNhanVien,
  ) : super.fullPara(maKH, tenKH, soLuong, giaBan) {
    this.soNhanVien = soNhanVien;
  }

  int get soNhanVien => _soNhanVien;
  set soNhanVien(int value) {
    if (value >= 0) {
      _soNhanVien = value;
    }
  }

  @override
  double tinhChietKhau() {
    double phanTram = 0.0;
    if (_soNhanVien > 5000) {
      phanTram = 0.07;
    } else if (_soNhanVien > 1000) {
      phanTram = 0.05;
    } else {
      phanTram = 0.0;
    }
    return phanTram * giaBan * soLuong;
  }

  @override
  double tinhTroGia() {
    return soLuong * 120000.0;
  }

  @override
  void nhapThongTin() {
    super.nhapThongTin();
    soNhanVien = InputHelper.nhapInt('Nhập số lượng nhân viên: ');
  }

  @override
  String toString() {
    return '${super.toString()}, Số NV: $_soNhanVien (Công ty)';
  }
}
