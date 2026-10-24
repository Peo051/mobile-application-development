// Trần Dương Gia Bảo - 2001240039

class TaiKhoan {
  final int? id;
  final String email;
  final String passwordHash;
  final String salt;

  TaiKhoan({
    this.id,
    required this.email,
    required this.passwordHash,
    required this.salt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'passwordHash': passwordHash,
      'salt': salt,
    };
  }

  factory TaiKhoan.fromMap(Map<String, dynamic> map) {
    return TaiKhoan(
      id: map['id'] as int,
      email: map['email'] as String,
      passwordHash: map['passwordHash'] as String,
      salt: map['salt'] as String,
    );
  }
}
