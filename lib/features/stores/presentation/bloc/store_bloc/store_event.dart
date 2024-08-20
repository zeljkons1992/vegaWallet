part of 'store_bloc.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object> get props => [];
}

final class LoadStores extends StoreEvent {}

final class SearchStores extends StoreEvent {
  final String query;

  const SearchStores(this.query);

  @override
  List<Object> get props => [query];
}

final class UpdateStore extends StoreEvent {
  final Store store;

  const UpdateStore(this.store);

  @override
  List<Object> get props => [store];
}


// class ToggleCategoryExpansion extends StoreEvent {
//   final String category;
//   final bool isExpanded;
//
//   const ToggleCategoryExpansion(this.category, this.isExpanded);
//
//   @override
//   List<Object> get props => [category, isExpanded];
// }

