import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/constants/text_const.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/wallet/domain/usecases/get_user_card_information_use_case.dart';
import '../../../domain/usecases/login_user_use_case.dart';
import '../../../domain/usecases/logout_user_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@Injectable()
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUserUseCase _loginUserUseCase;
  final LogoutUserUseCase _logoutUserUseCase;
  final GetUserCardInformationUseCase _cardInformationUseCase;
  final _navigationStreamController = StreamController<bool>();

  AuthBloc(this._loginUserUseCase, this._logoutUserUseCase, this._cardInformationUseCase) : super(AuthInitial()) {
    on<LoginWithGoogle>(_onUserLogin);
    on<LogoutUser>(_onUserLogout);
  }

  StreamSink<bool> get successNavigationSink => _navigationStreamController.sink;
  Stream<bool> get streamNavigationSuccess => _navigationStreamController.stream.asBroadcastStream();



  Future<void> _onUserLogin(LoginWithGoogle event, Emitter<AuthState> emit) async {
      emit(AuthVegaStartAuthorization());
      final result = await _loginUserUseCase();
      final result2 = await _cardInformationUseCase();
      if (result.status == DataStateStatus.success && result2.status == DataStateStatus.success) {
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
