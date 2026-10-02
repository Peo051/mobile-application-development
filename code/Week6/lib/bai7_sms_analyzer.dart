import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:another_telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';

/// Bài tập 7: SMS Analyzer
/// Thống kê tin nhắn, lọc theo số điện thoại, phân loại [QC] và [OTP],
/// trích xuất mã OTP 6 chữ số khi nhấn vào.
class Bai7SmsAnalyzerApp extends StatelessWidget {
  const Bai7SmsAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SmsAnalyzerHome();
  }
}

enum SmsCategory { all, qc, otp, normal }

class SmsItemModel {
  final String address;
  final String body;
  final DateTime date;
  final bool isQc;
  final bool isOtp;
  final String? otpCode;

  SmsItemModel({
    required this.address,
    required this.body,
    required this.date,
    required this.isQc,
    required this.isOtp,
    this.otpCode,
  });

  factory SmsItemModel.fromRaw(String address, String body, int timestamp) {
    final trimmedBody = body.trim();

    // 1. Kiểm tra tin quảng cáo: Bắt đầu bằng [QC]
    final isQc = trimmedBody.startsWith('[QC]');

    // 2. Kiểm tra tin OTP: Chứa [OTP] và có chuỗi 6 chữ số liên tiếp
    final isOtpTag = trimmedBody.contains('[OTP]');
    final otpRegex = RegExp(r'\b\d{6}\b');
    final match = otpRegex.firstMatch(trimmedBody);
    final isOtp = isOtpTag && match != null;
    final otpCode = match?.group(0);

    return SmsItemModel(
      address: address.isEmpty ? 'Không rõ' : address,
      body: trimmedBody,
      date: DateTime.fromMillisecondsSinceEpoch(
        timestamp > 0 ? timestamp : DateTime.now().millisecondsSinceEpoch,
      ),
      isQc: isQc,
      isOtp: isOtp,
      otpCode: otpCode,
    );
  }
}

class SmsAnalyzerHome extends StatefulWidget {
  const SmsAnalyzerHome({super.key});

  @override
  State<SmsAnalyzerHome> createState() => _SmsAnalyzerHomeState();
}

class _SmsAnalyzerHomeState extends State<SmsAnalyzerHome> {
  final Telephony _telephony = Telephony.instance;
  List<SmsItemModel> _allMessages = [];
  bool _isLoading = true;

