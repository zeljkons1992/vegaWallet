import 'dart:async';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import '../../../features/stores/presentation/bloc/search_bloc/search_bloc.dart';
import '../../constants/icon_const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StoreSearchBar extends StatefulWidget {
  final Function(Store) onStoreSelected;

  const StoreSearchBar({super.key, required this.onStoreSelected});

  @override
  StoreSearchBarState createState() => StoreSearchBarState();
}
class StoreSearchBarState extends State<StoreSearchBar> {
  SearchController? _controller;
  late StreamController<List<Store>> _searchStreamController;
  List<Widget> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _controller = SearchController();
    _searchStreamController = StreamController<List<Store>>.broadcast();
    BackButtonInterceptor.add(_interceptBackButton);
    _buildSuggestions();
  }

  @override
  void dispose() {
    _searchStreamController.close();
    BackButtonInterceptor.remove(_interceptBackButton);
    super.dispose();
  }

  bool _interceptBackButton(bool stopDefaultButtonEvent, RouteInfo info) {
    if (_controller != null && _controller!.isOpen) {
      _closeSearch();
      return true; // Intercept and prevent the default back button behavior
    }
    return false; // Allow the default back button behavior
  }

  void _onSearchChanged(String value) {
    if (value.isNotEmpty) {
      BlocProvider.of<SearchBloc>(context).add(SearchStores(value));
    }
  }

  void _closeSearch() {
    _controller?.closeView("");
    _onSearchChanged("");
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  void _buildSuggestions() {
    _searchStreamController.stream.listen((stores) {
      if (stores.isNotEmpty) {
        setState(() {
          _suggestions = stores
              .map((store) => ListTile(
            leading:
            Icon(categoryIcons[store.category] ?? Icons.category),
            title: Text(
              store.name,
              style: AppTextStyles(context).searchBarText,
            ),
            onTap: () {
              widget.onStoreSelected(store);
              _controller?.clear();
              _controller?.closeView("");
              FocusScope.of(context).unfocus();
            },
          ))
              .toList();
        });
      } else {
        setState(() {
          _suggestions = [];
        });
      }
    });
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
            barHintStyle:
            WidgetStatePropertyAll(AppTextStyles(context).searchBarText),
            onChanged: (value) {
              _onSearchChanged(value);
            },
            suggestionsBuilder: (context, controller) {
              return _suggestions;
            },

            searchController: _controller!,
            viewBackgroundColor: colorScheme.surface,
            viewHeaderHintStyle: AppTextStyles(context).searchBarText,
            viewLeading: IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: _closeSearch,
            ),
            barBackgroundColor:
            WidgetStateProperty.all<Color>(colorScheme.onPrimary),
            barElevation: WidgetStateProperty.all(0),
          ),
        ),
        BlocListener<SearchBloc, SearchState>(
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
}
