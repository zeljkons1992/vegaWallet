part of 'store_bloc.dart';

abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object> get props => [];
}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final List<Store> stores;

  const StoreLoaded({required this.stores});

  @override
  List<Object> get props => [stores];
}

class StoreError extends StoreState {
  final String message;

  const StoreError({required this.message});

  @override
  List<Object> get props => [message];
}

class StoreSearchDone extends StoreState {
  final List<Store> stores;

  const StoreSearchDone(this.stores);

  @override
  List<Object> get props => [stores];
 }
