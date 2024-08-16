import 'package:vegawallet/features/stores/domain/entities/favorite.dart';

import '../entities/store.dart';

abstract class LocalDataSource {
  Future<List<Store>> getStores();
  Future<void> clearAndReplaceStores(List<Store> stores);
  Future<void> clearStores();
  Future<List<Store>> searchStores(String query);
  Future<List<Favorite>> getFavorites();
  Future<void> addToFavorites(Store favorite);
  Future<void> removeFromFavorites(Store favorite);
}