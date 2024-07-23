import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/profile/domain/entites/user_profile_information.dart';
import 'package:vegawallet/features/profile/domain/repository/profile_repository.dart';
import 'package:vegawallet/features/profile/domain/usecases/get_user_information_use_case.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late GetUserInformationUseCase getUserInformationUseCase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    getUserInformationUseCase = GetUserInformationUseCase(mockProfileRepository);
  });

   UserProfileInformation userProfileInformation = const UserProfileInformation(
     uid: "123",
    nameAndSurname: 'John Doe',
    email: 'johndoe@example.com',
    phoneNumber: '1234567890',
    profileImage: 'http://example.com/photo.jpg',
    dateTime: 'January 1, 2020',
  );

  test('should return DataState.success with UserProfileInformation on success', () async {
    // Arrange
    when(() => mockProfileRepository.getUserInformation()).thenAnswer(
          (_) async => DataState.success(userProfileInformation),
    );

    // Act
    final result = await getUserInformationUseCase();

    // Assert
    expect(result, equals(DataState.success(userProfileInformation)));
  });

  test('should return DataState.error on failure', () async {
    // Arrange
    const errorMessage = 'Some error occurred';
    when(() => mockProfileRepository.getUserInformation()).thenAnswer(
          (_) async => DataState.error(errorMessage),
    );

    // Act
    final result = await getUserInformationUseCase();

    // Assert
    expect(result, equals(DataState<UserProfileInformation>.error(errorMessage)));
  });
}
