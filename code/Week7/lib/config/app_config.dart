import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConfig {
  // Google Maps API Key được cấp
  static const String googleMapsApiKey =
      'AIzaSyDqqF0YX6E5d-N4rIMJf9eC-J1nOyPx_LU';

  // Tọa độ mặc định tại TP. Hồ Chí Minh
  static const LatLng defaultHcmLocation = LatLng(10.7769, 106.7009);

  // Mức thu phóng mặc định
  static const double defaultZoom = 14.0;
}
