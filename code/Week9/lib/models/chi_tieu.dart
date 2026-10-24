// Trần Dương Gia Bảo - 2001240039

class ChiTieu {
  final int? id;
  final String noiDung;
  final double soTien;
  final String ghiChu;

  ChiTieu({
    this.id,
    required this.noiDung,
    required this.soTien,
    this.ghiChu = '',
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'noiDung': noiDung,
      'soTien': soTien,
      'ghiChu': ghiChu,
    };
  }

  factory ChiTieu.fromMap(Map<String, dynamic> map) {
    return ChiTieu(
      id: map['id'] as int,
      noiDung: map['noiDung'] as String,
      soTien: (map['soTien'] as num).toDouble(),
      ghiChu: map['ghiChu'] as String,
    );
  }
}
