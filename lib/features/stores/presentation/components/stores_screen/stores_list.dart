import 'package:flutter/material.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import '../../../domain/entities/store.dart';
import 'cetegory_expansion_tile.dart';

class StoresList extends StatefulWidget {
  final List<Store> stores;

  const StoresList({super.key, required this.stores});

  @override
  StoresListState createState() => StoresListState();
}

class StoresListState extends State<StoresList> {
  Map<String, bool> groupExpanded = {};
  late List<Store> stores;

  @override
  void initState() {
    super.initState();
    stores = widget.stores;
  }

  @override
  Widget build(BuildContext context) {
    final favoriteStores = stores.where((store) => store.isFavorite).toList();
    final otherCategories = stores
        .where((store) => !store.isFavorite)
        .map((store) => store.category)
        .toSet()
        .toList();

    if (favoriteStores.isEmpty) {
      setState(() {
        groupExpanded['Favorites'] = false;
      });
    }

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        CategoryExpansionTile(
          category: 'Favorites',
          stores: favoriteStores,
          onExpansionChanged: (expanded) {
            setState(() {
              groupExpanded['Favorites'] = expanded;
            });
          },
          isExpanded:
              favoriteStores.isEmpty && groupExpanded['Favorites'] == true,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Categories", style: AppTextStyles(context).headline1),
        ),
        ...otherCategories.map((category) {
          return CategoryExpansionTile(
            category: category,
            stores:
                stores.where((store) => store.category == category).toList(),
            isExpanded: groupExpanded[category] ?? false,
            onExpansionChanged: (expanded) {
              setState(() {
                groupExpanded[category] = expanded;
              });
            },
          );
        }),
      ],
    );
  }
}
