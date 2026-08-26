import 'dart:io';
import 'package:dart_application1/Lab5/MonHoc.dart';
import 'package:dart_application1/Lab5/LyThuyet.dart';
import 'package:dart_application1/Lab5/ThucHanh.dart';
import 'package:dart_application1/Lab5/DoAn.dart';

String nhapChuoi(String thongBao) {
  while (true) {
    stdout.write(thongBao);
    String? input = stdin.readLineSync();
    if (input != null && input.trim().isNotEmpty) {
      return input.trim();
    }
    print('Khong duoc de trong, vui long nhap lai!');
  }
}

int nhapInt(String thongBao, {int min = 1}) {
  while (true) {
    stdout.write(thongBao);
    String? input = stdin.readLineSync();
    int? value = int.tryParse(input?.trim() ?? '');
    if (value != null && value >= min) {
      return value;
    }
    print('Gia tri phai la so nguyen >= $min, vui long nhap lai!');
  }
}

double nhapDiem(String thongBao) {
  while (true) {
    stdout.write(thongBao);
    String? input = stdin.readLineSync();
    double? value = double.tryParse(input?.trim() ?? '');
    if (value != null && value >= 0 && value <= 10) {
      return value;
    }
    print('Diem phai trong khoang tu 0 den 10, vui long nhap lai!');
  }
}

Future<List<MonHoc>> readFile(String fileName) async {
  List<MonHoc> list = [];
  try {
    File file = File(fileName);
    if (!await file.exists()) {
      print('File khong ton tai: $fileName');
      return list;
    }

    List<String> lines = await file.readAsLines();
    for (String line in lines) {
      String trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      List<String> parts = trimmed.split('#');
      if (parts.length < 4) {
        print('Dong sai dinh dang: $line');
        continue;
      }

      String loai = parts[0].trim().toUpperCase();
      String ma = parts[1].trim();
      String ten = parts[2].trim();
      int? tc = int.tryParse(parts[3].trim());

      if (tc == null) {
        print('Loi so tin chi dong: $line');
        continue;
      }

      if (loai == 'LT' && parts.length == 6) {
        double? tl = double.tryParse(parts[4].trim());
        double? ck = double.tryParse(parts[5].trim());
        if (tl != null && ck != null) {
          list.add(LyThuyet.fullPara(ma, ten, tc, tl, ck));
        }
      } else if (loai == 'TH' && parts.length == 7) {
        double? kt1 = double.tryParse(parts[4].trim());
        double? kt2 = double.tryParse(parts[5].trim());
        double? kt3 = double.tryParse(parts[6].trim());
        if (kt1 != null && kt2 != null && kt3 != null) {
          list.add(ThucHanh.fullPara(ma, ten, tc, kt1, kt2, kt3));
        }
      } else if (loai == 'DA' && parts.length == 6) {
        double? gvhd = double.tryParse(parts[4].trim());
        double? gvpb = double.tryParse(parts[5].trim());
        if (gvhd != null && gvpb != null) {
          list.add(DoAn.fullPara(ma, ten, tc, gvhd, gvpb));
        }
      } else {
        print('Loai mon hoac so truong khong hop le: $line');
      }
    }
  } catch (e) {
    print('Loi doc file: $e');
  }
  return list;
}

bool daSapXepTheoTen(List<MonHoc> ds) {
  if (ds.length <= 1) return true;
  for (int i = 0; i < ds.length - 1; i++) {
    if (ds[i].tenMH.toLowerCase().compareTo(ds[i + 1].tenMH.toLowerCase()) > 0) {
      return false;
    }
  }
  return true;
}

double tinhTinChiTrungBinh(List<MonHoc> ds) {
  if (ds.isEmpty) return 0.0;
  int tongTC = ds.fold(0, (sum, m) => sum + m.soTinChi);
  return tongTC / ds.length;
}

void nhapMonMoi(List<MonHoc> ds, {String? tenMacDinh}) {
  print('\n--- NHAP THONG TIN MON HOC ---');
  print('1. Mon Ly thuyet');
  print('2. Mon Thuc hanh');
  print('3. Mon Do an');
  int loai = nhapInt('Chon loai mon (1-3): ', min: 1);

  String ma = nhapChuoi('Nhap ma mon hoc: ');
  String ten = tenMacDinh ?? nhapChuoi('Nhap ten mon hoc: ');
  int tc = nhapInt('Nhap so tin chi (> 0): ', min: 1);

  if (loai == 1) {
    double tl = nhapDiem('Nhap diem tieu luan (0-10): ');
    double ck = nhapDiem('Nhap diem cuoi ky (0-10): ');
    ds.add(LyThuyet.fullPara(ma, ten, tc, tl, ck));
  } else if (loai == 2) {
    double kt1 = nhapDiem('Nhap diem KT1 (0-10): ');
    double kt2 = nhapDiem('Nhap diem KT2 (0-10): ');
    double kt3 = nhapDiem('Nhap diem KT3 (0-10): ');
    ds.add(ThucHanh.fullPara(ma, ten, tc, kt1, kt2, kt3));
  } else if (loai == 3) {
    double gvhd = nhapDiem('Nhap diem GVHD (0-10): ');
    double gvpb = nhapDiem('Nhap diem GVPB (0-10): ');
    ds.add(DoAn.fullPara(ma, ten, tc, gvhd, gvpb));
  } else {
    print('Loai mon khong hop le.');
  }
}

Future<void> main() async {
  String filePath = 'lib/Lab5/monhoc.txt';
  List<MonHoc> dsMonHoc = await readFile(filePath);

  print('=== CHUONG TRINH QUAN LY MON HOC (OOP DART) ===\n');

  print('1. Danh sach mon hoc doc tu file:');
  for (MonHoc mh in dsMonHoc) {
    print(mh);
  }

  print('\n2. Kiem tra danh sach co dang tang dan theo ten:');
  if (daSapXepTheoTen(dsMonHoc)) {
    print('=> Danh sach DANG duoc sap xep tang dan theo ten.');
  } else {
    print('=> Danh sach CHUA duoc sap xep tang dan theo ten.');
  }

  dsMonHoc.sort((a, b) => a.soTinChi.compareTo(b.soTinChi));
  print('\n3. Danh sach sau khi sap xep tang dan theo so tin chi:');
  for (MonHoc mh in dsMonHoc) {
    print(mh);
  }

  print('\n4. Cac mon hoc co so tin chi cao nhat:');
  if (dsMonHoc.isNotEmpty) {
    int maxTC = dsMonHoc.map((m) => m.soTinChi).reduce((a, b) => a > b ? a : b);
    List<MonHoc> dsMaxTC = dsMonHoc.where((m) => m.soTinChi == maxTC).toList();
    for (MonHoc mh in dsMaxTC) {
      print(mh);
    }
  }

  double tcTB = tinhTinChiTrungBinh(dsMonHoc);
  print('\n5. So tin chi trung binh cua danh sach: ${tcTB.toStringAsFixed(2)}');
}
