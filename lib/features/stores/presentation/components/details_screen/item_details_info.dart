import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegawallet/features/stores/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:vegawallet/features/stores/presentation/bloc/store_bloc/store_bloc.dart';
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
  late bool shouldShowStar;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.store.isFavorite;
    shouldShowStar = widget.store.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocListener<FavoritesBloc, FavoritesState>(
        listener: (context, state) {
          if (state is FavoritesLoaded) {
            final updatedStore = state.favorites.firstWhere(
                  (s) => s.id == widget.store.id,
              orElse: () => widget.store,
            );
            // setState(() {
            //   isFavorite = updatedStore.isFavorite;
            // });
         //   widget.onUpdate(updatedStore);
          }
        },
        child: Padding(
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
                  IconButton(
                    onPressed: () {
                      shouldShowStar =! shouldShowStar;
                      if (isFavorite) {
                        print("PRIJE BRISANJA: ${widget.store}");
                        BlocProvider.of<FavoritesBloc>(context)
                            .add(RemoveStoreFromFavorites(widget.store.copyWith(isFavorite: true)));
                       // BlocProvider.of<StoreBloc>(context).add(UpdateStore(widget.store.copyWith(isFavorite: false)));
                        widget.onUpdate(widget.store.copyWith(isFavorite: false));
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      } else {
                        BlocProvider.of<FavoritesBloc>(context)
                            .add(AddStoreToFavorites(widget.store));
                       // BlocProvider.of<StoreBloc>(context).add(UpdateStore(widget.store.copyWith(isFavorite: true)));
                        widget.onUpdate(widget.store.copyWith(isFavorite: true));
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      }
                    },
                    icon: Icon(
                      shouldShowStar ? Icons.star_outlined : Icons.star_border_outlined,
                    ),
                    splashColor: Colors.transparent,
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
              _buildSectionText(
                widget.store.parsedDiscount != null
                    ? "${widget.store.parsedDiscount!.toInt().toString()}%"
                    : widget.store.discounts.toSet().join(", "),
                AppTextStyles(context).headline2.copyWith(fontSize: 14.0),
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
        ),

    );
  }

  Widget _buildSectionText(String content, TextStyle appTextStyle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
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
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  String _formatList(List<dynamic> list) {
    return list.join(', ');
  }
}
