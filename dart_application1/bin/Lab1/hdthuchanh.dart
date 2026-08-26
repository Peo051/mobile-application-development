import 'package:dart_application1/Lab1/SanPham.dart';

void main() {
  SanPham sp = SanPham();
  sp.maSP = 'SP001';
  sp.tenSP = 'Bánh gạo Nhật';
  sp.donGia = 25000;
  sp.giamGia = 2000;

  SanPham sp1 = SanPham.fullPara('SP002', 'Trà ô long', 75000, 5000);
  SanPham sp2 = SanPham.fullPara('SP003', 'Mứt xoài sấy', 45000, 0);
  SanPham sp3 = SanPham.fullPara('SP004', 'Cà phê', 120000, 10000);

  List<SanPham> listSP = [sp, sp1, sp2, sp3];

  print('Danh sách sản phẩm:');
  for (SanPham item in listSP) {
    item.showInfo();
  }
}