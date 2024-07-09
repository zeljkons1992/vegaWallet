import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';
import 'package:vegawallet/features/wallet/domain/repository/wallet_repository.dart';

import '../../../../core/services/auth_services.dart';

@Injectable(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository{
  final AuthService _authServices;
  WalletRepositoryImpl(this._authServices);


  @override
  Future<DataState<WalletCardInformation>> getWalletCardInformation() async{
    String? user =await _authServices.getUserName();
    if(user!=null){
      WalletCardInformation walletCardInformation = WalletCardInformation(name: user);
      return DataState.success(walletCardInformation);
    }
    return DataState.error("No information");
    }
}