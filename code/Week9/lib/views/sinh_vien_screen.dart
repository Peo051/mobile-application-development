// Trần Dương Gia Bảo - 2001240039
import 'package:flutter/material.dart';

import '../controllers/sinh_vien_controller.dart';
import '../models/sinh_vien.dart';

class SinhVienScreen extends StatefulWidget {
  const SinhVienScreen({super.key});

  @override
  State<SinhVienScreen> createState() => _SinhVienScreenState();
}

class _SinhVienScreenState extends State<SinhVienScreen> {
  final SinhVienController _controller = SinhVienController();
  final _searchController = TextEditingController();
  List<SinhVien> _sinhVien = [];
  bool _loading = true;
  bool _loadError = false;

  @override
  void initState() {
    super.initState();
    _loadSinhVien();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSinhVien() async {
    final query = _searchController.text.trim();
    try {
      final list = query.isEmpty
          ? await _controller.fetchSinhVien()
          : await _controller.searchSinhVien(query);
      if (!mounted || query != _searchController.text.trim()) return;
      // Bỏ kết quả cũ nếu người dùng đã gõ một từ khóa khác.
      setState(() {
        _sinhVien = list;
        _loadError = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadError = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openForm([SinhVien? sinhVien]) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _SinhVienDialog(sinhVien: sinhVien),
    );
    if (saved == true && mounted) await _loadSinhVien();
  }

  Future<void> _deleteSinhVien(SinhVien sinhVien) async {
    try {
      await _controller.deleteSinhVien(sinhVien.id!);
      if (mounted) await _loadSinhVien();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể xóa sinh viên.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE2F2FA), Color(0xFFF8D3EE)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm sinh viên...',
                    filled: true,
                    fillColor: const Color(0xFFEDE7F1),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      tooltip: 'Xóa tìm kiếm',
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        _loadSinhVien();
                      },
                    ),
                  ),
                  onChanged: (_) => _loadSinhVien(),
                ),
              ),
              Expanded(child: _buildList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Thêm Sinh Viên',
        backgroundColor: const Color(0xFFECE2F8),
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildList() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError) {
      return Center(
        child: TextButton(
          onPressed: _loadSinhVien,
          child: const Text('Không đọc được dữ liệu. Nhấn để thử lại.'),
        ),
      );
    }
    if (_sinhVien.isEmpty) {
      return Center(
        child: Text(
          _searchController.text.trim().isEmpty
              ? 'Chưa có sinh viên.'
              : 'Không tìm thấy sinh viên.',
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 88),
      itemCount: _sinhVien.length,
      itemBuilder: (context, index) {
        final sinhVien = _sinhVien[index];
        return Card(
          color: const Color(0xFFA5B0B8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/huit_logo.jpeg'),
              radius: 20,
            ),
            title: Text(
              sinhVien.name,
              style: const TextStyle(color: Color(0xFF124878), fontSize: 18),
            ),
            subtitle: Text(
              sinhVien.email,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: IconButton(
              tooltip: 'Xóa sinh viên',
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _deleteSinhVien(sinhVien),
            ),
            onTap: () => _openForm(sinhVien),
          ),
        );
      },
    );
  }
}

// Dùng cùng một form cho thêm và cập nhật, không lặp lại hai bộ xử lý.
class _SinhVienDialog extends StatefulWidget {
  const _SinhVienDialog({this.sinhVien});

  final SinhVien? sinhVien;

  @override
  State<_SinhVienDialog> createState() => _SinhVienDialogState();
}

class _SinhVienDialogState extends State<_SinhVienDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sinhVien?.name ?? '');
    _emailController = TextEditingController(
      text: widget.sinhVien?.email ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final sinhVien = SinhVien(
      id: widget.sinhVien?.id,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );
    try {
      final controller = SinhVienController();
      if (sinhVien.id == null) {
        await controller.insertSinhVien(sinhVien);
      } else {
        await controller.updateSinhVien(sinhVien);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) setState(() => _error = 'Không thể lưu sinh viên.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _buildFields() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.sinhVien != null)
              Text(
                'Dữ liệu: ${widget.sinhVien!.id} ${widget.sinhVien!.name}',
                style: const TextStyle(fontSize: 12),
              ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên Sinh Viên'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Vui lòng nhập tên sinh viên.'
                  : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
                  return 'Vui lòng nhập email hợp lệ.';
                }
                return null;
              },
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.sinhVien != null;
    // Dialog chi tiết cao như mẫu; thu lại khi bàn phím đang mở.
    final availableHeight =
        MediaQuery.sizeOf(context).height -
        MediaQuery.viewInsetsOf(context).bottom;
    final detailHeight = (availableHeight * 0.62).clamp(100.0, 520.0);
    return AlertDialog(
      backgroundColor: const Color(0xFFFCF6FF),
      title: Text(
        editing ? 'Thông tin chi tiết của sinh viên' : 'Thêm Sinh Viên',
        style: const TextStyle(fontSize: 20),
      ),
      content: editing
          ? SizedBox(width: 300, height: detailHeight, child: _buildFields())
          : SizedBox(width: 280, child: _buildFields()),
      actions: editing
          ? [
              TextButton(
                onPressed: _saving ? null : _save,
                child: const Text('Cập nhật'),
              ),
              TextButton(
                onPressed: _saving ? null : () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
            ]
          : [
              TextButton(
                onPressed: _saving ? null : () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: const Text('Lưu'),
              ),
            ],
    );
  }
}
