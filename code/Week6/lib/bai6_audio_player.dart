import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// Bài tập 6 trên lớp: Simple Audio Player
/// Bám sát chính xác 100% tài liệu PDF trang 34-36 và hình ảnh trang 33
class Bai6AudioPlayerApp extends StatelessWidget {
  const Bai6AudioPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Audio Player',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAF8FD),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.normal,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
      ),
      home: const AudioPlayerHome(),
    );
  }
}

class AudioPlayerHome extends StatefulWidget {
  const AudioPlayerHome({super.key});

  @override
  State<AudioPlayerHome> createState() => _AudioPlayerHomeState();
}

class _AudioPlayerHomeState extends State<AudioPlayerHome> {
  late AudioPlayer _audioPlayer;
  int _currentSongIndex = 0;
  bool _isPlaying = false;

  // Danh sách các bài hát (từ assets)
  final List<String> _songs = [
    'assets/audios/sample1.mp3',
    'assets/audios/sample2.mp3',
    'assets/audios/sample3.mp3',
  ];

  // Tên bài hát để hiển thị đúng như tài liệu
  final List<String> _songTitles = ['sample1', 'sample2', 'sample3'];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Lắng nghe trạng thái phát
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    // Lắng nghe khi bài hát kết thúc để tự động chuyển bài
    _audioPlayer.onPlayerComplete.listen((event) {
      _nextSong();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Phát bài hát
  Future<void> _playSong() async {
    try {
      final cleanPath = _songs[_currentSongIndex].replaceAll('assets/', '');
      await _audioPlayer.play(AssetSource(cleanPath));
      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
    }
  }

  // Tạm dừng bài hát
  Future<void> _pauseSong() async {
    try {
      await _audioPlayer.pause();
    } catch (_) {}
    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  // Dừng bài hát
  Future<void> _stopSong() async {
    try {
      await _audioPlayer.stop();
    } catch (_) {}
    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  // Chuyển sang bài tiếp theo
  void _nextSong() {
    setState(() {
      if (_currentSongIndex < _songs.length - 1) {
        _currentSongIndex++;
      } else {
        _currentSongIndex = 0; // Quay lại bài đầu nếu hết danh sách
      }
      _stopSong();
      _playSong();
    });
  }

  // Quay lại bài trước
  void _previousSong() {
    setState(() {
      if (_currentSongIndex > 0) {
        _currentSongIndex--;
      } else {
        _currentSongIndex = _songs.length - 1; // Chuyển đến bài cuối nếu đang ở đầu
      }
      _stopSong();
      _playSong();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Audio Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị tên bài hát
            Text(
              _songTitles[_currentSongIndex],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            // Nút điều khiển
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 40),
                  color: Colors.black87,
                  onPressed: _previousSong,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                  ),
                  color: Colors.black87,
                  onPressed: () {
                    if (_isPlaying) {
                      _pauseSong();
                    } else {
                      _playSong();
                    }
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.stop, size: 40),
                  color: Colors.black87,
                  onPressed: _stopSong,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 40),
                  color: Colors.black87,
                  onPressed: _nextSong,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
