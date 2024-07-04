import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/stores/domain/usecases/fetch_stores_use_case.dart';
import 'package:vegawallet/features/stores/domain/usecases/search_stores_use_case.dart';
import 'package:vegawallet/features/stores/presentation/bloc/store_bloc/store_bloc/store_bloc.dart';

class MockFetchStoresUseCase extends Mock implements FetchStoresUseCase {}
class MockSearchStoresUseCase extends Mock implements SearchStoresUseCase {}

void main() {
  late StoreBloc storeBloc;
  late MockFetchStoresUseCase mockFetchStoresUseCase;
  late MockSearchStoresUseCase mockSearchStoresUseCase;

  setUp(() {
    mockFetchStoresUseCase = MockFetchStoresUseCase();
    mockSearchStoresUseCase = MockSearchStoresUseCase();
    storeBloc = StoreBloc(mockFetchStoresUseCase, mockSearchStoresUseCase);
  });

  group('StoreBloc', () {
    final stores = [
      Store.withData(
        name: 'Store1',
        addressCities: [],
        discounts: [],
        conditions: [],
        category: 'Test',
      ),
    ];

    test('initial state is StoreLoading', () {
      expect(storeBloc.state, equals(StoreLoading()));
    });

    blocTest<StoreBloc, StoreState>(
      'emits [StoreLoaded] when data is fetched successfully',
      build: () {
        when(() => mockFetchStoresUseCase(params: any(named: 'params')))
            .thenAnswer((_) async => DataState.success(stores));
        return storeBloc;
      },
      act: (bloc) => bloc.add(LoadStores()),
      expect: () => [
        StoreLoaded(stores: stores),
      ],
    );

    blocTest<StoreBloc, StoreState>(
      'emits [StoreError] when fetching data fails',
      build: () {
        when(() => mockFetchStoresUseCase(params: any(named: 'params')))
            .thenAnswer((_) async => DataState.error('Error fetching data'));
        return storeBloc;
      },
      act: (bloc) => bloc.add(LoadStores()),
      expect: () => [
        const StoreError(message: 'Error fetching data'),
      ],
    );

    blocTest<StoreBloc, StoreState>(
      'emits [StoreLoaded] when search is successful',
      build: () {
        when(() => mockSearchStoresUseCase(params: any(named: 'params')))
            .thenAnswer((_) async => DataState.success(stores));
        return storeBloc;
      },
      act: (bloc) => bloc.add(const SearchStores('Store1')),
      expect: () => [
        StoreLoaded(stores: stores),
      ],
    );

    blocTest<StoreBloc, StoreState>(
      'emits [StoreError] when search fails',
      build: () {
        when(() => mockSearchStoresUseCase(params: any(named: 'params')))
            .thenAnswer((_) async => DataState.error('Error searching stores'));
        return storeBloc;
      },
      act: (bloc) => bloc.add(const SearchStores('Store1')),
      expect: () => [
        const StoreError(message: 'Error searching stores'),
      ],
    );
  });
}
