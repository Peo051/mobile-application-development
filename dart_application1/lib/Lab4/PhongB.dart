import 'package:dart_application1/Lab4/PhongThue.dart';

class PhongB extends PhongThue {
  double _giatUi = 0;
  double _soMay = 0;

  PhongB() : super() {
    _giatUi = 0;
    _soMay = 0;
  }

  PhongB.fullPara(
    String maPhong,
    double soNguoi,
    double soDien,
    double soNuoc,
    double giatUi,
    double soMay,
  ) : super.fullPara(maPhong, soNguoi, soDien, soNuoc) {
    this.giatUi = giatUi;
    this.soMay = soMay;
  }

  double get giatUi => _giatUi;
  set giatUi(double value) {
    if (value >= 0) {
      _giatUi = value;
    }
  }

  double get soMay => _soMay;
  set soMay(double value) {
    if (value >= 0) {
      _soMay = value;
    }
  }

  @override
  double tinhTienPhong() {
    return 2000 + 2 * soDien + 8 * soNuoc + _giatUi * 5 + _soMay * 100;
  }

  @override
  String toString() {
    return '${super.toString()}, Giặt ủi: $_giatUi, Số máy: $_soMay (Phòng B)';
  }
}
