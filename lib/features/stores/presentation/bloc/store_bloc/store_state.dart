part of 'store_bloc.dart';

abstract class StoreState extends Equatable {
  const StoreState();

}

final class StoreInitial extends StoreState {
  @override
  List<Object?> get props => [];
}

final class StoreLoading extends StoreState {
  @override
  List<Object?> get props => [];
}

final class StoreLoaded extends StoreState {
  final List<Store> stores;

  const StoreLoaded(this.stores);

  StoreLoaded copyWith({
    List<Store>? stores,
  }) {
    return StoreLoaded(
      stores ?? this.stores,
    );
  }

  @override
  List<Object> get props => [stores];
}

final class StoreError extends StoreState {
  final String message;

  const StoreError({required this.message});

  @override
  List<Object> get props => [message];
}

final class StoreSearchDone extends StoreState {
  final List<Store> stores;

  const StoreSearchDone(this.stores);

  @override
  List<Object> get props => [stores];
 }
