import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/usecase/use_case.dart';

import '../repository/location_repository.dart';

@Injectable()
class OpenNativeNavigationUseCase extends UseCase<DataState, String>{
  final LocationRepository _repository;

  OpenNativeNavigationUseCase(this._repository);

  @override
  Future<DataState> call({required String params}) async{
    return await _repository.getLocationPickedStore(params);
  }

}