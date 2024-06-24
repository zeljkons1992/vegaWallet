import 'package:injectable/injectable.dart';
import '../entities/store.dart';
import '../repository/store_repository.dart';

@Injectable()
class FetchStoresUseCase {
  final StoreRepository repository;

  FetchStoresUseCase({required this.repository});

  Future<List<Store>> call() async {
    return await repository.fetchStores();
  }
}
