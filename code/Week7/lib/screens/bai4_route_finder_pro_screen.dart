import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config/app_config.dart';
import '../models/favorite_route.dart';
import '../services/database_helper.dart';
import '../services/map_service.dart';
import '../widgets/app_map_view.dart';

class Bai4RouteFinderProScreen extends StatefulWidget {
  const Bai4RouteFinderProScreen({super.key});

  @override
  State<Bai4RouteFinderProScreen> createState() =>
      _Bai4RouteFinderProScreenState();
}

class _Bai4RouteFinderProScreenState extends State<Bai4RouteFinderProScreen> {
  AppMapController? _mapController;

  // Text controllers
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _searchPlaceController = TextEditingController();

  // Tọa độ đã phân giải
  LatLng? _startLatLng;
  LatLng? _endLatLng;
  String _startAddressName = '';
  String _endAddressName = '';

  // Quản lý Markers và Polylines
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  // Chế độ chọn điểm bằng cách chạm vào bản đồ: 'start' hoặc 'end'
  String _mapTapMode = 'start'; // 'start' hoặc 'end'

  // Phương tiện di chuyển: 'driving' (ô tô), 'two_wheeler' (xe máy), 'walking' (đi bộ)
  String _transportMode = 'driving';

  // Thông tin tuyến đường hiện tại
  DirectionResult? _currentRouteResult;
  bool _isLoading = false;

  // Danh sách kết quả tìm kiếm Places
  List<PlaceItem> _searchResults = [];
  bool _isSearchingPlace = false;

  @override
  void initState() {
    super.initState();
    // Đặt mặc định điểm xuất phát là Chợ Bến Thành, điểm đến là Dinh Độc Lập để tiện thử nghiệm
    _setInitialSample();
  }

  void _setInitialSample() {
    _startLatLng = const LatLng(10.7725, 106.6980); // Chợ Bến Thành
    _startController.text = '10.7725, 106.6980';
    _startAddressName = 'Chợ Bến Thành, Quận 1';

    _endLatLng = const LatLng(10.7769, 106.7009); // Phố đi bộ Nguyễn Huệ
    _endController.text = '10.7769, 106.7009';
    _endAddressName = 'Nguyễn Huệ, Quận 1';

    _updateMarkers();
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _searchPlaceController.dispose();
    super.dispose();
  }

  // Cập nhật Markers trên bản đồ
  void _updateMarkers() {
    setState(() {
      _markers.clear();
      if (_startLatLng != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('start'),
            position: _startLatLng!,
            infoWindow: InfoWindow(
              title: 'Điểm xuất phát',
              snippet: _startAddressName.isNotEmpty
                  ? _startAddressName
                  : '${_startLatLng!.latitude}, ${_startLatLng!.longitude}',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );
      }
      if (_endLatLng != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('end'),
            position: _endLatLng!,
            infoWindow: InfoWindow(
              title: 'Điểm đến',
              snippet: _endAddressName.isNotEmpty
                  ? _endAddressName
                  : '${_endLatLng!.latitude}, ${_endLatLng!.longitude}',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );
      }
    });
  }

