import 'package:dart_application1/Lab6/HoaDon.dart';
import 'package:dart_application1/Lab6/InputHelper.dart';

class DaiLyCap1 extends HoaDon {
  int _thoiGianHopTac = 0;

  DaiLyCap1() : super() {
    _thoiGianHopTac = 0;
  }

  DaiLyCap1.fullPara(
    String maKH,
    String tenKH,
    int soLuong,
    double giaBan,
    int thoiGianHopTac,
  ) : super.fullPara(maKH, tenKH, soLuong, giaBan) {
    this.thoiGianHopTac = thoiGianHopTac;
  }

  int get thoiGianHopTac => _thoiGianHopTac;
  set thoiGianHopTac(int value) {
    if (value >= 0) {
      _thoiGianHopTac = value;
    }
  }

  @override
  double tinhChietKhau() {
    double phanTram = 0.30;
    if (_thoiGianHopTac > 5) {
      int namVuot = _thoiGianHopTac - 5;
      phanTram = phanTram + namVuot * 0.01;
    }
    if (phanTram > 0.35) {
      phanTram = 0.35;
    }
    return phanTram * giaBan * soLuong;
  }

  @override
  double tinhTroGia() {
    return 0.0;
  }

  @override
  void nhapThongTin() {
    super.nhapThongTin();
    thoiGianHopTac = InputHelper.nhapInt('Nhập thời gian hợp tác (năm): ');
  }

  @override
  String toString() {
    return '${super.toString()}, Hợp tác: $_thoiGianHopTac năm (Đại lý cấp 1)';
  }
}
