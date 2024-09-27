import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/usecase/use_case.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/stores/domain/repository/store_repository.dart';

@LazySingleton()
class AddStoreToFavoritesUseCase extends UseCase<DataState, Store>{
  final StoreRepository repository;

  AddStoreToFavoritesUseCase(this.repository);

  @override
  Future<DataState> call({Store? params}) async {
    return await repository.addStoreToFavorites(params!);
  }
}
