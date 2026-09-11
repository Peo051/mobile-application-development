import 'package:dart_application1/Lab5/MonHoc.dart';

class LyThuyet extends MonHoc {
  double _tieuLuan = 0;
  double _cuoiKy = 0;

  LyThuyet() : super() {
    _tieuLuan = 0;
    _cuoiKy = 0;
  }

  LyThuyet.fullPara(
    String maMH,
    String tenMH,
    int soTinChi,
    double tieuLuan,
    double cuoiKy,
  ) : super.fullPara(maMH, tenMH, soTinChi) {
    this.tieuLuan = tieuLuan;
    this.cuoiKy = cuoiKy;
  }

  double get tieuLuan => _tieuLuan;
  set tieuLuan(double value) {
    if (value >= 0 && value <= 10) {
      _tieuLuan = value;
    }
  }

  double get cuoiKy => _cuoiKy;
  set cuoiKy(double value) {
    if (value >= 0 && value <= 10) {
      _cuoiKy = value;
    }
  }

  @override
  double tinhDTB() {
    return _tieuLuan * 0.3 + _cuoiKy * 0.7;
  }

  @override
  String toString() {
    return '${super.toString()}, Tiểu luận: $_tieuLuan, Cuối kỳ: $_cuoiKy (Lý thuyết)';
  }
}
