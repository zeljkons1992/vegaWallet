import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/stores/presentation/bloc/store_bloc.dart';

import '../../constants/icon_const.dart';

class StoreSearchBar extends StatefulWidget {
  final Function(Store) onStoreSelected;

  const StoreSearchBar({super.key, required this.onStoreSelected});

  @override
  StoreSearchBarState createState() => StoreSearchBarState();
}

class StoreSearchBarState extends State<StoreSearchBar> {
  late SearchController _controller;
  late StreamController<List<Store>> _searchStreamController;

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
          child: PopScope(
            canPop: true,
            onPopInvoked: (bool didPop) {
              if (didPop) {
                return;
              }
              _controller.closeView("");
              print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!POZVANO");
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                currentFocus.focusedChild?.unfocus();
              }
            },
            child: SearchAnchor.bar(
              barHintText: "Search stores",
              onChanged: (value) => {
                _onSearchChanged(value),
              },
              suggestionsBuilder: (context, controller) {
                return _buildSuggestions();
              },
              searchController: _controller,
              viewBackgroundColor: Colors.white,
              viewLeading: IconButton(
                icon: const Icon(Icons.arrow_back_outlined),
                onPressed: () {
                  _controller.closeView("");
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    currentFocus.focusedChild?.unfocus();
                  }
                },
              ),
              barBackgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              barElevation: WidgetStateProperty.all(0),
            ),
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
                  _controller.closeView(_controller.text);
                });
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
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
