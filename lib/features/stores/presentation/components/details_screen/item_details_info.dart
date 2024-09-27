import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
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
          _buildConditionText(widget.store.conditions),
        ],
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

  Widget _buildConditionText(List<String> conditions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: conditions.map((condition) {
        if (condition.contains('https://') || condition.contains('http://')) {
          return _buildLinkText(condition);
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(condition, style: AppTextStyles(context).headline2.copyWith(fontSize: 14.0)),
          );
        }
      }).toList(),
    );
  }

  Widget _buildLinkText(String text) {
    final urlRegex = RegExp(r'(https?://[^\s]+)');
    final matches = urlRegex.allMatches(text);

    return RichText(
      text: TextSpan(
        children: matches.map((match) {
          final url = match.group(0);
          final beforeUrl = text.substring(0, match.start);
          final afterUrl = text.substring(match.end);

          return [
            TextSpan(
              text: beforeUrl,
              style: AppTextStyles(context).headline2.copyWith(fontSize: 14.0),
            ),
            TextSpan(
              text: url,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                if(url!=null){
                  final uri = Uri.parse(url);
                  await launchUrl(uri);
                }else{
                  Fluttertoast.showToast(
                    msg: "Error",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                }
                },
            ),
            TextSpan(
              text: afterUrl,
              style: AppTextStyles(context).headline2.copyWith(fontSize: 14.0),
            ),
          ];
        }).expand((element) => element).toList(),
      ),
    );
  }
}
