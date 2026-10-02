import 'dart:io' show File, Platform;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

/// Bài tập 1: Media Picker App
/// Chuẩn theo tài liệu Bai06_Chuong4_Multimedia.pdf (Trang 8 - 14)
/// Tương thích 100% cả Flutter Mobile (Android, iOS) và Flutter Web / Desktop (Image.memory, chống lỗi !kIsWeb).
class Bai1MediaPickerApp extends StatelessWidget {
  const Bai1MediaPickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MediaPickerHome();
  }
}

class MediaPickerHome extends StatefulWidget {
  const MediaPickerHome({super.key});

  @override
  State<MediaPickerHome> createState() => _MediaPickerHomeState();
}

class _MediaPickerHomeState extends State<MediaPickerHome> {
  File? _mediaFile; // File phương tiện (khi chạy trên Mobile/Desktop)
  Uint8List? _mediaBytes; // Dữ liệu nhị phân phương tiện (tương thích 100% Flutter Web)
  bool _isAssetImage = false; // Đánh dấu nếu đang hiển thị ảnh mẫu từ asset
  VideoPlayerController? _videoController; // Điều khiển phát video
  final ImagePicker _picker = ImagePicker(); // Khởi tạo ImagePicker
  bool _isLoading = false; // Trạng thái đang tải / mở bộ chọn phương tiện

  // Kiểm tra và yêu cầu quyền truy cập an toàn (bỏ qua trên Web và có timeout chống treo trên Mobile)
  Future<void> _requestPermission(Permission permission) async {
    if (kIsWeb) return; // Trên Web không dùng permission_handler
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

  // Chọn ảnh hoặc video từ gallery
  Future<void> _pickMedia(ImageSource source, bool isVideo) async {
    // Yêu cầu quyền bộ nhớ/ảnh an toàn theo tài liệu
    if (isVideo) {
      await _requestPermission(Permission.storage);
    } else {
      await _requestPermission(Permission.photos);
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? rawFile = isVideo
          ? await _picker.pickVideo(source: source)
          : await _picker.pickImage(source: source);

      if (rawFile != null) {
        final XFile fileItem = rawFile;
        final String filePath = fileItem.path;
        final Uint8List bytes = await fileItem.readAsBytes();
        final bool isVideoFile = isVideo ||
            fileItem.name.toLowerCase().endsWith('.mp4') ||
            filePath.toLowerCase().endsWith('.mp4');

        if (isVideoFile) {
          _disposeVideoController();
          VideoPlayerController controller;
          if (kIsWeb) {
            controller = VideoPlayerController.networkUrl(Uri.parse(filePath));
          } else {
            controller = VideoPlayerController.file(File(filePath));
          }
          await controller.initialize();
          if (mounted) {
            setState(() {
              _mediaBytes = bytes;
              _mediaFile = kIsWeb ? null : File(filePath);
              _isAssetImage = false;
              _videoController = controller;
            });
            controller.play();
          }
        } else {
          _disposeVideoController();
          if (mounted) {
            setState(() {
              _mediaBytes = bytes;
              _mediaFile = kIsWeb ? null : File(filePath);
              _isAssetImage = false;
              _videoController = null;
            });
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chưa chọn tệp phương tiện nào.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi mở bộ chọn: $e'),
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

  // Chụp ảnh hoặc quay video từ camera
  Future<void> _captureMedia(bool isVideo) async {
    await _requestPermission(Permission.camera);
    if (isVideo) {
      await _requestPermission(Permission.microphone);
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? rawFile = isVideo
          ? await _picker.pickVideo(source: ImageSource.camera)
          : await _picker.pickImage(source: ImageSource.camera);

      if (rawFile != null) {
        final XFile fileItem = rawFile;
        final String filePath = fileItem.path;
        final Uint8List bytes = await fileItem.readAsBytes();

        if (isVideo) {
          _disposeVideoController();
          VideoPlayerController controller;
          if (kIsWeb) {
            controller = VideoPlayerController.networkUrl(Uri.parse(filePath));
          } else {
            controller = VideoPlayerController.file(File(filePath));
          }
          await controller.initialize();
          if (mounted) {
            setState(() {
              _mediaBytes = bytes;
              _mediaFile = kIsWeb ? null : File(filePath);
              _isAssetImage = false;
              _videoController = controller;
            });
            controller.play();
          }
        } else {
          _disposeVideoController();
          if (mounted) {
            setState(() {
              _mediaBytes = bytes;
              _mediaFile = kIsWeb ? null : File(filePath);
              _isAssetImage = false;
              _videoController = null;
            });
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không có tệp nào được chụp/quay.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi camera: $e'),
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

  // Tải ảnh mẫu hoa tulip từ tài liệu (hữu ích khi test trên máy ảo/web chưa có ảnh)
  void _loadSampleTulipImage() {
    _disposeVideoController();
    setState(() {
      _mediaBytes = null;
      _mediaFile = null;
      _isAssetImage = true;
      _videoController = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã tải ảnh mẫu hoa tulip từ tài liệu!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _disposeVideoController() {
    _videoController?.pause();
    _videoController?.dispose();
    _videoController = null;
  }

  @override
  void dispose() {
    _disposeVideoController();
    super.dispose();
  }

  Widget _buildPillButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(vertical: 4),
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
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
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
          'Media Picker App',
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
            icon: const Icon(Icons.image_outlined),
            tooltip: 'Tải ảnh mẫu hoa tulip',
            onPressed: _loadSampleTulipImage,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Vùng hiển thị media (tương thích hoàn toàn cả Web & Mobile)
              SizedBox(
                height: 260,
                child: Center(
                  child: _isLoading
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text(
                              'Đang tải tệp phương tiện...',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        )
                      : _isAssetImage
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/tulip.jpg',
                                height: 260,
                                fit: BoxFit.contain,
                              ),
                            )
                          : _videoController != null &&
                                  _videoController!.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio:
                                      _videoController!.value.aspectRatio,
                                  child: VideoPlayer(_videoController!),
                                )
                              : _mediaBytes != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(
                                        _mediaBytes!,
                                        height: 260,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : (_mediaFile != null && !kIsWeb)
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            _mediaFile!,
                                            height: 260,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      : const Text(
                                          'Chưa chọn ảnh hoặc video.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                          ),
                                        ),
                ),
              ),
              const SizedBox(height: 16),
              _buildPillButton(
                text: 'Chọn ảnh từ Gallery',
                onPressed: () => _pickMedia(ImageSource.gallery, false),
              ),
              _buildPillButton(
                text: 'Chụp ảnh từ Camera',
                onPressed: () => _captureMedia(false),
              ),
              _buildPillButton(
                text: 'Chọn video từ Gallery',
                onPressed: () => _pickMedia(ImageSource.gallery, true),
              ),
              _buildPillButton(
                text: 'Quay video từ Camera',
                onPressed: () => _captureMedia(true),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
