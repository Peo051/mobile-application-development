import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class Bt02Colors {
  static const background = Color(0xFFF5F7FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFEDF3FD);
  static const gold = Color(0xFFF5B930);
  static const darkBlue = Color(0xFF183C70);
  static const text = Color(0xFF17213B);
  static const primaryBlue = Color(0xFF1679C6);
  static const sectionBlue = Color(0xFF228DDC);
  static const muted = Color(0xFF64718B);
  static const border = Color(0xFFDCE4F0);
  static const purple = Color(0xFF6B4FD5);
  static const purpleSoft = Color(0xFFF0EDFF);
  static const danger = Color(0xFFDA4D5C);
}

ThemeData buildBt02Theme() {
  return ThemeData(
    useMaterial3: false,
    fontFamily: 'Inter',
    primaryColor: Bt02Colors.primaryBlue,
    scaffoldBackgroundColor: Bt02Colors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Bt02Colors.gold,
      foregroundColor: Bt02Colors.darkBlue,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 64,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Bt02Colors.gold,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Bt02Colors.primaryBlue,
    ),
  );
}
