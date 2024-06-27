import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import '../../domain/entities/cache_policy.dart';
import '../../domain/entities/store.dart';
import '../../domain/usecases/fetch_stores_use_case.dart';

part 'store_event.dart';

part 'store_state.dart';

@Injectable()
class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final FetchStoresUseCase _fetchStoresUseCase;

  StoreBloc(this._fetchStoresUseCase) : super(StoreLoading()) {
    on<LoadStores>(_onLoadStores);
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
}
