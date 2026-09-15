import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Daily Status',
      debugShowCheckedModeBanner: false,
      home: DailyStatusPage(),
    );
  }
}

class DailyStatusPage extends StatefulWidget {
  const DailyStatusPage({super.key});

  @override
  State<DailyStatusPage> createState() => _DailyStatusPageState();
}

class _DailyStatusPageState extends State<DailyStatusPage> {
  int _selectedMoodIndex = 1;
  int _selectedNavigationIndex = 0;

  final List<String> _moodIcons = ['😩', '🙂', '😄', '🥳'];
  final List<String> _moodNames = ['Bad', 'Fine', 'Well', 'Excellent'];

  void _selectMood(int index) {
    setState(() {
      _selectedMoodIndex = index;
    });
  }

  void _onNavigationTapped(int index) {
    setState(() {
      _selectedNavigationIndex = index;
    });

    String message;

    if (index == 0) {
      message = 'Home';
    } else if (index == 1) {
      message = 'Messages';
    } else {
      message = 'Profile';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bạn đã chọn $message'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      body: SafeArea(
        child: Column(
          children: [
            // Phần nền màu xanh phía trên
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
              decoration: const BoxDecoration(
                color: Color(0xFF1764C0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dòng chào và nút thông báo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, Jared!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '23 Jan, 2021',
                            style: TextStyle(
                              color: Color(0xFF9CC7F5),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C8CE5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Không có thông báo mới'),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Ô tìm kiếm
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2382DD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tiêu đề tình trạng
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'How do you feel?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Danh sách tình trạng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      _moodIcons.length,
                      (index) {
                        return _buildMoodItem(index);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Phần Exercises
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                color: const Color(0xFFF2F2F2),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Exercises',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: Color(0xFF555555),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _buildExerciseCard(
                      icon: Icons.favorite,
                      iconColor: const Color(0xFFFF9500),
                      title: 'Speaking Skills',
                      subtitle: '16 Exercises',
                    ),

                    const SizedBox(height: 12),

                    _buildExerciseCard(
                      icon: Icons.person,
                      iconColor: const Color(0xFF39AD5A),
                      title: 'Reading Skills',
                      subtitle: '8 Exercises',
                    ),

                    const SizedBox(height: 12),

                    _buildExerciseCard(
                      icon: Icons.star,
                      iconColor: const Color(0xFFE91E63),
                      title: 'Writing Skills',
                      subtitle: '20 Exercises',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Thanh điều hướng dưới
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavigationIndex,
        onTap: _onNavigationTapped,
        selectedItemColor: const Color(0xFF1688DF),
        unselectedItemColor: const Color(0xFF555555),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Widget tạo một tình trạng
  Widget _buildMoodItem(int index) {
    bool isSelected = _selectedMoodIndex == index;

    return GestureDetector(
      onTap: () {
        _selectMood(index);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Tình trạng đã chọn: ${_moodNames[index]}',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 55,
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF4FA6F0)
                  : const Color(0xFF287FD5),
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: Colors.white,
                      width: 2,
                    )
                  : null,
            ),
            child: Text(
              _moodIcons[index],
              style: const TextStyle(fontSize: 25),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            _moodNames[index],
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Widget tạo một thẻ bài tập
  Widget _buildExerciseCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      height: 74,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF444444),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.more_horiz,
            color: Color(0xFF555555),
          ),
        ],
      ),
    );
  }
}