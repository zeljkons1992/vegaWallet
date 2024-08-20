part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {}

final class FavoritesInitial extends FavoritesState {
  @override
  List<Object?> get props => [];
}

final class FavoritesLoading extends FavoritesState {
  @override
  List<Object?> get props => [];
}

final class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

final class FavoritesLoaded extends FavoritesState {
  final List<Store> favorites;

  FavoritesLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}
