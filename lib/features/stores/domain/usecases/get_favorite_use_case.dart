

import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/usecase/use_case.dart';
import 'package:vegawallet/features/stores/domain/repository/store_repository.dart';

class GetFavoriteUseCase extends UseCase<DataState, String>{
  final StoreRepository repository;

  GetFavoriteUseCase(this.repository);

  @override
  Future<DataState> call({String? params})async {
    return await repository.getFavorite(params!);
  }

}