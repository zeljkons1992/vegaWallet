import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

class MockFirebaseService extends Mock implements FirebaseDatabase {}

class MockUser extends Mock implements User {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

class MockUserMetadata extends Mock implements UserMetadata {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthServices mockAuthServices;
  late MockFirebaseService mockFirebaseService;
  late MockDatabaseReference mockDatabaseReference;
  late MockUser mockUser;
  late MockDataSnapshot mockDataSnapshot;
  late MockUserMetadata mockUserMetadata;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockAuthServices = MockAuthServices();
    mockFirebaseService = MockFirebaseService();
    mockDatabaseReference = MockDatabaseReference();
    mockUser = MockUser();
    mockDataSnapshot = MockDataSnapshot();
    mockUserMetadata = MockUserMetadata();
    repository = AuthRepositoryImpl(mockAuthServices, mockFirebaseService);

    when(() => mockFirebaseService.ref()).thenReturn(mockDatabaseReference);
    when(() => mockDatabaseReference.child(any())).thenReturn(mockDatabaseReference);
    when(() => mockDatabaseReference.set(any())).thenAnswer((_) async => {});
    when(() => mockDatabaseReference.get()).thenAnswer((_) async => mockDataSnapshot);
  });

  group('AuthRepositoryImpl - loginUserWithGoogle', () {
    test('should return success when signInWithGoogle succeeds', () async {
      when(() => mockAuthServices.signInWithGoogle()).thenAnswer((_) async => true);
      when(() => mockAuthServices.getCurrentUser()).thenAnswer((_) async => mockUser);
      when(() => mockUser.uid).thenReturn('12345');
      when(() => mockUser.displayName).thenReturn('Test User');
      when(() => mockUser.email).thenReturn('test@example.com');
      when(() => mockUser.phoneNumber).thenReturn('1234567890');
      when(() => mockUser.photoURL).thenReturn('https://example.com/photo.jpg');
      when(() => mockUser.metadata).thenReturn(mockUserMetadata);
      when(() => mockUserMetadata.creationTime).thenReturn(DateTime.now());
      when(() => mockUserMetadata.lastSignInTime).thenReturn(DateTime.now());
      when(() => mockDataSnapshot.exists).thenReturn(false);

      final result = await repository.loginUserWithGoogle();

      expect(result.status, equals(DataStateStatus.success));
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
