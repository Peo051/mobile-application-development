abstract class PhongThue {
  String _maPhong = '';
  double _soNguoi = 0;
  double _soDien = 0;
  double _soNuoc = 0;

  PhongThue() {
    _maPhong = 'P000';
    _soNguoi = 1;
    _soDien = 0;
    _soNuoc = 0;
  }

  PhongThue.fullPara(String maPhong, double soNguoi, double soDien, double soNuoc) {
    this.maPhong = maPhong;
    this.soNguoi = soNguoi;
    this.soDien = soDien;
    this.soNuoc = soNuoc;
  }

  String get maPhong => _maPhong;
  set maPhong(String value) {
    if (value.trim().isNotEmpty) {
      _maPhong = value.trim();
    }
  }

  double get soNguoi => _soNguoi;
  set soNguoi(double value) {
    if (value > 0) {
      _soNguoi = value;
    }
  }

  double get soDien => _soDien;
  set soDien(double value) {
    if (value >= 0) {
      _soDien = value;
    }
  }

  double get soNuoc => _soNuoc;
  set soNuoc(double value) {
    if (value >= 0) {
      _soNuoc = value;
    }
  }

  double tinhTienPhong();

  @override
  String toString() {
    return 'Mã phòng: $_maPhong, Số người: $_soNguoi, Điện: $_soDien, Nước: $_soNuoc, Tiền phòng: ${tinhTienPhong()}';
  }
}
