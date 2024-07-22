import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/constants/text_const.dart';
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
  late MockLoginUserUseCase mockLoginUserUseCase;
  late MockLogoutUserUseCase mockLogoutUserUseCase;

  setUp(() {
    mockLoginUserUseCase = MockLoginUserUseCase();
    mockLogoutUserUseCase = MockLogoutUserUseCase();
    authBloc = AuthBloc(mockLoginUserUseCase, mockLogoutUserUseCase);
  });

  test('initial state is AuthInitial', () {
    expect(authBloc.state, equals(AuthInitial()));
  });

  blocTest<AuthBloc, AuthState>(
    'emits [AuthVegaStartAuthorization, AuthLoginWithGoogleError] when LoginWithGoogle is added and login fails',
    build: () {
      when(() => mockLoginUserUseCase()).thenAnswer((_) async => DataState.error("error"));
      return authBloc;
    },
    act: (bloc) => bloc.add(LoginWithGoogle()),
    expect: () => [
      AuthVegaStartAuthorization(),
      AuthLoginWithGoogleError("error"),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthVegaStartAuthorization] and adds true to navigation stream when LoginWithGoogle is added and login succeeds',
    build: () {
      when(() => mockLoginUserUseCase()).thenAnswer((_) async => DataState.success());
      return authBloc;
    },
    act: (bloc) {
      bloc.add(LoginWithGoogle());
    },
    expect: () => [
      AuthVegaStartAuthorization(),
    ],
    verify: (bloc) {
      expectLater(bloc.streamNavigationSuccess, emitsInOrder([true]));
    },
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
    'emits [AuthInitial] when LoginWithGoogle is added and user closes dialog',
    build: () {
      when(() => mockLoginUserUseCase()).thenAnswer((_) async => DataState.error(TextConst.userCloseDialog));
      return authBloc;
    },
    act: (bloc) => bloc.add(LoginWithGoogle()),
    expect: () => [
      AuthVegaStartAuthorization(),
      AuthInitial(),
    ],
  );
}
