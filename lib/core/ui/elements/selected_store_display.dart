import 'package:flutter/material.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';

class SelectedStoreDisplay extends StatelessWidget {
  final Store store;

  const SelectedStoreDisplay({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    IconData categoryIcon;

    final Map<String, IconData> categoryIcons = {
      'Kafići i Restorani': Icons.coffee_outlined,
      'Putovanja': Icons.card_travel,
      'Zabava': Icons.celebration_outlined,
      'Usluge': Icons.health_and_safety,
      'Zdravlje i wellness': Icons.local_hospital_outlined,
      'Kupovina': Icons.shopping_cart_outlined,
    };

    return Container(
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
    );
  }
}
