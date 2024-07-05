part of 'location_bloc.dart';


abstract class LocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetLocation extends LocationEvent {}

class RequestLocationPermission extends LocationEvent {}

class OpenLocationSettings extends LocationEvent {}

class UpdateStoreLocation extends LocationEvent {
  final String city;

  UpdateStoreLocation(this.city);

  @override
  List<Object?> get props => [city];
}

class OpenNavigationToAddress extends LocationEvent {
  final String address;

  OpenNavigationToAddress(this.address);

  @override
  List<Object?> get props => [address];
}