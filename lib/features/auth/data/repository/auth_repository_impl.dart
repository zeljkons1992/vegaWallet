import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/services/auth_services.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {

  final AuthService _authServices;
  AuthRepositoryImpl(this._authServices);

  @override
  Future<DataState> loginUserWithGoogle() async {
    bool isLoggedIn = await _authServices.signInWithGoogle();
    if (isLoggedIn) {
      return DataState.success();
    } else {
      return DataState.error("Error");
    }
  }

  @override
  Future<DataState> logoutUser() async{
    bool isLogoutSuccess = await _authServices.signOut();
    if(isLogoutSuccess){
      return DataState.success();
    }else{
      return DataState.error("Error");
    }
  }
}
