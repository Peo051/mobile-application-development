import 'package:flutter/material.dart';

/// Model đại diện cho một mục quà tặng
class GiftItem {
  final String brandName;
  final String title;
  final String description;
  final String? expiryDate;
  final String? expiryNotice;
  final String? topTag;
  final String? bottomTag;
  final String assetPath;
  final IconData fallbackIcon;
  final Color fallbackColor;
  final bool hasHeart;
  bool isFavorite;
  final bool isCollectButton;

  GiftItem({
    required this.brandName,
    required this.title,
    required this.description,
    this.expiryDate,
    this.expiryNotice,
    this.topTag,
    this.bottomTag,
    required this.assetPath,
    required this.fallbackIcon,
    required this.fallbackColor,
    this.hasHeart = true,
    this.isFavorite = false,
    this.isCollectButton = false,
  });
}

/// Widget hiển thị ảnh nội bộ với fallback icon khi chưa có file ảnh thực tế
class LocalImagePlaceholder extends StatelessWidget {
  final String assetPath;
  final IconData fallbackIcon;
  final Color? fallbackColor;
  final double size;

  const LocalImagePlaceholder({
    super.key,
    required this.assetPath,
    required this.fallbackIcon,
    this.fallbackColor,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          fallbackIcon,
          size: size,
          color: fallbackColor ?? const Color(0xFFE92E8B),
        );
      },
    );
  }
}

class Bai03Page extends StatefulWidget {
  const Bai03Page({super.key});

  @override
  State<Bai03Page> createState() => _Bai03PageState();
}

class _Bai03PageState extends State<Bai03Page> {
  // Bảng màu chính theo thiết kế
  static const Color primaryPink = Color(0xFFE92E8B);
  static const Color headerPink = Color(0xFFFFF0F7);
  static const Color screenBackground = Color(0xFFF6F4F7);
  static const Color primaryBlue = Color(0xFF1769E8);
  static const Color accentOrange = Color(0xFFF6A623);

  // Danh sách đúng 5 mục quà theo đề bài
  late List<GiftItem> _gifts;

