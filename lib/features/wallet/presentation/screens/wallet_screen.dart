import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/constants/assets_const.dart';
import 'package:vegawallet/core/constants/size_const.dart';
import 'package:vegawallet/core/ui/elements/language_switcher.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/stores/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:vegawallet/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:vegawallet/core/di/injection.dart';
import '../../../../core/ui/elements/search_bar.dart';
import '../../../../main.dart';
import '../../data/models/wallet_card_information.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/icon_with_text.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final FlipCardController _flipCardController = FlipCardController();
  final WalletBloc walletBloc = getIt<WalletBloc>();
  final SearchBloc searchBloc = getIt<SearchBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    final localization = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => walletBloc..add(FetchCardInfo())),
        BlocProvider(
          create: (context) => getIt<SearchBloc>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: PADDING_VALUE_SMALL),
            child: BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                switch (state) {
                  case WalletStateLoading _:
                    return const Center(child: CircularProgressIndicator());
                  case WalletStateLoaded _:
                    return _buildContent(
                        context, (state).walletCardInformation);
                  case WalletStateError _:
                    return Center(
                        child: Text(localization.cardInformationLoadFailed));
                  default:
                    return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WalletCardInformation cardInfo) {
    final localization = AppLocalizations.of(context)!;
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: PADDING_VALUE_SMALL, vertical: PADDING_VALUE_LARGE),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localization.walletTitle,
                  style: AppTextStyles(context).headline1,
                ),
                const LanguageSwitcher(),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _flipCardController.flipcard(),
            child: FlipCard(
              controller: _flipCardController,
              rotateSide: RotateSide.bottom,
              frontWidget: _buildFrontCard(context, cardInfo),
              backWidget: _buildBackCard(context),
            ),


          ),
          Padding(
            padding: const EdgeInsets.only(
                top: SELECTED_STORE_CATEGORY_ICON_SIZE, left: PADDING_VALUE_SMALL),
            child: Text(
              localization.discountsTitle,
              style: AppTextStyles(context).headline2.copyWith(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 0.0),
            child: StoreSearchBar(
              onStoreSelected: (store) {
                context.go('/stores/store_details', extra: {'store': store, 'source': 'wallet'});
              },
            ),
          ),
          // 3 SVG images in one row
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 130, // Konstantna visina za sve kartice
                    child: IconWithText(
                      iconPath: 'assets/icons/coffee_icon.svg',
                      label: localization.categoryCoffeeShopsAndRestaurants,
                      onTap: () {
                        bottomNavKey.currentState?.setSelectedIndex(TabItem.stores.index);
                        context.go('/stores', extra: "Kafići i Restorani");
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 22.0),
                Expanded(
                  child: SizedBox(
                    height: 130, // Konstantna visina za sve kartice
                    child: IconWithText(
                      iconPath: 'assets/icons/travel_icon.svg',
                      label: localization.categoryTravel,
                      onTap: () {
                        bottomNavKey.currentState?.setSelectedIndex(TabItem.stores.index);
                        context.go('/stores', extra: "Putovanja");
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 22.0),
                Expanded(
                  child: SizedBox(
                    height: 130, // Konstantna visina za sve kartice
                    child: IconWithText(
                      iconPath: 'assets/icons/entertaiment_icon.svg',
                      label: localization.categoryEntertainment,
                      onTap: () {
                        bottomNavKey.currentState?.setSelectedIndex(TabItem.stores.index);
                        context.go('/stores', extra: "Zabava");
                      },
                    ),
                  ),
                ),
              ],
            ),

          ),

// 3 SVG images in another row with text and click listeners
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Start alignment to avoid overflow
              children: [
                Expanded(
                  child: SizedBox(
                    height: 130,
                    child: IconWithText(
                      iconPath: 'assets/icons/services_icon.svg',
                      label: localization.categoryServices,
                      onTap: () {
                        bottomNavKey.currentState?.setSelectedIndex(TabItem.stores.index);
                        context.go('/stores', extra: "Usluge");
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 22.0), // Razmak između prvog i drugog itema
                Expanded(
                  child: SizedBox(
                    height: 130,
                    child: IconWithText(
                      iconPath: 'assets/icons/beauty_and_health_icon.svg',
                      label: localization.categoryBeautyAndHealth,
                      onTap: () {
                        bottomNavKey.currentState?.setSelectedIndex(TabItem.stores.index);
                        context.go('/stores', extra: "Lepota i Zdravlje");
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 22.0), // Razmak između drugog i trećeg itema
                Expanded(
                  child: SizedBox(
                    height: 130,
                    child: IconWithText(
                      iconPath: 'assets/icons/shopping_icon.svg',
                      label: localization.categoryShopping,
                      onTap: () {
                        bottomNavKey.currentState?.setSelectedIndex(TabItem.stores.index);
                        context.go('/stores', extra: "Kupovina");
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrontCard(BuildContext context, WalletCardInformation cardInfo) {
    final localization = AppLocalizations.of(context)!;
    return Stack(
      key: const ValueKey(true),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(CIRCULAR_BORDER_RADIUS_LARGE),
          child: SizedBox(
            width: double.infinity,
            child: SvgPicture.asset(
              vegaCard,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 16,
          child: Text(
            cardInfo.name,
            style: AppTextStyles(context).cardNameStyle,
          ),
        ),
        Positioned(
          bottom: 20,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localization.cardInformationNumber,
                    style: AppTextStyles(context).cardLabelTitle,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    cardInfo.cardNo,
                    style: AppTextStyles(context).cardLabelDigital,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackCard(BuildContext context) {
    return ClipRRect(
      key: const ValueKey(false),
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: double.infinity,
        child: SvgPicture.asset(
          vegaCardBackside,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