  // Bộ lọc
  String _searchPhone = '';
  SmsCategory _selectedCategory = SmsCategory.all;
  DateTime? _selectedFilterDate;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestAndLoadSms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _requestAndLoadSms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final statuses = await [Permission.sms, Permission.phone].request();
      if (statuses[Permission.sms]!.isGranted) {
        final List<SmsMessage> messages = await _telephony.getInboxSms(
          columns: [
            SmsColumn.ADDRESS,
            SmsColumn.BODY,
            SmsColumn.DATE,
            SmsColumn.TYPE,
          ],
          sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
        );

        if (messages.isNotEmpty) {
          setState(() {
            _allMessages = messages
                .map(
                  (m) => SmsItemModel.fromRaw(
                    m.address ?? '',
                    m.body ?? '',
                    m.date ?? 0,
                  ),
                )
                .toList();
            _isLoading = false;
          });
          return;
        }
      }
    } catch (_) {
      // Bỏ qua lỗi và tải dữ liệu mẫu
    }

    // Nếu không có tin nhắn thật trên thiết bị/máy ảo, tải dữ liệu mẫu chuẩn theo tài liệu
    _loadSampleMessages();
  }

  // Tải tin nhắn mẫu đa dạng gồm tin thường, tin QC và tin OTP để kiểm thử
  void _loadSampleMessages() {
    final now = DateTime.now();
    final sampleList = [
      SmsItemModel.fromRaw(
        'VPBank',
        '[OTP] Ma xac thuc dang nhap cua ban la 839201. Khong chia se ma nay cho bat ky ai.',
        now.subtract(const Duration(minutes: 10)).millisecondsSinceEpoch,
      ),
      SmsItemModel.fromRaw(
        'VIETTEL_QC',
        '[QC] Sieu uu dai goi cuoc 4G ST15K chi 15.000d co 3GB/3 ngay. Soan ST15K gui 191.',
        now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
      ),
      SmsItemModel.fromRaw(
        '0912345678',
        'Chieu nay 2h di hoc thuc hanh Flutter nhe Bao!',
        now.subtract(const Duration(hours: 4)).millisecondsSinceEpoch,
      ),
      SmsItemModel.fromRaw(
        'MOMO',
        '[OTP] 456789 la ma xac thuc OTP giao dich vi MoMo cua ban.',
        now.subtract(const Duration(days: 1, hours: 2)).millisecondsSinceEpoch,
      ),
      SmsItemModel.fromRaw(
        'SHOPEE_PROMO',
        '[QC] Shopee Sale giua thang! Tang ban ma giam 50K cho don tu 0d. Xem ngay tai shopee.vn.',
        now.subtract(const Duration(days: 2)).millisecondsSinceEpoch,
      ),
      SmsItemModel.fromRaw(
        '0987654321',
        'Nho gui bai tap tuan 6 truoc 23h Chu Nhat nha.',
        now.subtract(const Duration(days: 3)).millisecondsSinceEpoch,
      ),
      SmsItemModel.fromRaw(
        'TPBank',
        '[OTP] Ma OTP xac thuc chuyen tien cua Quy khach la 654321. Hieu luc trong 3 phut.',
        now.subtract(const Duration(days: 4)).millisecondsSinceEpoch,
      ),
      SmsItemModel.fromRaw(
        'VINAPHONE_KM',
        '[QC] Nap the ngay hom nay de nhan 20% gia tri the nap vao tai khoan KM3.',
        now.subtract(const Duration(days: 5)).millisecondsSinceEpoch,
      ),
    ];

    setState(() {
      _allMessages = sampleList;
      _isLoading = false;
    });
  }

  // Thống kê số lượng
  int get _totalCount => _allMessages.length;
  int get _qcCount => _allMessages.where((m) => m.isQc).length;
  int get _otpCount => _allMessages.where((m) => m.isOtp).length;
  int get _normalCount => _allMessages.where((m) => !m.isQc && !m.isOtp).length;

  // Lọc danh sách theo các điều kiện
  List<SmsItemModel> get _filteredMessages {
    return _allMessages.where((m) {
      // 1. Lọc theo số điện thoại
      if (_searchPhone.isNotEmpty &&
          !m.address.toLowerCase().contains(_searchPhone.toLowerCase())) {
        return false;
      }
      // 2. Lọc theo danh mục
      if (_selectedCategory == SmsCategory.qc && !m.isQc) return false;
      if (_selectedCategory == SmsCategory.otp && !m.isOtp) return false;
      if (_selectedCategory == SmsCategory.normal && (m.isQc || m.isOtp)) {
        return false;
      }
      // 3. Lọc theo ngày
      if (_selectedFilterDate != null) {
        if (m.date.year != _selectedFilterDate!.year ||
            m.date.month != _selectedFilterDate!.month ||
            m.date.day != _selectedFilterDate!.day) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  void _showOtpDialog(SmsItemModel message) {
    final code = message.otpCode ?? 'Không tìm thấy';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.security, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'Mã OTP xác thực',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Hệ thống đã tự động trích xuất mã OTP:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade400, width: 1.5),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Từ: ${message.address}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã sao chép mã OTP: $code'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Sao chép mã'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  // Chọn ngày lọc
  Future<void> _pickFilterDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedFilterDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedFilterDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredMessages;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Analyzer'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại tin nhắn',
            onPressed: _requestAndLoadSms,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 1. Các thẻ thống kê tổng quan
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                  child: Row(
                    children: [
                      _buildStatCard(
                        title: 'Tổng SMS',
                        count: _totalCount,
                        color: const Color(0xFF1E3A8A),
                        icon: Icons.mark_email_read,
                        isSelected: _selectedCategory == SmsCategory.all,
                        onTap: () {
                          setState(() {
                            _selectedCategory = SmsCategory.all;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildStatCard(
                        title: 'Quảng cáo',
                        count: _qcCount,
                        color: Colors.orange.shade800,
                        icon: Icons.campaign,
                        isSelected: _selectedCategory == SmsCategory.qc,
                        onTap: () {
                          setState(() {
                            _selectedCategory = SmsCategory.qc;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildStatCard(
                        title: 'Mã OTP',
                        count: _otpCount,
                        color: Colors.green.shade700,
                        icon: Icons.pin,
                        isSelected: _selectedCategory == SmsCategory.otp,
                        onTap: () {
                          setState(() {
                            _selectedCategory = SmsCategory.otp;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildStatCard(
                        title: 'Tin thường',
                        count: _normalCount,
                        color: Colors.teal.shade700,
                        icon: Icons.chat,
                        isSelected: _selectedCategory == SmsCategory.normal,
                        onTap: () {
                          setState(() {
                            _selectedCategory = SmsCategory.normal;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // 2. Ô tìm kiếm số điện thoại và lọc ngày
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Tìm theo số người gửi...',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            suffixIcon: _searchPhone.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchPhone = '';
                                      });
                                    },
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            isDense: true,
                          ),
                          onChanged: (val) {
                            setState(() {
                              _searchPhone = val.trim();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Nút lọc theo ngày
                      OutlinedButton.icon(
                        onPressed: _pickFilterDate,
                        icon: Icon(
                          _selectedFilterDate != null
                              ? Icons.event_available
                              : Icons.date_range,
                          size: 18,
                        ),
                        label: Text(
                          _selectedFilterDate != null
                              ? '${_selectedFilterDate!.day}/${_selectedFilterDate!.month}'
                              : 'Ngày',
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                      if (_selectedFilterDate != null)
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          tooltip: 'Xóa lọc ngày',
                          onPressed: () {
                            setState(() {
                              _selectedFilterDate = null;
                            });
                          },
                        ),
                    ],
                  ),
                ),

                // Dòng trạng thái số lượng tin tìm thấy
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hiển thị: ${filtered.length} tin nhắn',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      if (_allMessages.isNotEmpty && _totalCount <= 8)
                        Text(
                          '(Dữ liệu mẫu kiểm thử)',
                          style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Colors.blue.shade700,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // 3. Danh sách tin nhắn
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 56,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Không có tin nhắn nào phù hợp.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return _buildSmsCard(item);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  // Thẻ thống kê tổng quan
  Widget _buildStatCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color, width: isSelected ? 2 : 1),
          ),
          child: Column(
            children: [
              Icon(icon, size: 22, color: isSelected ? Colors.white : color),
              const SizedBox(height: 4),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card hiển thị từng tin nhắn
  Widget _buildSmsCard(SmsItemModel item) {
    Color badgeColor = Colors.teal;
    String badgeText = 'THƯỜNG';
    if (item.isQc) {
      badgeColor = Colors.orange.shade800;
      badgeText = 'QUẢNG CÁO';
    } else if (item.isOtp) {
      badgeColor = Colors.green.shade700;
      badgeText = 'MÃ OTP';
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: item.isOtp
              ? Colors.green.shade400
              : item.isQc
              ? Colors.orange.shade300
              : Colors.grey.shade300,
          width: item.isOtp ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: item.isOtp ? () => _showOtpDialog(item) : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Người gửi
                  Row(
                    children: [
                      Icon(Icons.person_pin, size: 18, color: badgeColor),
                      const SizedBox(width: 6),
                      Text(
                        item.address,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  // Badge phân loại
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: badgeColor, width: 0.8),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Nội dung tin nhắn
              Text(
                item.body,
                style: const TextStyle(fontSize: 13, height: 1.35),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.date.day.toString().padLeft(2, '0')}/${item.date.month.toString().padLeft(2, '0')}/${item.date.year} ${item.date.hour.toString().padLeft(2, '0')}:${item.date.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  if (item.isOtp)
                    Row(
                      children: const [
                        Text(
                          'Chạm để trích xuất OTP',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.touch_app, size: 14, color: Colors.green),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
