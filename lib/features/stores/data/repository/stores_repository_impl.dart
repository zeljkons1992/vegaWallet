import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/data/model/store.dart';
import 'package:vegawallet/features/stores/domain/repository/store_repository.dart';

import 'list_stores.dart';



@Injectable(as: StoreRepository)
class StoresRepositoryImpl implements StoreRepository{

  @override
  Future<DataState<List<Store>>> getStoresWithDiscounts() async{
    return DataState.success(listStores);
  }

}