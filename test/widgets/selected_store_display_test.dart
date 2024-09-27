import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vegawallet/core/ui/elements/selected_store_display.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';

void main() {
  testWidgets('SelectedStoreDisplay shows store name and icon', (WidgetTester tester) async {
    final store = Store.withData(name: 'Store 1', category: 'Kafići i Restorani', addressCities: [], discounts: [], conditions: [], parsedDiscount: 10.0);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SelectedStoreDisplay(store: store),
        ),
      ),
    );

    expect(find.text('Store 1'), findsOneWidget);
    expect(find.byIcon(Icons.coffee_outlined), findsOneWidget);
    expect(find.text('-10.0%'), findsOneWidget);
  });
}
