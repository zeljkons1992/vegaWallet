import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/cache_policy.dart';
import '../../domain/entities/store.dart';
import '../../domain/repository/store_repository.dart';
import '../data_sources/local_data_source.dart';
import '../data_sources/remote_data_source.dart';

@LazySingleton(as: StoreRepository)
class StoreRepositoryImpl implements StoreRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  StoreRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<Store>> getStores(CachePolicy cachePolicy) async {
    final prefs = await SharedPreferences.getInstance();
    final createdAt = prefs.getInt('createdAt') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    switch (cachePolicy.type) {
      case CacheType.NEVER:
        return await remoteDataSource.fetchStores();
      case CacheType.ALWAYS:
        return await _getLocalOrFetchRemoteAndCache();
      case CacheType.REFRESH:
        return await _fetchRemoteAndCache();
      case CacheType.EXPIRES:
        if (now - createdAt > cachePolicy.expires.inMilliseconds) {
          return await _fetchRemoteAndCache();
        } else {
          return await localDataSource.getStores();
        }
      case CacheType.CLEAR:
        return await _clearAndFetch();
      default:
        return await localDataSource.getStores();
    }
  }

  Future<List<Store>> _getLocalOrFetchRemoteAndCache() async {
    final localStores = await localDataSource.getStores();
    if (localStores.isNotEmpty) {
      return localStores;
    } else {
      return await _fetchRemoteAndCache();
    }
  }

  Future<List<Store>> _fetchRemoteAndCache() async {
    final stores = await remoteDataSource.fetchStores();
    await localDataSource.clearAndReplaceStores(stores);
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('createdAt', DateTime.now().millisecondsSinceEpoch);
    return stores;
  }

  Future<List<Store>> _clearAndFetch() async {
    final localStores = await localDataSource.getStores();
    if (localStores.isNotEmpty) {
      await localDataSource.clearStores();
      return localStores;
    } else {
      return await remoteDataSource.fetchStores();
    }
  }
}
