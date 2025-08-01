/*

  Auth credential:

     - used to cleanly pass login/register data arround.

*/

class AuthCredential {
  final String email;
  final String password;

  AuthCredential({required this.email, required this.password});
}

