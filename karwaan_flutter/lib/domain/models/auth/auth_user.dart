/*

 Auth user:

   - represents the authenticated user after successful login.

*/

class AuthUser {
  final int id;
  final String name;
  final String email;
  final String token;
  final String? profileImage;
  final bool? isDarkMode;

  AuthUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.token,
      this.profileImage,
      this.isDarkMode});

  AuthUser copyWith({
    int? id,
    String? name,
    String? email,
    String? token,
    String? profileImage,
    bool? isDarkMode,
  }) {
    return AuthUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      profileImage: profileImage ?? this.profileImage,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
