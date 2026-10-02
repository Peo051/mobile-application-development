import 'dart:io' show File, Platform;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Bài tập 2: Photo Capture & Preview
/// Chuẩn theo tài liệu Bai06_Chuong4_Multimedia.pdf (Trang 15 - 18)
/// Tương thích 100% cả Flutter Mobile (Android, iOS) và Flutter Web / Desktop (Image.memory, chống lỗi !kIsWeb).
class Bai2PhotoCaptureApp extends StatelessWidget {
  const Bai2PhotoCaptureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const PhotoCaptureHome();
  }
}

class PhotoCaptureHome extends StatefulWidget {
  const PhotoCaptureHome({super.key});

  @override
  State<PhotoCaptureHome> createState() => _PhotoCaptureHomeState();
}

class _PhotoCaptureHomeState extends State<PhotoCaptureHome> {
  File? _imageFile;
  Uint8List? _imageBytes;
  bool _isAssetImage = false;
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

  // Chọn ảnh từ gallery
  Future<void> _pickImageFromGallery() async {
    await _requestPermission(Permission.photos);

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        final Uint8List bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageFile = kIsWeb ? null : File(pickedFile.path);
          _isAssetImage = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chưa chọn ảnh nào.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi mở thư viện ảnh: $e'),
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

  // Chụp ảnh từ camera
  Future<void> _captureImageFromCamera() async {
    await _requestPermission(Permission.camera);

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? capturedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (capturedFile != null) {
        final Uint8List bytes = await capturedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageFile = kIsWeb ? null : File(capturedFile.path);
          _isAssetImage = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chưa chụp ảnh nào.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi máy ảnh: $e'),
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

  // Tải ảnh mẫu hoa tulip từ tài liệu
  void _loadSampleTulipImage() {
    setState(() {
      _imageBytes = null;
      _imageFile = null;
      _isAssetImage = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã tải ảnh mẫu hoa tulip từ tài liệu!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Xem trước ảnh toàn màn hình
  void _showFullScreenPreview(BuildContext context) {
    if (_isAssetImage) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FullScreenAssetImage(
            assetPath: 'assets/images/tulip.jpg',
          ),
        ),
      );
    } else if (_imageBytes != null || _imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImage(
            imageBytes: _imageBytes,
            imageFile: _imageFile,
          ),
        ),
      );
    }
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
          'Photo Capture & Preview',
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                              'Đang xử lý hình ảnh...',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        )
                      : _isAssetImage
                          ? GestureDetector(
                              onTap: () => _showFullScreenPreview(context),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/tulip.jpg',
                                  height: 260,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          : _imageBytes != null
                              ? GestureDetector(
                                  onTap: () => _showFullScreenPreview(context),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      _imageBytes!,
                                      height: 260,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                )
                              : (_imageFile != null && !kIsWeb)
                                  ? GestureDetector(
                                      onTap: () => _showFullScreenPreview(context),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          _imageFile!,
                                          height: 260,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Chưa có ảnh nào được chọn.',
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
                onPressed: _pickImageFromGallery,
              ),
              _buildPillButton(
                text: 'Chụp ảnh từ Camera',
                onPressed: _captureImageFromCamera,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Màn hình xem ảnh toàn màn hình (hỗ trợ cả Bytes và File)
class FullScreenImage extends StatelessWidget {
  final Uint8List? imageBytes;
  final File? imageFile;

  const FullScreenImage({
    super.key,
    this.imageBytes,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Xem trước'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: InteractiveViewer(
          child: imageBytes != null
              ? Image.memory(imageBytes!)
              : (imageFile != null && !kIsWeb)
                  ? Image.file(imageFile!)
                  : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

/// Màn hình xem ảnh toàn màn hình từ Asset
class FullScreenAssetImage extends StatelessWidget {
  final String assetPath;

  const FullScreenAssetImage({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Xem trước'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.asset(assetPath),
        ),
      ),
    );
  }
}