  @override
  void initState() {
    super.initState();
    _gifts = [
      GiftItem(
        brandName: 'CGV',
        title: 'CGV -',
        description: 'Đồng giá 79K khi mua vé CGV 2D trên M...',
        expiryDate: 'HSD: 28/02/2025',
        assetPath: 'assets/images/logocgv.png',
        fallbackIcon: Icons.local_movies_rounded,
        fallbackColor: Colors.red.shade700,
        hasHeart: true,
        isFavorite: false,
        isCollectButton: false,
      ),
      GiftItem(
        brandName: 'Mua Sim\nchính chủ',
        title: 'Giảm 100K',
        description: 'Cho đơn từ 0đ',
        expiryDate: 'HSD: 28/02/2025',
        assetPath: 'assets/images/sim.png',
        fallbackIcon: Icons.sim_card_rounded,
        fallbackColor: primaryPink,
        hasHeart: true,
        isFavorite: true, // Tim màu hồng
        isCollectButton: false,
      ),
      GiftItem(
        brandName: 'Ngân hàng\nQuốc Tế VIB',
        title: 'Tặng 100k',
        description: 'Khi mở thẻ VIB Online Plus 2in1 (*)',
        expiryDate: 'HSD: 31/03/2025',
        bottomTag: 'Quà hiện vật',
        assetPath: 'assets/images/viblogo.png',
        fallbackIcon: Icons.account_balance_rounded,
        fallbackColor: const Color(0xFF004990),
        hasHeart: true,
        isFavorite: false,
        isCollectButton: false,
      ),
      GiftItem(
        brandName: 'Thanh toán\nBảo hiểm',
        title: 'Hoàn 15k',
        description: 'Cho hóa đơn từ 3.000.000đ',
        expiryNotice: 'Hết hạn sau 5 ngày',
        assetPath: 'assets/images/insurance.png',
        fallbackIcon: Icons.umbrella_rounded,
        fallbackColor: const Color(0xFF0084FF),
        hasHeart: true,
        isFavorite: false,
        isCollectButton: false,
      ),
      GiftItem(
        brandName: 'Phí không\ndừng',
        title: 'Giảm 10K',
        description: 'Cho đơn từ 100K',
        topTag: 'KM đa tầng',
        assetPath: 'assets/images/toll.png',
        fallbackIcon: Icons.directions_car_rounded,
        fallbackColor: accentOrange,
        hasHeart: false,
        isFavorite: false,
        isCollectButton: true, // Nút viền hồng Thu thập
      ),
    ];
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildFilterBar(),
                    const SizedBox(height: 12),
                    _buildTwoInfoCards(),
                    const SizedBox(height: 14),
                    _buildGiftList(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A. Thanh tiêu đề (AppBar)
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: headerPink,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFEBF3), headerPink],
        ),
      ),
      child: Row(
        children: [
          // Nút quay lại tròn
          InkWell(
            onTap: () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Tiêu đề
          const Expanded(
            child: Text(
              'Quà của Vinh (7)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // Cụm biểu tượng hỗ trợ và đóng
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300, width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => _showMessage('Trợ giúp & Hỗ trợ'),
                  child: const Icon(
                    Icons.headset_mic_outlined,
                    size: 19,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  height: 14,
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.grey.shade300,
                ),
                InkWell(
                  onTap: () => Navigator.maybePop(context),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 19,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// B. Thanh bộ lọc cuộn ngang
  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          _buildFilterChip(
            icon: Icons.filter_alt_outlined,
            onTap: () => _showMessage('Bộ lọc'),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Sắp xếp',
            icon: Icons.filter_list,
            iconRight: true,
            onTap: () => _showMessage('Sắp xếp'),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Dịch vụ',
            icon: Icons.keyboard_arrow_down,
            iconRight: true,
            onTap: () => _showMessage('Dịch vụ'),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Gần tôi',
            onTap: () => _showMessage('Gần tôi'),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Yêu thích',
            onTap: () => _showMessage('Yêu thích'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    String? label,
    IconData? icon,
    bool iconRight = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E2E6), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null && !iconRight) ...[
              Icon(icon, size: 16, color: Colors.black87),
              if (label != null) const SizedBox(width: 5),
            ],
            if (label != null)
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (icon != null && iconRight) ...[
              const SizedBox(width: 3),
              Icon(icon, size: 16, color: Colors.black87),
            ],
          ],
        ),
      ),
    );
  }

  /// C. Hai thẻ thông tin
  Widget _buildTwoInfoCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          // Thẻ trái: Đang có 1.955 Xu
          Expanded(
            child: InkWell(
              onTap: () => _showMessage('Xem chi tiết Xu tích lũy'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFE8B2), width: 1),
                ),
                child: Row(
                  children: [
                    LocalImagePlaceholder(
                      assetPath: 'assets/images/coin.png',
                      fallbackIcon: Icons.monetization_on_rounded,
                      fallbackColor: accentOrange,
                      size: 34,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Đang có',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            '1.955 Xu',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: accentOrange,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Thẻ phải: Bỏ túi ngay 4 thẻ quà
          Expanded(
            child: InkWell(
              onTap: () => _showMessage('Xem 4 thẻ quà mới'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1357D6), Color(0xFF2272F2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const LocalImagePlaceholder(
                      assetPath: 'assets/images/gift.png',
                      fallbackIcon: Icons.card_giftcard_rounded,
                      fallbackColor: Colors.amberAccent,
                      size: 34,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bỏ túi ngay',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '4 thẻ quà',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Color(0xFF1357D6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// D. Danh sách quà
  Widget _buildGiftList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      itemCount: _gifts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = _gifts[index];
        return _buildGiftCard(item, index);
      },
    );
  }

  /// Card cho từng thẻ quà tặng
  Widget _buildGiftCard(GiftItem item, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nhãn trên cùng nếu có (như KM đa tầng ở mục 5)
          if (item.topTag != null)
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.topTag!,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Khối Logo thương hiệu bên trái
                SizedBox(
                  width: 66,
                  child: Column(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9FA),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFEEEEEE),
                            width: 0.8,
                          ),
                        ),
                        padding: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        child: LocalImagePlaceholder(
                          assetPath: item.assetPath,
                          fallbackIcon: item.fallbackIcon,
                          fallbackColor: item.fallbackColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.brandName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.2,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Cột thông tin ở giữa
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (item.expiryNotice != null)
                        Text(
                          item.expiryNotice!,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: accentOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else if (item.expiryDate != null)
                        Text(
                          item.expiryDate!,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      if (item.bottomTag != null) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.bottomTag!,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Cột hành động bên phải (trái tim & nút bấm)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Biểu tượng trái tim
                    if (item.hasHeart)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            item.isFavorite = !item.isFavorite;
                          });
                          _showMessage(
                            item.isFavorite
                                ? 'Đã thêm vào yêu thích'
                                : 'Đã bỏ yêu thích',
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Icon(
                            item.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 20,
                            color: item.isFavorite
                                ? primaryPink
                                : Colors.grey.shade400,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 20),
                    // Nút hành động
                    if (item.isCollectButton)
                      InkWell(
                        onTap: () => _showMessage('Đã thu thập mã ưu đãi'),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: primaryPink, width: 1.2),
                          ),
                          child: const Text(
                            'Thu thập',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: primaryPink,
                            ),
                          ),
                        ),
                      )
                    else
                      InkWell(
                        onTap: () => _showMessage('Áp dụng: '),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'Dùng ngay',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: primaryPink,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
