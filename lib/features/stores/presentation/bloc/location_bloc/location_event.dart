part of 'location_bloc.dart';


abstract class LocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetLocation extends LocationEvent {}
