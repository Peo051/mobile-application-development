import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'theme/bt02_theme.dart';

void main() {
  runApp(const BaiTap02App());
}

class BaiTap02App extends StatelessWidget {
  const BaiTap02App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý đồ án',
      theme: buildBt02Theme(),
      home: const HomePage(),
    );
  }
}
