import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/services/auth_services.dart';
import 'package:vegawallet/features/auth/data/repository/auth_repository_impl.dart';

class MockAuthServices extends Mock implements AuthService {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthServices mockAuthServices;

  setUp(() {
    mockAuthServices = MockAuthServices();
    repository = AuthRepositoryImpl(mockAuthServices);
  });

  group('AuthRepositoryImpl', () {
    test('should return success when loginUserWithGoogle succeeds', () async {

      when(() => mockAuthServices.signInWithGoogle()).thenAnswer((_) async => true);

      final result = await repository.loginUserWithGoogle();

      expect(result.status, equals(DataStateStatus.success));
      expect(result.message, equals(DataState.success().message));
    });

    test('should return error when loginUserWithGoogle fails', () async {

      when(() => mockAuthServices.signInWithGoogle()).thenAnswer((_) async => false);

      final result = await repository.loginUserWithGoogle();

      expect(result.status, equals(DataStateStatus.error));
      expect(result.message, equals("Error"));
    });

    test('should return error when logoutUser fails', () async {

      when(() => mockAuthServices.signOut()).thenAnswer((_) async => false);

      final result = await repository.logoutUser();

      expect(result.status, equals(DataStateStatus.error));
    });

    test('should return error when logoutUser fails', () async {

      when(() => mockAuthServices.signOut()).thenAnswer((_) async => true);

      final result = await repository.logoutUser();

      expect(result.status, equals(DataStateStatus.success));
      expect(result.message, equals(DataState.success().message));

    });

    test('should return error when isUserVega fails', () async {

      when(() => mockAuthServices.isUserEmailValid()).thenAnswer((_) async => false);

      final result = await repository.isUserVega();

      expect(result.status, equals(DataStateStatus.error));

    });

    test('should return success when isUserVega', () async {

      when(() => mockAuthServices.isUserEmailValid()).thenAnswer((_) async => true);

      final result = await repository.isUserVega();

      expect(result.status, equals(DataStateStatus.success));
      expect(result.message, equals(DataState.success().message));

    });
  });
}
