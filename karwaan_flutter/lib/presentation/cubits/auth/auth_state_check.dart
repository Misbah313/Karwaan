import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';

abstract class AuthStateCheck {}

class AuthInitial extends AuthStateCheck {}

class AuthLoading extends AuthStateCheck {}

class AuthAuthenticated extends AuthStateCheck {
  final AuthUser user;
  AuthAuthenticated(this.user);
}

class AuthUnAuthenticated extends AuthStateCheck {
  final bool fromRegisteration;

  AuthUnAuthenticated({this.fromRegisteration = false});
}

class RegisterationSuccess extends AuthStateCheck {
  final String email;

  RegisterationSuccess(this.email);
}

class DeleteSuccessfully extends AuthStateCheck {
  final int userId;

  DeleteSuccessfully(this.userId);
}

class AuthError extends AuthStateCheck {
  final String errormessage;
  AuthError(this.errormessage);
}
