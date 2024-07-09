import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/auth/domain/usecases/is_user_vega_use_case.dart';
import 'package:vegawallet/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:vegawallet/features/auth/domain/usecases/logout_user_use_case.dart';
import 'package:vegawallet/features/auth/presentaion/bloc/auth/auth_bloc.dart';

class MockIsUserVegaUseCase extends Mock implements IsUserVegaUseCase {}
class MockLoginUserUseCase extends Mock implements LoginUserUseCase {}
class MockLogoutUserUseCase extends Mock implements LogoutUserUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockIsUserVegaUseCase mockIsUserVegaUseCase;
  late MockLoginUserUseCase mockLoginUserUseCase;
  late MockLogoutUserUseCase mockLogoutUserUseCase;

  setUp(() {
    mockIsUserVegaUseCase = MockIsUserVegaUseCase();
    mockLoginUserUseCase = MockLoginUserUseCase();
    mockLogoutUserUseCase = MockLogoutUserUseCase();
    authBloc = AuthBloc(mockLoginUserUseCase, mockLogoutUserUseCase, mockIsUserVegaUseCase);
  });

  test('initial state is AuthInitial', () {
    expect(authBloc.state, equals(AuthInitial()));
  });

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthAuthenticated] when LoginWithGoogle is added',
    build: () {
      when(() => mockLoginUserUseCase()).thenAnswer((_) async => DataState.success());
      return authBloc;
    },
    act: (bloc) => bloc.add(LoginWithGoogle()),
    expect: () => [
      AuthLoginWithGoogleSuccess(),
    ],
  );
  blocTest<AuthBloc, AuthState>(
    'emmit error',
    build: () {
      when(() => mockLoginUserUseCase()).thenAnswer((_) async => DataState.error("error"));
      return authBloc;
    },
    act: (bloc) => bloc.add(LoginWithGoogle()),
    expect: () => [
      AuthLoginWithGoogleError(),
    ],
  );
}
