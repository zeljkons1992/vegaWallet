import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/stores/presentation/bloc/store_bloc/store_bloc.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';
import 'package:vegawallet/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:vegawallet/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MockWalletBloc extends MockBloc<WalletEvent, WalletState> implements WalletBloc {}
class MockStoreBloc extends MockBloc<StoreEvent, StoreState> implements StoreBloc {}
class MockStore extends Mock implements Store {}

void main() {
  late MockWalletBloc mockWalletBloc;
  late MockStoreBloc mockStoreBloc;

  setUpAll(() {
    GetIt.I.reset();
  });

  setUp(() {
    mockWalletBloc = MockWalletBloc();
    mockStoreBloc = MockStoreBloc();
    GetIt.I.registerFactory<WalletBloc>(() => mockWalletBloc);
    GetIt.I.registerFactory<StoreBloc>(() => mockStoreBloc);
  });

  tearDown(() {
    GetIt.I.unregister<WalletBloc>();
    GetIt.I.unregister<StoreBloc>();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('sr'),
      ],
      home: MultiBlocProvider(
        providers: [
          BlocProvider<WalletBloc>(create: (_) => mockWalletBloc),
          BlocProvider<StoreBloc>(create: (_) => mockStoreBloc),
        ],
        child: const WalletScreen(),
      ),
    );
  }

  testWidgets('shows loaded card information when state is WalletStateLoaded', (WidgetTester tester) async {
    const  mockCardInfo = WalletCardInformation(name: "John Doe", expireDate: "12/25", cardNo: "111 111");
    whenListen(mockWalletBloc, Stream.fromIterable([const  WalletStateLoaded(mockCardInfo)]), initialState: WalletStateInitial());
    whenListen(mockStoreBloc, Stream.fromIterable([const StoreLoaded(stores: [])]), initialState: StoreLoading());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
  });

  testWidgets('clears selected store when clear button is pressed', (WidgetTester tester) async {
    const  mockCardInfo =  WalletCardInformation(name: 'John Doe',expireDate: "12/25",cardNo: "111 111");
    final store = Store.withData(name: 'Store 1', category: 'Kafići i Restorani', addressCities: [], discounts: [], conditions: [], parsedDiscount: 10.0);

    whenListen(mockWalletBloc, Stream.fromIterable([const WalletStateLoaded(mockCardInfo)]), initialState: WalletStateInitial());
    whenListen(mockStoreBloc, Stream.fromIterable([StoreLoaded(stores: [store])]), initialState: StoreLoading());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Select the store
    final searchField = find.byType(SearchBar);
    await tester.enterText(searchField, 'Store 1');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Store 1').last);
    await tester.pumpAndSettle();

    // Verify the store is selected and displayed
    expect(find.text('Store 1'), findsAny);
    expect(find.byIcon(Icons.close), findsOneWidget);

    // Press the clear button
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // Verify the store is cleared
    expect(find.text('Store 1'), findsNothing);
  });
}
