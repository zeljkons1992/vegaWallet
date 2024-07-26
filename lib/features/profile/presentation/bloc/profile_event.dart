part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?>get props => [];
}

class GetUserInformation extends ProfileEvent {}

class UpdateUserLocation extends ProfileEvent {
  final UserProfileInformation user;

  UpdateUserLocation(this.user);
}

