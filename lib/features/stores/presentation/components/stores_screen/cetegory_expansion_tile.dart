import 'package:flutter/material.dart';
import '../../../domain/entities/store.dart';
import 'store_list_tile.dart';

class CategoryExpansionTile extends StatelessWidget {
  final String category;
  final List<Store> stores;
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;

  final Map<String, IconData> categoryIcons = {
    'Kafići i Restorani': Icons.coffee_outlined,
    'Putovanja': Icons.card_travel,
    'Zabava': Icons.celebration_outlined,
    'Usluge': Icons.health_and_safety,
    'Zdravlje i wellness': Icons.local_hospital_outlined,
    'Kupovina': Icons.shopping_cart_outlined,
  };

  CategoryExpansionTile({super.key,
    required this.category,
    required this.stores,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Icon(categoryIcons[category] ?? Icons.category),
          title: Text(
            category,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          children: stores
              .map((store) => StoreListTile(store: store))
              .toList(),
        ),
      ),
    );
  }
}
