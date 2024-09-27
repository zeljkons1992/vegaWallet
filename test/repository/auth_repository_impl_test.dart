import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/constants/text_const.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/domain/exceptions/auth_exception_message.dart';
import 'package:vegawallet/core/services/auth_services.dart';
import 'package:vegawallet/features/auth/data/repository/auth_repository_impl.dart';

class MockAuthServices extends Mock implements AuthService {}

class MockAuthExceptionMessage extends Mock implements AuthExceptionMessage {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthServices mockAuthServices;

  setUp(() {
    mockAuthServices = MockAuthServices();
    repository = AuthRepositoryImpl(mockAuthServices);
  });

  group('AuthRepositoryImpl - loginUserWithGoogle', () {
    test('should return success when signInWithGoogle succeeds', () async {
      when(() => mockAuthServices.signInWithGoogle()).thenAnswer((_) async => true);

      final result = await repository.loginUserWithGoogle();

      expect(result.status, equals(DataStateStatus.success));
      expect(result.message, equals(DataState.success().message));
    });

    test('should return error with userCloseDialog when signInWithGoogle fails', () async {
      when(() => mockAuthServices.signInWithGoogle()).thenAnswer((_) async => false);

      final result = await repository.loginUserWithGoogle();

      expect(result.status, equals(DataStateStatus.error));
      expect(result.message, equals(TextConst.userCloseDialog));
    });

    test('should return error with specific cause when AuthExceptionMessage is thrown', () async {
      final authException = MockAuthExceptionMessage();
      when(() => authException.cause).thenReturn("auth_error");
      when(() => mockAuthServices.signInWithGoogle()).thenThrow(authException);

      final result = await repository.loginUserWithGoogle();

      expect(result.status, equals(DataStateStatus.error));
      expect(result.message, equals("auth_error"));
    });

    test('should return error with "no_network" when PlatformException with network_error code is thrown', () async {
      when(() => mockAuthServices.signInWithGoogle()).thenThrow(PlatformException(code: 'network_error'));

      final result = await repository.loginUserWithGoogle();

      expect(result.status, equals(DataStateStatus.error));
      expect(result.message, equals("no_network"));
    });

    test('should return error with exception message when PlatformException with other code is thrown', () async {
      when(() => mockAuthServices.signInWithGoogle()).thenThrow(PlatformException(code: 'other_error'));

      final result = await repository.loginUserWithGoogle();

      expect(result.status, equals(DataStateStatus.error));
      expect(result.message, contains('PlatformException'));
    });

    test('should return error with "tech_prob" when an unknown exception is thrown', () async {
      when(() => mockAuthServices.signInWithGoogle()).thenThrow(Exception());

      final result = await repository.loginUserWithGoogle();

      expect(result.status, equals(DataStateStatus.error));
      expect(result.message, equals("tech_prob"));
    });
  });

  group('AuthRepositoryImpl - Other Methods', () {
    test('should return success when signOut succeeds', () async {
      when(() => mockAuthServices.signOut()).thenAnswer((_) async => true);

      final result = await repository.logoutUser();

      expect(result.status, equals(DataStateStatus.success));
      expect(result.message, equals(DataState.success().message));
    });

    test('should return error when signOut fails', () async {
      when(() => mockAuthServices.signOut()).thenAnswer((_) async => false);

      final result = await repository.logoutUser();

      expect(result.status, equals(DataStateStatus.error));
    });

    test('should return error when isUserEmailValid returns false', () async {
      when(() => mockAuthServices.isUserEmailValid()).thenAnswer((_) async => false);

      final result = await repository.isUserVega();

      expect(result.status, equals(DataStateStatus.error));
    });

    test('should return success when isUserEmailValid returns true', () async {
      when(() => mockAuthServices.isUserEmailValid()).thenAnswer((_) async => true);

      final result = await repository.isUserVega();

      expect(result.status, equals(DataStateStatus.success));
      expect(result.message, equals(DataState.success().message));
    });
  });
}
