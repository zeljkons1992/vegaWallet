import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/features/profile/domain/repository/profile_repository.dart';

import '../../features/stores/domain/entities/position.dart';
import '../data_state/data_state.dart';

@Singleton()
class LocationForegroundService {
  final ProfileRepository _profileRepository;
  final Location _location = Location();
  late StreamSubscription<LocationData> locationSubscription;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  LocationForegroundService(this._profileRepository) {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse);
  }

  void _onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    if (notificationResponse.payload == 'stop_sharing') {
      stopLocationTracking();
    }
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'location_channel',
      'Location Tracking',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('stop_sharing', 'Stop Sharing'),
      ],
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Location Tracking',
      'Your location is being tracked',
      platformChannelSpecifics,
      payload: 'stop_sharing',
    );
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

    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 5000,
      distanceFilter: 20,
    );

    await _location.enableBackgroundMode(enable: true);
    await _showNotification();

    locationSubscription = _location.onLocationChanged.listen((LocationData currentLocation) async {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        final userResult = await _profileRepository.getRemoteUserInformation(uid);
        if (userResult.status == DataStateStatus.success) {
          final userProfile = userResult.data;
          final updatedUser = userProfile?.copyWith(
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

  Future<void> stopLocationTracking() async {
    await flutterLocalNotificationsPlugin.cancel(0);
    locationSubscription.cancel();
  }
}
