import 'dart:io' show File, Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

/// Bài tập 4: Video Recorder & Playback
/// Chuẩn theo tài liệu Bai06_Chuong4_Multimedia.pdf (Trang 25 - 28)
/// Tương thích 100% cả Flutter Mobile (Android, iOS) và Flutter Web / Desktop (tránh lỗi kIsWeb, hỗ trợ URL blob và video mẫu).
class Bai4VideoRecorderApp extends StatelessWidget {
  const Bai4VideoRecorderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const VideoRecorderHome();
  }
}

class VideoRecorderHome extends StatefulWidget {
  const VideoRecorderHome({super.key});

  @override
  State<VideoRecorderHome> createState() => _VideoRecorderHomeState();
}

class _VideoRecorderHomeState extends State<VideoRecorderHome> {
  String? _videoTitle;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Kiểm tra quyền an toàn có timeout (bỏ qua trên Web)
  Future<void> _requestPermission(Permission permission) async {
    if (kIsWeb) return;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final status = await permission.status.timeout(
          const Duration(milliseconds: 1000),
          onTimeout: () => PermissionStatus.granted,
        );
        if (status.isDenied) {
          await permission.request().timeout(
            const Duration(milliseconds: 1500),
            onTimeout: () => PermissionStatus.granted,
          );
        }
      }
    } catch (e) {
      debugPrint('Permission request error (ignored): $e');
    }
  }

  // Chọn video từ Gallery
  Future<void> _pickVideoFromGallery() async {
    // Xin quyền video/bộ nhớ trên Android/iOS
    await _requestPermission(Permission.storage);

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        await _loadVideo(pickedFile);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chưa chọn video nào.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi mở thư viện video: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Quay video từ camera
  Future<void> _recordVideoFromCamera() async {
    await _requestPermission(Permission.camera);
    await _requestPermission(Permission.microphone);

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? recordedFile = await _picker.pickVideo(
        source: ImageSource.camera,
      );
      if (recordedFile != null) {
        await _loadVideo(recordedFile);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chưa quay video nào.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi camera quay video: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Khởi tạo và nạp video tương thích cả Web lẫn Mobile
  Future<void> _loadVideo(XFile fileItem) async {
    final String path = fileItem.path;
    try {
      await _disposeVideoController();

      VideoPlayerController controller;
      if (kIsWeb) {
        controller = VideoPlayerController.networkUrl(Uri.parse(path));
      } else {
        controller = VideoPlayerController.file(File(path));
      }

      await controller.initialize();
      if (mounted) {
        setState(() {
          _videoTitle = fileItem.name;
          _videoController = controller;
        });
        controller.play();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi giải mã video: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // Tải video mẫu online để kiểm tra nhanh (hữu ích khi máy ảo/web chưa có sẵn file mp4)
  Future<void> _loadSampleOnlineVideo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _disposeVideoController();
      // Video mẫu MP4 công khai siêu nhẹ của Flutter
      final controller = VideoPlayerController.networkUrl(
        Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
      );
      await controller.initialize();
      if (mounted) {
        setState(() {
          _videoTitle = 'butterfly.mp4 (Sample)';
          _videoController = controller;
        });
        controller.play();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã tải video mẫu thành công!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể tải video mẫu: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _disposeVideoController() async {
    if (_videoController != null) {
      await _videoController!.pause();
      await _videoController!.dispose();
      _videoController = null;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Widget _buildPillButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF2EDF7),
          foregroundColor: const Color(0xFF37286B),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFE6DEEB), width: 0.8),
          ),
        ),
        onPressed: _isLoading ? null : onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Video Recorder & Playback',
          style: TextStyle(
            color: Color(0xFF1C1B1F),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_collection_outlined),
            tooltip: 'Tải video mẫu online',
            onPressed: _loadSampleOnlineVideo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Khung hiển thị Video (hỗ trợ loading indicator)
              SizedBox(
                height: 240,
                child: Center(
                  child: _isLoading
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text(
                              'Đang tải video...',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        )
                      : _videoController != null &&
                              _videoController!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            )
                          : const Text(
                              'Chưa có video nào được chọn.',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                ),
              ),
              if (_videoTitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  _videoTitle!,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
              const SizedBox(height: 14),
              // Nút Play / Pause tròn màu tím chuẩn giao diện PDF
              if (_videoController != null &&
                  _videoController!.value.isInitialized) ...[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2EDF7),
                    foregroundColor: const Color(0xFF37286B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color: Color(0xFFE6DEEB),
                        width: 0.8,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _videoController!.value.isPlaying
                          ? _videoController!.pause()
                          : _videoController!.play();
                    });
                  },
                  child: Icon(
                    _videoController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 14),
              ],
              _buildPillButton(
                text: 'Chọn video từ Gallery',
                onPressed: _pickVideoFromGallery,
              ),
              _buildPillButton(
                text: 'Quay video từ Camera',
                onPressed: _recordVideoFromCamera,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
