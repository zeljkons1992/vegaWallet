import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/wallet/presentation/widgets/discount_info.dart';

void main() {
  testWidgets('DiscountInfo shows discounts and conditions', (WidgetTester tester) async {
    final store = Store.withData(name: 'Store 1', category: 'Kafići i Restorani', addressCities: [], discounts: ['10% off'], conditions: ['Valid on weekends'], parsedDiscount: null);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              DiscountInfo(store: store),
            ],
          ),
        ),
      ),
    );

    expect(find.text('10% off'), findsOneWidget);
    expect(find.text('Valid on weekends'), findsOneWidget);
  });
}
