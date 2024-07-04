import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/usecase/use_case.dart';
import '../../../../core/data_state/no_params.dart';
import '../repository/location_repository.dart';

@Injectable()
class GetCurrentLocationUseCase extends UseCase<DataState, NoParams> {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  @override
  Future<DataState> call({NoParams? params}) async{
    return await repository.getCurrentLocation();
  }

}