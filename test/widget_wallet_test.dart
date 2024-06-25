import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:vegawallet/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:vegawallet/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';

class MockWalletBloc extends MockBloc<WalletEvent, WalletState> implements WalletBloc {}

void main() {
  late MockWalletBloc mockWalletBloc;

  setUpAll(() {
    GetIt.I.reset();
  });

  setUp(() {
    mockWalletBloc = MockWalletBloc();
    GetIt.I.registerFactory<WalletBloc>(() => mockWalletBloc);
  });

  tearDown(() {
    GetIt.I.unregister<WalletBloc>();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider.value(
        value: mockWalletBloc,
        child: WalletScreen(),
      ),
    );
  }


  testWidgets('shows loaded card information when state is WalletStateLoaded', (WidgetTester tester) async {
    final mockCardInfo = WalletCardInformation(name: 'John Doe', expiry: '12/34', cardNo: '123456789012');
    whenListen(mockWalletBloc, Stream.fromIterable([WalletStateLoaded(mockCardInfo)]), initialState: WalletStateInitial());
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Expiry'), findsOneWidget);
    expect(find.text('12/34'), findsOneWidget);
    expect(find.text('Card No'), findsOneWidget);
  });
}
