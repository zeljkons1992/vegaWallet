import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/services/auth_services.dart';
import 'package:vegawallet/features/profile/data/repository/profile_repository_impl.dart';
import 'package:vegawallet/features/profile/domain/entites/user_profile_information.dart';

class MockAuthServices extends Mock implements AuthService {}

class MockUser extends Mock implements User {
  @override
  UserMetadata get metadata => MockUserMetadata();
}

class MockUserMetadata extends Mock implements UserMetadata {
  @override
  DateTime? get creationTime => DateTime(2020, 1, 1);
}

void main() {
  late ProfileRepositoryImpl profileRepositoryImpl;
  late MockAuthServices mockAuthServices;
  late MockUser mockUser;

  setUp(() {
    mockAuthServices = MockAuthServices();
    profileRepositoryImpl = ProfileRepositoryImpl(mockAuthServices);
    mockUser = MockUser();
    when(() => mockUser.uid).thenReturn("123");
    when(() => mockUser.displayName).thenReturn("Nikla");
    when(() => mockUser.email).thenReturn("nikla@example.com");
    when(() => mockUser.phoneNumber).thenReturn("1234567890");
    when(() => mockUser.photoURL).thenReturn("http://example.com/photo.jpg");
  });

  test("should return success with valid data", () async {

    when(() => mockAuthServices.getCurrentUser()).thenAnswer((_) async => mockUser);

    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    final String formattedDate = formatter.format(mockUser.metadata.creationTime!);

    final expectedUserProfileInformation = UserProfileInformation(
        uid: "123",
        nameAndSurname: "Nikla",
        email: "nikla@example.com",
        phoneNumber: "1234567890",
        profileImage: "http://example.com/photo.jpg",
        dateTime: formattedDate,
        isEpsilon: true
    );

    final result = await profileRepositoryImpl.getUserInformation();

    expect(result.data, equals(expectedUserProfileInformation));
  });

  test("should return error when user is not logged in", () async {

    when(() => mockAuthServices.getCurrentUser()).thenAnswer((_) async => null);

    final result = await profileRepositoryImpl.getUserInformation();

    expect(result, equals(DataState<UserProfileInformation>.error('User not logged in')));
  });

  test("should return error when there is an exception", () async {

    when(() => mockAuthServices.getCurrentUser()).thenThrow(Exception("Some error"));

    final result = await profileRepositoryImpl.getUserInformation();

    expect(result, equals(DataState<UserProfileInformation>.error("Exception: Some error")));
  });
}
