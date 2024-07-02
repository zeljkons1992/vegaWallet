import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

Widget currentLocationLayer() {
  return CurrentLocationLayer(
    alignPositionOnUpdate: AlignOnUpdate.always,
    alignDirectionOnUpdate: AlignOnUpdate.always,
    style: const LocationMarkerStyle(
      marker: DefaultLocationMarker(
        child: Icon(
          Icons.navigation,
          color: Colors.white,
        ),
      ),
      markerSize: Size(40, 40),
      markerDirection: MarkerDirection.heading,
    ),
  );
}