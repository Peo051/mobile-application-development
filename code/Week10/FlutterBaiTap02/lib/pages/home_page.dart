import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/chuyen_nganh.dart';
import '../models/loai_de_tai.dart';
import '../services/api_service.dart';
import '../theme/bt02_theme.dart';
import '../widgets/bt02_widgets.dart';
import 'project_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _api = ApiService();
  bool _isLoading = true;
  String? _errorMessage;
  List<LoaiDeTai> _loaiDeTai = [];
  List<ChuyenNganh> _chuyenNganh = [];
  String? _selectedMaLoai = 'DA';

  // Mã dùng để sắp xếp theo thứ tự của hình mẫu; nội dung lấy từ API.
  static const List<String> _categoryOrder = ['DA', 'KLKS', 'LV', 'KHAC'];
  static const List<String> _majorOrder = ['CNPM', 'HTTT', 'MMT', 'ATTT'];

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _api.getLoaiDeTai(),
        _api.getChuyenNganh(),
      ]);
      final allMajors = results[1] as List<ChuyenNganh>;
      final majorsByCode = {for (final item in allMajors) item.maCN: item};

      if (!mounted) return;
      setState(() {
        _loaiDeTai = _sortByCode(
          results[0] as List<LoaiDeTai>,
          _categoryOrder,
          (item) => item.maLoai,
        );
        _chuyenNganh = _majorOrder
            .where(majorsByCode.containsKey)
            .map((code) => majorsByCode[code]!)
            .toList();
        _isLoading = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Không tải được dữ liệu. Hãy thử kết nối lại.';
        _isLoading = false;
      });
    }
  }

  List<T> _sortByCode<T>(
    List<T> items,
    List<String> order,
    String Function(T) getCode,
  ) {
    final byCode = {for (final item in items) getCode(item): item};
    return order
        .where(byCode.containsKey)
        .map((code) => byCode[code]!)
        .toList();
  }

  void _openProjects({String? maLoai, String? maCN, required String title}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProjectListPage(
          api: _api,
          maLoai: maLoai,
          maCN: maCN,
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Bt02AppBar(title: 'Danh sách đồ án'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }
    if (_errorMessage != null) {
      return Bt02ErrorState(
        technicalDetails: _errorMessage,
        onRetry: _loadHomeData,
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
      children: [
        const Text(
          'KHÁM PHÁ ĐỀ TÀI',
          style: TextStyle(
            color: Bt02Colors.primaryBlue,
            fontSize: 12,
            height: 1.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.35,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Chọn loại đề tài và chuyên ngành',
          style: TextStyle(
            color: Bt02Colors.text,
            fontSize: 20,
            height: 1.3,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 18),
        const Bt02SectionHeader('Chọn loại đề tài'),
        const SizedBox(height: 10),
        if (_loaiDeTai.isEmpty)
          const _EmptyMessage(message: 'Chưa có loại đề tài trong dữ liệu.')
        else
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _loaiDeTai.length,
              itemBuilder: (context, index) {
                final item = _loaiDeTai[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      setState(() => _selectedMaLoai = item.maLoai);
                      _openProjects(
                        maLoai: item.maLoai,
                        title: 'Lọc theo loại đề tài',
                      );
                    },
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 72),
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: item.maLoai == _selectedMaLoai
                            ? Bt02Colors.purple
                            : Bt02Colors.purpleSoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        item.tenLoai,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: item.maLoai == _selectedMaLoai
                              ? Bt02Colors.surface
                              : Bt02Colors.purple,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 20),
        const Bt02SectionHeader('Chọn chuyên ngành thực hiện'),
        const SizedBox(height: 12),
        if (_chuyenNganh.isEmpty)
          const _EmptyMessage(message: 'Chưa có chuyên ngành trong dữ liệu.')
        else
          ..._chuyenNganh.map(_majorCard),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
      children: [
        const Text(
          'Đang tải dữ liệu...',
          style: TextStyle(
            color: Bt02Colors.text,
            fontSize: 20,
            height: 1.45,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Danh sách được tải qua ASP.NET Core Web API',
          style: TextStyle(color: Bt02Colors.muted, fontSize: 12, height: 1.5),
        ),
        const SizedBox(height: 18),
        const Bt02SectionHeader('Chọn chuyên ngành thực hiện'),
        const SizedBox(height: 18),
        for (var index = 0; index < 4; index++) ...[
          const Bt02LoadingCard(),
          if (index < 3) const SizedBox(height: 18),
        ],
        const SizedBox(height: 8),
        const Text(
          'Vui lòng kiểm tra kết nối khi tải quá lâu.',
          style: TextStyle(color: Bt02Colors.muted, fontSize: 12, height: 1.5),
        ),
      ],
    );
  }

  Widget _majorCard(ChuyenNganh item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Bt02Colors.surface,
        border: Border.all(color: Bt02Colors.border),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () =>
              _openProjects(maCN: item.maCN, title: 'Lọc theo chuyên ngành'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Bt02Colors.surfaceAlt,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    'assets/figma/major.svg',
                    width: 23,
                    height: 23,
                    colorFilter: const ColorFilter.mode(
                      Bt02Colors.purple,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.tenCN,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Bt02Colors.text,
                          fontSize: 15,
                          height: 1.35,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.moTa ?? 'Chưa có mô tả trong cơ sở dữ liệu.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Bt02Colors.muted,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  'assets/figma/chevron-right.svg',
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    Bt02Colors.muted,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Bt02Colors.muted, fontSize: 13),
        ),
      ),
    );
  }
}
