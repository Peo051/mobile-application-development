import 'package:flutter/material.dart';

import 'bai1_media_picker.dart';
import 'bai2_photo_capture.dart';
import 'bai3_contacts_sms.dart';
import 'bai4_video_recorder.dart';
import 'bai5_contact_manager.dart';
import 'bai6_audio_player.dart';
import 'bai6_music_player.dart';
import 'bai7_sms_analyzer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Week6MultimediaApp());
}

class Week6MultimediaApp extends StatelessWidget {
  const Week6MultimediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tuần 6 - Multimedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Week6HomeScreen(),
    );
  }
}

class ExerciseItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;
  final String tag;

  ExerciseItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
    required this.tag,
  });
}

class Week6HomeScreen extends StatelessWidget {
  const Week6HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ExerciseItem> exercises = [
      ExerciseItem(
        title: 'Bài tập 1: Media Picker App',
        subtitle: 'Chọn ảnh/video từ Gallery hoặc chụp/quay từ Camera',
        icon: Icons.perm_media,
        color: Colors.blue,
        screen: const Bai1MediaPickerApp(),
        tag: 'Bài 1',
      ),
      ExerciseItem(
        title: 'Bài tập 2: Photo Capture & Preview',
        subtitle: 'Chụp/chọn ảnh và xem trước toàn màn hình',
        icon: Icons.photo_camera_back,
        color: Colors.green,
        screen: const Bai2PhotoCaptureApp(),
        tag: 'Bài 2',
      ),
      ExerciseItem(
        title: 'Bài tập 3: Contacts & SMS Reader',
        subtitle: 'Đọc danh bạ và tin nhắn SMS từ thiết bị Android',
        icon: Icons.contact_phone,
        color: Colors.indigo,
        screen: const Bai3ContactsSmsApp(),
        tag: 'Bài 3',
      ),
      ExerciseItem(
        title: 'Bài tập 4: Video Recorder & Playback',
        subtitle: 'Quay video từ Camera, chọn từ Gallery và Play/Pause',
        icon: Icons.video_camera_back,
        color: Colors.purple,
        screen: const Bai4VideoRecorderApp(),
        tag: 'Bài 4',
      ),
      ExerciseItem(
        title: 'Bài tập 5: Quản lý và thêm danh bạ',
        subtitle: 'Đọc danh sách và thêm danh bạ mới kèm ảnh đại diện',
        icon: Icons.person_add_alt_1,
        color: Colors.teal,
        screen: const Bai5ContactManagerApp(),
        tag: 'Bài 5',
      ),
      ExerciseItem(
        title: 'Bài tập 6 (Trên lớp): Simple Audio Player',
        subtitle: 'Phát nhạc từ Assets: Play, Pause, Stop, Next, Previous',
        icon: Icons.music_note,
        color: Colors.deepOrange,
        screen: const Bai6AudioPlayerApp(),
        tag: 'Bài 6.1',
      ),
      ExerciseItem(
        title: 'Bài tập 6 (Về nhà): Ứng dụng nghe nhạc',
        subtitle: 'Giao diện nghe nhạc theo ảnh mẫu (Now Playing & Playlist)',
        icon: Icons.album,
        color: Colors.pink,
        screen: const Bai6MusicPlayerApp(),
        tag: 'Bài 6.2',
      ),
      ExerciseItem(
        title: 'Bài tập 7 (Về nhà): SMS Analyzer',
        subtitle: 'Thống kê, lọc người gửi, phân loại [QC] và trích xuất [OTP]',
        icon: Icons.analytics,
        color: const Color(0xFF1E3A8A),
        tag: 'Bài 7',
        screen: const Bai7SmsAnalyzerApp(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tuần 6: Multimedia',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Bài tập thực hành Lập trình di động',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: exercises.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = exercises[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item.screen),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, color: item.color, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: item.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: item.color.withValues(alpha: 0.5),
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  item.tag,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: item.color,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
