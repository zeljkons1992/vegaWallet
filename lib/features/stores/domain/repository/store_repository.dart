import '../entities/store.dart';

abstract class StoreRepository {
  Future<List<Store>> fetchStores();
}
