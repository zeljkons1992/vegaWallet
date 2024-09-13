import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import '../../domain/datasources/local_data_source.dart';
import '../../domain/datasources/remote_data_source.dart';
import '../../domain/entities/cache_policy.dart';
import '../../domain/entities/store.dart';
import '../../domain/repository/store_repository.dart';

@LazySingleton(as: StoreRepository)
class StoreRepositoryImpl implements StoreRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  StoreRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<DataState<List<Store>>> getStores(CachePolicy cachePolicy) async {
    final prefs = await SharedPreferences.getInstance();
    final createdAt = prefs.getInt('createdAt') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    try {
      switch (cachePolicy.type) {
        case CacheType
            .ALWAYS: //Proba dobaviti lokalno, ako nema dobavi remote i kesira
          final stores = await _getLocalOrFetchRemoteAndCache();
          return DataState.success(stores);
        case CacheType
            .EXPIRES: //Provjeri da li je expired, ako jeste dobavi remote i kesira, ako nije dobavi lokalno
          if (now - createdAt > cachePolicy.expires.inMilliseconds) {
            final stores = await _fetchRemoteAndCache();
            return DataState.success(stores);
          } else {
            var stores = await localDataSource.getStores();
            if (stores.isEmpty) {
              stores = await _fetchRemoteAndCache();
            }
            return DataState.success(stores);
          }
        default:
          {
            final stores = await localDataSource.getStores();
            return DataState.success(stores);
          }
      }
    } catch (e) {
      return DataState.error("Error occurred: ${e.toString()}");
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

  @override
  Future<DataState<List<Store>>> searchStores(String query) async {
    try {
      final stores = await localDataSource.searchStores(query);
      return DataState.success(stores);
    } catch (e) {
      return DataState.error("Error occurred: ${e.toString()}");
    }
  }

  @override
  Future<DataState> addStoreToFavorites(Store store) async {
    try {
      await localDataSource.addToFavorites(store);
      return DataState.success();
    } catch (e) {
      return DataState.error("Failed to add store to favorites.");
    }
  }

  @override
  Future<DataState> removeStoreFromFavorites(Store store) async {

    try {
      await localDataSource.removeFromFavorites(store);
      return DataState.success();
    } catch (e) {
      return DataState.error("Failed to remove store from favorites");
    }
  }

  @override
  Future<DataState<List<Store>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavoriteStores();
      return DataState.success(favorites);
    } catch (e) {
      return DataState.error("Failed to get favorite stores.");
    }
  }

  @override
  Future<DataState> getFavorite(String id) async{
    try{
      final favorite = await localDataSource.getFavoriteItem(id);
      return DataState.success(favorite);
    }catch(e){
      return DataState.error("Failed to get fafavorite stire");
    }
  }
}