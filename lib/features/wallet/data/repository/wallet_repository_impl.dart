import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';
import 'package:vegawallet/features/wallet/domain/repository/wallet_repository.dart';

@Injectable(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository{

  @override
  Future<DataState<WalletCardInformation>> getWalletCardInformation() async{
    WalletCardInformation walletCardInformation =const  WalletCardInformation(name: "Nikola Ranković", expiry: "12/25", cardNo: "100 951");
    return DataState.success(walletCardInformation);
    }
}