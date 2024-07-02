import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'current_location_layer.dart';
class MapLocationLoadedWidget extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final double? storeLatitude;
  final double? storeLongitude;
  final MapController mapController;

  const MapLocationLoadedWidget({super.key,
    required this.initialLatitude,
    required this.initialLongitude,
    this.storeLatitude,
    this.storeLongitude,
    required this.mapController,
  });

  @override
  MapLocationLoadedWidgetState createState() => MapLocationLoadedWidgetState();
}

class MapLocationLoadedWidgetState extends State<MapLocationLoadedWidget> {
  late MapOptions _mapOptions;

  @override
  void initState() {
    super.initState();
    _mapOptions = MapOptions(
      initialCenter: LatLng(widget.initialLatitude, widget.initialLongitude),
      initialZoom: 18,
    );
  }

  @override
  void didUpdateWidget(MapLocationLoadedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.storeLatitude != null && widget.storeLongitude != null &&
        (oldWidget.storeLatitude != widget.storeLatitude || oldWidget.storeLongitude != widget.storeLongitude)) {
      widget.mapController.move(LatLng(widget.storeLatitude!, widget.storeLongitude!), 18);
      setState(() {
        _mapOptions = MapOptions(
          initialCenter: LatLng(widget.storeLatitude!, widget.storeLongitude!),
          initialZoom: 18,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: _mapOptions,
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'net.tlserver6y.flutter_map_location_marker.example',
        ),
        if (widget.storeLatitude != null && widget.storeLongitude != null)
          CircleLayer(
            circles: [
              CircleMarker(
                point: LatLng(widget.storeLatitude!, widget.storeLongitude!),
                color: Colors.red.withOpacity(0.7),
                radius: 10,
              ),
            ],
          ),
        currentLocationLayer(),
      ],
    );
  }
}
