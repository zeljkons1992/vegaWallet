import 'dart:async';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  List<Widget> _allSuggestions = [];
  List<Widget> _suggestions = [];
  late String searchCriteria = "";

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SearchBloc>(context).add(SearchStores(searchCriteria));
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
    searchCriteria = value;
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
      setState(() {
        _suggestions = [];
      });
      if (stores.isNotEmpty && _allSuggestions.isEmpty) {
        setState(() {
          _suggestions = stores
              .map((store) => ListTile(
            contentPadding: const EdgeInsets.only(left: 15),
            leading: categoryIcons.containsKey(store.category)
                ? SvgPicture.asset(
              categoryIcons[store.category]!,
              width: 30.0,
            )
                : const Icon(
              Icons.star_outlined,
            ),
            title: Text(
              store.name,
              style: AppTextStyles(context).searchBarText,
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                store.isFavorite ? Icons.star : Icons.star_border,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: () {
              widget.onStoreSelected(store);
              _controller?.clear();
              _controller?.closeView("");
              FocusScope.of(context).unfocus();
            },
          )).toList();
          _allSuggestions = _suggestions;
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: colorScheme.onSurface,
              width: 1.0,
            ),
          ),
          child: SearchAnchor.bar(
            barHintText: localization.searchBarHint,
            barHintStyle:
            WidgetStatePropertyAll(AppTextStyles(context).searchBarText),
            onChanged: (value) {
              _onSearchChanged(value);
            },
            suggestionsBuilder: (context, controller) {
              searchCriteria = controller.text;
              return _filterSuggestions(controller.text);
            },

            searchController: _controller!,
            viewBackgroundColor: colorScheme.surface,
            viewHeaderHintStyle: AppTextStyles(context).searchBarText,
            viewLeading: IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: _closeSearch,
            ),
            barBackgroundColor:
            WidgetStateProperty.all<Color>(colorScheme.surface),
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

  List<Widget> _filterSuggestions(String searchText) {
      return _allSuggestions.where((suggestion) {
        if (suggestion is ListTile) {
          final titleText = (suggestion.title as Text).data?.toLowerCase() ?? '';
          return titleText.contains(searchText.toLowerCase());
        }
        return false;
      }).toList();
  }
}
