import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// Bài tập 6 về nhà: Ứng dụng nghe nhạc theo ảnh mẫu
/// Thiết kế giao diện hiện đại với 2 chế độ: Màn hình Đĩa nhạc (Now Playing)
/// và Màn hình Danh sách bài hát (Playlist).
class Bai6MusicPlayerApp extends StatelessWidget {
  const Bai6MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MusicPlayerHome();
  }
}

class SongModel {
  final String title;
  final String artist;
  final String assetPath;
  final String durationText;
  bool isFavorite;

  SongModel({
    required this.title,
    required this.artist,
    required this.assetPath,
    required this.durationText,
    this.isFavorite = false,
  });
}

class MusicPlayerHome extends StatefulWidget {
  const MusicPlayerHome({super.key});

  @override
  State<MusicPlayerHome> createState() => _MusicPlayerHomeState();
}

class _MusicPlayerHomeState extends State<MusicPlayerHome> {
  late AudioPlayer _audioPlayer;
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = const Duration(minutes: 3);
  bool _showPlaylist = false; // Chuyển đổi giữa Now Playing và Playlist

  // Danh sách bài hát
  final List<SongModel> _playlist = [
    SongModel(
      title: 'Em Của Ngày Hôm Qua',
      artist: 'Sơn Tùng M-TP',
      assetPath: 'audios/sample1.mp3',
      durationText: '3:45',
    ),
    SongModel(
      title: 'Nơi Này Có Anh',
      artist: 'Sơn Tùng M-TP',
      assetPath: 'audios/sample2.mp3',
      durationText: '4:20',
    ),
    SongModel(
      title: 'Cơn Mưa Ngang Qua',
      artist: 'Sơn Tùng M-TP',
      assetPath: 'audios/sample3.mp3',
      durationText: '3:50',
    ),
    SongModel(
      title: 'Lạc Trôi',
      artist: 'Sơn Tùng M-TP',
      assetPath: 'audios/sample1.mp3',
      durationText: '4:12',
    ),
    SongModel(
      title: 'Chúng Ta Của Hiện Tại',
      artist: 'Sơn Tùng M-TP',
      assetPath: 'audios/sample2.mp3',
      durationText: '5:01',
    ),
    SongModel(
      title: 'Muộn Rồi Mà Sao Còn',
      artist: 'Sơn Tùng M-TP',
      assetPath: 'audios/sample3.mp3',
      durationText: '4:35',
    ),
    SongModel(
      title: 'Making My Way',
      artist: 'Sơn Tùng M-TP',
      assetPath: 'audios/sample1.mp3',
      durationText: '3:15',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Lắng nghe trạng thái phát
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    // Lắng nghe vị trí phát nhạc
    _audioPlayer.onPositionChanged.listen((pos) {
      if (mounted) {
        setState(() {
          _currentPosition = pos;
        });
      }
    });

    // Lắng nghe tổng thời lượng
    _audioPlayer.onDurationChanged.listen((dur) {
      if (mounted && dur.inSeconds > 0) {
        setState(() {
          _totalDuration = dur;
        });
      }
    });

    // Tự động chuyển bài khi kết thúc
    _audioPlayer.onPlayerComplete.listen((event) {
      _nextSong();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSong(int index) async {
    setState(() {
      _currentIndex = index;
    });

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(_playlist[index].assetPath));
      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đang phát mô phỏng: ${_playlist[index].title}.\n(Tập tin ${_playlist[index].assetPath} chưa có nội dung thật)',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        // Vẫn bật trạng thái mô phỏng cho người dùng trải nghiệm UI
        setState(() {
          _isPlaying = true;
        });
      }
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      _playSong(_currentIndex);
    }
  }

  void _nextSong() {
    int next = (_currentIndex + 1) % _playlist.length;
    _playSong(next);
  }

  void _prevSong() {
    int prev = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    _playSong(prev);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140822),
      appBar: AppBar(
        title: Text(_showPlaylist ? 'Danh sách phát' : 'Trình phát nhạc'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showPlaylist ? Icons.album : Icons.queue_music),
            tooltip: _showPlaylist ? 'Xem đĩa nhạc' : 'Xem danh sách bài hát',
            onPressed: () {
              setState(() {
                _showPlaylist = !_showPlaylist;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1C0A33), Color(0xFF4A104E), Color(0xFF160624)],
          ),
        ),
        child: SafeArea(
          child: _showPlaylist ? _buildPlaylistView() : _buildNowPlayingView(),
        ),
      ),
    );
  }


  Widget _buildNowPlayingView() {
    final currentSong = _playlist[_currentIndex];
    final double progress = _totalDuration.inSeconds > 0
        ? (_currentPosition.inSeconds / _totalDuration.inSeconds).clamp(
            0.0,
            1.0,
          )
        : 0.35;

    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'ALBUM',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
        const Spacer(),
        // Vòng đĩa tròn màu trắng với hiệu ứng xoay và vạch progress cung tròn
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Vòng cung progress ngoài cùng
              SizedBox(
                width: 250,
                height: 250,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3.5,
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              // Đĩa than trắng tròn lớn
              Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  // Vòng tâm đĩa màu xám nhạt
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EBF5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: Center(
                      // Nút play tròn màu tím hồng ở chính giữa
                      child: GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFC2185B),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Tên bài hát và Nghệ sĩ
        Text(
          currentSong.title.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          currentSong.artist.toUpperCase(),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        // Thanh điều khiển màu trắng dưới đáy (theo thiết kế mẫu)
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hàng nút: Menu, Prev, Favorite, Share, Next
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFFC2185B)),
                    onPressed: () {
                      setState(() {
                        _showPlaylist = true;
                      });
                    },
                    tooltip: 'Danh sách bài hát',
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Color(0xFFC2185B),
                      size: 28,
                    ),
                    onPressed: _prevSong,
                    tooltip: 'Bài trước',
                  ),
                  IconButton(
                    icon: Icon(
                      currentSong.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: const Color(0xFFC2185B),
                      size: 26,
                    ),
                    onPressed: () {
                      setState(() {
                        currentSong.isFavorite = !currentSong.isFavorite;
                      });
                    },
                    tooltip: 'Yêu thích',
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.share,
                      color: Color(0xFFC2185B),
                      size: 24,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Chia sẻ bài hát: ${currentSong.title}',
                          ),
                        ),
                      );
                    },
                    tooltip: 'Chia sẻ',
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.skip_next,
                      color: Color(0xFFC2185B),
                      size: 28,
                    ),
                    onPressed: _nextSong,
                    tooltip: 'Bài tiếp',
                  ),
                ],
              ),
              // Slider tiến trình bài hát
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3.0,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 14,
                  ),
                  activeTrackColor: const Color(0xFFC2185B),
                  inactiveTrackColor: const Color(0xFFE0C5DC),
                  thumbColor: const Color(0xFFC2185B),
                ),
                child: Slider(
                  value: progress,
                  onChanged: (val) {
                    final target = Duration(
                      seconds: (val * _totalDuration.inSeconds).toInt(),
                    );
                    _audioPlayer.seek(target);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_currentPosition),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFC2185B),
                      ),
                    ),
                    Text(
                      _formatDuration(_totalDuration),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // Mũi tên thu nhỏ
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFFC2185B),
                size: 22,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 2. Màn hình danh sách phát Playlist (Ảnh mẫu bên phải)
  Widget _buildPlaylistView() {
    final currentSong = _playlist[_currentIndex];
    final double progress = _totalDuration.inSeconds > 0
        ? (_currentPosition.inSeconds / _totalDuration.inSeconds).clamp(
            0.0,
            1.0,
          )
        : 0.35;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        // Header tiêu đề bài đang phát
        Text(
          currentSong.title.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          currentSong.artist.toUpperCase(),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // Mini player bar nền trắng
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3.0,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 5,
                  ),
                  activeTrackColor: const Color(0xFFC2185B),
                  inactiveTrackColor: const Color(0xFFE0C5DC),
                  thumbColor: const Color(0xFFC2185B),
                ),
                child: Slider(
                  value: progress,
                  onChanged: (val) {
                    final target = Duration(
                      seconds: (val * _totalDuration.inSeconds).toInt(),
                    );
                    _audioPlayer.seek(target);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Color(0xFFC2185B),
                      size: 26,
                    ),
                    onPressed: _prevSong,
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC2185B),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(
                      Icons.skip_next,
                      color: Color(0xFFC2185B),
                      size: 26,
                    ),
                    onPressed: _nextSong,
                  ),
                ],
              ),
            ],
          ),
        ),
        // Danh sách bài hát dạng bảng phẳng
        Expanded(
          child: Container(
            color: const Color(0xFF202024),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _playlist.length,
              separatorBuilder: (context, index) => Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: const Color(0xFF4A104E).withValues(alpha: 0.5),
              ),
              itemBuilder: (context, index) {
                final song = _playlist[index];
                final bool isThisPlaying = index == _currentIndex;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Số thứ tự 1., 2., 3.
                      SizedBox(
                        width: 24,
                        child: Text(
                          '${index + 1}.',
                          style: TextStyle(
                            color: isThisPlaying
                                ? const Color(0xFFE91E63)
                                : Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Ô màu vuông nhỏ đại diện bìa album
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isThisPlaying
                              ? const Color(0xFFE91E63)
                              : const Color(0xFFB06090),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: isThisPlaying && _isPlaying
                            ? const Icon(
                                Icons.equalizer,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    ],
                  ),
                  title: Text(
                    song.title,
                    style: TextStyle(
                      color: isThisPlaying
                          ? const Color(0xFFFF80AB)
                          : Colors.white,
                      fontSize: 14,
                      fontWeight: isThisPlaying
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    song.artist,
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        song.durationText,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.more_vert,
                        color: Color(0xFFE91E63),
                        size: 20,
                      ),
                    ],
                  ),
                  onTap: () {
                    _playSong(index);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
