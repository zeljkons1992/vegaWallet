import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';

import '../../constants/icon_const.dart';

class SelectedStoreDisplay extends StatelessWidget {
  final Store store;

  const SelectedStoreDisplay({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/stores/store_details', extra: store);
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(categoryIcons[store.category] ?? Icons.category,
                    color: Colors.black, size: 30.0),
                const SizedBox(width: 16.0),
                Text(store.name, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            if (store.parsedDiscount != null)
              Text(
                "-${store.parsedDiscount}%",
                style: AppTextStyles.discountRed,
              )
          ],
        ),
      ),
    );
  }
}
