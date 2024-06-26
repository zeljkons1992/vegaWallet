import 'package:injectable/injectable.dart';
import 'package:vegawallet/features/stores/domain/entities/cache_policy.dart';
import 'package:vegawallet/features/stores/domain/repository/store_repository.dart';
import '../entities/store.dart';
import '../repository/store_repository.dart';

@Injectable()
class FetchStoresUseCase {
  final StoreRepository repository;

  FetchStoresUseCase({required this.repository});

  Future<List<Store>> call(CachePolicy cachePolicy) async {
    return await repository.getStores(cachePolicy);
  }
}
