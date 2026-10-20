import 'package:flutter/material.dart';

import '../services/notification_service.dart';

class NotificationDemoScreen extends StatefulWidget {
  const NotificationDemoScreen({super.key, required this.notificationService});

  final NotificationService notificationService;

  @override
  State<NotificationDemoScreen> createState() => _NotificationDemoScreenState();
}

class _NotificationDemoScreenState extends State<NotificationDemoScreen> {
  bool _busy = false;

  Future<void> _perform(
    Future<NotificationReceipt> Function() action, {
    required String successMessage,
  }) async {
    setState(() => _busy = true);
    try {
      final receipt = await action();
      if (!mounted) return;
      final timingMessage = receipt.exactTime
          ? successMessage
          : '$successMessage Android có thể giao thông báo trễ khi máy ở chế độ tiết kiệm pin.';
      _showMessage(timingMessage);
    } catch (error) {
      if (mounted) _showMessage(error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài tập 1: Thông báo')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Thực hành Local Notification',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _busy
                      ? null
                      : () => _perform(
                          () => widget.notificationService.showNow(
                            title: 'Nhắc học Ngoại ngữ',
                            body: 'Đã đến lúc học Ngoại ngữ rồi!',
                          ),
                          successMessage: 'Đã gửi thông báo nhắc học.',
                        ),
                  child: const Text('Gửi thông báo nhắc học Ngoại ngữ'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _busy
                      ? null
                      : () => _perform(
                          () => widget.notificationService.scheduleAt(
                            title: 'Nhắc uống nước',
                            body: 'Đã đến lúc uống nước.',
                            scheduledAt: DateTime.now().add(
                              const Duration(minutes: 2),
                            ),
                          ),
                          successMessage:
                              'Đã đặt lịch nhắc uống nước sau 2 phút.',
                        ),
                  child: const Text('Gửi thông báo nhắc uống nước sau 2 phút'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _busy
                      ? null
                      : () => _perform(
                          () => widget.notificationService.scheduleAt(
                            title: 'Nhắc học Ngoại ngữ',
                            body: 'Đã đến giờ học Ngoại ngữ.',
                            scheduledAt: DateTime.now().add(
                              const Duration(minutes: 10),
                            ),
                          ),
                          successMessage:
                              'Đã đặt lịch học Ngoại ngữ sau 10 phút.',
                        ),
                  child: const Text(
                    'Hẹn giờ gửi thông báo học Ngoại ngữ sau 10 phút',
                  ),
                ),
                if (_busy) ...[
                  const SizedBox(height: 20),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
