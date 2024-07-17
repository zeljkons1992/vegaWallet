import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'current_location_layer.dart';

class MapLocationLoadedWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final bool isStore;
  final double zoomLevel;


  const MapLocationLoadedWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.isStore,
    required this.zoomLevel
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
    if (oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude||
        oldWidget.zoomLevel != widget.zoomLevel) {
      _mapController.move(LatLng(widget.latitude, widget.longitude), widget.zoomLevel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(widget.latitude, widget.longitude),
        initialZoom: widget.zoomLevel,

      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName:
              'net.tlserver6y.flutter_map_location_marker.example',
        ),
        if (widget.isStore)
          MarkerLayer(markers: [
            Marker(
                point: LatLng(widget.latitude, widget.longitude),
                child: const Icon(
                  Icons.store,
                  color: Colors.black,
                  size: 40,
                ))
          ])
        else
          currentLocationLayer(),
      ],
    );
  }
}
