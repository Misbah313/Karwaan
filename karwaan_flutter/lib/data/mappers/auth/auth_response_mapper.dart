/*

 auth-response mapper:
   
   - Convert AuthResponse (from Serverpod (which has both user + token )) → AuthUser (for your app's domain).
   
*/

import 'package:karwaan_client/karwaan_client.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';

extension AuthResponeMapper on AuthResponse {
  AuthUser toDomain() {
    return AuthUser(
        id: user.id!, name: user.name, email: user.email, token: token, profileImage: user.profileImage, isDarkMode: user.isDarkMode);
  }
}
