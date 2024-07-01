import 'package:injectable/injectable.dart';
import 'package:vegawallet/features/stores/domain/repository/store_repository.dart';

import '../../../../core/data_state/data_state.dart';

@Injectable()
class GetStoresWithDiscountsUseCase {
  final StoreRepository _storeRepository;

  GetStoresWithDiscountsUseCase(this._storeRepository);

  Future<DataState> call() async{
    return await _storeRepository.getStoresWithDiscounts();
  }
}