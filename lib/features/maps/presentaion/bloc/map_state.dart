part of 'map_bloc.dart';

abstract class MapState extends Equatable {}

final class MapInitial extends MapState {

  @override
  List<Object?> get props => [];
}

final class NoInternetConnection extends MapState {

  @override
  List<Object?> get props => [];
}

