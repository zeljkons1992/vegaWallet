part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {}

class SaveMyLocation extends MapEvent {
  @override
  List<Object?> get props => [];
}

class ConnectionLost extends MapEvent {
  @override
  List<Object?> get props => [];
}

class ConnectionRegained extends MapEvent {
  @override
  List<Object?> get props => [];
}