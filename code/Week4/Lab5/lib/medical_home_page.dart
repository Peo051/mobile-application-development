import 'package:flutter/material.dart';
import 'category_item.dart';
import 'doctor_card.dart';

class MedicalHomePage extends StatefulWidget {
  const MedicalHomePage({super.key});

  @override
  State<MedicalHomePage> createState() => _MedicalHomePageState();
}

class _MedicalHomePageState extends State<MedicalHomePage> {
  int selectedCategoryIndex = 0;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  void selectCategory(int index, String categoryName) {
    setState(() {
      selectedCategoryIndex = index;
    });

    showMessage('Bạn đã chọn chuyên khoa $categoryName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,',
                        style: TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Mitch Koko',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      showMessage('Mở tài khoản cá nhân');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9CBF1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person, color: Color(0xFF33215B)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB4C9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFFA38AD2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.medical_information_outlined,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'How do you feel?',
                            style: TextStyle(
                              color: Color(0xFF513E59),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 7),

                          const Text(
                            'Fill out your medical card right now',
                            style: TextStyle(
                              color: Color(0xFF755D70),
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 38,
                            child: ElevatedButton(
                              onPressed: () {
                                showMessage('Bắt đầu điền hồ sơ y tế');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF906ACA),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                              child: const Text(
                                'Get Started',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                height: 58,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6C8ED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Color(0xFF74648D)),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'How can we help you?',
                          hintStyle: TextStyle(color: Color(0xFF74648D)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryItem(
                      icon: Icons.medical_services_outlined,
                      title: 'Dentist',
                      iconColor: const Color(0xFF665383),
                      isSelected: selectedCategoryIndex == 0,
                      onTap: () {
                        selectCategory(0, 'Dentist');
                      },
                    ),

                    const SizedBox(width: 12),

                    CategoryItem(
                      icon: Icons.person_search,
                      title: 'Surgeon',
                      iconColor: const Color(0xFF2E9488),
                      isSelected: selectedCategoryIndex == 1,
                      onTap: () {
                        selectCategory(1, 'Surgeon');
                      },
                    ),

                    const SizedBox(width: 12),

                    CategoryItem(
                      icon: Icons.medication,
                      title: 'Pharmacy',
                      iconColor: const Color(0xFFE95A83),
                      isSelected: selectedCategoryIndex == 2,
                      onTap: () {
                        selectCategory(2, 'Pharmacy');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Doctor list',
                    style: TextStyle(
                      color: Color(0xFF383838),
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showMessage('Xem tất cả bác sĩ');
                    },
                    child: const Text(
                      'See all',
                      style: TextStyle(color: Color(0xFF888888)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DoctorCard(
                      doctorName: 'Dr. Mitch Koko',
                      specialty: 'Psychologist 7 years',
                      rating: 4.4,
                      backgroundColor: const Color(0xFFCBB9E8),
                      imagePath: 'assets/images/doctor_1.jpg',
                      onTap: () {
                        showMessage('Bạn đã chọn Dr. Mitch Koko');
                      },
                    ),

                    const SizedBox(width: 15),

                    DoctorCard(
                      doctorName: 'Dr. Steve Jobs',
                      specialty: 'Surgeon 7 years',
                      rating: 5.0,
                      backgroundColor: const Color(0xFFCBB9E8),
                      imagePath: 'assets/images/doctor_2.jpg',
                      onTap: () {
                        showMessage('Bạn đã chọn Dr. Steve Jobs');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
