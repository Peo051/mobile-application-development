import 'package:dart_application1/Lab5/MonHoc.dart';

class ThucHanh extends MonHoc {
  double _kt1 = 0;
  double _kt2 = 0;
  double _kt3 = 0;

  ThucHanh() : super() {
    _kt1 = 0;
    _kt2 = 0;
    _kt3 = 0;
  }

  ThucHanh.fullPara(
    String maMH,
    String tenMH,
    int soTinChi,
    double kt1,
    double kt2,
    double kt3,
  ) : super.fullPara(maMH, tenMH, soTinChi) {
    this.kt1 = kt1;
    this.kt2 = kt2;
    this.kt3 = kt3;
  }

  double get kt1 => _kt1;
  set kt1(double value) {
    if (value >= 0 && value <= 10) {
      _kt1 = value;
    }
  }

  double get kt2 => _kt2;
  set kt2(double value) {
    if (value >= 0 && value <= 10) {
      _kt2 = value;
    }
  }

  double get kt3 => _kt3;
  set kt3(double value) {
    if (value >= 0 && value <= 10) {
      _kt3 = value;
    }
  }

  @override
  double tinhDTB() {
    return (_kt1 + _kt2 + _kt3) / 3;
  }

  @override
  String toString() {
    return '${super.toString()}, KT1: $_kt1, KT2: $_kt2, KT3: $_kt3 (Thực hành)';
  }
}
