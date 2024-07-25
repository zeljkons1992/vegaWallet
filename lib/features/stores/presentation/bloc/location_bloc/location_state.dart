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

class FetchStoreLocationSuccessState extends LocationState {
  final PositionSimple position;

  FetchStoreLocationSuccessState(this.position);

  @override
  List<Object?> get props => [position];
}

class FetchStoreLocationUnsuccessfullyState extends LocationState {

  FetchStoreLocationUnsuccessfullyState();
}



class NoInternetConnectionState extends LocationState {}



class OpenNavigationToAddressUnsuccessful extends LocationState {}