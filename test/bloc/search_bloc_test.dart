import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/stores/domain/usecases/search_stores_use_case.dart';
import 'package:vegawallet/features/stores/presentation/bloc/search_bloc/search_bloc.dart';

// Kreiranje mocka za SearchStoresUseCase
class MockSearchStoresUseCase extends Mock implements SearchStoresUseCase {}

void main() {
  late SearchBloc searchBloc;
  late MockSearchStoresUseCase mockSearchStoresUseCase;

  setUp(() {
    mockSearchStoresUseCase = MockSearchStoresUseCase();
    searchBloc = SearchBloc(mockSearchStoresUseCase);
  });

  group('SearchBloc', () {
    final stores = [
      Store.withData(
        name: 'Store1',
        addressCities: [],
        discounts: [],
        conditions: [],
        category: 'Test',
      ),
    ];

    test('initial state is SearchInitial', () {
      expect(searchBloc.state, equals(SearchInitial()));
    });

    blocTest<SearchBloc, SearchState>(
      'emits [StoreSearchDone] when search is successful',
      build: () {
        // Mock-ovanje uspešne pretrage
        when(() => mockSearchStoresUseCase(params: any(named: 'params')))
            .thenAnswer((_) async => DataState.success(stores));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchStores('Store1')),
      expect: () => [
        StoreSearchDone(stores),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [StoreSearchError] when search fails',
      build: () {
        // Mock-ovanje neuspešne pretrage
        when(() => mockSearchStoresUseCase(params: any(named: 'params')))
            .thenAnswer((_) async => DataState.error('Error searching stores'));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchStores('Store1')),
      expect: () => [
        const StoreSearchError(message: 'Error searching stores'),
      ],
    );
  });
}
