import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;
import 'package:vegawallet/features/profile/domain/enums/location_permission_response.dart';
import 'package:vegawallet/features/profile/domain/repository/profile_repository.dart';

import '../../features/profile/domain/entites/user_profile_information.dart';
import '../../features/stores/domain/entities/position.dart';
import '../data_state/data_state.dart';

@Singleton()
class LocationForegroundService {
  final ProfileRepository _profileRepository;
  final Location _location = Location();
  StreamSubscription<LocationData>? locationSubscription;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  LocationForegroundService(this._profileRepository) {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('vega_splash');
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<LocationPermissionResponse> startLocationTracking(String uid) async {
    bool serviceEnabled;

    // Request foreground location permission first
    final permission_handler.PermissionStatus foregroundPermissionStatus =
    await permission_handler.Permission.location.request();

    if (foregroundPermissionStatus.isGranted) {
      print("Location granted while using the app");
      // Request background location permission
      final permission_handler.PermissionStatus backgroundPermissionStatus =
      await permission_handler.Permission.locationAlways.request();

      if (backgroundPermissionStatus.isGranted) {

        serviceEnabled = await _location.serviceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await _location.requestService();
          if (!serviceEnabled) {
            return LocationPermissionResponse.serviceDisabled;
          }
        }

        print("Location granted always");
        await _location.changeNotificationOptions(
          title: "Location tracking",
          subtitle: 'Your location is being tracked',
          iconName: 'vega_splash',
          onTapBringToFront: true,
        );

        await _location.changeSettings(
          accuracy: LocationAccuracy.high,
          interval: 5000,
          distanceFilter: 20,
        );

        await _location.enableBackgroundMode(enable: true);

        locationSubscription = _location.onLocationChanged
            .listen((LocationData currentLocation) async {
          if (currentLocation.latitude != null &&
              currentLocation.longitude != null) {
            final userResult =
            await _profileRepository.getRemoteUserInformation(uid);
            if (userResult.status == DataStateStatus.success) {
              final userProfile = userResult.data;
              final updatedUser = userProfile?.copyWith(
                isLocationOn: true,
                position: PositionSimple(
                  latitude: currentLocation.latitude!,
                  longitude: currentLocation.longitude!,
                ),
              );
              await _profileRepository.updateUserLocation(updatedUser!);
            }
          }
        });

        return LocationPermissionResponse.granted;
      } else {
        print("Location allowed when using the app, but not always");
        // Emit the event to ProfileBloc to notify about the permission status
        // profileBloc.add(LocationPermissionNotAlwaysAllowed());
        return LocationPermissionResponse.notGranted;
      }
    } else {
      print("Location not allowed at all");
      // Handle case where foreground permission is not granted
      // Emit the event to ProfileBloc to notify about the permission status
      // profileBloc.add(LocationPermissionNotAlwaysAllowed());
      return LocationPermissionResponse.notGranted;
    }
  }

  Future<void> stopLocationTracking(String uid) async {
    final userResult = await _profileRepository.getRemoteUserInformation(uid);
    if (userResult.status == DataStateStatus.success) {
      final userProfile = userResult.data;
      final updatedUser = UserProfileInformation(
        uid: userProfile!.uid,
        nameAndSurname: userProfile.nameAndSurname,
        email: userProfile.email,
        phoneNumber: userProfile.phoneNumber,
        profileImage: userProfile.profileImage,
        dateTime: userProfile.dateTime,
        position: null,
        isLocationOn: false,
      );
      await _profileRepository.updateUserLocation(updatedUser);
      _location.enableBackgroundMode(enable: false);
      if (locationSubscription != null) locationSubscription!.cancel();
    }
  }
}
