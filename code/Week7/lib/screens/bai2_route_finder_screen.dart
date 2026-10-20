import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config/app_config.dart';
import '../services/map_service.dart';
import '../widgets/app_map_view.dart';

class Bai2RouteFinderScreen extends StatefulWidget {
  const Bai2RouteFinderScreen({super.key});

  @override
  State<Bai2RouteFinderScreen> createState() => _Bai2RouteFinderScreenState();
}

class _Bai2RouteFinderScreenState extends State<Bai2RouteFinderScreen> {
  AppMapController? _mapController;

  // Controller nhập tọa độ
  final TextEditingController _startController = TextEditingController(
    text: '10.7769, 106.7009',
  );
  final TextEditingController _endController = TextEditingController(
    text: '10.7798, 106.6990',
  );

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _isLoading = false;
  String? _routeInfo;

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  // Hàm chuyển đổi chuỗi "lat, lng" thành LatLng với kiểm tra tính hợp lệ
  LatLng? _parseCoordinates(String input, String fieldName) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$fieldName không được để trống!'),
          backgroundColor: Colors.orange,
        ),
      );
      return null;
    }

    final parts = trimmed.split(',');
    if (parts.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$fieldName phải đúng định dạng "vĩ độ, kinh độ" (ví dụ: 10.7769, 106.7009)',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }

    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$fieldName chứa giá trị tọa độ không hợp lệ!'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }

    if (lat < -90.0 || lat > 90.0 || lng < -180.0 || lng > 180.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$fieldName vượt quá phạm vi hợp lệ (-90..90 cho vĩ độ, -180..180 cho kinh độ)!',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }

    return LatLng(lat, lng);
  }

  // Tìm đường giữa 2 tọa độ
  Future<void> _findRoute() async {
    // Ẩn bàn phím
    FocusScope.of(context).unfocus();

    final startPoint = _parseCoordinates(
      _startController.text,
      'Điểm xuất phát',
    );
    if (startPoint == null) return;

    final endPoint = _parseCoordinates(_endController.text, 'Điểm đến');
    if (endPoint == null) return;

    setState(() {
      _isLoading = true;
      _routeInfo = null;
    });

    try {
      // 1. Cập nhật Marker điểm đi và điểm đến
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('start'),
            position: startPoint,
            infoWindow: const InfoWindow(title: 'Điểm xuất phát'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );
        _markers.add(
          Marker(
            markerId: const MarkerId('end'),
            position: endPoint,
            infoWindow: const InfoWindow(title: 'Điểm đến'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );
      });

      // 2. Gọi Directions API
      final result = await MapService.getDirections(
        origin: startPoint,
        destination: endPoint,
      );

      if (result != null && result.polylinePoints.isNotEmpty) {
        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: result.polylinePoints,
              color: Colors.blue,
              width: 5,
            ),
          );
          _routeInfo =
              'Khoảng cách: ${result.distanceText} | Thời gian: ${result.durationText}';
        });

        // 3. Điều chỉnh camera bao quát cả 2 điểm
        _fitBounds(startPoint, endPoint);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã tìm thấy tuyến đường!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Không tìm thấy đường đi giữa hai điểm này hoặc API gặp sự cố.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tìm đường: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Thu phóng camera bao quát 2 điểm
  void _fitBounds(LatLng p1, LatLng p2) {
    if (_mapController == null) return;

    final southWest = LatLng(
      p1.latitude < p2.latitude ? p1.latitude : p2.latitude,
      p1.longitude < p2.longitude ? p1.longitude : p2.longitude,
    );
    final northEast = LatLng(
      p1.latitude > p2.latitude ? p1.latitude : p2.latitude,
      p1.longitude > p2.longitude ? p1.longitude : p2.longitude,
    );

    _mapController?.fitCoordinates([southWest, northEast], padding: 80);
  }

  // Xóa toàn bộ đường đi và marker
  void _clearRoute() {
    setState(() {
      _markers.clear();
      _polylines.clear();
      _routeInfo = null;
    });
  }

  // Đặt tọa độ mẫu thử nghiệm
  void _setSampleCoordinates() {
    setState(() {
      _startController.text = '10.7769, 106.7009'; // Chợ Bến Thành
      _endController.text = '10.7798, 106.6990'; // Dinh Độc Lập
    });
    _findRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 2: Route Finder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            tooltip: 'Tọa độ mẫu (Bến Thành -> Dinh Độc Lập)',
            onPressed: _setSampleCoordinates,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Xóa tuyến đường',
            onPressed: _clearRoute,
          ),
        ],
      ),
      body: Column(
        children: [
          // Bảng nhập tọa độ
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _startController,
                  decoration: const InputDecoration(
                    labelText: 'Điểm xuất phát (vĩ độ, kinh độ)',
                    prefixIcon: Icon(Icons.my_location, color: Colors.green),
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _endController,
                  decoration: const InputDecoration(
                    labelText: 'Điểm đến (vĩ độ, kinh độ)',
                    prefixIcon: Icon(Icons.location_on, color: Colors.red),
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _findRoute,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.directions),
                    label: Text(_isLoading ? 'Đang tìm đường...' : 'Tìm đường'),
                  ),
                ),
                if (_routeInfo != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      _routeInfo!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Khu vực bản đồ
          Expanded(
            child: AppMapView(
              initialCameraPosition: const CameraPosition(
                target: AppConfig.defaultHcmLocation,
                zoom: AppConfig.defaultZoom,
              ),
              markers: _markers,
              polylines: _polylines,
              zoomControlsEnabled: true,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}
