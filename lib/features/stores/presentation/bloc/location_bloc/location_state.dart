part of 'location_bloc.dart';


abstract class LocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationPermissionDenied extends LocationState {}

class LocationLoaded extends LocationState {
  final Position position;

  LocationLoaded(this.position);

  @override
  List<Object?> get props => [position];
}

class LocationError extends LocationState {
  final String message;

  LocationError(this.message);

  @override
  List<Object?> get props => [message];
}

class StoreLocationUpdatedSuccess extends LocationState {
  final PositionSimple position;

  StoreLocationUpdatedSuccess(this.position);

  @override
  List<Object?> get props => [position];
}

class StoreLocationUpdatedUnsuccessful extends LocationState {
  final String string;

  StoreLocationUpdatedUnsuccessful(this.string);

  @override
  List<Object?> get props => [string];
}

class OpenNavigationToAddressSuccessful extends LocationState {
  final PositionSimple position;

  OpenNavigationToAddressSuccessful(this.position);
  @override
  List<Object?> get props => [position];
}

class OpenNavigationToAddressUnsuccessful extends LocationState {}