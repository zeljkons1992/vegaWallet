part of 'auth_bloc.dart';

abstract class AuthState extends Equatable{
  @override
  List<Object?> get props => [];

}
class AuthInitial extends AuthState {}

class AuthLoginWithGoogleSuccess extends AuthState {}

class AuthLoginWithGoogleError extends AuthState {}

class AuthLogoutSuccess extends AuthState {}

class AuthLogoutError extends AuthState {}


