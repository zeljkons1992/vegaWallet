import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/ui/theme/text_style.dart';
import '../../../domain/entities/store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../bloc/store_bloc/store_bloc.dart';

class ItemDetailsInfo extends StatefulWidget {
  final Store store;
  final Function(Store) onUpdate;

  const ItemDetailsInfo({Key? key, required this.store, required this.onUpdate}) : super(key: key);

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

    return BlocProvider<StoreBloc>(
      create: (context) => getIt<StoreBloc>(),
      child: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          Store updatedStore = widget.store;
          if (state is StoreLoaded) {
            updatedStore = state.stores.firstWhere(
                  (s) => s.id == widget.store.id,
              orElse: () => widget.store,
            );
            isFavorite = updatedStore.isFavorite;
          }

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
                        AppTextStyles(context)
                            .titleBold
                            .copyWith(fontSize: 14)),
                    IconButton(
                      onPressed: () {
                        if (isFavorite) {
                          BlocProvider.of<StoreBloc>(context).add(RemoveStoreFromFavorites(updatedStore));
                          setState(() {
                            isFavorite = false;
                          });
                          widget.onUpdate(updatedStore.copyWith(isFavorite: false));
                        } else {
                          BlocProvider.of<StoreBloc>(context).add(AddStoreToFavorites(updatedStore));
                          setState(() {
                            isFavorite = true;
                          });
                          widget.onUpdate(updatedStore.copyWith(isFavorite: true));
                        }
                      },
                      icon: isFavorite
                          ? const Icon(Icons.star_outlined)
                          : const Icon(Icons.star_border_outlined),
                      splashColor: Colors.transparent,
                    ),
                  ],
                ),
                _buildSectionText(updatedStore.name,
                    AppTextStyles(context).titleBold.copyWith(fontSize: 18.0)),
                _buildDivider(context),
                _buildSectionText(localization.discountsTitle,
                    AppTextStyles(context).titleBold.copyWith(fontSize: 14)),
                _buildSectionText(
                    updatedStore.parsedDiscount != null
                        ? "${updatedStore.parsedDiscount!.toInt().toString()}%"
                        : updatedStore.discounts.toSet().join(", "),
                    AppTextStyles(context).headline2.copyWith(fontSize: 14.0)),
                _buildDivider(context),
                _buildSectionText(
                    localization.discountCalculatorConditionsTitle,
                    AppTextStyles(context).titleBold.copyWith(fontSize: 14)),
                _buildSectionText(_formatList(updatedStore.conditions),
                    AppTextStyles(context).headline2.copyWith(fontSize: 14.0)),
              ],
            ),
          );
        },
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
