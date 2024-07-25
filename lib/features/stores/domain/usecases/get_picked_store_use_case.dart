import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/usecase/use_case.dart';
import '../../../../core/data_state/data_state.dart';
import '../repository/location_repository.dart';

@Injectable()
class GetPickedStoreUseCase extends UseCase<DataState, String> {
  final LocationRepository repository;

  GetPickedStoreUseCase(this.repository);

  @override
  Future<DataState> call({String? params}) async{
    return await repository.getLocationPickedStore(params!);
  }
}
