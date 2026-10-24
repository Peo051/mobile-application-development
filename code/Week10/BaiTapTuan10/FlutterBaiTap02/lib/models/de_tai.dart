class DeTai {
  const DeTai({
    required this.maDeTai,
    required this.tenDeTai,
    required this.soLuongSinhVienToiDa,
    required this.maCN,
    required this.tenCN,
    this.maLoai,
    this.tenLoai,
    this.giangVienHuongDan,
    this.yeuCauDeTai,
  });

  final String maDeTai;
  final String tenDeTai;
  final int soLuongSinhVienToiDa;
  final String? maLoai;
  final String? tenLoai;
  final String maCN;
  final String tenCN;
  final String? giangVienHuongDan;
  final String? yeuCauDeTai;

  factory DeTai.fromJson(Map<String, dynamic> json) {
    return DeTai(
      maDeTai: json['maDeTai'] as String,
      tenDeTai: json['tenDeTai'] as String,
      soLuongSinhVienToiDa: (json['soLuongSinhVienToiDa'] as num).toInt(),
      maLoai: json['maLoai'] as String?,
      tenLoai: json['tenLoai'] as String?,
      maCN: json['maCN'] as String,
      tenCN: json['tenCN'] as String,
      giangVienHuongDan: json['giangVienHuongDan'] as String?,
      yeuCauDeTai: json['yeuCauDeTai'] as String?,
    );
  }
}
