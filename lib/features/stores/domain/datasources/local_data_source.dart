import '../entities/store.dart';

abstract class LocalDataSource {
  Future<List<Store>> getStores();
  Future<void> clearAndReplaceStores(List<Store> stores);
  Future<void> clearStores();
}