  // 1. CHỨC NĂNG BÀI 4: Lấy vị trí GPS hiện tại làm điểm đích hoặc điểm đi
  Future<void> _setCurrentLocationAs({required bool isDestination}) async {
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vui lòng bật dịch vụ vị trí (GPS)!'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Quyền truy cập vị trí bị từ chối!'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final current = LatLng(position.latitude, position.longitude);
      final coordString =
          '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';

      setState(() {
        if (isDestination) {
          _endLatLng = current;
          _endController.text = coordString;
          _endAddressName = 'Vị trí hiện tại (GPS)';
        } else {
          _startLatLng = current;
          _startController.text = coordString;
          _startAddressName = 'Vị trí hiện tại (GPS)';
        }
        _updateMarkers();
      });

      _mapController?.animateToLocation(current, zoom: 15);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isDestination
                  ? 'Đã gán vị trí hiện tại làm điểm đích!'
                  : 'Đã gán vị trí hiện tại làm điểm đi!',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi lấy GPS: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 2. CHỨC NĂNG BÀI 4: Chạm vào bản đồ để chọn điểm
  void _onMapTapped(LatLng point) {
    final coordStr =
        '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}';
    setState(() {
      if (_mapTapMode == 'start') {
        _startLatLng = point;
        _startController.text = coordStr;
        _startAddressName = 'Tọa độ chọn trên bản đồ';
      } else {
        _endLatLng = point;
        _endController.text = coordStr;
        _endAddressName = 'Tọa độ chọn trên bản đồ';
      }
      _updateMarkers();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã chọn ${_mapTapMode == 'start' ? 'Điểm xuất phát' : 'Điểm đến'}: $coordStr',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // 3. CHỨC NĂNG VỀ NHÀ: Phân giải địa chỉ chữ (Geocoding) hoặc Parse tọa độ
  Future<LatLng?> _resolveLocation(String input, String fieldName) async {
    final text = input.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$fieldName không được để trống!'),
          backgroundColor: Colors.orange,
        ),
      );
      return null;
    }

    // Kiểm tra xem người dùng nhập tọa độ "lat, lng" hay địa chỉ bằng chữ
    if (text.contains(',')) {
      final parts = text.split(',');
      final lat = double.tryParse(parts[0].trim());
      final lng = double.tryParse(parts[1].trim());
      if (lat != null &&
          lng != null &&
          lat >= -90 &&
          lat <= 90 &&
          lng >= -180 &&
          lng <= 180) {
        return LatLng(lat, lng);
      }
    }

    // Nếu không phải dạng tọa độ số, sử dụng Geocoding API để tìm kiếm địa chỉ chữ
    final geocodeRes = await MapService.geocodeAddress(text);
    if (geocodeRes != null) {
      final loc = geocodeRes['location'] as LatLng;
      return loc;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể tìm thấy địa chỉ/tọa độ cho $fieldName!'),
          backgroundColor: Colors.red,
        ),
      );
    }
    return null;
  }

  // 4. TÌM ĐƯỜNG ĐI VÀ VẼ POLYLINE
  Future<void> _findRoute() async {
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    final start = await _resolveLocation(
      _startController.text,
      'Điểm xuất phát',
    );
    final end = await _resolveLocation(_endController.text, 'Điểm đến');

    if (start == null || end == null) {
      setState(() => _isLoading = false);
      return;
    }

    _startLatLng = start;
    _endLatLng = end;
    _updateMarkers();

    try {
      final result = await MapService.getDirections(
        origin: start,
        destination: end,
        mode: _transportMode,
      );

      if (result != null && result.polylinePoints.isNotEmpty) {
        setState(() {
          _currentRouteResult = result;
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('activeRoute'),
              points: result.polylinePoints,
              color: _getModeColor(_transportMode),
              width: 5,
            ),
          );
        });

        _fitBounds(start, end);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Tìm đường thành công! (${result.distanceText} - ${result.durationText})',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Không tìm thấy đường đi giữa hai điểm này hoặc dịch vụ Google Maps bận.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _getModeColor(String mode) {
    switch (mode) {
      case 'walking':
        return Colors.purple;
      case 'two_wheeler':
        return Colors.orange;
      case 'driving':
      default:
        return Colors.blue;
    }
  }

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
    _mapController?.fitCoordinates([southWest, northEast], padding: 70);
  }

  // 5. TÌM KIẾM ĐỊA ĐIỂM (Places API)
  void _openPlacesSearchDialog() {
    _searchPlaceController.clear();
    _searchResults.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SizedBox(
                height: 450,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.search, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Tìm kiếm địa điểm (Places API)',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _searchPlaceController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText:
                            'Nhập tên địa điểm (VD: Bến Thành, Landmark 81...)',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            final q = _searchPlaceController.text.trim();
                            if (q.isEmpty) return;
                            setModalState(() => _isSearchingPlace = true);
                            final results = await MapService.searchPlaces(
                              q,
                              nearLocation: _startLatLng,
                            );
                            setModalState(() {
                              _searchResults = results;
                              _isSearchingPlace = false;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (q) async {
                        if (q.trim().isEmpty) return;
                        setModalState(() => _isSearchingPlace = true);
                        final results = await MapService.searchPlaces(
                          q.trim(),
                          nearLocation: _startLatLng,
                        );
                        setModalState(() {
                          _searchResults = results;
                          _isSearchingPlace = false;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    if (_isSearchingPlace)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_searchResults.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Text('Nhập từ khóa và bấm tìm kiếm'),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, idx) {
                            final place = _searchResults[idx];
                            return ListTile(
                              dense: true,
                              leading: const Icon(
                                Icons.place,
                                color: Colors.red,
                              ),
                              title: Text(
                                place.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                place.address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: PopupMenuButton<String>(
                                icon: const Icon(Icons.add_location_alt),
                                onSelected: (val) {
                                  Navigator.pop(ctx);
                                  setState(() {
                                    if (val == 'start') {
                                      _startLatLng = place.location;
                                      _startController.text =
                                          '${place.location.latitude.toStringAsFixed(5)}, ${place.location.longitude.toStringAsFixed(5)}';
                                      _startAddressName = place.name;
                                    } else {
                                      _endLatLng = place.location;
                                      _endController.text =
                                          '${place.location.latitude.toStringAsFixed(5)}, ${place.location.longitude.toStringAsFixed(5)}';
                                      _endAddressName = place.name;
                                    }
                                    _updateMarkers();
                                  });
                                  _mapController?.animateToLocation(
                                    place.location,
                                    zoom: 16,
                                  );
                                },
                                itemBuilder: (c) => [
                                  const PopupMenuItem(
                                    value: 'start',
                                    child: Text('Đặt làm Điểm đi'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'end',
                                    child: Text('Đặt làm Điểm đến'),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.pop(ctx);
                                setState(() {
                                  _endLatLng = place.location;
                                  _endController.text =
                                      '${place.location.latitude.toStringAsFixed(5)}, ${place.location.longitude.toStringAsFixed(5)}';
                                  _endAddressName = place.name;
                                  _updateMarkers();
                                });
                                _mapController?.animateToLocation(
                                  place.location,
                                  zoom: 16,
                                );
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 6. CHỨC NĂNG VỀ NHÀ: Lưu tuyến yêu thích vào SQLite
  Future<void> _saveFavoriteRoute() async {
    if (_currentRouteResult == null ||
        _startLatLng == null ||
        _endLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng tìm tuyến đường trước khi lưu!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final titleController = TextEditingController(
      text:
          '${_startAddressName.isNotEmpty ? _startAddressName : "Điểm đi"} ➔ ${_endAddressName.isNotEmpty ? _endAddressName : "Điểm đến"}',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Lưu tuyến đường yêu thích'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Tên tuyến đường',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim().isEmpty
                    ? 'Tuyến đường yêu thích'
                    : titleController.text.trim();
                Navigator.pop(ctx);

                final route = FavoriteRoute(
                  title: title,
                  originAddress: _startAddressName.isNotEmpty
                      ? _startAddressName
                      : _startController.text,
                  destinationAddress: _endAddressName.isNotEmpty
                      ? _endAddressName
                      : _endController.text,
                  originLat: _startLatLng!.latitude,
                  originLng: _startLatLng!.longitude,
                  destLat: _endLatLng!.latitude,
                  destLng: _endLatLng!.longitude,
                  transportMode: _transportMode,
                  distance: _currentRouteResult!.distanceText,
                  duration: _currentRouteResult!.durationText,
                  encodedPolyline: _currentRouteResult!.encodedPolyline,
                  createdAt: DateTime.now().toString().substring(0, 16),
                );

                await DatabaseHelper.instance.insertRoute(route);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Đã lưu tuyến đường vào SQLite thành công!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  // 7. CHỨC NĂNG VỀ NHÀ: Xem và xóa danh sách tuyến yêu thích từ SQLite
  void _openFavoriteRoutesModal() async {
    final routes = await DatabaseHelper.instance.getAllRoutes();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: 480,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bookmarks, color: Colors.orange),
                        const SizedBox(width: 8),
                        const Text(
                          'Tuyến đường yêu thích (SQLite)',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  if (routes.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Chưa có tuyến đường nào được lưu!\nHãy tìm kiếm một tuyến đường và nhấn nút Lưu.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: routes.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, idx) {
                          final r = routes[idx];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getModeColor(r.transportMode)
                                  .withValues(alpha: 0.2),
                              child: Icon(
                                _getModeIcon(r.transportMode),
                                color: _getModeColor(r.transportMode),
                              ),
                            ),
                            title: Text(
                              r.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${r.originAddress} ➔ ${r.destinationAddress}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'KC: ${r.distance} | Thời gian: ${r.duration} (${r.createdAt})',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              tooltip: 'Xóa',
                              onPressed: () async {
                                if (r.id != null) {
                                  await DatabaseHelper.instance.deleteRoute(
                                    r.id!,
                                  );
                                  setModalState(() {
                                    routes.removeAt(idx);
                                  });
                                }
                              },
                            ),
                            onTap: () {
                              Navigator.pop(ctx);
                              _loadSavedRoute(r);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  IconData _getModeIcon(String mode) {
    switch (mode) {
      case 'walking':
        return Icons.directions_walk;
      case 'two_wheeler':
        return Icons.two_wheeler;
      case 'driving':
      default:
        return Icons.directions_car;
    }
  }

  // Tải lại một tuyến đường đã lưu lên bản đồ
  void _loadSavedRoute(FavoriteRoute route) {
    final start = LatLng(route.originLat, route.originLng);
    final end = LatLng(route.destLat, route.destLng);

    setState(() {
      _startLatLng = start;
      _endLatLng = end;
      _startController.text =
          '${start.latitude.toStringAsFixed(5)}, ${start.longitude.toStringAsFixed(5)}';
      _endController.text =
          '${end.latitude.toStringAsFixed(5)}, ${end.longitude.toStringAsFixed(5)}';
      _startAddressName = route.originAddress;
      _endAddressName = route.destinationAddress;
      _transportMode = route.transportMode;

      final points = MapService.decodePolyline(route.encodedPolyline);
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('activeRoute'),
          points: points,
          color: _getModeColor(route.transportMode),
          width: 5,
        ),
      );

      _currentRouteResult = DirectionResult(
        polylinePoints: points,
        encodedPolyline: route.encodedPolyline,
        distanceText: route.distance,
        durationText: route.duration,
        startAddress: route.originAddress,
        endAddress: route.destinationAddress,
      );

      _updateMarkers();
    });

    _fitBounds(start, end);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã tải lại: ${route.title}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 4 & Về Nhà: Route Finder Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Tìm địa điểm (Places API)',
            onPressed: _openPlacesSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.bookmarks),
            tooltip: 'Tuyến yêu thích (SQLite)',
            onPressed: _openFavoriteRoutesModal,
          ),
        ],
      ),
      body: Column(
        children: [
          // Khu vực điều khiển nhập liệu và tùy chọn
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ô nhập điểm xuất phát + Nút GPS lấy vị trí hiện tại
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _startController,
                        decoration: InputDecoration(
                          labelText: 'Điểm xuất phát (địa chỉ hoặc tọa độ)',
                          prefixIcon: const Icon(
                            Icons.my_location,
                            color: Colors.green,
                            size: 20,
                          ),
                          suffixIcon: _startController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      _startController.clear();
                                      _startLatLng = null;
                                      _updateMarkers();
                                    });
                                  },
                                )
                              : null,
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.gps_fixed, size: 20),
                      tooltip: 'Lấy GPS làm điểm đi',
                      onPressed: () =>
                          _setCurrentLocationAs(isDestination: false),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Ô nhập điểm đến + Nút GPS lấy vị trí hiện tại làm điểm đích
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _endController,
                        decoration: InputDecoration(
                          labelText: 'Điểm đến (địa chỉ hoặc tọa độ)',
                          prefixIcon: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 20,
                          ),
                          suffixIcon: _endController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      _endController.clear();
                                      _endLatLng = null;
                                      _updateMarkers();
                                    });
                                  },
                                )
                              : null,
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.flag, size: 20, color: Colors.red),
                      tooltip: 'Lấy GPS làm điểm đích',
                      onPressed: () =>
                          _setCurrentLocationAs(isDestination: true),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Lựa chọn phương tiện & Lựa chọn chế độ chạm bản đồ
                Row(
                  children: [
                    // Phương tiện di chuyển
                    Expanded(
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _transportMode,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                value: 'driving',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.directions_car,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Ô tô (Driving)',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'two_wheeler',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.two_wheeler,
                                      size: 18,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Xe máy',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'walking',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.directions_walk,
                                      size: 18,
                                      color: Colors.purple,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Đi bộ (Walking)',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _transportMode = val);
                                if (_currentRouteResult != null) {
                                  _findRoute(); // Tự động cập nhật tuyến đường khi đổi phương tiện
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Chế độ chạm vào bản đồ
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'start',
                          label: Text(
                            'Chạm: Đi',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        ButtonSegment(
                          value: 'end',
                          label: Text(
                            'Chạm: Đến',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                      selected: {_mapTapMode},
                      onSelectionChanged: (set) {
                        setState(() => _mapTapMode = set.first);
                      },
                      style: const ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Hàng nút: "Tìm đường" và "Lưu yêu thích"
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _findRoute,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.directions, size: 20),
                        label: Text(_isLoading ? 'Đang tìm...' : 'Tìm đường'),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      flex: 1,
                      child: OutlinedButton.icon(
                        onPressed: _currentRouteResult == null
                            ? null
                            : _saveFavoriteRoute,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        icon: const Icon(Icons.bookmark_add, size: 18),
                        label: const Text('Lưu'),
                      ),
                    ),
                  ],
                ),

                // Hiển thị thông tin khoảng cách & thời gian
                if (_currentRouteResult != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.straighten,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Khoảng cách: ${_currentRouteResult!.distanceText}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.timer,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Thời gian: ${_currentRouteResult!.durationText}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Khu vực Google Map
          Expanded(
            child: AppMapView(
              initialCameraPosition: const CameraPosition(
                target: AppConfig.defaultHcmLocation,
                zoom: AppConfig.defaultZoom,
              ),
              markers: _markers,
              polylines: _polylines,
              zoomControlsEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: _onMapTapped,
              onMapCreated: (ctrl) => _mapController = ctrl,
            ),
          ),
        ],
      ),
    );
  }
}
