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
  final TextEditingController _controller = TextEditingController();
  List<Store> _filteredStores = [];

  final Map<String, IconData> categoryIcons = {
    'Kafići i Restorani': Icons.coffee_outlined,
    'Putovanja': Icons.card_travel,
    'Zabava': Icons.celebration_outlined,
    'Usluge': Icons.health_and_safety,
    'Zdravlje i wellness': Icons.local_hospital_outlined,
    'Kupovina': Icons.shopping_cart_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(Icons.menu, color: Colors.black),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Search stores',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      BlocProvider.of<StoreBloc>(context).add(SearchStores(value));
                    } else {
                      setState(() {
                        _filteredStores.clear();
                      });
                    }
                  },
                ),
              ),
              const Icon(Icons.search, color: Colors.black),
            ],
          ),
        ),
        BlocBuilder<StoreBloc, StoreState>(
          builder: (context, state) {
            if (state is StoreLoaded) {
              _filteredStores = state.stores;
            }
            return _filteredStores.isNotEmpty
                ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(8.0),
              constraints: const BoxConstraints(
                maxHeight: 200.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredStores.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(categoryIcons[_filteredStores[index].category] ?? Icons.category),
                      title: Text(_filteredStores[index].name),
                      onTap: () {
                        widget.onStoreSelected(_filteredStores[index]);
                        setState(() {
                          _controller.clear();
                          _filteredStores.clear();
                        });
                      },
                    ),
                  );
                },
              ),
            )
                : Container();
          },
        ),
      ],
    );
  }
}