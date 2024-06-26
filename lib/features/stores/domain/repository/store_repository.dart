import '../entities/cache_policy.dart';
import '../entities/store.dart';

abstract class StoreRepository {
  Future<List<Store>> getStores(CachePolicy cachePolicy);
}
