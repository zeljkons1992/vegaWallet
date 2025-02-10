import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/di/injection.dart';
import 'package:vegawallet/core/ui/elements/language_switcher.dart';
import 'package:vegawallet/core/ui/elements/search_bar.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/stores/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:vegawallet/features/stores/presentation/bloc/store_bloc/store_bloc.dart';
import '../bloc/search_bloc/search_bloc.dart';
import '../components/stores_screen/stores_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../components/stores_screen/city_filter.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  String? selectedCity;

  @override
  void initState() {
    BlocProvider.of<FavoritesBloc>(context).add(GetFavorites());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final categoryForExpand = GoRouterState.of(context).extra is String
        ? GoRouterState.of(context).extra as String
        : null;


    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SearchBloc>(),
        ),
        ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localization.storesTitle,
                      style: AppTextStyles(context).headline1,
                    ),
                    const LanguageSwitcher(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: StoreSearchBar(
                  onStoreSelected: (store) {
                    context.go('/stores/store_details', extra: {'store': store, 'source': 'search'});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: BlocBuilder<StoreBloc, StoreState>(
                  builder: (context, state) {
                    if (state is StoreLoaded) {
                      final cities = state.stores
                          .expand((store) => store.addressCities.map((city) => city.city))
                          .map((city) => city.replaceAll(',', '').trim())
                          .toSet()
                          .toList();

                      return CityFilter(
                        cities: cities,
                        selectedCity: selectedCity,
                        onCitySelected: (city) {
                          setState(() {
                            selectedCity = city;
                          });
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<StoreBloc, StoreState>(
                  buildWhen: (previous, current) => current is! StoreSearchDone,
                  builder: (context, state) {
                    switch (state) {
                      case StoreLoading():
                        return const Center(child: CircularProgressIndicator());
                      case StoreLoaded():
                        final filteredStores = selectedCity == null
                            ? state.stores
                            : state.stores.where((store) =>
                                store.addressCities.any((city) => city.city == selectedCity)).toList();
                        return StoresList(stores: filteredStores, categoryForExpand: categoryForExpand);
                      case StoreError():
                        return Center(child: Text(state.message));
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
