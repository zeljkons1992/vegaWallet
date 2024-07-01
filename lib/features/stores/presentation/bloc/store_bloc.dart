import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import '../../domain/entities/cache_policy.dart';
import '../../domain/entities/store.dart';
import '../../domain/usecases/fetch_stores_use_case.dart';
import '../../domain/usecases/search_stores_use_case.dart';

part 'store_event.dart';

part 'store_state.dart';

@Injectable()
class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final FetchStoresUseCase _fetchStoresUseCase;
  final SearchStoresUseCase _searchStoresUseCase;


  StoreBloc(this._fetchStoresUseCase, this._searchStoresUseCase) : super(StoreLoading()) {
    on<LoadStores>(_onLoadStores);
    on<SearchStores>(_onSearchStores);

  }

  Future<void> _onLoadStores(LoadStores event, Emitter<StoreState> emit) async {
    final cachePolicy =
        CachePolicy(type: CacheType.EXPIRES, expires: const Duration(days: 7));
    final dataState = await _fetchStoresUseCase(params: cachePolicy);
    if (dataState.status == DataStateStatus.success) {
      emit(StoreLoaded(stores: dataState.data!));
    } else {
      emit(StoreError(message: dataState.message.toString()));
    }
  }

  Future<void> _onSearchStores(SearchStores event, Emitter<StoreState> emit) async {
    final dataState = await _searchStoresUseCase(params: event.query);
    if (dataState.status == DataStateStatus.success) {
      emit(StoreLoaded(stores: dataState.data!));
    } else {
      emit(StoreError(message: dataState.message.toString()));
    }
  }
}
