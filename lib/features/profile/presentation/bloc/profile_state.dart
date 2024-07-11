part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable{
  @override
  List<Object?> get props => [];

}

class ProfileInitial extends ProfileState {}

class ProfileInformationSuccess extends ProfileState {
  final UserProfileInformation userProfileInformation;
  ProfileInformationSuccess(this.userProfileInformation);
}

class ProfileInformationError extends ProfileState {}
