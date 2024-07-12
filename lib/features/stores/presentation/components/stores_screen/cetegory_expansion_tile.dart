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
    final localization = AppLocalizations.of(context)!;

    switch (category) {
      case "Kafići i Restorani": return localization.categoryCoffeeShopsAndRestaurants;
      case "Putovanja": return localization.categoryTravel;
      case "Zabava": return localization.categoryEntertainment;
      case "Usluge": return localization.categoryServices;
      case "Lepota i Zdravlje": return localization.categoryBeautyAndHealth;
      case "Kupovina": return localization.categoryShopping;
      default: return localization.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Icon(
            categoryIcons[category] ?? Icons.category,
            color: colorScheme.onSurface,
          ),
          title: Text(
            _mapCategoryToLocalizationString(category, context),
            style:  TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface
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
