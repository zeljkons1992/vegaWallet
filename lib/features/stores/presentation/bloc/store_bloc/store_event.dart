part of 'store_bloc.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object> get props => [];
}

class LoadStores extends StoreEvent {}

class SearchStores extends StoreEvent {
  final String query;

  const SearchStores(this.query);

  @override
  List<Object> get props => [query];
}
