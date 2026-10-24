// Trần Dương Gia Bảo - 2001240039
class SinhVien {
  final int? id;
  final String name;
  String email;

  SinhVien({this.id, required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email};
  }

  factory SinhVien.fromMap(Map<String, dynamic> map) {
    return SinhVien(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }
}
