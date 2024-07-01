import 'package:flutter/material.dart';
import '../../../data/model/store.dart';
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
      children: widget.stores
          .map((store) => store.category)
          .toSet()
          .toList()
          .map((category) {
        return CategoryExpansionTile(
          category: category,
          stores: widget.stores.where((store) => store.category == category).toList(),
          isExpanded: groupExpanded[category] ?? false,
          onExpansionChanged: (expanded) {
            setState(() {
              groupExpanded[category] = expanded;
            });
          },
        );
      }).toList(),
    );
  }
}
