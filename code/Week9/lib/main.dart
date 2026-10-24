// Trần Dương Gia Bảo - 2001240039
import 'package:flutter/material.dart';

import 'views/bai9_menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Week9App());
}

class Week9App extends StatelessWidget {
  const Week9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài 09: Làm việc với cơ sở dữ liệu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF87C8E6)),
        scaffoldBackgroundColor: const Color(0xFFF5FAFD),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5FAFD),
          foregroundColor: Color(0xFF20272B),
          centerTitle: false,
          scrolledUnderElevation: 0,
        ),
      ),
      home: const Bai9MenuScreen(),
    );
  }
}
