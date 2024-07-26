import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:vegawallet/core/di/injection.dart';
import 'package:vegawallet/features/profile/domain/entites/user_profile_information.dart';
import 'package:vegawallet/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:vegawallet/features/stores/domain/entities/position.dart';

import '../../../auth/presentaion/bloc/auth/auth_bloc.dart';
import '../../../stores/presentation/bloc/location_bloc/location_bloc.dart';
import '../../../stores/presentation/components/details_screen/maps/current_location_layer.dart';
import '../../../stores/presentation/components/details_screen/maps/map_location_error.dart';
import '../bloc/map_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapBloc _mapBloc = getIt<MapBloc>();
  final ProfileBloc _profileBloc = getIt<ProfileBloc>();
  late MapController _mapController;
  late StreamSubscription<Position?> _locationSubscription;
  late UserProfileInformation _user;
  double? _previousLongitude;
  double? _previousLatitude;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _locationSubscription = const LocationMarkerDataStreamFactory()
        .defaultPositionStreamSource()
        .listen((position) {
      if (position != null && (position.longitude != _previousLongitude || position.latitude != _previousLatitude)) _updateUserLocation(position);
    });
  }

  _updateUserLocation(Position position) {
     final user = UserProfileInformation(
        uid: _user.uid,
        nameAndSurname: _user.nameAndSurname,
        email: _user.email,
        profileImage: _user.profileImage,
        dateTime: _user.dateTime,
        position: PositionSimple(latitude: position.latitude, longitude: position.longitude),
        isLocationOn: _user.isLocationOn,
    );
     _previousLatitude = position.latitude;
     _previousLongitude = position.longitude;
     _profileBloc.add(UpdateUserLocation(user));
    print("PROMIJENIO LOKACIJU");
  }

  @override
  void dispose() {
    super.dispose();
    _locationSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MapBloc>(
          create: (context) => _mapBloc,
        ),
        BlocProvider(
          create: (context) => _profileBloc..add(GetUserInformation()),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<MapBloc, MapState>(
          builder: (context, mapState) {
            if (mapState is NoInternetConnection) {
              return const MapLocationError();
            } else {
              return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, profileState) {
                if (profileState is ProfileInformationSuccess) {
                  _user = profileState.userProfileInformation;
                  return FlutterMap(
                    mapController: _mapController,
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName:
                            'net.tlserver6y.flutter_map_location_marker.example',
                      ),
                      CurrentLocationLayer(
                        alignPositionOnUpdate: AlignOnUpdate.once,
                        style: LocationMarkerStyle(
                          marker: DefaultLocationMarker(
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(profileState
                                  .userProfileInformation.profileImage),
                            ),
                          ),
                          showHeadingSector: false,
                          markerSize: const Size(40, 40),
                        ),
                      )
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              });
            }
          },
        ),
      ),
    );
  }
}
