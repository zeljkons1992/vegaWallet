import 'package:vegawallet/core/data_state/data_state.dart';

import '../entities/cache_policy.dart';
import '../entities/store.dart';

abstract class StoreRepository {
  Future<DataState<List<Store>>> getStores(CachePolicy cachePolicy);
  Future<DataState<List<Store>>> searchStores(String query);
  Future<DataState> addStoreToFavorites(Store store);
  Future<DataState> removeStoreFromFavorites(Store store);
  Future<DataState<List<Store>>> getFavorites();
}
