import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:geocoding/geocoding.dart';

import 'i_geo_locator_wrapper.dart';

@lazySingleton
class LocationService {
  final IGeolocatorWrapper geolocator;

  LocationService(this.geolocator);

  Future<List<Location>> getLocationFromAddress(String address) async {
    try {
      return await locationFromAddress(address);
    } catch (e) {
      throw Exception('Failed to get location from address: $e');
    }
  }

  Future<Position> getCurrentPosition() async {
    if (!await _isServiceEnabled()) {
      await Geolocator.openLocationSettings();
      throw Exception('Location services are disabled.');
    }

    await _checkAndRequestPermission();

    return await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<bool> _isServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }
  }
}
