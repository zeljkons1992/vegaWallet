import 'dart:async';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import '../../../features/stores/presentation/bloc/store_bloc/store_bloc.dart';
import '../../constants/icon_const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
    BackButtonInterceptor.add(_interceptBackButton);
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchStreamController.close();
    BackButtonInterceptor.remove(_interceptBackButton);
    super.dispose();
  }

  bool _interceptBackButton(bool stopDefaultButtonEvent, RouteInfo info) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus &&
        currentFocus.focusedChild != null &&
        _controller.isOpen) {
      _controller.closeView("");
      currentFocus.focusedChild?.unfocus();
      return true; // Intercept and prevent the default back button behavior
    }
    return false; // Allow the default back button behavior
  }

  void _onSearchChanged(String value) {
      BlocProvider.of<StoreBloc>(context).add(SearchStores(value));
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final localization = AppLocalizations.of(context)!;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: SearchAnchor.bar(
            barHintText: localization.searchBarHint,
            barHintStyle: WidgetStatePropertyAll(AppTextStyles(context).searchBarText),
            onChanged: (value) {
              _onSearchChanged(value);
            },
            suggestionsBuilder: (context, controller) {
              return _buildSuggestions();
            },
            searchController: _controller,
            viewBackgroundColor: colorScheme.surface,
            viewHeaderHintStyle: AppTextStyles(context).searchBarText,
            viewLeading: IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: () {
                _controller.closeView("");
                _onSearchChanged("");
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  currentFocus.focusedChild?.unfocus();
                }
              },
            ),
            barBackgroundColor: WidgetStateProperty.all<Color>(colorScheme.onPrimary),
            barElevation: WidgetStateProperty.all(0),
          ),
        ),
        BlocListener<StoreBloc, StoreState>(
          listenWhen: (previous, current) => true,
          listener: (context, state) {
            if (state is StoreSearchDone) {
              _searchStreamController.add(state.stores);
            }
          },
          child: Container(),
        ),
      ],
    );
  }

  Future<List<Widget>> _buildSuggestions() async {
    final stores = await _searchStreamController.stream.first;

    if (stores.isEmpty) {
      return [];
    }

    return stores
        .map(
          (store) => ListTile(
        leading: Icon(categoryIcons[store.category] ?? Icons.category),
        trailing: IconButton(
          onPressed: () {
            // store.isFavorite ? BlocProvider.of<StoreBloc>(context).add(RemoveStoreFromFavorites(store)) : BlocProvider.of<StoreBloc>(context)
            //     .add(AddStoreToFavorites(store));
          },
          icon: store.isFavorite
              ? const Icon(Icons.star_outlined)
              : const Icon(Icons.star_border_outlined),
          splashColor: Colors.transparent,
        ),
        title: Text(
          store.name,
          style: AppTextStyles(context).searchBarText,
        ),
        onTap: () {
          widget.onStoreSelected(store);
          setState(() {
            _searchStreamController.add([]);
            _controller.closeView(_controller.text);
            _controller.clear();
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
  }

}
