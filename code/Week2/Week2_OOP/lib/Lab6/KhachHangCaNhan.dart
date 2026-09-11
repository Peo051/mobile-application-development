import 'package:dart_application1/Lab6/HoaDon.dart';
import 'package:dart_application1/Lab6/InputHelper.dart';

class KhachHangCaNhan extends HoaDon {
  double _khoangCach = 0;

  KhachHangCaNhan() : super() {
    _khoangCach = 0;
  }

  KhachHangCaNhan.fullPara(
    String maKH,
    String tenKH,
    int soLuong,
    double giaBan,
    double khoangCach,
  ) : super.fullPara(maKH, tenKH, soLuong, giaBan) {
    this.khoangCach = khoangCach;
  }

  double get khoangCach => _khoangCach;
  set khoangCach(double value) {
    if (value >= 0) {
      _khoangCach = value;
    }
  }

  @override
  double tinhChietKhau() {
    double ckCoBan = 0;
    if (soLuong >= 3) {
      ckCoBan = 0.05 * giaBan * soLuong;
    }

    double ckVanChuyen = 0;
    if (_khoangCach < 10) {
      ckVanChuyen = 50000.0 * soLuong;
    }

    return ckCoBan + ckVanChuyen;
  }

  @override
  double tinhTroGia() {
    double troGiaSP = 0.02 * giaBan * soLuong;
    double troGiaThem = 0;
    if (soLuong > 2) {
      troGiaThem = 100000;
    }
    return troGiaSP + troGiaThem;
  }

  @override
  void nhapThongTin() {
    super.nhapThongTin();
    khoangCach = InputHelper.nhapDouble('Nhập khoảng cách giao hàng (km): ');
  }

  @override
  String toString() {
    return '${super.toString()}, Khoảng cách: $_khoangCach km (Cá nhân)';
  }
}
