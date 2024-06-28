import '../entities/store.dart';

abstract class RemoteDataSource {
  Future<List<Store>> fetchStores();
}
