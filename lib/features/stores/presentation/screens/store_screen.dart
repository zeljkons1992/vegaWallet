import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/di/injection.dart';
import 'package:vegawallet/core/ui/elements/language_switcher.dart';
import 'package:vegawallet/core/ui/elements/search_bar.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/stores/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:vegawallet/features/stores/presentation/bloc/store_bloc/store_bloc.dart';
import '../components/stores_screen/stores_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<FavoritesBloc>()..add(GetFavorites()),
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
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: StoreSearchBar(
                  onStoreSelected: (store) {
                    context.go('/stores/store_details', extra: store);
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
                        print("KAO NAVODNO REBUILDAM LISTU");
                        return StoresList( stores: state.stores,);
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
