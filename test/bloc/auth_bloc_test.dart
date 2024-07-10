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
    'emits [AuthLoginWithGoogleSuccess] when LoginWithGoogle is added and login is successful',
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
    'emits [AuthLoginWithGoogleError] when LoginWithGoogle is added and login fails',
    build: () {
      when(() => mockLoginUserUseCase()).thenAnswer((_) async => DataState.error("error"));
      return authBloc;
    },
    act: (bloc) => bloc.add(LoginWithGoogle()),
    expect: () => [
      AuthLoginWithGoogleError(),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLogoutSuccess] when LogoutUser is added and logout is successful',
    build: () {
      when(() => mockLogoutUserUseCase()).thenAnswer((_) async => DataState.success());
      return authBloc;
    },
    act: (bloc) => bloc.add(LogoutUser()),
    expect: () => [
      AuthLogoutSuccess(),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLogoutError] when LogoutUser is added and logout fails',
    build: () {
      when(() => mockLogoutUserUseCase()).thenAnswer((_) async => DataState.error("error"));
      return authBloc;
    },
    act: (bloc) => bloc.add(LogoutUser()),
    expect: () => [
      AuthLogoutError(),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthVegaStartAuthorization, AuthVegaConfirmAnimation, AuthVegaConfirm] when CheckIsUserVega is added and user is Vega',
    build: () {
      when(() => mockIsUserVegaUseCase()).thenAnswer((_) async => DataState.success());
      return authBloc;
    },
    act: (bloc) => bloc.add(CheckIsUserVega()),
    wait: const Duration(seconds: 11),
    expect: () => [
      AuthVegaStartAuthorization(),
      AuthVegaConfirmAnimation(),
      AuthVegaConfirm(),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthVegaStartAuthorization, AuthVegaNotConfirmAnimation, AuthVegaNotConfirm] when CheckIsUserVega is added and user is not Vega',
    build: () {
      when(() => mockIsUserVegaUseCase()).thenAnswer((_) async => DataState.error("Korisnicko ime nije Vega"));
      return authBloc;
    },
    act: (bloc) => bloc.add(CheckIsUserVega()),
    wait: const Duration(seconds: 15),
    expect: () => [
      AuthVegaStartAuthorization(),
      AuthVegaNotConfirmAnimation(),
      AuthVegaNotConfirm(),
    ],
  );
}
