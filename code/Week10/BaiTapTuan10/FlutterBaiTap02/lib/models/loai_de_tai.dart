class LoaiDeTai {
  const LoaiDeTai({required this.maLoai, required this.tenLoai});

  final String maLoai;
  final String tenLoai;

  factory LoaiDeTai.fromJson(Map<String, dynamic> json) {
    return LoaiDeTai(
      maLoai: json['maLoai'] as String,
      tenLoai: json['tenLoai'] as String,
    );
  }
}
