import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vegawallet/core/constants/assets_const.dart';
import 'package:vegawallet/core/constants/text_const.dart';
import 'package:vegawallet/core/ui/theme/button_style.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';

class WalletScreen extends StatefulWidget {
  final WalletCardInformation walletCardInformation;

  const WalletScreen({super.key, required this.walletCardInformation});

  @override
  WalletScreenState createState() => WalletScreenState();
}

class WalletScreenState extends State<WalletScreen> {
  final FlipCardController _flipCardController = FlipCardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Text(TextConst.wallet, style: AppTextStyles.headline1),
                ),
                GestureDetector(
                  onTap: () => _flipCardController.flipcard(),
                  child: FlipCard(
                    controller: _flipCardController,
                    rotateSide: RotateSide.bottom,
                    frontWidget: _buildFrontCard(context),
                    backWidget: _buildBackCard(context),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: primaryButtonStyle(context),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Calculate the Discount',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrontCard(BuildContext context) {
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
            widget.walletCardInformation.name,
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
                    widget.walletCardInformation.expiry,
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
                    widget.walletCardInformation.cardNo,
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
          'assets/img/vega_card_back.svg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
