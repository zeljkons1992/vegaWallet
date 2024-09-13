part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class SearchStores extends SearchEvent {
  final String query;

  const SearchStores(this.query);

  @override
  List<Object> get props => [query];
}