import 'package:injectable/injectable.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';
import 'package:vegawallet/features/wallet/domain/repository/wallet_repository.dart';

import '../../../../core/data_state/data_state.dart';

@Injectable()
class GetUserCardInformationUseCase {
  final WalletRepository _walletRepository;

  GetUserCardInformationUseCase(this._walletRepository);

  Future<DataState<WalletCardInformation>> call() async{
    return await _walletRepository.getWalletCardInformation();
  }
}