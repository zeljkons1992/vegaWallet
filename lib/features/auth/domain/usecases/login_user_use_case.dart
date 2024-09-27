import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/usecase/use_case.dart';
import 'package:vegawallet/features/auth/domain/repository/auth_repository.dart';

@Injectable()
class LoginUserUseCase extends UseCase<DataState, void>{

  final AuthRepository _authRepository;

  LoginUserUseCase(this._authRepository);

  @override
  Future<DataState> call({void params}) async{
    return await _authRepository.loginUserWithGoogle();
  }

}