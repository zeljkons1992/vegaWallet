import '../../../../core/data_state/data_state.dart';

abstract class AuthRepository {
  Future<DataState> loginUserWithGoogle();
  Future<DataState> logoutUser();
}