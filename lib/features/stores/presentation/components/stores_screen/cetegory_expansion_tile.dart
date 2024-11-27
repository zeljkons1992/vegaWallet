import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/icon_const.dart';
import '../../../../../core/ui/theme/text_style.dart';
import '../../../domain/entities/store.dart';
import 'store_list_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CategoryExpansionTile extends StatefulWidget {
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

  @override
  State<CategoryExpansionTile> createState() => _CategoryExpansionTileState();
}

class _CategoryExpansionTileState extends State<CategoryExpansionTile> {
  final ExpansionTileController controller = ExpansionTileController();

  String _mapCategoryToLocalizationString(String category, BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    switch (category) {
      case "Favorites": return localization.categoryFavorites;
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
    bool isFavorite = widget.category == "Favorites";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.stores.isEmpty && controller.isExpanded) {
        controller.collapse();
      }
    });

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isFavorite ? Colors.orange : Colors.transparent,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: isFavorite ? Colors.transparent : colorScheme.onSurface,
          width: 1.0,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          controller: controller,
          leading: categoryIcons.containsKey(widget.category)
              ? SvgPicture.asset(
            categoryIcons[widget.category]!,
            color: colorScheme.onSurface,
            width: 30.0,
          )
              : Icon(
            Icons.star_outlined,
            color: colorScheme.onSurface,
          ),
          trailing: widget.stores.isEmpty ? const SizedBox() : null,
          title: Text(
            _mapCategoryToLocalizationString(widget.category, context),
            style: AppTextStyles(context).bodyText1,
          ),
          maintainState: true,
          initiallyExpanded: widget.isExpanded,
          onExpansionChanged: widget.onExpansionChanged,
          children: widget.stores.map((store) => StoreListTile(store: store)).toList(),
        ),
      ),
    );
  }
}
