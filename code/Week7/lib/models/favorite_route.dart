class FavoriteRoute {
  final int? id;
  final String title;
  final String originAddress;
  final String destinationAddress;
  final double originLat;
  final double originLng;
  final double destLat;
  final double destLng;
  final String transportMode;
  final String distance;
  final String duration;
  final String encodedPolyline;
  final String createdAt;

  FavoriteRoute({
    this.id,
    required this.title,
    required this.originAddress,
    required this.destinationAddress,
    required this.originLat,
    required this.originLng,
    required this.destLat,
    required this.destLng,
    required this.transportMode,
    required this.distance,
    required this.duration,
    required this.encodedPolyline,
    required this.createdAt,
  });

  // Chuyển đối tượng thành Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'origin_address': originAddress,
      'destination_address': destinationAddress,
      'origin_lat': originLat,
      'origin_lng': originLng,
      'dest_lat': destLat,
      'dest_lng': destLng,
      'transport_mode': transportMode,
      'distance': distance,
      'duration': duration,
      'encoded_polyline': encodedPolyline,
      'created_at': createdAt,
    };
  }

  // Chuyển Map từ SQLite thành đối tượng FavoriteRoute
  factory FavoriteRoute.fromMap(Map<String, dynamic> map) {
    return FavoriteRoute(
      id: map['id'] as int?,
      title: map['title'] ?? '',
      originAddress: map['origin_address'] ?? '',
      destinationAddress: map['destination_address'] ?? '',
      originLat: (map['origin_lat'] as num).toDouble(),
      originLng: (map['origin_lng'] as num).toDouble(),
      destLat: (map['dest_lat'] as num).toDouble(),
      destLng: (map['dest_lng'] as num).toDouble(),
      transportMode: map['transport_mode'] ?? 'driving',
      distance: map['distance'] ?? '',
      duration: map['duration'] ?? '',
      encodedPolyline: map['encoded_polyline'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }
}
