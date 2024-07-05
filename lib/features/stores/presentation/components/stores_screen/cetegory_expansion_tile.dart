import 'package:flutter/material.dart';
import '../../../../../core/constants/icon_const.dart';
import '../../../domain/entities/store.dart';
import 'store_list_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CategoryExpansionTile extends StatelessWidget {
  final String category;
  final List<Store> stores;
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;

  const CategoryExpansionTile({
    super.key,
    required this.category,
    required this.stores,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  String _mapCategoryToLocalizationString(String category, BuildContext context) {
    final t = AppLocalizations.of(context)!;

    switch (category) {
      case "Kafići i Restorani": return t.categoryCoffeeShopsAndRestaurants;
      case "Putovanja": return t.categoryTravel;
      case "Zabava": return t.categoryEntertainment;
      case "Usluge": return t.categoryServices;
      case "Lepota i Zdravlje": return t.categoryBeautyAndHealth;
      case "Kupovina": return t.categoryShopping;
      default: return t.error;
    }
  }

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
          leading: Icon(
            categoryIcons[category] ?? Icons.category,
          ),
          title: Text(
            _mapCategoryToLocalizationString(category, context),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          children: stores.map((store) => StoreListTile(store: store)).toList(),
        ),
      ),
    );
  }
}
