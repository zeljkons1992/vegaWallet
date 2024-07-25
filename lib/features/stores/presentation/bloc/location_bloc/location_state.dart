part of 'location_bloc.dart';


abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class FetchStoreLocationSuccessState extends LocationState {
  final PositionSimple position;

  const FetchStoreLocationSuccessState(this.position);

  @override
  List<Object?> get props => [position];
}

class FetchStoreLocationUnsuccessfullyState extends LocationState {

  const FetchStoreLocationUnsuccessfullyState();
}

class NoInternetConnectionState extends LocationState {}

class OpenNavigationToAddressUnsuccessful extends LocationState {}