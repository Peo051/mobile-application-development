import 'package:dart_application1/Lab2/NhanVien.dart';

class CanBo extends NhanVien {
  String _chucVu = '';
  double _hsChucVu = 0;

  CanBo() : super() {
    _chucVu = 'Chưa có chức vụ';
    _hsChucVu = 0;
  }

  CanBo.fullPara(
    String maNV,
    String tenNV,
    double heSoLuong,
    String phongBan,
    double soNgayLV,
    String chucVu,
    double hsChucVu,
  ) : super.fullPara(maNV, tenNV, heSoLuong, phongBan, soNgayLV) {
    this.chucVu = chucVu;
    this.hsChucVu = hsChucVu;
  }

  String get chucVu => _chucVu;
  set chucVu(String value) {
    if (value.trim().isNotEmpty) {
      _chucVu = value;
    }
  }

  double get hsChucVu => _hsChucVu;
  set hsChucVu(double value) {
    if (value >= 0) {
      _hsChucVu = value;
    }
  }

  @override
  double tinhLuong() {
    return super.tinhLuong() + _hsChucVu * 1100;
  }

  @override
  String toString() {
    return '${super.toString()}, Chức vụ: $_chucVu, HS Chức vụ: $_hsChucVu';
  }
}