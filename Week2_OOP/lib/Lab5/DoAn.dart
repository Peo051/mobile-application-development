import 'package:dart_application1/Lab5/MonHoc.dart';

class DoAn extends MonHoc {
  double _gvhd = 0;
  double _gvpb = 0;

  DoAn() : super() {
    _gvhd = 0;
    _gvpb = 0;
  }

  DoAn.fullPara(
    String maMH,
    String tenMH,
    int soTinChi,
    double gvhd,
    double gvpb,
  ) : super.fullPara(maMH, tenMH, soTinChi) {
    this.gvhd = gvhd;
    this.gvpb = gvpb;
  }

  double get gvhd => _gvhd;
  set gvhd(double value) {
    if (value >= 0 && value <= 10) {
      _gvhd = value;
    }
  }

  double get gvpb => _gvpb;
  set gvpb(double value) {
    if (value >= 0 && value <= 10) {
      _gvpb = value;
    }
  }

  @override
  double tinhDTB() {
    return (_gvhd + _gvpb) / 2;
  }

  @override
  String toString() {
    return '${super.toString()}, GVHD: $_gvhd, GVPB: $_gvpb (Đồ án)';
  }
}
