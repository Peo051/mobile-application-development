import 'package:flutter/material.dart';
import 'package:lab03/product_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thông tin sản phẩm',
      theme: ThemeData(useMaterial3: true),
      home: const ProductPage(),
    );
  }
}
