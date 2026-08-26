import 'package:dart_application1/Lab2/NhanVien.dart';
import 'package:dart_application1/Lab2/CanBo.dart';

void main() {
  List<NhanVien> lstNhanVien = [];

  NhanVien nv1 = NhanVien.fullPara('NV01', 'Trần Gia Bảo', 2.0, 'Kế toán', 26);
  NhanVien nv2 = NhanVien.fullPara('NV02', 'Lê Quang Bảo', 1.5, 'Kinh doanh', 24);
  CanBo cb1 = CanBo.fullPara('CB01', 'Trần Dương Gia Bảo', 3.0, 'Ban Giám Đốc', 20, 'Trưởng phòng', 1.5);
  CanBo cb2 = CanBo.fullPara('CB02', 'Trần Bảo Anh', 2.5, 'Kỹ thuật', 27, 'Phó giám đốc', 2.0);

  lstNhanVien.add(nv1);
  lstNhanVien.add(nv2);
  lstNhanVien.add(cb1);
  lstNhanVien.add(cb2);

  print('1. Toàn bộ danh sách:');
  for (NhanVien nv in lstNhanVien) {
    print(nv);
  }

  print('\n2. Danh sách nhân viên/cán bộ loại A:');
  List<NhanVien> dsLoaiA = lstNhanVien.where((a) => a.xepLoai() == 'A').toList();
  for (NhanVien nv in dsLoaiA) {
    print(nv);
  }

  double tongLuong = lstNhanVien.fold(0.0, (sum, nv) => sum + nv.tinhLuong());
  print('\n3. Tổng lương toàn bộ danh sách: $tongLuong');

  lstNhanVien.sort((a, b) => a.xepLoai().compareTo(b.xepLoai()));
  print('\n4. Danh sách sắp xếp tăng dần theo xếp loại (A -> B -> C):');
  for (NhanVien nv in lstNhanVien) {
    print(nv);
  }
}