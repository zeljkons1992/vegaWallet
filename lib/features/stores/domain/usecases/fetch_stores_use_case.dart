import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/usecase/use_case.dart';
import 'package:vegawallet/features/stores/domain/entities/cache_policy.dart';
import 'package:vegawallet/features/stores/domain/repository/store_repository.dart';

import '../entities/store.dart';

@Injectable()
class FetchStoresUseCase extends UseCase<DataState, CachePolicy> {
  final StoreRepository repository;

  FetchStoresUseCase({required this.repository});

  @override
  Future<DataState<List<Store>>> call({CachePolicy? params}) async {
    return await repository.getStores(params!);
  }
}
