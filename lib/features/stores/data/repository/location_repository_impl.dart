// data/repositories/location_repository_impl.dart
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:injectable/injectable.dart';

import '../../domain/entities/position.dart';
import '../../domain/repository/location_repository.dart';

@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await geolocator.Geolocator.openLocationSettings();
      throw ('Location services are disabled.');
    }

    geolocator.LocationPermission permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) {
        throw ('Location permissions are denied');
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      throw ('Location permissions are permanently denied, we cannot request permissions.');
    }

    geolocator.Position position = await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high);

    return Position(latitude: position.latitude, longitude: position.longitude);
  }
}
