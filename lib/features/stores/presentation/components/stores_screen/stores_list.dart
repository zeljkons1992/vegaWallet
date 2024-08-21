import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/stores/presentation/bloc/favorites_bloc/favorites_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, favoritesState) {
            final favoriteStores = favoritesState is FavoritesLoaded
                ? favoritesState.favorites
                : widget.stores.where((store) => store.isFavorite).toList();

            final isFavoriteGroupExpanded =
                groupExpanded['Favorites'] ?? false;

            return CategoryExpansionTile(
              category: 'Favorites',
              stores: favoriteStores,
              onExpansionChanged: (expanded) {
                setState(() {
                  groupExpanded['Favorites'] = expanded;
                });
              },
              isExpanded: isFavoriteGroupExpanded,
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Categories",
            style: AppTextStyles(context).headline1,
          ),
        ),
        ..._buildCategoryTiles(widget.stores),
      ],
    );
  }

  List<Widget> _buildCategoryTiles(List<Store> stores) {
    final otherCategories = stores
        .where((store) => !store.isFavorite)
        .map((store) => store.category)
        .toSet()
        .toList();

    return otherCategories.map((category) {
      final categoryStores =
      stores.where((store) => store.category == category).toList();

      return CategoryExpansionTile(
        category: category,
        stores: categoryStores,
        isExpanded: groupExpanded[category] ?? false,
        onExpansionChanged: (expanded) {
          setState(() {
            groupExpanded[category] = expanded;
          });
        },
      );
    }).toList();
  }
}
