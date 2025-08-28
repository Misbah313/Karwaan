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

  AuthUser(
      {required this.id,
      required this.name,
      required this.email, 
      required this.token,
       this.profileImage});
}
