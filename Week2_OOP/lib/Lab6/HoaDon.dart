import 'package:dart_application1/Lab6/InputHelper.dart';

abstract class HoaDon {
  String _maKH = '';
  String _tenKH = '';
  int _soLuong = 0;
  double _giaBan = 0;

  HoaDon() {
    _maKH = 'KH0000';
    _tenKH = 'Chưa có tên';
    _soLuong = 1;
    _giaBan = 0;
  }

  HoaDon.fullPara(String maKH, String tenKH, int soLuong, double giaBan) {
    this.maKH = maKH;
    this.tenKH = tenKH;
    this.soLuong = soLuong;
    this.giaBan = giaBan;
  }

  String get maKH => _maKH;
  set maKH(String value) {
    RegExp regex = RegExp(r'^KH\d{4}$');
    if (regex.hasMatch(value.trim())) {
      _maKH = value.trim();
    }
  }

  String get tenKH => _tenKH;
  set tenKH(String value) {
    if (value.trim().isNotEmpty) {
      _tenKH = value.trim();
    }
  }

  int get soLuong => _soLuong;
  set soLuong(int value) {
    if (value > 0) {
      _soLuong = value;
    }
  }

  double get giaBan => _giaBan;
  set giaBan(double value) {
    if (value > 0) {
      _giaBan = value;
    }
  }

  double tinhTienHang() {
    return _soLuong * _giaBan;
  }

  double tinhVAT() {
    return 0.1 * tinhTienHang();
  }

  double tinhChietKhau();

  double tinhTroGia();

  double tinhThanhTien() {
    return tinhTienHang() - tinhChietKhau() + tinhVAT();
  }

  void nhapThongTin() {
    maKH = InputHelper.nhapMaKH('Nhập mã khách hàng (VD: KH0001): ');
    tenKH = InputHelper.nhapChuoi('Nhập tên khách hàng: ');
    soLuong = InputHelper.nhapInt('Nhập số lượng máy lạnh (> 0): ', min: 1);
    giaBan = InputHelper.nhapDouble('Nhập đơn giá bán (> 0): ', min: 1);
  }

  @override
  String toString() {
    return 'Mã KH: $_maKH, Tên: $_tenKH, SL: $_soLuong, Đơn giá: $_giaBan, Tiền hàng: ${tinhTienHang()}, Chiết khấu: ${tinhChietKhau()}, VAT: ${tinhVAT()}, Trợ giá: ${tinhTroGia()}, Thành tiền: ${tinhThanhTien()}';
  }
}
