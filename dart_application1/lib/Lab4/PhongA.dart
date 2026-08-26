import 'package:dart_application1/Lab4/PhongThue.dart';

class PhongA extends PhongThue {
  double _soNguoiThan = 0;

  PhongA() : super() {
    _soNguoiThan = 0;
  }

  PhongA.fullPara(
    String maPhong,
    double soNguoi,
    double soDien,
    double soNuoc,
    double soNguoiThan,
  ) : super.fullPara(maPhong, soNguoi, soDien, soNuoc) {
    this.soNguoiThan = soNguoiThan;
  }

  double get soNguoiThan => _soNguoiThan;
  set soNguoiThan(double value) {
    if (value >= 0) {
      _soNguoiThan = value;
    }
  }

  @override
  double tinhTienPhong() {
    return 1400 + 2 * soDien + 8 * soNuoc + 50 * _soNguoiThan;
  }

  @override
  String toString() {
    return '${super.toString()}, Người thân: $_soNguoiThan (Phòng A)';
  }
}
