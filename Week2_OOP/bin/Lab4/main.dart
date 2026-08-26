import 'dart:io';
import 'package:dart_application1/Lab4/PhongThue.dart';
import 'package:dart_application1/Lab4/PhongA.dart';
import 'package:dart_application1/Lab4/PhongB.dart';

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

Future<List<PhongThue>> readFile(String fileName) async {
  List<PhongThue> list = [];
  try {
    String duongDanThuc = layDuongDanFile(fileName);
    File file = File(duongDanThuc);
    if (!await file.exists()) {
      print('File không tồn tại: $fileName');
      return list;
    }

    List<String> lines = await file.readAsLines();
    for (String line in lines) {
      String trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      List<String> parts = trimmedLine.split('#');
      if (parts.isEmpty) continue;

      String ma = parts[0].trim();
      if (ma.startsWith('A') && parts.length == 5) {
        double? soNguoi = double.tryParse(parts[1].trim());
        double? soDien = double.tryParse(parts[2].trim());
        double? soNuoc = double.tryParse(parts[3].trim());
        double? soNguoiThan = double.tryParse(parts[4].trim());

        if (soNguoi != null && soDien != null && soNuoc != null && soNguoiThan != null) {
          list.add(PhongA.fullPara(ma, soNguoi, soDien, soNuoc, soNguoiThan));
        } else {
          print('Lỗi dữ liệu số dòng: $line');
        }
      } else if (ma.startsWith('B') && parts.length == 6) {
        double? soNguoi = double.tryParse(parts[1].trim());
        double? soDien = double.tryParse(parts[2].trim());
        double? soNuoc = double.tryParse(parts[3].trim());
        double? giatUi = double.tryParse(parts[4].trim());
        double? soMay = double.tryParse(parts[5].trim());

        if (soNguoi != null && soDien != null && soNuoc != null && giatUi != null && soMay != null) {
          list.add(PhongB.fullPara(ma, soNguoi, soDien, soNuoc, giatUi, soMay));
        } else {
          print('Lỗi dữ liệu số dòng: $line');
        }
      } else {
        print('Dòng sai định dạng hoặc mã phòng: $line');
      }
    }
  } catch (e) {
    print('Lỗi đọc file: $e');
  }
  return list;
}

Future<void> main() async {
  List<PhongThue> dsPhong = await readFile('Lab4/phongthue.txt');

  print('1. Toàn bộ danh sách phòng thuê:');
  for (PhongThue p in dsPhong) {
    print(p);
  }

  print('\n2. Danh sách phòng có số người thuê > 2:');
  List<PhongThue> dsHon2Nguoi = dsPhong.where((p) => p.soNguoi > 2).toList();
  for (PhongThue p in dsHon2Nguoi) {
    print(p);
  }

  double tongTien = dsPhong.fold(0.0, (sum, p) => sum + p.tinhTienPhong());
  print('\n3. Tổng tiền toàn bộ phòng thuê: $tongTien');

  dsPhong.sort((a, b) => b.soDien.compareTo(a.soDien));
  print('\n4. Danh sách sắp xếp giảm dần theo số điện tiêu thụ:');
  for (PhongThue p in dsPhong) {
    print(p);
  }

  print('\n5. Danh sách tất cả phòng loại A:');
  List<PhongThue> dsPhongA = dsPhong.where((p) => p is PhongA).toList();
  for (PhongThue p in dsPhongA) {
    print(p);
  }
}
