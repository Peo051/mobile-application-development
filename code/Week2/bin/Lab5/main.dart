import 'dart:io';
import 'package:dart_application1/Lab5/MonHoc.dart';
import 'package:dart_application1/Lab5/LyThuyet.dart';
import 'package:dart_application1/Lab5/ThucHanh.dart';
import 'package:dart_application1/Lab5/DoAn.dart';

String layDuongDanFile(String tenFileTrongLib) {
  List<String> cacViTri = [
    tenFileTrongLib,
    'lib/$tenFileTrongLib',
    'code/Week2/Week2_OOP/lib/$tenFileTrongLib',
    'Week2_OOP/lib/$tenFileTrongLib',
    Platform.script.resolve('../../../lib/$tenFileTrongLib').toFilePath(),
    Platform.script.resolve('../../lib/$tenFileTrongLib').toFilePath(),
  ];

  for (String viTri in cacViTri) {
    if (File(viTri).existsSync()) {
      return viTri;
    }
  }
  return tenFileTrongLib;
}

String nhapChuoi(String thongBao) {
  while (true) {
    stdout.write(thongBao);
    String? input = stdin.readLineSync();
    if (input != null && input.trim().isNotEmpty) {
      return input.trim();
    }
    print('Không được để trống, vui lòng nhập lại!');
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
    print('Giá trị phải là số nguyên >= $min, vui lòng nhập lại!');
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
    print('Điểm phải trong khoảng từ 0 đến 10, vui lòng nhập lại!');
  }
}

Future<List<MonHoc>> readFile(String fileName) async {
  List<MonHoc> list = [];
  try {
    String duongDanThuc = layDuongDanFile(fileName);
    File file = File(duongDanThuc);
    if (!await file.exists()) {
      print('File không tồn tại: $fileName');
      return list;
    }

    List<String> lines = await file.readAsLines();
    for (String line in lines) {
      String trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      List<String> parts = trimmed.split('#');
      if (parts.length < 4) continue;

      String loai = parts[0].trim().toUpperCase();
      String ma = parts[1].trim();
      String ten = parts[2].trim();
      int? tc = int.tryParse(parts[3].trim());

      if (tc == null) continue;

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
      }
    }
  } catch (e) {
    print('Lỗi đọc file: $e');
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

Future<void> main() async {
  List<MonHoc> dsMonHoc = await readFile('Lab5/monhoc.txt');

  print('=== CHƯƠNG TRÌNH QUẢN LÝ MÔN HỌC (OOP DART) ===\n');

  print('1. Danh sách môn học đọc từ file:');
  for (MonHoc mh in dsMonHoc) {
    print(mh);
  }

  print('\n2. Kiểm tra danh sách có đang tăng dần theo tên:');
  if (daSapXepTheoTen(dsMonHoc)) {
    print('=> Danh sách ĐANG được sắp xếp tăng dần theo tên.');
  } else {
    print('=> Danh sách CHƯA được sắp xếp tăng dần theo tên.');
  }

  dsMonHoc.sort((a, b) => a.soTinChi.compareTo(b.soTinChi));
  print('\n3. Danh sách sau khi sắp xếp tăng dần theo số tín chỉ:');
  for (MonHoc mh in dsMonHoc) {
    print(mh);
  }

  print('\n4. Các môn học có số tín chỉ cao nhất:');
  if (dsMonHoc.isNotEmpty) {
    int maxTC = dsMonHoc.map((m) => m.soTinChi).reduce((a, b) => a > b ? a : b);
    List<MonHoc> dsMaxTC = dsMonHoc.where((m) => m.soTinChi == maxTC).toList();
    for (MonHoc mh in dsMaxTC) {
      print(mh);
    }
  }

  double tcTB = tinhTinChiTrungBinh(dsMonHoc);
  print('\n5. Số tín chỉ trung bình của danh sách: ${tcTB.toStringAsFixed(2)}');
}
