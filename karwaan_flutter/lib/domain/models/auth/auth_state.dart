/*

  Auth state:
    
    - used for different auth states, specially used in bloc/cubit.

*/

import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final AuthUser user;

  Authenticated(this.user);
}

class UnAuthenticated extends AuthState {
}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}

class LogoutOutSuccess extends AuthState {}
