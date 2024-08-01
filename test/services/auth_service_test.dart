import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/domain/exceptions/auth_exception_message.dart';
import 'package:vegawallet/core/services/auth_services.dart';

// Mock classes
class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late AuthService authService;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockGoogleSignIn = MockGoogleSignIn();
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    authService = AuthService(
      googleSignIn: mockGoogleSignIn,
      firebaseAuth: mockFirebaseAuth,
    );

    // Register fallback values for non-nullable types
    registerFallbackValue(MockUser());
    registerFallbackValue(MockUserCredential());
    registerFallbackValue(const OAuthCredential(
      providerId: 'providerId',
      signInMethod: 'signInMethod',
    ));
  });

  group('AuthService', () {
    test('signInWithGoogle returns true for valid @vegait.rs email', () async {
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleSignInAccount);
      when(() => mockGoogleSignInAccount.authentication).thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(() => mockGoogleSignInAuthentication.accessToken).thenReturn('accessToken');
      when(() => mockGoogleSignInAuthentication.idToken).thenReturn('idToken');
      when(() => mockFirebaseAuth.signInWithCredential(any())).thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.email).thenReturn('test@vegait.rs');

      final result = await authService.signInWithGoogle();

      expect(result, true);
    });

    test('signInWithGoogle throws AuthExceptionMessage for invalid email', () async {
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleSignInAccount);
      when(() => mockGoogleSignInAccount.authentication).thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(() => mockGoogleSignInAuthentication.accessToken).thenReturn('accessToken');
      when(() => mockGoogleSignInAuthentication.idToken).thenReturn('idToken');
      when(() => mockFirebaseAuth.signInWithCredential(any())).thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.email).thenReturn('test@gmail.com');

      expect(() async => await authService.signInWithGoogle(), throwsA(isA<AuthExceptionMessage>()));
    });

    test('isUserLoggedIn returns true when user is logged in', () {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final result = authService.isUserLoggedIn();

      expect(result, true);
    });

    test('isUserLoggedIn returns false when user is not logged in', () {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final result = authService.isUserLoggedIn();

      expect(result, false);
    });

    test('signOut returns true on successful sign out', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);

      final result = await authService.signOut();

      expect(result, true);
    });

    test('signOut returns false on failed sign out', () async {
      when(() => mockFirebaseAuth.signOut()).thenThrow(Exception('Failed to sign out'));

      final result = await authService.signOut();

      expect(result, false);
    });

    test('isUserEmailValid returns true for valid @vegait.rs email', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.email).thenReturn('test@vegait.rs');

      final result = await authService.isUserEmailValid();

      expect(result, true);
    });

    test('isUserEmailValid returns false for invalid email', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.email).thenReturn('test@gmail.com');
      when(() => mockUser.delete()).thenAnswer((_) async {});

      final result = await authService.isUserEmailValid();

      expect(result, false);
    });

    test('getUserName returns the display name of the user', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.displayName).thenReturn('Test User');

      final result = await authService.getUserName();

      expect(result, 'Test User');
    });

    test('getCurrentUser returns the current user', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final result = await authService.getCurrentUser();

      expect(result, mockUser);
    });

    test('getCurrentUser returns null when there is no current user', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final result = await authService.getCurrentUser();

      expect(result, null);
    });
  });
}
