import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/chuyen_nganh.dart';
import '../models/de_tai.dart';
import '../models/loai_de_tai.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiService {
  ApiService()
    : baseUrl = const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://10.0.2.2:5130',
      ).replaceFirst(RegExp(r'/$'), '');

  final String baseUrl;

  Future<List<LoaiDeTai>> getLoaiDeTai() async {
    final json = await _getJson(Uri.parse('$baseUrl/api/loai-de-tai'));
    return _readList(json, LoaiDeTai.fromJson);
  }

  Future<List<ChuyenNganh>> getChuyenNganh() async {
    final json = await _getJson(Uri.parse('$baseUrl/api/chuyen-nganh'));
    return _readList(json, ChuyenNganh.fromJson);
  }

  Future<List<DeTai>> getDeTai({String? maLoai, String? maCN}) async {
    final query = <String, String>{};
    if (maLoai != null) query['maLoai'] = maLoai;
    if (maCN != null) query['maCN'] = maCN;

    final uri = Uri.parse('$baseUrl/api/de-tai')
        .replace(queryParameters: query.isEmpty ? null : query);
    final json = await _getJson(uri);
    return _readList(json, DeTai.fromJson);
  }

  Future<DeTai> getDeTaiById(String maDeTai) async {
    final uri = Uri.parse(
      '$baseUrl/api/de-tai/${Uri.encodeComponent(maDeTai)}',
    );
    final json = await _getJson(uri);
    if (json is! Map) {
      throw const ApiException('Dữ liệu chi tiết đề tài không hợp lệ.');
    }
    return DeTai.fromJson(Map<String, dynamic>.from(json));
  }

  Future<dynamic> _getJson(Uri uri) async {
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('Máy chủ phản hồi HTTP ${response.statusCode}.');
      }
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('Kết nối hết thời gian chờ. Hãy thử lại.');
    } on FormatException {
      throw const ApiException('Dữ liệu JSON từ máy chủ không hợp lệ.');
    } catch (_) {
      throw const ApiException(
        'Không thể kết nối API. Kiểm tra Web API, địa chỉ mạng và SQL Server.',
      );
    }
  }

  List<T> _readList<T>(
    dynamic json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (json is! List) {
      throw const ApiException('API không trả về danh sách dữ liệu hợp lệ.');
    }

    try {
      return json
          .map((item) => fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      throw const ApiException(
        'Một bản ghi trong danh sách có JSON không hợp lệ.',
      );
    }
  }
}
