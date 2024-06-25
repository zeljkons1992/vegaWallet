import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';

import '../../../../core/data_state/data_state.dart';

abstract class WalletRepository{
  Future<DataState<WalletCardInformation>> getWalletCardInformation();
}