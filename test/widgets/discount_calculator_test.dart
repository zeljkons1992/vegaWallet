import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/wallet/presentation/widgets/discount_calculator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('DiscountCalculator calculates discount correctly', (WidgetTester tester) async {
    final store = Store.withData(name: 'Store 1', category: 'Kafići i Restorani', addressCities: [], discounts: [], conditions: [], parsedDiscount: 10.0);

    await tester.pumpWidget(
      MaterialApp(
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
        home: Scaffold(
          body: DiscountCalculator(store: store),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, '1000');
    await tester.pump();

    expect(find.text('900.00 rsd'), findsOneWidget);
  });
}
