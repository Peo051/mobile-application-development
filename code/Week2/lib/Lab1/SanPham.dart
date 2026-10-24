class SanPham {
  String _maSP = '';
  String _tenSP = '';
  double _donGia = 0;
  double _giamGia = 0;

  SanPham() {
    _maSP = 'SP000';
    _tenSP = 'Chưa có tên';
    _donGia = 0;
    _giamGia = 0;
  }

  SanPham.fullPara(String masp, String tensp, double gia, double giam) {
    maSP = masp;
    tenSP = tensp;
    donGia = gia;
    giamGia = giam;
  }

  String get maSP => _maSP;
  set maSP(String value) {
    if (value.trim().isNotEmpty) {
      _maSP = value;
    } else {
      print('Mã sản phẩm không hợp lệ');
    }
  }

  String get tenSP => _tenSP;
  set tenSP(String value) {
    if (value.trim().isNotEmpty) {
      _tenSP = value;
    } else {
      print('Tên sản phẩm không hợp lệ');
    }
  }

  double get donGia => _donGia;
  set donGia(double value) {
    if (value > 0) {
      _donGia = value;
    } else {
      print('Đơn giá phải > 0');
    }
  }

  double get giamGia => _giamGia;
  set giamGia(double value) {
    if (value >= 0) {
      _giamGia = value;
    } else {
      print('Giảm giá phải >= 0');
    }
  }

  double tinhThueNhapKhau() {
    return 0.1 * _donGia;
  }

  void showInfo() {
    print('Mã SP: $_maSP, Tên: $_tenSP, Giá: $_donGia, Giảm giá: $_giamGia, Thuế: ${tinhThueNhapKhau()}');
  }
}