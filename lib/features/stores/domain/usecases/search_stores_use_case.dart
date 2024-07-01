// search_stores_use_case.dart
import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/stores/domain/repository/store_repository.dart';

@LazySingleton()
class SearchStoresUseCase {
  final StoreRepository repository;

  SearchStoresUseCase(this.repository);

  Future<DataState<List<Store>>> call({required String params}) async {
    return await repository.searchStores(params);
  }
}
