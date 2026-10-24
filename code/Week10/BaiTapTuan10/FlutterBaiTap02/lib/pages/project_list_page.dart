import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/de_tai.dart';
import '../models/loai_de_tai.dart';
import '../services/api_service.dart';
import '../theme/bt02_theme.dart';
import '../widgets/bt02_widgets.dart';
import 'project_detail_page.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({
    required this.api,
    required this.title,
    this.maLoai,
    this.maCN,
    super.key,
  });

  final ApiService api;
  final String title;
  final String? maLoai;
  final String? maCN;

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  static const List<String> _categoryOrder = ['DA', 'KLKS', 'LV', 'KHAC'];

  bool _isLoading = true;
  String? _errorMessage;
  List<DeTai> _items = [];
  List<LoaiDeTai> _categories = [];
  String? _selectedMaLoai;
  String? _selectedMaCN;
  int _requestVersion = 0;

  @override
  void initState() {
    super.initState();
    _selectedMaLoai = widget.maLoai;
    _selectedMaCN = widget.maCN;
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final requestVersion = ++_requestVersion;
    final maLoai = _selectedMaLoai;
    final maCN = _selectedMaCN;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        widget.api.getDeTai(maLoai: maLoai, maCN: maCN),
        if (maCN == null)
          widget.api.getLoaiDeTai()
        else
          Future.value(_categories),
      ]);
      final items = results[0] as List<DeTai>;
      final categories = _sortCategories(results[1] as List<LoaiDeTai>);

      if (!mounted || requestVersion != _requestVersion) return;
      setState(() {
        _items = items;
        _categories = categories;
        _isLoading = false;
      });
    } on ApiException catch (error) {
      if (!mounted || requestVersion != _requestVersion) return;
      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted || requestVersion != _requestVersion) return;
      setState(() {
        _errorMessage = 'Không tải được danh sách đề tài.';
        _isLoading = false;
      });
    }
  }

  List<LoaiDeTai> _sortCategories(List<LoaiDeTai> categories) {
    final order = {
      for (var index = 0; index < _categoryOrder.length; index++)
        _categoryOrder[index]: index,
    };
    final sorted = List<LoaiDeTai>.of(categories);
    sorted.sort(
      (first, second) => (order[first.maLoai] ?? _categoryOrder.length)
          .compareTo(order[second.maLoai] ?? _categoryOrder.length),
    );
    return sorted;
  }

  void _selectCategory(LoaiDeTai category) {
    setState(() {
      _selectedMaLoai = category.maLoai;
      _selectedMaCN = null;
    });
    _loadProjects();
  }

  void _clearFilters() {
    setState(() {
      _selectedMaLoai = null;
      _selectedMaCN = null;
    });
    _loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    final title = _selectedMaCN != null ? widget.title : 'Lọc theo loại đề tài';

    return Scaffold(
      appBar: Bt02AppBar(
        title: title,
        onLeadingPressed: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildLoadingState();
    if (_errorMessage != null) {
      return Bt02ErrorState(
        technicalDetails: _errorMessage,
        onRetry: _loadProjects,
      );
    }
    if (_items.isEmpty) return _buildEmptyState();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
      children: [
        const Text(
          'BỘ LỌC DANH SÁCH',
          style: TextStyle(
            color: Bt02Colors.primaryBlue,
            fontSize: 12,
            height: 1.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.35,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _selectedMaCN == null
              ? 'Đề tài theo loại đã chọn'
              : 'Đề tài theo chuyên ngành đã chọn',
          style: const TextStyle(
            color: Bt02Colors.text,
            fontSize: 20,
            height: 1.3,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (_selectedMaCN == null && _categories.isNotEmpty) ...[
          const SizedBox(height: 18),
          const Bt02SectionHeader('Chọn loại đề tài'),
          const SizedBox(height: 10),
          _buildCategoryFilters(),
        ],
        const SizedBox(height: 20),
        const Bt02SectionHeader('Kết quả tìm thấy'),
        const SizedBox(height: 12),
        for (final item in _items) _projectCard(item),
      ],
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category.maLoai == _selectedMaLoai;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => _selectCategory(category),
              child: Container(
                constraints: const BoxConstraints(minWidth: 72),
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Bt02Colors.purple : Bt02Colors.purpleSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  category.tenLoai,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? Bt02Colors.surface : Bt02Colors.purple,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
      children: [
        const Text(
          'Đang tải danh sách...',
          style: TextStyle(
            color: Bt02Colors.text,
            fontSize: 20,
            height: 1.4,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 18),
        const Bt02SectionHeader('Kết quả tìm thấy'),
        const SizedBox(height: 18),
        for (var index = 0; index < 3; index++) ...[
          const Bt02LoadingCard(),
          if (index < 2) const SizedBox(height: 14),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
      children: [
        const Text(
          'KHÔNG CÓ KẾT QUẢ',
          style: TextStyle(
            color: Bt02Colors.primaryBlue,
            fontSize: 12,
            height: 1.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.35,
          ),
        ),
        const SizedBox(height: 18),
        const Bt02SectionHeader('Danh sách đề tài'),
        const SizedBox(height: 18),
        const Bt02EmptyStatePanel(),
        const SizedBox(height: 18),
        Bt02PrimaryButton(label: 'Xóa bộ lọc', onPressed: _clearFilters),
      ],
    );
  }

  Widget _projectCard(DeTai item) {
    final borderRadius = BorderRadius.circular(16);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Bt02Colors.surface,
        border: Border.all(color: Bt02Colors.border),
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) =>
                  ProjectDetailPage(api: widget.api, maDeTai: item.maDeTai),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Bt02Colors.purpleSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.maDeTai,
                        style: const TextStyle(
                          color: Bt02Colors.purple,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${item.soLuongSinhVienToiDa} sinh viên',
                      style: const TextStyle(
                        color: Bt02Colors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.tenDeTai,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Bt02Colors.text,
                    fontSize: 16,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${item.tenCN} · Tối đa ${item.soLuongSinhVienToiDa} sinh viên',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Bt02Colors.muted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Xem chi tiết',
                      style: TextStyle(
                        color: Bt02Colors.primaryBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      'assets/figma/chevron-right.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Bt02Colors.primaryBlue,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
