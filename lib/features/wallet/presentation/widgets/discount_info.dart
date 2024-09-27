import 'package:flutter/material.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vegawallet/features/wallet/presentation/widgets/discount_conditions.dart';

import '../../../../core/constants/size_const.dart';

class DiscountInfo extends StatelessWidget {
  final Store store;

  const DiscountInfo({super.key, required this.store});

  List<String> _uniqueElements(List<String> elements) {
    return elements.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final uniqueDiscounts = _uniqueElements(store.discounts);
    final localization = AppLocalizations.of(context)!;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: localization.discountsTitle,
                labelStyle: AppTextStyles(context).searchBarText,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CIRCULAR_BORDER_RADIUS_TINY),
                  borderSide: BorderSide(color: colorScheme.onSurface),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CIRCULAR_BORDER_RADIUS_TINY),
                  borderSide: BorderSide(color: colorScheme.onSurface),
                ),
              ),
              controller: TextEditingController(
                text: uniqueDiscounts.join(', '),
              ),
              readOnly: true,
              maxLines: null,
            ),
            const SizedBox(height: 8),
            DiscountConditions(conditions: store.conditions)
          ],
        ),
      ),
    );
  }
}
