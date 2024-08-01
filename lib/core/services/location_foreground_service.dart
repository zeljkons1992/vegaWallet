import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/features/profile/domain/repository/profile_repository.dart';

import '../../features/profile/domain/entites/user_profile_information.dart';
import '../../features/stores/domain/entities/position.dart';
import '../data_state/data_state.dart';

@Singleton()
class LocationForegroundService {
  final ProfileRepository _profileRepository;
  final Location _location = Location();
  late StreamSubscription<LocationData> locationSubscription;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LocationForegroundService(this._profileRepository) {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('vega_splash');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> startLocationTracking(String uid) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

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
      locationSubscription.cancel();
    }
  }
}
