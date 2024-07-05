import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../bloc/location_bloc/location_bloc.dart';

class MapLocationError extends StatefulWidget {
  const MapLocationError({super.key});

  @override
  MapLocationErrorState createState() => MapLocationErrorState();
}

class MapLocationErrorState extends State<MapLocationError> {
  final StreamController<bool> _locationPermissionStreamController = StreamController<bool>();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _startPeriodicPermissionCheck();
  }

  @override
  void dispose() {
    _locationPermissionStreamController.close();
    _timer?.cancel();
    super.dispose();
  }

  void _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      _locationPermissionStreamController.add(true);
    } else {
      _locationPermissionStreamController.add(false);
    }
  }

  void _startPeriodicPermissionCheck() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(45.267136, 19.833549),
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
          ],
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Center(
            child: StreamBuilder<bool>(
              stream: _locationPermissionStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!) {
                  BlocProvider.of<LocationBloc>(context).add(GetLocation());
                  return const SizedBox.shrink();
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Location not allowed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          LocationPermission permission = await Geolocator.requestPermission();
                          if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
                            _locationPermissionStreamController.add(true);
                          } else {
                            Geolocator.openLocationSettings();
                          }
                        },
                        child: const Text('Give permission'),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
