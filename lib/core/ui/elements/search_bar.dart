import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/stores/presentation/bloc/store_bloc.dart';

class StoreSearchBar extends StatefulWidget {
  final Function(Store) onStoreSelected;

  const StoreSearchBar({super.key, required this.onStoreSelected});

  @override
  StoreSearchBarState createState() => StoreSearchBarState();
}

class StoreSearchBarState extends State<StoreSearchBar> {
  late SearchController _controller;
  late StreamController<List<Store>> _searchStreamController;

  final Map<String, IconData> categoryIcons = {
    'Kafići i Restorani': Icons.coffee_outlined,
    'Putovanja': Icons.card_travel,
    'Zabava': Icons.celebration_outlined,
    'Usluge': Icons.health_and_safety,
    'Zdravlje i wellness': Icons.local_hospital_outlined,
    'Kupovina': Icons.shopping_cart_outlined,
  };

  @override
  void initState() {
    super.initState();
    _controller = SearchController();
    _searchStreamController = StreamController<List<Store>>.broadcast();
  }

  void _onSearchChanged(String value) {
    if (value.isNotEmpty) {
      BlocProvider.of<StoreBloc>(context).add(SearchStores(value));
    } else {
      _searchStreamController.add([]);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: SearchAnchor(
            viewOnChanged: (value) {
              _onSearchChanged(value);
            },
            isFullScreen: false,
            viewConstraints: const BoxConstraints(
              minHeight: 0,
              maxHeight: 250,
            ),
            searchController: _controller,
            builder: (context, controller) {
              return SearchBar(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
                trailing: const [Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.search),
                )],
                controller: controller,
                hintText: 'Search stores',
                onTap: () {
                  controller.openView();
                },
              );
            },
            suggestionsBuilder: (context, controller) {
              return _buildSuggestions();
            },
            viewBackgroundColor: Colors.white,
          ),
        ),
        BlocListener<StoreBloc, StoreState>(
          listener: (context, state) {
            if (state is StoreLoaded) {
              _searchStreamController.add(state.stores);
            }
          },
          child: Container(),
        ),
      ],
    );
  }

  Future<List<Widget>> _buildSuggestions() async {
    final completer = Completer<List<Widget>>();
    _searchStreamController.stream.first.then((stores) {
      final suggestions = stores
          .map(
            (store) => ListTile(
              leading: Icon(categoryIcons[store.category] ?? Icons.category),
              title: Text(store.name),
              onTap: () {
                widget.onStoreSelected(store);
                setState(() {
                  _searchStreamController.add([]);
                  _controller.closeView("");
                });
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                  currentFocus.focusedChild?.unfocus();
                }
              },
            ),
          )
          .toList();
      completer.complete(suggestions);
    });
    return completer.future;
  }
}
