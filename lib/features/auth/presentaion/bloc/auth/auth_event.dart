part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable{
  @override
  List<Object?>get props => [];
}

class LoginWithGoogle extends AuthEvent {}

class LogoutUser extends AuthEvent {}
