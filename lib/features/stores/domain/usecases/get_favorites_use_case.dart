import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/usecase/use_case.dart';
import 'package:vegawallet/features/stores/domain/repository/store_repository.dart';

@LazySingleton()
class GetFavoritesUseCase extends UseCase<DataState, void>{
  final StoreRepository repository;

  GetFavoritesUseCase(this.repository);

  @override
  Future<DataState> call({void params}) async {
    return await repository.getFavorites();
  }
}
