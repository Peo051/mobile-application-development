import 'package:flutter/material.dart';
import 'package:lab02/thesis_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thông tin đồ án',
      theme: ThemeData(useMaterial3: true),
      home: const ThesisPage(),
    );
  }
}
