abstract class MonHoc {
  String _maMH = '';
  String _tenMH = '';
  int _soTinChi = 0;

  MonHoc() {
    _maMH = 'MH000';
    _tenMH = 'Chưa có tên';
    _soTinChi = 1;
  }

  MonHoc.fullPara(String maMH, String tenMH, int soTinChi) {
    this.maMH = maMH;
    this.tenMH = tenMH;
    this.soTinChi = soTinChi;
  }

  String get maMH => _maMH;
  set maMH(String value) {
    if (value.trim().isNotEmpty) {
      _maMH = value.trim();
    }
  }

  String get tenMH => _tenMH;
  set tenMH(String value) {
    if (value.trim().isNotEmpty) {
      _tenMH = value.trim();
    }
  }

  int get soTinChi => _soTinChi;
  set soTinChi(int value) {
    if (value > 0) {
      _soTinChi = value;
    }
  }

  double tinhDTB();

  @override
  String toString() {
    return 'Mã MH: $_maMH, Tên: $_tenMH, Tín chỉ: $_soTinChi, ĐTB: ${tinhDTB().toStringAsFixed(2)}';
  }
}
