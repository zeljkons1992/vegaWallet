import 'package:geolocator/geolocator.dart';
import 'package:vegawallet/core/data_state/data_state.dart';

import '../entities/position.dart';


abstract class LocationRepository{
  Future<DataState<Position>> getCurrentLocation();
  Future<DataState<PositionSimple>> getLocationPickedStore(String address);
}