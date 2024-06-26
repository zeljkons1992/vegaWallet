import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vegawallet/features/stores/domain/datasources/local_data_source.dart';

import '../../domain/entities/store.dart';

@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  late Future<Isar> isar;

  LocalDataSourceImpl() {
    isar = _initIsar();
  }

  Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([StoreSchema], directory: dir.path);
  }

  @override
  Future<List<Store>> getStores() async {
    final db = await isar;
    return await db.stores.where().findAll();
  }

  @override
  Future<void> clearAndReplaceStores(List<Store> stores) async {
    final db = await isar;
    await db.writeTxn(() async {
      await db.stores.clear();
      await db.stores.putAll(stores);
    });
  }

  @override
  Future<void> clearStores() async {
    final db = await isar;
    await db.writeTxn(() async {
      await db.stores.clear();
    });
  }

}