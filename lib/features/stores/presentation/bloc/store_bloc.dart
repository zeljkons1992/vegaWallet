import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
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
    print("pokusao");
    try {
      final stores = await _fetchStoresUseCase();
      print("Stores loaded: ${stores.length}");
      emit(StoreLoaded(stores: stores));
    } catch (e) {
      print("error");
      print(e);
      emit(StoreError(message: e.toString()));
    }
  }
}
