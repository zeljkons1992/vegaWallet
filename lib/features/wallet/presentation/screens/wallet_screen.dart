import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vegawallet/core/constants/assets_const.dart';
import 'package:vegawallet/core/constants/text_const.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/stores/presentation/bloc/store_bloc.dart';
import 'package:vegawallet/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:vegawallet/core/di/injection.dart';
import '../../../../core/ui/elements/search_bar.dart';
import '../../../../core/ui/elements/selected_store_display.dart';
import '../../../stores/domain/entities/store.dart';
import '../../data/models/wallet_card_information.dart';
import '../widgets/discount_calculator.dart';
import '../widgets/discount_info.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final FlipCardController _flipCardController = FlipCardController();
  final WalletBloc walletBloc = getIt<WalletBloc>();
  final StoreBloc storeBloc = getIt<StoreBloc>();

  Store? _selectedStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => walletBloc..add(FetchCardInfo())),
        BlocProvider(create: (context) => storeBloc),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                switch (state) {
                  case WalletStateLoading _:
                    return const Center(child: CircularProgressIndicator());
                  case WalletStateLoaded _:
                    return _buildContent(
                        context, (state).walletCardInformation);
                  case WalletStateError _:
                    return const Center(
                        child: Text('Failed to load card information'));
                  default:
                    return const Center(child: Text('Welcome to your wallet'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WalletCardInformation cardInfo) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(TextConst.wallet, style: AppTextStyles.headline1),
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
            padding: const EdgeInsets.only(top: 16.0, left: 8.0),
            child: Text(
              "Calculator",
              style: AppTextStyles.headline1,
            ),
          ),
          StoreSearchBar(
            onStoreSelected: (store) {
              setState(() {
                _selectedStore = store;
              });
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          if (_selectedStore != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: SelectedStoreDisplay(
                store: _selectedStore!,
              ),
            ),
          if (_selectedStore != null)
            _selectedStore!.parsedDiscount != null
                ? DiscountCalculator(store: _selectedStore!)
                : DiscountInfo(store: _selectedStore!),
        ],
      ),
    );
  }

  Widget _buildFrontCard(BuildContext context, WalletCardInformation cardInfo) {
    return Stack(
      key: const ValueKey(true),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
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
            style: AppTextStyles.cardNameStyle,
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
                    'Expiry',
                    style: AppTextStyles.cardLabelTitle,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    cardInfo.expiry,
                    style: AppTextStyles.cardLabelDigital,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Card No',
                    style: AppTextStyles.cardLabelTitle,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    cardInfo.cardNo,
                    style: AppTextStyles.cardLabelDigital,
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
