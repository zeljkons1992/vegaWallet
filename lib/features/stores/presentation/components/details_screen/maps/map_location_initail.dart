import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Widget mapLocationInitial(BuildContext context){
  return Stack(
    children: [
      FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(45.267136, 19.833549),
          initialZoom: 1.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
        ],
      ),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      ),
    ],
  );
}