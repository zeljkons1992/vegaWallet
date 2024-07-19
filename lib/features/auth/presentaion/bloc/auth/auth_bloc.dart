import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/constants/text_const.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import '../../../domain/usecases/login_user_use_case.dart';
import '../../../domain/usecases/logout_user_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@Injectable()
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUserUseCase _loginUserUseCase;
  final LogoutUserUseCase _logoutUserUseCase;
  final _navigationStreamController = StreamController<bool>();

  AuthBloc(this._loginUserUseCase, this._logoutUserUseCase) : super(AuthInitial()) {
    on<LoginWithGoogle>(_onUserLogin);
    on<LogoutUser>(_onUserLogout);
  }

  StreamSink<bool> get successNavigationSink => _navigationStreamController.sink;
  Stream<bool> get streamNavigationSuccess => _navigationStreamController.stream.asBroadcastStream();



  Future<void> _onUserLogin(LoginWithGoogle event, Emitter<AuthState> emit) async {
      emit(AuthVegaStartAuthorization());
      final result = await _loginUserUseCase();
      if (result.status == DataStateStatus.success) {
        _navigationStreamController.sink.add(true);
      }
      else if (result.message==TextConst.userCloseDialog){
        emit(AuthInitial());
      } else {
        emit(AuthLoginWithGoogleError(result.message ?? ""));
      }
  }

  Future<void> _onUserLogout(LogoutUser event, Emitter<AuthState> emit) async {
    final result = await _logoutUserUseCase();
    if (result.status == DataStateStatus.success) {
      emit(AuthLogoutSuccess());
    } else {
      emit(AuthLogoutError());
    }
  }
}
