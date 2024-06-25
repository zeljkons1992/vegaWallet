import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/datasources/local_data_source.dart';
import '../../domain/datasources/remote_data_source.dart';
import '../../domain/entities/cache_policy.dart';
import '../../domain/entities/store.dart';
import '../../domain/repository/store_repository.dart';

@LazySingleton(as: StoreRepository)
class StoreRepositoryImpl implements StoreRepository {
  final ApiClient apiClient;

  StoreRepositoryImpl({required this.apiClient});

  @override
  Future<List<Store>> getStores(CachePolicy cachePolicy) async {
    final prefs = await SharedPreferences.getInstance();
    final createdAt = prefs.getInt('createdAt') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    switch (cachePolicy.type) {
      case CacheType.ALWAYS: //Proba dobaviti lokalno, ako nema dobavi remote i kesira
        return await _getLocalOrFetchRemoteAndCache();
      case CacheType.EXPIRES: //Provjeri da li je expired, ako jeste dobavi remote i kesira, ako nije dobavi lokalno
        if (now - createdAt > cachePolicy.expires.inMilliseconds) {
          return await _fetchRemoteAndCache();
        } else {
          return await localDataSource.getStores();
        }
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
}
