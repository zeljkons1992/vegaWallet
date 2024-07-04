import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/domain/datasources/local_data_source.dart';
import 'package:vegawallet/features/stores/domain/datasources/remote_data_source.dart';
import 'package:vegawallet/features/stores/domain/entities/cache_policy.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/stores/data/repository/store_repository_impl.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

void main() {
  late StoreRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = StoreRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );

    SharedPreferences.setMockInitialValues({});
  });

  group('StoreRepositoryImpl', () {
    final stores = [
      Store.withData(
        name: 'Store1',
        addressCities: [],
        discounts: [],
        conditions: [],
        category: 'Test',
      ),
    ];

    test('should return stores from local database when cache policy is ALWAYS and local data is available', () async {
      // Arrange
      when(() => mockLocalDataSource.getStores()).thenAnswer((_) async => stores);

      // Act
      final result = await repository.getStores(CachePolicy(type: CacheType.ALWAYS, expires: const Duration(days: 7)));

      // Assert
      expect(result.status, equals(DataStateStatus.success));
      expect(result.data, equals(stores));
      verify(() => mockLocalDataSource.getStores()).called(1);
      verifyNever(() => mockRemoteDataSource.fetchStores());
    });

    test('should fetch and cache stores from remote when cache policy is ALWAYS and local data is not available', () async {
      // Arrange
      when(() => mockLocalDataSource.getStores()).thenAnswer((_) async => []);
      when(() => mockRemoteDataSource.fetchStores()).thenAnswer((_) async => stores);
      when(() => mockLocalDataSource.clearAndReplaceStores(stores)).thenAnswer((_) async {});

      // Act
      final result = await repository.getStores(CachePolicy(type: CacheType.ALWAYS, expires: const Duration(days: 7)));

      // Assert
      expect(result.status, equals(DataStateStatus.success));
      expect(result.data, equals(stores));
      verify(() => mockLocalDataSource.getStores()).called(1);
      verify(() => mockRemoteDataSource.fetchStores()).called(1);
      verify(() => mockLocalDataSource.clearAndReplaceStores(stores)).called(1);
    });

    test('should return stores from local database when cache policy is EXPIRES and data is not expired', () async {
      // Arrange
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('createdAt', DateTime.now().millisecondsSinceEpoch - const Duration(days: 1).inMilliseconds);
      when(() => mockLocalDataSource.getStores()).thenAnswer((_) async => stores);

      // Act
      final result = await repository.getStores(CachePolicy(type: CacheType.EXPIRES, expires: const Duration(days: 7)));

      // Assert
      expect(result.status, equals(DataStateStatus.success));
      expect(result.data, equals(stores));
      verify(() => mockLocalDataSource.getStores()).called(1);
      verifyNever(() => mockRemoteDataSource.fetchStores());
    });

    test('should fetch and cache stores from remote when cache policy is EXPIRES and data is expired', () async {
      // Arrange
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('createdAt', DateTime.now().millisecondsSinceEpoch - const Duration(days: 8).inMilliseconds);
      when(() => mockRemoteDataSource.fetchStores()).thenAnswer((_) async => stores);
      when(() => mockLocalDataSource.clearAndReplaceStores(stores)).thenAnswer((_) async {});

      // Act
      final result = await repository.getStores(CachePolicy(type: CacheType.EXPIRES, expires: const Duration(days: 7)));

      // Assert
      expect(result.status, equals(DataStateStatus.success));
      expect(result.data, equals(stores));
      verify(() => mockRemoteDataSource.fetchStores()).called(1);
      verify(() => mockLocalDataSource.clearAndReplaceStores(stores)).called(1);
    });

    test('should return error when an exception occurs', () async {
      // Arrange
      when(() => mockLocalDataSource.getStores()).thenThrow(Exception('Error occurred'));

      // Act
      final result = await repository.getStores(CachePolicy(type: CacheType.ALWAYS, expires: const Duration(days: 7)));

      // Assert
      expect(result.status, equals(DataStateStatus.error));
      expect(result.message, equals('Error occurred: Exception: Error occurred'));
    });

    test('should return list of stores when the call to local data source is successful', () async {
      // Arrange
      final stores = [Store.withData(name: 'Store1', addressCities: [], discounts: [], conditions: [], category: 'Test')];
      when(() => mockLocalDataSource.searchStores(any())).thenAnswer((_) async => stores);

      // Act
      final result = await repository.searchStores('Store1');

      // Assert
      expect(result, DataState<List<Store>>.success(stores));
      verify(() => mockLocalDataSource.searchStores('Store1')).called(1);
    });

    test('should return error when the call to local data source is unsuccessful', () async {
      // Arrange
      final exception = Exception('Some error');
      when(() => mockLocalDataSource.searchStores(any())).thenThrow(exception);

      // Act
      final result = await repository.searchStores('Store1');

      // Assert
      expect(result, DataState<List<Store>>.error('Error occurred: ${exception.toString()}'));
      verify(() => mockLocalDataSource.searchStores('Store1')).called(1);
    });
  });
}
