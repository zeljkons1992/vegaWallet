import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:vegawallet/features/stores/presentation/bloc/store_bloc.dart';
import 'package:vegawallet/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:vegawallet/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';

class MockWalletBloc extends MockBloc<WalletEvent, WalletState> implements WalletBloc {}
class MockStoreBloc extends MockBloc<StoreEvent, StoreState> implements StoreBloc {}

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
    const mockCardInfo = WalletCardInformation(name: 'John Doe', expiry: '12/34', cardNo: '123456789012');
    whenListen(mockWalletBloc, Stream.fromIterable([const WalletStateLoaded(mockCardInfo)]), initialState: WalletStateInitial());
    whenListen(mockStoreBloc, Stream.fromIterable([const StoreLoaded(stores: [])]), initialState: StoreLoading());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Expiry'), findsOneWidget);
    expect(find.text('12/34'), findsOneWidget);
    expect(find.text('Card No'), findsOneWidget);
  });
}
