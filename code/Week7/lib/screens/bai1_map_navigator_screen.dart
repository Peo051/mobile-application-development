import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config/app_config.dart';
import '../widgets/app_map_view.dart';

class Bai1MapNavigatorScreen extends StatefulWidget {
  const Bai1MapNavigatorScreen({super.key});

  @override
  State<Bai1MapNavigatorScreen> createState() => _Bai1MapNavigatorScreenState();
}

class _Bai1MapNavigatorScreenState extends State<Bai1MapNavigatorScreen> {
  AppMapController? _mapController;
  final Set<Marker> _markers = {};
  LatLng _currentLocation = AppConfig.defaultHcmLocation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Đặt marker mặc định tại TP.HCM
    _setInitialMarker();
    // Trên Web, chờ người dùng bấm nút trước khi xin quyền vị trí của trình duyệt.
    if (!kIsWeb) _getCurrentLocation();
  }

  void _setInitialMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('defaultLocation'),
          position: AppConfig.defaultHcmLocation,
          infoWindow: const InfoWindow(
            title: 'TP. Hồ Chí Minh',
            snippet: 'Vị trí mặc định (10.7769, 106.7009)',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
        ),
      );
    });
  }

  // Hàm kiểm tra quyền và lấy vị trí GPS hiện tại
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Kiểm tra dịch vụ định vị (GPS) đã bật chưa
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Vui lòng bật dịch vụ định vị (GPS) trên thiết bị.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      // 2. Kiểm tra quyền truy cập vị trí
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Quyền truy cập vị trí đã bị từ chối.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Quyền vị trí bị từ chối vĩnh viễn. Vui lòng cấp quyền trong Cài đặt.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      // 3. Lấy vị trí hiện tại
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final newLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentLocation = newLocation;
        // Đặt marker vị trí hiện tại
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: newLocation,
            infoWindow: InfoWindow(
              title: 'Vị trí hiện tại của bạn',
              snippet:
                  '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        );
      });

      // Di chuyển camera tới vị trí vừa lấy
      _mapController?.animateToLocation(newLocation, zoom: 16);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã cập nhật vị trí hiện tại thành công!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi lấy vị trí: $e'),
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

  // Đưa camera về vị trí mặc định TP.HCM
  void _resetToDefaultLocation() {
    _mapController?.animateToLocation(
      AppConfig.defaultHcmLocation,
      zoom: AppConfig.defaultZoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 1: Map Navigator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_city),
            tooltip: 'Về TP.HCM mặc định',
            onPressed: _resetToDefaultLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          AppMapView(
            initialCameraPosition: const CameraPosition(
              target: AppConfig.defaultHcmLocation,
              zoom: AppConfig.defaultZoom,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          // Hiển thị tọa độ hiện tại
          Positioned(
            bottom: 80,
            left: 16,
            right: 16,
            child: Card(
              color: Colors.white.withValues(alpha: 0.9),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tọa độ: ${_currentLocation.latitude.toStringAsFixed(5)}, ${_currentLocation.longitude.toStringAsFixed(5)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 16),
                      Text('Đang lấy vị trí GPS hiện tại...'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _getCurrentLocation,
        icon: const Icon(Icons.my_location),
        label: const Text('Vị trí hiện tại'),
      ),
    );
  }
}
