import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:vegawallet/features/stores/domain/datasources/local_data_source.dart';

import '../../domain/entities/store.dart';

@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  final Isar isar;

  LocalDataSourceImpl(this.isar);

  @override
  Future<List<Store>> getStores() async {
    final db = isar;
    return await db.stores.where().findAll();
  }

  @override
  Future<void> clearAndReplaceStores(List<Store> stores) async {
    final db = isar;
    await db.writeTxn(() async {
      await db.stores.clear();
      await db.stores.putAll(stores);
    });
  }

  @override
  Future<void> clearStores() async {
    final db = isar;
    await db.writeTxn(() async {
      await db.stores.clear();
    });
  }

  @override
  Future<List<Store>> searchStores(String query) async {
    final db = isar;
    return await db.stores.filter().nameContains(query, caseSensitive: false).findAll();
  }

}
