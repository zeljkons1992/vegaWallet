import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';

import '../../../domain/entities/store.dart';
import '../../../domain/usecases/add_store_to_favorites_use_case.dart';
import '../../../domain/usecases/get_favorites_use_case.dart';
import '../../../domain/usecases/remove_store_from_favorites_use_case.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

@Injectable()
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final AddStoreToFavoritesUseCase _addStoreToFavoritesUseCase;
  final RemoveStoreFromFavoritesUseCase _removeStoreFromFavoritesUseCase;

  FavoritesBloc(this._getFavoritesUseCase, this._addStoreToFavoritesUseCase, this._removeStoreFromFavoritesUseCase) : super(FavoritesInitial()) {
     on<GetFavorites>(_onGetFavorites);
     on<AddStoreToFavorites>(_onAddStoreToFavorites);
     on<RemoveStoreFromFavorites>(_onRemoveStoreFromFavorites);
  }

  Future<void> _onGetFavorites(GetFavorites event, Emitter<FavoritesState> emit) async {
    emit(FavoritesInitial());
    final dataState = await _getFavoritesUseCase();
    if (dataState.status == DataStateStatus.success) {
      emit(FavoritesLoaded(dataState.data));
    }
  }


  Future<FutureOr<void>> _onAddStoreToFavorites(AddStoreToFavorites event, Emitter<FavoritesState> emit) async {
    final result = await _addStoreToFavoritesUseCase(params: event.store);

    if (result.status == DataStateStatus.success) {
      if (state is FavoritesLoaded) {
        final updatedFavorites = List<Store>.from((state as FavoritesLoaded).favorites)
        ..add(event.store.copyWith(isFavorite: true));
        emit(FavoritesLoaded(updatedFavorites));
      }
    }
    else {
      if (result.status == DataStateStatus.error) emit(FavoritesError(result.message!));
    }
  }

  Future<FutureOr<void>> _onRemoveStoreFromFavorites(RemoveStoreFromFavorites event, Emitter<FavoritesState> emit) async {
    final result = await _removeStoreFromFavoritesUseCase(params: event.store);

    if (result.status == DataStateStatus.success) {
      if (state is FavoritesLoaded) {
        final updatedFavorites = List<Store>.from((state as FavoritesLoaded).favorites)
          ..removeWhere((s) => s.id == event.store.id);
        emit(FavoritesLoaded(updatedFavorites));
      }
    }
    else {
      if (result.status == DataStateStatus.error) emit(FavoritesError(result.message!));
    }
  }
}
