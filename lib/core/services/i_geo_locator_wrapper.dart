import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

abstract class IGeolocatorWrapper {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
  Future<Position> getCurrentPosition({LocationAccuracy desiredAccuracy = LocationAccuracy.best});
  Future<void> openLocationSettings();
}
@Injectable(as: IGeolocatorWrapper)
class GeolocatorWrapper implements IGeolocatorWrapper {
  @override
  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermission> checkPermission() {
    return Geolocator.checkPermission();
  }

  @override
  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  @override
  Future<Position> getCurrentPosition({LocationAccuracy desiredAccuracy = LocationAccuracy.best}) {
    return Geolocator.getCurrentPosition(desiredAccuracy: desiredAccuracy);
  }

  @override
  Future<void> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }
}
