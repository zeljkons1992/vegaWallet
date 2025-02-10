
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegawallet/core/constants/text_const.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/domain/exceptions/auth_exception_message.dart';
import 'package:vegawallet/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/services/auth_services.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {

  final AuthService _authServices;
  AuthRepositoryImpl(this._authServices);

  @override
  Future<DataState> loginUserWithGoogle() async {
    try {
      bool result = await _authServices.signInWithGoogle();
      if (result) {
        return DataState.success();
      } else {
        return DataState.error(TextConst.userCloseDialog);
      }
    } on AuthExceptionMessage catch (e) {
      return DataState.error(e.cause);
    } on PlatformException catch (e) {
      if (e.code == 'network_error') {
        return DataState.error("no_network");
      } else {
        return DataState.error(e.toString());
      }
    } catch (e) {
      return DataState.error("tech_prob");
    }
  }

  @override
  Future<DataState> logoutUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    bool isLogoutSuccess = await _authServices.signOut();
    if(isLogoutSuccess){
      return DataState.success();
    }else{
      return DataState.error("Error");
    }
  }

  @override
  Future<DataState> isUserVega() async {
      var result = await _authServices.isUserEmailValid();
      if(result){
        return DataState.success();
      }
      return DataState.error("Korisnicko ime nije Vega");
  }
}
