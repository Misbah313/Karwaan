/*
 
 Auth repo:
   
   - This is how authentication works.
 
*/

import 'package:karwaan_flutter/domain/models/auth/auth_credentials.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';

abstract class AuthRepo {
  Future<AuthUser> registerUser(AuthCredential credential, String name);

  Future<AuthUser> loginUser(AuthCredential credential);

  Future<AuthUser?> validateToken(String token);

  Future<void> logoutUser(String token);

  Future<void> deleteUser(int userId);
}
