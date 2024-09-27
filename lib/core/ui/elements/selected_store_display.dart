import 'package:flutter/material.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';

import '../../constants/icon_const.dart';
import '../../constants/size_const.dart';

class SelectedStoreDisplay extends StatelessWidget {
  final Store store;

  const SelectedStoreDisplay({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(PADDING_VALUE_LARGE),
      decoration: BoxDecoration(
        color: colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(CIRCULAR_BORDER_RADIUS_SMALL),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                categoryIcons[store.category] ?? Icons.category,
                color: colorScheme.onSurface,
                size: SELECTED_STORE_CATEGORY_ICON_SIZE,
              ),
              const SizedBox(width: SIZED_BOX_LARGE),
              Text(store.name, style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
          if (store.parsedDiscount != null)
            Text(
              "-${store.parsedDiscount}%",
              style: AppTextStyles(context).discountRed,
            )
        ],
      ),
    );
  }
}
