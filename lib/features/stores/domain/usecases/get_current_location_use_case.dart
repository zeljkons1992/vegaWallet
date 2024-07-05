import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/usecase/use_case.dart';
import '../repository/location_repository.dart';

@Injectable()
class GetCurrentLocationUseCase extends UseCase<DataState, void> {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  @override
  Future<DataState> call({void params}) async{
    return await repository.getCurrentLocation();
  }

}