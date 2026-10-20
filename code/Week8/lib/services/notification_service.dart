import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void>? _initialization;
  Future<void>? _idSequenceInitialization;
  Future<void> _idAllocationTail = Future<void>.value();
  Future<bool>? _permissionRequest;
  int? _nextId;
  Object? _pluginInitializationError;
  Object? _timeZoneInitializationError;
  bool _timeZoneReady = false;
  bool _exactAlarmPermissionRequested = false;

  static bool get isSupported {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  Future<void> initialize() {
    return _initialization ??= _initialize();
  }

  Future<void> _initialize() async {
    if (kIsWeb) return;

    try {
      tz_data.initializeTimeZones();
      final deviceTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(deviceTimeZone.identifier));
      _timeZoneReady = true;
    } catch (error) {
      _timeZoneInitializationError = error;
    }

    try {
      const settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );
      await _plugin.initialize(settings: settings);
    } catch (error) {
      _pluginInitializationError = error;
    }
  }

  Future<NotificationReceipt> showNow({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _ensurePluginReady();
    await _requireNotificationPermission();

    final id = await _allocateId();
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: _details,
      payload: payload,
    );
    return NotificationReceipt(id: id, exactTime: true);
  }

  Future<NotificationReceipt> scheduleAt({
    required String title,
    required String body,
    required DateTime scheduledAt,
    String? payload,
    bool repeatDaily = false,
  }) async {
    await _ensurePluginReady();
    if (!_timeZoneReady) {
      throw StateError(
        'Không xác định được múi giờ thiết bị: $_timeZoneInitializationError',
      );
    }
    if (!scheduledAt.isAfter(DateTime.now())) {
      throw ArgumentError.value(
        scheduledAt,
        'scheduledAt',
        'Thời gian nhắc phải ở tương lai.',
      );
    }

    await _requireNotificationPermission();
    final id = await _allocateId();
    final scheduleMode = await _androidScheduleMode();
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledAt, tz.local),
      notificationDetails: _details,
      androidScheduleMode: scheduleMode,
      payload: payload,
      matchDateTimeComponents: repeatDaily ? DateTimeComponents.time : null,
    );
    return NotificationReceipt(
      id: id,
      exactTime: scheduleMode == AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancel(int id) async {
    if (!isSupported) return;
    await _ensurePluginReady();
    await _plugin.cancel(id: id);
  }

  Future<List<PendingNotificationRequest>> pendingNotifications() async {
    if (!isSupported) return [];
    await _ensurePluginReady();
    return _plugin.pendingNotificationRequests();
  }

  Future<void> _ensurePluginReady() async {
    if (!isSupported) {
      throw const NotificationFeatureUnsupportedException();
    }
    await initialize();
    if (_pluginInitializationError != null) {
      throw StateError(
        'NotificationService không khởi tạo được: $_pluginInitializationError',
      );
    }
  }

  Future<void> _requireNotificationPermission() async {
    final request = _permissionRequest ??= _requestPermission();
    try {
      final granted = await request;
      if (!granted) {
        _permissionRequest = null;
        throw const NotificationPermissionDeniedException();
      }
    } catch (_) {
      _permissionRequest = null;
      rethrow;
    }
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final enabled = await android?.areNotificationsEnabled();
      if (enabled == true) return true;
      return await android?.requestNotificationsPermission() ?? false;
    }

    if (Platform.isIOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await ios?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }

    return false;
  }

  Future<AndroidScheduleMode> _androidScheduleMode() async {
    if (!Platform.isAndroid) return AndroidScheduleMode.inexactAllowWhileIdle;

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return AndroidScheduleMode.inexactAllowWhileIdle;

    try {
      var canScheduleExactly = await android.canScheduleExactNotifications();
      if (canScheduleExactly != true && !_exactAlarmPermissionRequested) {
        _exactAlarmPermissionRequested = true;
        await android.requestExactAlarmsPermission();
        canScheduleExactly = await android.canScheduleExactNotifications();
      }

      return canScheduleExactly == true
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;
    } on PlatformException {
      return AndroidScheduleMode.inexactAllowWhileIdle;
    }
  }

  Future<int> _allocateId() async {
    final previousAllocation = _idAllocationTail;
    final allocationComplete = Completer<void>();
    _idAllocationTail = allocationComplete.future;
    await previousAllocation;

    try {
      return await _allocateIdSequentially();
    } finally {
      allocationComplete.complete();
    }
  }

  Future<int> _allocateIdSequentially() async {
    await (_idSequenceInitialization ??= _loadIdSequence());

    final pending = await _plugin.pendingNotificationRequests();
    final pendingIds = pending.map((request) => request.id).toSet();
    var id = _nextId!;
    while (pendingIds.contains(id)) {
      id = _incrementId(id);
    }
    _nextId = _incrementId(id);

    final directory = await getApplicationDocumentsDirectory();
    final file = File(path.join(directory.path, 'notification_id.txt'));
    await file.writeAsString('$_nextId', flush: true);
    return id;
  }

  Future<void> _loadIdSequence() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(path.join(directory.path, 'notification_id.txt'));
    if (await file.exists()) {
      final storedValue = int.tryParse((await file.readAsString()).trim());
      if (storedValue != null && storedValue > 0 && storedValue < 2000000000) {
        _nextId = storedValue;
        return;
      }
    }

    final timeBasedSeed = DateTime.now().microsecondsSinceEpoch.remainder(
      1000000000,
    );
    _nextId = timeBasedSeed == 0 ? 1 : timeBasedSeed;
  }

  int _incrementId(int value) => value >= 1999999999 ? 1 : value + 1;

  static const NotificationDetails _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'bai08_reminders',
      'Nhắc việc và học tập',
      channelDescription: 'Thông báo nhắc việc trong các bài thực hành Bài 8.',
      importance: Importance.max,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );
}

class NotificationReceipt {
  const NotificationReceipt({required this.id, required this.exactTime});

  final int id;
  final bool exactTime;
}

class NotificationPermissionDeniedException implements Exception {
  const NotificationPermissionDeniedException();

  @override
  String toString() =>
      'Bạn chưa cấp quyền thông báo. Hãy bật thông báo cho ứng dụng trong Cài đặt.';
}

class NotificationFeatureUnsupportedException implements Exception {
  const NotificationFeatureUnsupportedException();

  @override
  String toString() => 'Thông báo Bài 8 cần chạy trên Android hoặc iOS.';
}
