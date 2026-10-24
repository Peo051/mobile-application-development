import 'dart:io';
import 'package:dart_application1/Lab1/SanPham.dart';

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

Future<List<SanPham>> readFile(String fileName) async {
  List<SanPham> list = [];
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
      if (parts.length == 4) {
        String ma = parts[0].trim();
        String ten = parts[1].trim();
        double? gia = double.tryParse(parts[2].trim());
        double? giam = double.tryParse(parts[3].trim());

        if (gia != null && giam != null) {
          list.add(SanPham.fullPara(ma, ten, gia, giam));
        } else {
          print('Dòng lỗi định dạng số: $line');
        }
      } else {
        print('Dòng không đúng 4 phần tử: $line');
      }
    }
  } catch (e) {
    print('Lỗi đọc file: $e');
  }
  return list;
}

Future<void> main() async {
  List<SanPham> ds = await readFile('Lab3/sanpham.txt');

  print('Danh sách sản phẩm:');
  for (SanPham sp in ds) {
    sp.showInfo();
  }
}
