import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegawallet/features/stores/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import '../../../../../core/ui/theme/text_style.dart';
import '../../../domain/entities/store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemDetailsInfo extends StatefulWidget {
  final Store store;
  final Function(Store) onUpdate;

  const ItemDetailsInfo(
      {super.key, required this.store, required this.onUpdate});

  @override
  State<ItemDetailsInfo> createState() => _ItemDetailsInfoState();
}

class _ItemDetailsInfoState extends State<ItemDetailsInfo> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.store.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionText(
                localization.storeDetailsNameLabel,
                AppTextStyles(context).titleBold.copyWith(fontSize: 14),
              ),
              // BlocBuilder to manage the state of the favorite icon
              BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  bool isFavorite = false;

                  if (state is FavoritesLoaded) {
                    // Check if the store is in the favorites list
                    isFavorite = state.favorites.any((favoriteStore) => favoriteStore.id == widget.store.id);
                  }

                  return IconButton(
                    onPressed: () {
                      if (isFavorite) {
                        // Remove from favorites if it's already a favorite
                        BlocProvider.of<FavoritesBloc>(context).add(RemoveStoreFromFavorites(widget.store));
                        widget.onUpdate(widget.store.copyWith(isFavorite: false));
                      } else {
                        // Add to favorites if it's not a favorite
                        BlocProvider.of<FavoritesBloc>(context).add(AddStoreToFavorites(widget.store));
                        widget.onUpdate(widget.store.copyWith(isFavorite: true));
                      }
                    },
                    icon: Icon(
                      isFavorite ? Icons.star_outlined : Icons.star_border_outlined,
                      color: isFavorite ? Colors.black : Colors.grey,
                    ),
                    splashColor: Colors.transparent,
                  );
                },
              ),
            ],
          ),
          _buildSectionText(
            widget.store.name,
            AppTextStyles(context).titleBold.copyWith(fontSize: 18.0),
          ),
          _buildDivider(context),
          _buildSectionText(
            localization.discountsTitle,
            AppTextStyles(context).titleBold.copyWith(fontSize: 14),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Dodavanje unutrašnjeg razmaka
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface, // Crna pozadina
              borderRadius: BorderRadius.circular(16.0), // Zaobljeni uglovi
            ),
            child: _buildSectionText(
              widget.store.parsedDiscount != null
                  ? "${widget.store.parsedDiscount!.toInt().toString()}%"
                  : widget.store.discounts.toSet().join(", "),
              AppTextStyles(context).headline2.copyWith(fontSize: 14.0, color: Theme.of(context).colorScheme.surface), // Beleži tekst belom bojom
            ),
          ),
          _buildDivider(context),
          _buildSectionText(
            localization.discountCalculatorConditionsTitle,
            AppTextStyles(context).titleBold.copyWith(fontSize: 14),
          ),
          _buildSectionText(
            _formatList(widget.store.conditions),
            AppTextStyles(context).headline2.copyWith(fontSize: 14.0),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionText(String content, TextStyle appTextStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        content,
        style: appTextStyle,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Divider(
        height: 1,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  String _formatList(List<dynamic> list) {
    return list.join(', ');
  }
}
