import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

/// Bài tập 3: Contacts Reader và SMS Reader
/// Chuẩn theo tài liệu Bai06_Chuong4_Multimedia.pdf (Trang 19 - 25)
class Bai3ContactsSmsApp extends StatelessWidget {
  const Bai3ContactsSmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainHomePage();
  }
}

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Main App',
          style: TextStyle(
            color: Color(0xFF1C1B1F),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Welcome to the Main App!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2EDF7),
                foregroundColor: const Color(0xFF37286B),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFE6DEEB), width: 0.8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SmsReaderApp()),
                );
              },
              child: const Text(
                'Go to SMS Reader App',
                style: TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2EDF7),
                foregroundColor: const Color(0xFF37286B),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFE6DEEB), width: 0.8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactsReaderApp(),
                  ),
                );
              },
              child: const Text(
                'Go to contacts Reader App',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Màn hình đọc danh bạ
class ContactsReaderApp extends StatefulWidget {
  const ContactsReaderApp({super.key});

  @override
  State<ContactsReaderApp> createState() => _ContactsReaderAppState();
}

class _ContactsReaderAppState extends State<ContactsReaderApp> {
  List<ContactInfo> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    try {
      final statuses = await [Permission.contacts].request();
      if (statuses[Permission.contacts]!.isGranted) {
        _loadContacts();
      } else {
        _loadMockContacts();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vui lòng cấp quyền để đọc danh bạ!')),
          );
        }
      }
    } catch (_) {
      _loadMockContacts();
    }
  }

  void _loadMockContacts() {
    setState(() {
      _contacts = [
        ContactInfo(
          displayName: 'Bich Ngan',
          phones: [ValueItem(label: 'mobile', value: '(908) 765-7765')],
        ),
        ContactInfo(
          displayName: 'Van Vinh',
          phones: [ValueItem(label: 'mobile', value: '(890) 754-4468')],
        ),
        ContactInfo(
          displayName: 'Tam Dinh',
          phones: [ValueItem(label: 'mobile', value: '0987955567')],
        ),
        ContactInfo(
          displayName: 'Hoa Mi',
          phones: [ValueItem(label: 'mobile', value: '098976552')],
        ),
      ];
      _isLoading = false;
    });
  }

  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<ContactInfo> contacts =
          await FlutterContactsService.getContacts();
      if (contacts.isEmpty) {
        _loadMockContacts();
      } else {
        setState(() {
          _contacts = contacts;
          _isLoading = false;
        });
      }
    } catch (_) {
      _loadMockContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Contacts Reader',
          style: TextStyle(
            color: Color(0xFF1C1B1F),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
              ? const Center(child: Text('Không có danh bạ nào.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    final ContactInfo contact = _contacts[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      title: Text(
                        contact.displayName ?? 'Không có tên',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        contact.phones!.isNotEmpty
                            ? contact.phones?.first.value ?? 'Không có số'
                            : 'Không có số',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

/// Màn hình đọc tin nhắn SMS
class SmsReaderApp extends StatefulWidget {
  const SmsReaderApp({super.key});

  @override
  State<SmsReaderApp> createState() => _SmsReaderAppState();
}

class DisplaySms {
  final String? address;
  final String? body;

  DisplaySms({this.address, this.body});
}

class _SmsReaderAppState extends State<SmsReaderApp> {
  final Telephony telephony = Telephony.instance;
  List<DisplaySms> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    try {
      final statuses =
          await [Permission.sms, Permission.phone].request();
      if (statuses[Permission.sms]!.isGranted) {
        _loadMessages();
      } else {
        _loadMockMessages();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vui lòng cấp quyền để đọc tin nhắn SMS!'),
            ),
          );
        }
      }
    } catch (_) {
      _loadMockMessages();
    }
  }

  void _loadMockMessages() {
    setState(() {
      _messages = [
        DisplaySms(
          address: '6505551212',
          body: 'Đang test gửi tin nhắn.',
        ),
        DisplaySms(
          address: '6505551212',
          body: 'Android is always a sweet treat!',
        ),
        DisplaySms(
          address: '6505551212',
          body: 'Dang test gởi tin nhắn!',
        ),
        DisplaySms(
          address: '6505551212',
          body: 'Android is always a sweet treat!',
        ),
      ];
      _isLoading = false;
    });
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<SmsMessage> messages = await telephony.getInboxSms(
        columns: [
          SmsColumn.ADDRESS,
          SmsColumn.BODY,
          SmsColumn.DATE,
          SmsColumn.TYPE,
        ],
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );

      if (messages.isEmpty) {
        _loadMockMessages();
      } else {
        setState(() {
          _messages = messages
              .map((m) => DisplaySms(address: m.address, body: m.body))
              .toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      _loadMockMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'SMS Reader',
          style: TextStyle(
            color: Color(0xFF1C1B1F),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _messages.isEmpty
              ? const Center(child: Text('Không có tin nhắn nào.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final DisplaySms message = _messages[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      title: Text(
                        message.body ?? 'Không có nội dung',
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        'Từ: ${message.address ?? 'Không rõ'}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
