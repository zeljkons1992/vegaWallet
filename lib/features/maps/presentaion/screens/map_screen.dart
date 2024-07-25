import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:vegawallet/core/di/injection.dart';
import 'package:vegawallet/features/profile/presentation/bloc/profile_bloc.dart';

import '../../../auth/presentaion/bloc/auth/auth_bloc.dart';
import '../../../stores/presentation/bloc/location_bloc/location_bloc.dart';
import '../../../stores/presentation/components/details_screen/maps/current_location_layer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationBloc _locationBloc = getIt<LocationBloc>();
  final ProfileBloc _profileBloc = getIt<ProfileBloc>();
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationBloc>(
          create: (context) => _locationBloc..add(GetLocation()),
        ),
        BlocProvider(
          create: (context) => _profileBloc..add(GetUserInformation()),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, locationState) {
            return BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, profileState) {
              if (locationState is LocationLoaded &&
                  profileState is ProfileInformationSuccess) {
                return FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(locationState.position.latitude,
                        locationState.position.longitude),
                    initialZoom: 18,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName:
                          'net.tlserver6y.flutter_map_location_marker.example',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                            point: LatLng(locationState.position.latitude,
                                locationState.position.longitude),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.orange,
                              size: 40,
                            ))
                      ],
                    ),
                    CurrentLocationLayer(
                      alignPositionOnUpdate: AlignOnUpdate.never,
                      alignDirectionOnUpdate: AlignOnUpdate.never,
                      style: LocationMarkerStyle(
                        marker: DefaultLocationMarker(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(profileState
                                .userProfileInformation.profileImage),
                          ),
                        ),
                        markerSize: const Size(40, 40),
                        markerDirection: MarkerDirection.heading,
                      ),
                    )
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            });
          },
        ),
      ),
    );
  }
}
