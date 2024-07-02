import '../entities/position.dart';

abstract class LocationRepository{
  Future<Position> getCurrentLocation();
}