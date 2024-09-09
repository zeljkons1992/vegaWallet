part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];

}

final class SearchInitial extends SearchState {
  @override
  List<Object?> get props => [];
}


final class StoreSearchDone extends SearchState {
  final List<Store> stores;

  const StoreSearchDone(this.stores);

  @override
  List<Object> get props => [stores];
}

final class StoreSearchError extends SearchState {
  final String message;

  const StoreSearchError({required this.message});

  @override
  List<Object> get props => [message];
}