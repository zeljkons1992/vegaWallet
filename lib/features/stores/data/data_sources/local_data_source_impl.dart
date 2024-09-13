import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:vegawallet/features/stores/domain/datasources/local_data_source.dart';
import 'package:vegawallet/features/stores/domain/entities/favorite.dart';

import '../../domain/entities/store.dart';

@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  final Isar isar;

  LocalDataSourceImpl(this.isar);

  @override
  Future<List<Store>> getStores() async {
    return await isar.stores.where().findAll();
  }

  @override
  Future<void> clearAndReplaceStores(List<Store> stores) async {
    final favoriteStoreNames = (await isar.favorites.where().findAll())
        .map((favorite) => favorite.storeName)
        .toSet();

    for (var store in stores) {
      store.isFavorite = favoriteStoreNames.contains(store.name);
    }

    await isar.writeTxn(() async {
      await isar.stores.clear();
      await isar.stores.putAll(stores);
    });
  }


  @override
  Future<void> clearStores() async {
    await isar.writeTxn(() async {
      await isar.stores.clear();
    });
  }

  @override
  Future<List<Store>> searchStores(String query) async {
    return await isar.stores
        .filter()
        .nameContains(query, caseSensitive: false)
        .findAll();
  }

  @override
  Future<void> addToFavorites(Store store) async {
    await isar.writeTxn(() async {
      final favoriteToAdd = await isar.favorites
          .filter()
          .storeNameEqualTo(store.name)
          .findFirst();

      if (favoriteToAdd == null) {
        await isar.favorites.put(Favorite(store.name));

        final storeToUpdate =
            await isar.stores.filter().nameEqualTo(store.name).findFirst();

        if (storeToUpdate != null) {
          await isar.stores.put(storeToUpdate.copyWith(isFavorite: true));
        }
      }
    });
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    return await isar.favorites.where().findAll();
  }

  @override
  Future<void> removeFromFavorites(Store store) async {
    await isar.writeTxn(() async {
      final favoriteToDelete = await isar.favorites
          .filter()
          .storeNameEqualTo(store.name)
          .findFirst();


      if (favoriteToDelete != null) {
        await isar.favorites.delete(favoriteToDelete.id);

        final storeToUpdate =
            await isar.stores.filter().nameEqualTo(store.name).findFirst();

        if (storeToUpdate != null) {
          await isar.stores.put(storeToUpdate.copyWith(isFavorite: false));
        }
      }
    });
  }

  @override
  Future<List<Store>> getFavoriteStores() async {
    return await isar.stores.filter().isFavoriteEqualTo(true).findAll();
  }

}
