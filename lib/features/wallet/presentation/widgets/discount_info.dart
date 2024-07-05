import 'package:flutter/material.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiscountInfo extends StatelessWidget {
  final Store store;

  const DiscountInfo({super.key, required this.store});

  List<String> _uniqueElements(List<String> elements) {
    return elements.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final uniqueDiscounts = _uniqueElements(store.discounts);
    final uniqueConditions = _uniqueElements(store.conditions);
    final t = AppLocalizations.of(context)!;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: t.discountsTitle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              controller: TextEditingController(
                text: uniqueDiscounts.join(', '),
              ),
              readOnly: true,
              maxLines: null,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: t.discountCalculatorConditionsTitle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              controller: TextEditingController(
                text: uniqueConditions.join(', '),
              ),
              readOnly: true,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
