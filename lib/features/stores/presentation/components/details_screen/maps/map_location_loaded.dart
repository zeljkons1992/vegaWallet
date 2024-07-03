import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'current_location_layer.dart';

class MapLocationLoadedWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final bool isStore;

  const MapLocationLoadedWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.isStore,
  });

  @override
  MapLocationLoadedWidgetState createState() => MapLocationLoadedWidgetState();
}

class MapLocationLoadedWidgetState extends State<MapLocationLoadedWidget> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void didUpdateWidget(MapLocationLoadedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latitude != widget.latitude || oldWidget.longitude != widget.longitude) {
      _mapController.move(LatLng(widget.latitude, widget.longitude), 18);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(widget.latitude, widget.longitude),
        initialZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'net.tlserver6y.flutter_map_location_marker.example',
        ),
        if (widget.isStore)
          CircleLayer(
            circles: [
              CircleMarker(
                point: LatLng(widget.latitude, widget.longitude),
                color: Colors.red.withOpacity(0.7),
                radius: 10,
              ),
            ],
          )
        else
          currentLocationLayer(),
      ],
    );
  }
}
