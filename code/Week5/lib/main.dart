import 'package:flutter/material.dart';

import 'bai_03.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quà của Vinh',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F4F7),
        useMaterial3: true,
      ),
      home: const Bai03Page(),
    );
  }
}
