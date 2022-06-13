part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SignInGoogle extends AuthEvent {}

class SignInFacebook extends AuthEvent {}

class LogOut extends AuthEvent {}
