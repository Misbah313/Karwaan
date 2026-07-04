// Create a new file: lib/data/mappers/user_mapper.dart
import 'package:karwaan_client/karwaan_client.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';

extension UserMapper on User {
  AuthUser toAuthUser() {
    return AuthUser(
      id: id!,
      name: name,
      email: email ,
      token: '', // Token is not available from User object alone
      profileImage: profileImage,
      isDarkMode: isDarkMode,
    );
  }
}
