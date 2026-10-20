import 'package:flutter/material.dart';

import 'screens/bai8_menu_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService.instance;
  await notificationService.initialize();

  runApp(Week8App(notificationService: notificationService));
}

class Week8App extends StatelessWidget {
  const Week8App({super.key, required this.notificationService});

  final NotificationService notificationService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài 08: Notification và File',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
      ),
      home: Bai8MenuScreen(notificationService: notificationService),
    );
  }
}
