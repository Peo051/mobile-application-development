import 'package:flutter/material.dart';

import 'screens/intro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cửa hàng điện thoại',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE0E0E0),
        useMaterial3: true,
      ),
      home: const IntroScreen(),
    );
  }
}
