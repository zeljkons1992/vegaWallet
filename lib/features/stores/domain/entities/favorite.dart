import 'package:isar/isar.dart';

part 'favorite.g.dart';

@Collection()
class Favorite {
  Id id = Isar.autoIncrement;

  late String storeName;

  Favorite(this.storeName);
}
