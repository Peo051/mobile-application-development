import 'package:flutter/material.dart';

import 'music_control_button.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  bool isPlaying = false;
  bool isFavorite = true;
  bool isShuffleEnabled = false;
  bool isRepeatEnabled = false;

  double currentPosition = 0.0;
  final double songDuration = 262.0;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  void togglePlaying() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      showMessage('Đang phát nhạc');
    } else {
      showMessage('Đã tạm dừng');
    }
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void toggleShuffle() {
    setState(() {
      isShuffleEnabled = !isShuffleEnabled;
    });

    if (isShuffleEnabled) {
      showMessage('Đã bật phát ngẫu nhiên');
    } else {
      showMessage('Đã tắt phát ngẫu nhiên');
    }
  }

  void toggleRepeat() {
    setState(() {
      isRepeatEnabled = !isRepeatEnabled;
    });

    if (isRepeatEnabled) {
      showMessage('Đã bật lặp lại');
    } else {
      showMessage('Đã tắt lặp lại');
    }
  }

  String formatTime(double seconds) {
    int totalSeconds = seconds.round();
    int minutes = totalSeconds ~/ 60;
    int remainingSeconds = totalSeconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTopButton(
                    icon: Icons.arrow_back,
                    onPressed: () {
                      showMessage('Quay lại');
                    },
                  ),
                  const Text(
                    'P L A Y L I S T',
                    style: TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  _buildTopButton(
                    icon: Icons.menu,
                    onPressed: () {
                      showMessage('Mở danh sách nhạc');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFECECEC),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 10,
                      offset: Offset(4, 5),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 8,
                      offset: Offset(-4, -4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/album_birdie.jpg',
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,

                        errorBuilder:
                            (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) {
                              return Container(
                                width: double.infinity,
                                height: 300,
                                color: const Color(0xFFE98C77),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                  size: 90,
                                ),
                              );
                            },
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kota The Friend',
                                style: TextStyle(
                                  color: Color(0xFF555555),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Birdie',
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: toggleFavorite,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? const Color(0xFFFF4545)
                                : const Color(0xFF777777),
                            size: 31,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Text(
                      formatTime(currentPosition),
                      style: const TextStyle(
                        color: Color(0xFF696969),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: toggleShuffle,
                          icon: Icon(
                            Icons.shuffle,
                            color: isShuffleEnabled
                                ? const Color(0xFF42B653)
                                : const Color(0xFF555555),
                          ),
                        ),
                        IconButton(
                          onPressed: toggleRepeat,
                          icon: Icon(
                            Icons.repeat,
                            color: isRepeatEnabled
                                ? const Color(0xFF42B653)
                                : const Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      formatTime(songDuration),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFF696969),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFECECEC),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 7,
                      offset: Offset(3, 4),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 7,
                      offset: Offset(-3, -3),
                    ),
                  ],
                ),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF42B653),
                    inactiveTrackColor: const Color(0xFFD4D4D4),
                    thumbColor: const Color(0xFF42B653),
                    overlayColor: const Color(0x3342B653),
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 7,
                    ),
                  ),
                  child: Slider(
                    min: 0,
                    max: songDuration,
                    value: currentPosition,
                    onChanged: (value) {
                      setState(() {
                        currentPosition = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MusicControlButton(
                    icon: Icons.skip_previous,
                    onPressed: () {
                      setState(() {
                        currentPosition = 0;
                      });

                      showMessage('Chuyển về bài trước');
                    },
                  ),
                  MusicControlButton(
                    icon: isPlaying ? Icons.pause : Icons.play_arrow,
                    width: 90,
                    height: 70,
                    iconSize: 38,
                    onPressed: togglePlaying,
                  ),
                  MusicControlButton(
                    icon: Icons.skip_next,
                    onPressed: () {
                      setState(() {
                        currentPosition = 0;
                      });

                      showMessage('Chuyển sang bài tiếp theo');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFECECEC),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 7,
            offset: Offset(3, 4),
          ),
          BoxShadow(color: Colors.white, blurRadius: 7, offset: Offset(-3, -3)),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: const Color(0xFF3F3F3F), size: 23),
      ),
    );
  }
}
