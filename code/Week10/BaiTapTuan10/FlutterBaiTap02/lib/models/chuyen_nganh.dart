class ChuyenNganh {
  const ChuyenNganh({required this.maCN, required this.tenCN, this.moTa});

  final String maCN;
  final String tenCN;
  final String? moTa;

  factory ChuyenNganh.fromJson(Map<String, dynamic> json) {
    return ChuyenNganh(
      maCN: json['maCN'] as String,
      tenCN: json['tenCN'] as String,
      moTa: json['moTa'] as String?,
    );
  }
}
