import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/store.dart';

@LazySingleton()
class LocalDataSource {
  late Future<Isar> isar;

  LocalDataSource() {
    isar = _initIsar();
  }

  Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([StoreSchema], directory: dir.path);
  }

  Future<List<Store>> getStores() async {
    final db = await isar;
    return await db.stores.where().findAll();
  }

  Future<void> clearAndReplaceStores(List<Store> stores) async {
    final db = await isar;
    await db.writeTxn(() async {
      await db.stores.clear();
      await db.stores.putAll(stores);
    });
  }

  Future<void> clearStores() async {
    final db = await isar;
    await db.writeTxn(() async {
      await db.stores.clear();
    });
  }

}