import 'dart:io';

class InputHelper {
  static String nhapChuoi(String thongBao) {
    while (true) {
      stdout.write(thongBao);
      String? input = stdin.readLineSync();
      if (input != null && input.trim().isNotEmpty) {
        return input.trim();
      }
      print('Không được để trống, vui lòng nhập lại!');
    }
  }

  static String nhapMaKH(String thongBao) {
    RegExp regex = RegExp(r'^KH\d{4}$');
    while (true) {
      stdout.write(thongBao);
      String? input = stdin.readLineSync();
      if (input != null && regex.hasMatch(input.trim())) {
        return input.trim();
      }
      print('Mã KH không đúng định dạng (phải bắt đầu bằng KH và 4 chữ số, VD: KH0001)!');
    }
  }

  static int nhapInt(String thongBao, {int min = 0}) {
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

  static double nhapDouble(String thongBao, {double min = 0}) {
    while (true) {
      stdout.write(thongBao);
      String? input = stdin.readLineSync();
      double? value = double.tryParse(input?.trim() ?? '');
      if (value != null && value >= min) {
        return value;
      }
      print('Giá trị phải là số thực >= $min, vui lòng nhập lại!');
    }
  }
}
