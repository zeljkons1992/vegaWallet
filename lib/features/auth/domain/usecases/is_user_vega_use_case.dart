import 'package:injectable/injectable.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/usecase/use_case.dart';
import '../repository/auth_repository.dart';

@Injectable()
class IsUserVegaUseCase extends UseCase<DataState, void>{

  final AuthRepository _authRepository;

  IsUserVegaUseCase(this._authRepository);

  @override
  Future<DataState> call({void params}) async{
    return await _authRepository.isUserVega();
  }

}