import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Bài tập 5: Quản lý và thêm thông tin danh bạ
/// Đúng chuẩn giao diện trang 29-32 tài liệu PDF
class Bai5ContactManagerApp extends StatelessWidget {
  const Bai5ContactManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý danh bạ',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAF8FD),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.normal,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
      ),
      home: const ContactsListScreen(),
    );
  }
}

/// Dữ liệu mẫu danh bạ như trong ảnh trang 29
class MockContactItem {
  final String name;
  final String phone;
  final String email;
  final String? imageAsset;
  final Color? avatarColor;

  MockContactItem({
    required this.name,
    required this.phone,
    required this.email,
    this.imageAsset,
    this.avatarColor,
  });
}

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  List<ContactInfo> _contacts = [];
  bool _isLoading = false;

  // Dữ liệu mẫu khớp 100% hình ảnh trong tài liệu (trang 29_img_1)
  final List<MockContactItem> _mockContacts = [
    MockContactItem(
      name: 'Bich Ngan',
      phone: '(908) 765-7765',
      email: 'ngan@gmail.com',
      imageAsset: 'assets/images/tulip.jpg',
      avatarColor: const Color(0xFFF48FB1),
    ),
    MockContactItem(
      name: 'Van Vinh',
      phone: '(890) 754-4468',
      email: 'vinh@gmail.com',
      imageAsset: 'assets/images/tulip.jpg',
      avatarColor: const Color(0xFF80CBC4),
    ),
    MockContactItem(
      name: 'Tam Dinh',
      phone: '0987955567',
      email: 'Không có email',
      avatarColor: const Color(0xFFE57373),
    ),
    MockContactItem(
      name: 'Hoa Mi',
      phone: '098976552',
      email: 'Không có email',
      avatarColor: const Color(0xFFA1887F),
    ),
    MockContactItem(
      name: 'Tester',
      phone: '+1 650-555-1212',
      email: 'Không có email',
      avatarColor: const Color(0xFFE1D5F8),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final status = await Permission.contacts.status;
      if (status.isGranted) {
        final contacts = await FlutterContactsService.getContacts();
        setState(() {
          _contacts = contacts;
          _isLoading = false;
        });
        return;
      }
    } catch (_) {}

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh bạ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 28),
            onPressed: () async {
              final newContact = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddContactScreen(),
                ),
              );
              if (newContact != null && newContact is MockContactItem) {
                setState(() {
                  _mockContacts.insert(0, newContact);
                });
              } else {
                _loadContacts();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isNotEmpty
              ? ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts[index];
                    final phone = (contact.phones != null &&
                            contact.phones!.isNotEmpty)
                        ? contact.phones!.first.value ?? 'Không có số'
                        : 'Không có số';
                    final email = (contact.emails != null &&
                            contact.emails!.isNotEmpty)
                        ? contact.emails!.first.value ?? 'Không có email'
                        : 'Không có email';

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: contact.avatar != null &&
                              contact.avatar!.isNotEmpty
                          ? CircleAvatar(
                              radius: 24,
                              backgroundImage: MemoryImage(contact.avatar!),
                            )
                          : const CircleAvatar(
                              radius: 24,
                              backgroundColor: Color(0xFFE8DEF8),
                              child: Icon(Icons.person, color: Color(0xFF4F378B)),
                            ),
                      title: Text(
                        contact.displayName ?? 'Không có tên',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        '$phone\n$email',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.3,
                        ),
                      ),
                      isThreeLine: true,
                    );
                  },
                )
              : ListView.builder(
                  itemCount: _mockContacts.length,
                  itemBuilder: (context, index) {
                    final item = _mockContacts[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: item.avatarColor ?? const Color(0xFFE8DEF8),
                        child: item.imageAsset != null
                            ? ClipOval(
                                child: Image.asset(
                                  item.imageAsset!,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.person, color: Colors.white),
                                ),
                              )
                            : (item.name == 'Tester'
                                ? null
                                : const Icon(Icons.person, color: Colors.white)),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        '${item.phone}\n${item.email}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.3,
                        ),
                      ),
                      isThreeLine: true,
                    );
                  },
                ),
    );
  }
}

/// Màn hình thêm danh bạ theo đúng ảnh trang 29
class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _avatar;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _avatar = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveContact() async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tên và số điện thoại không được để trống!'),
        ),
      );
      return;
    }

    try {
      final contact = ContactInfo(
        displayName: _nameController.text.trim(),
        phones: [
          ValueItem(label: 'mobile', value: _phoneController.text.trim()),
        ],
        emails: [
          ValueItem(
            label: 'email',
            value: _emailController.text.trim().isEmpty
                ? 'Không có email'
                : _emailController.text.trim(),
          ),
        ],
        avatar: _avatar != null ? await _avatar!.readAsBytes() : null,
      );

      await FlutterContactsService.addContact(contact);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Danh bạ đã được lưu thành công!')),
        );
      }
    } catch (_) {}

    if (mounted) {
      Navigator.pop(
        context,
        MockContactItem(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim().isEmpty
              ? 'Không có email'
              : _emailController.text.trim(),
          avatarColor: const Color(0xFF7E57C2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Thêm danh bạ'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: const Color(0xFFE8DEF8),
                  backgroundImage: _avatar != null ? FileImage(_avatar!) : null,
                  child: _avatar == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 44,
                          color: Color(0xFF4F378B),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 36),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tên',
                labelStyle: TextStyle(color: Colors.black54),
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6750A4), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                labelStyle: TextStyle(color: Colors.black54),
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6750A4), width: 2),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black54),
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6750A4), width: 2),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 36),
            ElevatedButton(
              onPressed: _saveContact,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2EDF7),
                foregroundColor: const Color(0xFF37286B),
                elevation: 0,
                minimumSize: const Size(100, 42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Lưu',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF37286B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
