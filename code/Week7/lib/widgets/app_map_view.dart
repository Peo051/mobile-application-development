import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart' as latlong;

/// Shared map view that uses native Google Maps on mobile and OSM tiles on Web.
class AppMapController {
  final gmaps.GoogleMapController? _googleController;
  final fmap.MapController? _webController;

  const AppMapController._({this._googleController, this._webController});

  void animateToLocation(gmaps.LatLng target, {double zoom = 14}) {
    final googleController = _googleController;
    if (googleController != null) {
      googleController.animateCamera(
        gmaps.CameraUpdate.newLatLngZoom(target, zoom),
      );
      return;
    }

    _webController?.move(_toWebLatLng(target), zoom);
  }

  void fitCoordinates(List<gmaps.LatLng> coordinates, {double padding = 70}) {
    if (coordinates.isEmpty) return;

    final south = coordinates.map((point) => point.latitude).reduce(_min);
    final north = coordinates.map((point) => point.latitude).reduce(_max);
    final west = coordinates.map((point) => point.longitude).reduce(_min);
    final east = coordinates.map((point) => point.longitude).reduce(_max);

    if (south == north && west == east) {
      animateToLocation(coordinates.first, zoom: 15);
      return;
    }

    final googleController = _googleController;
    if (googleController != null) {
      googleController.animateCamera(
        gmaps.CameraUpdate.newLatLngBounds(
          gmaps.LatLngBounds(
            southwest: gmaps.LatLng(south, west),
            northeast: gmaps.LatLng(north, east),
          ),
          padding,
        ),
      );
      return;
    }

    _webController?.fitCamera(
      fmap.CameraFit.coordinates(
        coordinates: coordinates.map(_toWebLatLng).toList(),
        padding: EdgeInsets.all(padding),
        maxZoom: 16,
      ),
    );
  }

  static double _min(double a, double b) => a < b ? a : b;
  static double _max(double a, double b) => a > b ? a : b;
}

latlong.LatLng _toWebLatLng(gmaps.LatLng point) =>
    latlong.LatLng(point.latitude, point.longitude);

class AppMapView extends StatefulWidget {
  final gmaps.CameraPosition initialCameraPosition;
  final Set<gmaps.Marker> markers;
  final Set<gmaps.Polyline> polylines;
  final void Function(gmaps.LatLng)? onTap;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final bool zoomControlsEnabled;
  final void Function(AppMapController)? onMapCreated;

  const AppMapView({
    super.key,
    required this.initialCameraPosition,
    this.markers = const {},
    this.polylines = const {},
    this.onTap,
    this.myLocationEnabled = true,
    this.myLocationButtonEnabled = true,
    this.zoomControlsEnabled = true,
    this.onMapCreated,
  });

  @override
  State<AppMapView> createState() => _AppMapViewState();
}

class _AppMapViewState extends State<AppMapView> {
  final fmap.MapController _webController = fmap.MapController();
  bool _webControllerReported = false;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return gmaps.GoogleMap(
        initialCameraPosition: widget.initialCameraPosition,
        markers: widget.markers,
        polylines: widget.polylines,
        onTap: widget.onTap,
        myLocationEnabled: widget.myLocationEnabled,
        myLocationButtonEnabled: widget.myLocationButtonEnabled,
        zoomControlsEnabled: widget.zoomControlsEnabled,
        onMapCreated: (controller) {
          widget.onMapCreated?.call(
            AppMapController._(googleController: controller),
          );
        },
      );
    }

    return fmap.FlutterMap(
      mapController: _webController,
      options: fmap.MapOptions(
        initialCenter: _toWebLatLng(widget.initialCameraPosition.target),
        initialZoom: widget.initialCameraPosition.zoom,
        minZoom: 3,
        maxZoom: 19,
        onTap: (_, point) {
          widget.onTap?.call(gmaps.LatLng(point.latitude, point.longitude));
        },
        onMapReady: _notifyWebMapReady,
      ),
      children: [
        fmap.TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          maxNativeZoom: 19,
        ),
        if (widget.polylines.isNotEmpty)
          fmap.PolylineLayer(
            polylines: widget.polylines
                .map(
                  (line) => fmap.Polyline(
                    points: line.points.map(_toWebLatLng).toList(),
                    color: line.color,
                    strokeWidth: line.width.toDouble(),
                  ),
                )
                .toList(),
          ),
        if (widget.markers.isNotEmpty)
          fmap.MarkerLayer(
            markers: widget.markers.map(_buildWebMarker).toList(),
          ),
        const fmap.SimpleAttributionWidget(
          source: Text('© OpenStreetMap contributors'),
        ),
      ],
    );
  }

  void _notifyWebMapReady() {
    if (_webControllerReported) return;
    _webControllerReported = true;
    widget.onMapCreated?.call(
      AppMapController._(webController: _webController),
    );
  }

  fmap.Marker _buildWebMarker(gmaps.Marker marker) {
    final id = marker.markerId.value.toLowerCase();
    final color = id.contains('start')
        ? Colors.green
        : id.contains('end')
        ? Colors.red
        : id.contains('default')
        ? Colors.deepPurple
        : Colors.blue;

    return fmap.Marker(
      point: _toWebLatLng(marker.position),
      width: 42,
      height: 48,
      child: Tooltip(
        message: [
          marker.infoWindow.title,
          marker.infoWindow.snippet,
        ].whereType<String>().where((text) => text.isNotEmpty).join('\n'),
        child: Icon(Icons.location_on, color: color, size: 40),
      ),
    );
  }
}
