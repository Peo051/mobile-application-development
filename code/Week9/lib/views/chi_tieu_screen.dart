// Trần Dương Gia Bảo - 2001240039

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/chi_tieu_controller.dart';
import '../models/chi_tieu.dart';

class ChiTieuScreen extends StatefulWidget {
  const ChiTieuScreen({super.key});

  @override
  State<ChiTieuScreen> createState() => _ChiTieuScreenState();
}

class _ChiTieuScreenState extends State<ChiTieuScreen> {
  final ChiTieuController _controller = ChiTieuController();
  final NumberFormat _moneyFormat = NumberFormat('#,##0.##', 'vi_VN');
  List<ChiTieu> _danhSach = [];
  bool _isLoading = true;
  bool _isBusy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadChiTieu();
  }

  Future<void> _loadChiTieu() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final danhSach = await _controller.fetchChiTieu();
      if (!mounted) return;
      setState(() => _danhSach = danhSach);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Không thể đọc danh sách chi tiêu.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _openForm([ChiTieu? chiTieu]) async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ChiTieuForm(chiTieu: chiTieu),
    );
    if (!mounted) return;
    setState(() => _isBusy = false);
    if (saved == true) await _loadChiTieu();
  }

  Future<void> _deleteChiTieu(ChiTieu chiTieu) async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    try {
      await _controller.deleteChiTieu(chiTieu.id!);
      if (!mounted) return;
      await _loadChiTieu();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Không thể xóa khoản chi.')));
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tongTien = _danhSach.fold<double>(
      0,
      (tong, chiTieu) => tong + chiTieu.soTien,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý chi tiêu')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!),
                  TextButton(
                    onPressed: _loadChiTieu,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Tổng chi tiêu: ${_moneyFormat.format(tongTien)} đ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: _danhSach.isEmpty
                      ? const Center(child: Text('Chưa có khoản chi nào.'))
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 88),
                          itemCount: _danhSach.length,
                          itemBuilder: (context, index) {
                            final chiTieu = _danhSach[index];
                            return Card(
                              child: ListTile(
                                title: Text(chiTieu.noiDung),
                                subtitle: Text(
                                  '${_moneyFormat.format(chiTieu.soTien)} đ'
                                  '${chiTieu.ghiChu.isEmpty ? '' : '\n${chiTieu.ghiChu}'}',
                                ),
                                isThreeLine: chiTieu.ghiChu.isNotEmpty,
                                onTap: _isBusy
                                    ? null
                                    : () => _openForm(chiTieu),
                                trailing: IconButton(
                                  tooltip: 'Xóa khoản chi',
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: _isBusy
                                      ? null
                                      : () => _deleteChiTieu(chiTieu),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isBusy || _isLoading ? null : () => _openForm(),
        tooltip: 'Thêm khoản chi',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ChiTieuForm extends StatefulWidget {
  final ChiTieu? chiTieu;

  const _ChiTieuForm({this.chiTieu});

  @override
  State<_ChiTieuForm> createState() => _ChiTieuFormState();
}

class _ChiTieuFormState extends State<_ChiTieuForm> {
  final _formKey = GlobalKey<FormState>();
  final ChiTieuController _controller = ChiTieuController();
  late final TextEditingController _noiDungController;
  late final TextEditingController _soTienController;
  late final TextEditingController _ghiChuController;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final chiTieu = widget.chiTieu;
    _noiDungController = TextEditingController(text: chiTieu?.noiDung ?? '');
    _soTienController = TextEditingController(
      text: chiTieu?.soTien.toString() ?? '',
    );
    _ghiChuController = TextEditingController(text: chiTieu?.ghiChu ?? '');
  }

  @override
  void dispose() {
    _noiDungController.dispose();
    _soTienController.dispose();
    _ghiChuController.dispose();
    super.dispose();
  }

  double? _parseSoTien(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  Future<void> _save() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;
    setState(() {
      _isSaving = true;
      _error = null;
    });
    final chiTieu = ChiTieu(
      id: widget.chiTieu?.id,
      noiDung: _noiDungController.text.trim(),
      soTien: _parseSoTien(_soTienController.text)!,
      ghiChu: _ghiChuController.text.trim(),
    );
    try {
      if (chiTieu.id == null) {
        await _controller.insertChiTieu(chiTieu);
      } else {
        await _controller.updateChiTieu(chiTieu);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Không thể lưu khoản chi. Vui lòng thử lại.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSaving,
      child: AlertDialog(
        title: Text(
          widget.chiTieu == null ? 'Thêm khoản chi' : 'Sửa khoản chi',
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _noiDungController,
                  enabled: !_isSaving,
                  decoration: const InputDecoration(
                    labelText: 'Nội dung chi tiêu',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Vui lòng nhập nội dung chi tiêu.'
                      : null,
                ),
                TextFormField(
                  controller: _soTienController,
                  enabled: !_isSaving,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Số tiền',
                    hintText: 'Ví dụ: 25000',
                  ),
                  validator: (value) {
                    final soTien = _parseSoTien(value ?? '');
                    if (soTien == null || !soTien.isFinite || soTien <= 0) {
                      return 'Số tiền phải là số lớn hơn 0.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ghiChuController,
                  enabled: !_isSaving,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Ghi chú'),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: _isSaving ? null : _save,
            child: Text(_isSaving ? 'Đang lưu...' : 'Lưu'),
          ),
        ],
      ),
    );
  }
}
