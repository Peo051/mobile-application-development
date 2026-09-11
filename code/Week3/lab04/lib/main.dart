import 'package:flutter/material.dart';
import 'package:lab04/group_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thông tin CNTT',
      theme: ThemeData(useMaterial3: true),
      home: const GroupPage(),
    );
  }
}
