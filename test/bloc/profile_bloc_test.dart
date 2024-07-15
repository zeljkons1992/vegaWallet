import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/profile/domain/entites/user_profile_information.dart';
import 'package:vegawallet/features/profile/domain/usecases/get_user_information_use_case.dart';
import 'package:vegawallet/features/profile/presentation/bloc/profile_bloc.dart';

class MockGetUserInformationUseCase extends Mock implements GetUserInformationUseCase {}

void main() {
  late ProfileBloc profileBloc;
  late MockGetUserInformationUseCase mockGetUserInformationUseCase;

  setUp(() {
    mockGetUserInformationUseCase = MockGetUserInformationUseCase();
    profileBloc = ProfileBloc(mockGetUserInformationUseCase);
  });

  test('initial state is ProfileInitial', () {
    expect(profileBloc.state, equals(ProfileInitial()));
  });

  UserProfileInformation userProfileInformation = const UserProfileInformation(
    uid: "123",
    nameAndSurname: "nik",
    email: "ee",
    phoneNumber: "e",
    profileImage: "e",
    dateTime: "e",
    isEpsilon: true
  );

  blocTest<ProfileBloc, ProfileState>(
    'emits [ProfileInformationSuccess] when GetUserInformation is added and fetching is successful',
    build: () {
      when(() => mockGetUserInformationUseCase()).thenAnswer((_) async => DataState.success(userProfileInformation));
      return profileBloc;
    },
    act: (bloc) => bloc.add(GetUserInformation()),
    expect: () => [
      ProfileInformationSuccess(userProfileInformation)
    ],
  );
  blocTest<ProfileBloc, ProfileState>(
    'emits [ProfileInformationSuccess] when GetUserInformation is added and fetching is error',
    build: () {
      when(() => mockGetUserInformationUseCase()).thenAnswer((_) async => DataState.error("error"));
      return profileBloc;
    },
    act: (bloc) => bloc.add(GetUserInformation()),
    expect: () => [
      ProfileInformationError()
    ],
  );
}
