import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';

import '../../domain/usecases/login_user_use_case.dart';
import '../../domain/usecases/logout_user_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@Injectable()
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUserUseCase _loginUserUseCase;
  final LogoutUserUseCase _logoutUserUseCase;
  AuthBloc(this._loginUserUseCase, this._logoutUserUseCase) : super(AuthInitial()) {
    on<LoginWithGoogle>(_onUserLogin);
    on<LogoutUser>(_onUserLogout);
  }

  Future<void> _onUserLogin(LoginWithGoogle event, Emitter<AuthState> emit) async{
    final result = await _loginUserUseCase();
    if(result.status == DataStateStatus.success){
      emit(AuthLoginWithGoogleSuccess());
    }else{
      emit(AuthLoginWithGoogleError());
    }
  }

  Future<void> _onUserLogout(LogoutUser event, Emitter<AuthState> emit) async{
    final result =  await _logoutUserUseCase();
    if(result.status ==  DataStateStatus.success){
      emit(AuthLogoutSuccess());
    }else{
      emit(AuthLogoutError());
    }
  }
}
