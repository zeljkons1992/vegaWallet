import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/data_state/data_state.dart';
import '../../../domain/entities/store.dart';
import '../../../domain/usecases/search_stores_use_case.dart';

part 'search_event.dart';
part 'search_state.dart';

@Injectable()
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchStoresUseCase _searchStoresUseCase;

  SearchBloc(this._searchStoresUseCase) : super(SearchInitial()) {
    on<SearchStores>(_onSearchStores);
  }

    Future<void> _onSearchStores(SearchStores event, Emitter<SearchState> emit) async {
      final dataState = await _searchStoresUseCase(params: event.query);
      if (dataState.status == DataStateStatus.success) {
        final updatedStores = List<Store>.from(dataState.data!);
        emit(StoreSearchDone(updatedStores));
      } else {
        emit(StoreSearchError(message: dataState.message.toString()));
      }
    }
  }
