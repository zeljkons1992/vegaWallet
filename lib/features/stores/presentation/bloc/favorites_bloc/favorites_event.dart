part of 'favorites_bloc.dart';


abstract class FavoritesEvent extends Equatable {}

final class GetFavorites extends FavoritesEvent {

  @override
  List<Object?> get props => [];

}

final class AddStoreToFavorites extends FavoritesEvent {
  final Store store;

  AddStoreToFavorites(this.store);

  @override
  List<Object> get props => [store];
}

final class RemoveStoreFromFavorites extends FavoritesEvent {
  final Store store;

  RemoveStoreFromFavorites(this.store);

  @override
  List<Object> get props => [store];
}