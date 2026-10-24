import 'package:flutter/material.dart';

import '../models/de_tai.dart';
import '../services/api_service.dart';
import '../theme/bt02_theme.dart';
import '../widgets/bt02_widgets.dart';

class ProjectDetailPage extends StatefulWidget {
  const ProjectDetailPage({
    required this.api,
    required this.maDeTai,
    super.key,
  });

  final ApiService api;
  final String maDeTai;

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  bool _isLoading = true;
  String? _errorMessage;
  DeTai? _item;

  @override
  void initState() {
    super.initState();
    _loadProject();
  }

  Future<void> _loadProject() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final item = await widget.api.getDeTaiById(widget.maDeTai);
      if (!mounted) return;
      setState(() {
        _item = item;
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
        _errorMessage = 'Không tải được thông tin đề tài.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Bt02AppBar(
        title: 'Thông tin khóa luận',
        leadingIcon: Bt02LeadingIcon.back,
        dark: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Bt02ErrorState(
        technicalDetails: _errorMessage,
        onRetry: _loadProject,
      );
    }

    final item = _item;
    if (item == null) {
      return Bt02ErrorState(
        technicalDetails: 'Máy chủ không trả về thông tin đề tài.',
        onRetry: _loadProject,
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Bt02Colors.surfaceAlt,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.maDeTai,
                style: const TextStyle(
                  color: Bt02Colors.darkBlue,
                  fontSize: 28,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                item.tenDeTai,
                style: const TextStyle(
                  color: Bt02Colors.text,
                  fontSize: 18,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _detailField(
          'Số lượng sinh viên tối đa',
          '${item.soLuongSinhVienToiDa} sinh viên',
        ),
        _detailField('Chuyên ngành', item.tenCN),
        _detailField(
          'Giảng viên hướng dẫn',
          item.giangVienHuongDan ?? 'Chưa cập nhật',
        ),
        _detailField('Yêu cầu đề tài', item.yeuCauDeTai ?? 'Chưa cập nhật'),
      ],
    );
  }

  Widget _detailField(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Bt02Colors.surface,
        border: Border.all(color: Bt02Colors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Bt02Colors.primaryBlue,
              fontSize: 10,
              height: 1.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.35,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: Bt02Colors.text,
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
