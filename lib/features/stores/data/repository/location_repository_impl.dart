import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/domain/entities/position.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/repository/location_repository.dart';

@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  final LocationService _locationService;

  LocationRepositoryImpl(this._locationService);

  @override
  Future<DataState<Position>> getCurrentLocation() async {
    try {
      Position position = await _locationService.getCurrentPosition();
      return DataState.success(position);
    } catch (e) {
      return DataState.error(e.toString());
    }
  }

  @override
  Future<DataState<PositionSimple>> getLocationPickedStore(String address) async {
    try {
      List<Location> locations = await _locationService.getLocationFromAddress(address);
      PositionSimple positionSimple = PositionSimple(
        latitude: locations.first.latitude,
        longitude: locations.first.longitude,
      );
      return DataState.success(positionSimple);
    } catch (e) {
      return DataState.error(e.toString());
    }
  }
}

