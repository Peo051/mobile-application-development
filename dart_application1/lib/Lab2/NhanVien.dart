class NhanVien {
  String _maNV = '';
  String _tenNV = '';
  double _heSoLuong = 0;
  String _phongBan = '';
  double _soNgayLV = 0;
  static const double _luongCB = 2340;

  NhanVien() {
    _maNV = 'NV000';
    _tenNV = 'Chưa có tên';
    _heSoLuong = 1.0;
    _phongBan = 'Phòng ban chung';
    _soNgayLV = 0;
  }

  NhanVien.fullPara(String maNV, String tenNV, double heSoLuong, String phongBan, double soNgayLV) {
    this.maNV = maNV;
    this.tenNV = tenNV;
    this.heSoLuong = heSoLuong;
    this.phongBan = phongBan;
    this.soNgayLV = soNgayLV;
  }

  String get maNV => _maNV;
  set maNV(String value) {
    if (value.trim().isNotEmpty) {
      _maNV = value;
    }
  }

  String get tenNV => _tenNV;
  set tenNV(String value) {
    if (value.trim().isNotEmpty) {
      _tenNV = value;
    }
  }

  double get heSoLuong => _heSoLuong;
  set heSoLuong(double value) {
    if (value > 0) {
      _heSoLuong = value;
    }
  }

  String get phongBan => _phongBan;
  set phongBan(String value) {
    if (value.trim().isNotEmpty) {
      _phongBan = value;
    }
  }

  double get soNgayLV => _soNgayLV;
  set soNgayLV(double value) {
    if (value >= 0) {
      _soNgayLV = value;
    }
  }

  String xepLoai() {
    if (_soNgayLV > 25) {
      return 'A';
    } else if (_soNgayLV > 22) {
      return 'B';
    } else {
      return 'C';
    }
  }

  double tinhLuong() {
    String loai = xepLoai();
    double heSoThiDua = 0.5;
    if (loai == 'A') {
      heSoThiDua = 1.0;
    } else if (loai == 'B') {
      heSoThiDua = 0.75;
    } else {
      heSoThiDua = 0.5;
    }
    return _luongCB * _heSoLuong * heSoThiDua;
  }

  @override
  String toString() {
    return 'Mã: $_maNV, Tên: $_tenNV, Phòng: $_phongBan, Ngày làm: $_soNgayLV, Xếp loại: ${xepLoai()}, Lương: ${tinhLuong()}';
  }
}