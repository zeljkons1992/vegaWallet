import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/ui/elements/search_bar.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/stores/presentation/bloc/store_bloc.dart';

class MockStoreBloc extends MockBloc<StoreEvent, StoreState> implements StoreBloc {}

class FakeStoreEvent extends Fake implements StoreEvent {}
class FakeStoreState extends Fake implements StoreState {}

void main() {
  late MockStoreBloc mockStoreBloc;

  setUpAll(() {
    registerFallbackValue(FakeStoreEvent());
    registerFallbackValue(FakeStoreState());
  });

  setUp(() {
    mockStoreBloc = MockStoreBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<StoreBloc>(
          create: (context) => mockStoreBloc,
          child: StoreSearchBar(
            onStoreSelected: (store) {},
          ),
        ),
      ),
    );
  }

  testWidgets('renders StoreSearchBar and interacts with it', (WidgetTester tester) async {
    whenListen(
      mockStoreBloc,
      Stream<StoreState>.fromIterable([StoreLoaded(stores: [Store.withData(name: 'Store 1', category: 'Kafići i Restorani', addressCities: [], discounts: [], conditions: [], parsedDiscount: 10.0)])]),
      initialState: StoreLoading(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byType(SearchBar), findsOneWidget);

    await tester.enterText(find.byType(SearchBar), 'Store 1');
    await tester.pumpAndSettle();

    expect(find.text('Store 1'), findsOneWidget);
  });
}
