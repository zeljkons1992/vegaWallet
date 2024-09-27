import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/stores/domain/repository/store_repository.dart';
import 'package:vegawallet/features/stores/domain/usecases/search_stores_use_case.dart';

class MockStoreRepository extends Mock implements StoreRepository {}

void main() {
  late SearchStoresUseCase searchStoresUseCase;
  late MockStoreRepository mockStoreRepository;

  setUp(() {
    mockStoreRepository = MockStoreRepository();
    searchStoresUseCase = SearchStoresUseCase(mockStoreRepository);
  });

  test('should return list of stores when the call to repository is successful', () async {
    // Arrange
    final stores = [Store.withData(name: 'Store1', addressCities: [], discounts: [], conditions: [], category: 'Test')];
    when(() => mockStoreRepository.searchStores(any())).thenAnswer((_) async => DataState.success(stores));

    // Act
    final result = await searchStoresUseCase(params: 'Store1');

    // Assert
    expect(result, DataState.success(stores));
    verify(() => mockStoreRepository.searchStores('Store1')).called(1);
  });

  test('should return error when the call to repository is unsuccessful', () async {
    // Arrange
    const errorMessage = 'Error occurred';
    when(() => mockStoreRepository.searchStores(any())).thenAnswer((_) async => DataState<List<Store>>.error(errorMessage));

    // Act
    final result = await searchStoresUseCase(params: 'Store1');

    // Assert
    expect(result, DataState<List<Store>>.error(errorMessage));
    verify(() => mockStoreRepository.searchStores('Store1')).called(1);
  });
}
