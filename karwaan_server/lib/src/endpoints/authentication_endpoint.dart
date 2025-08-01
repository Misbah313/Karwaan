import 'package:karwaan_server/src/endpoints/hashing_pw.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class AuthenticationEndpoint extends Endpoint {
  // Register
  Future<User> registerUser(
      Session session, String userName, String userEmail, String userPw) async {
    // check if user already exists
    final existingUser = await User.db.findFirstRow(
      session,
      where: (u) => u.email.equals(userEmail),
    );

    if (existingUser != null) {
      throw Exception('Email exists!');
    }

    try {
      // create the new user
      final newUser = User(
          name: userName, email: userEmail, password: encryptPassword(userPw));

      final insertedUser = await User.db.insertRow(session, newUser);

      session.log('Created User id: ${insertedUser.id}');

      return insertedUser;
    } catch (e, stack) {
     session.log('Registeration failed', exception: e, stackTrace: stack);
     throw Exception('Registeration error. Please try different credentials.');
    }
  }

  // Login
  Future<AuthResponse> loginUser(
      Session session, String email, String pw) async {
    // hash the pw
    final hashPw = encryptPassword(pw);

    // check if user already exists
    final existingUser = await User.db.findFirstRow(
      session,
      where: (u) => u.email.equals(email) & u.password.equals(hashPw),
    );

    if (existingUser == null) {
      throw Exception('Invalid email or password.');
    }

    try {
      // generate a secure token for user login
      final _uuid = Uuid();
      final token = _uuid.v4();

      // delete old token for this user
      await UserToken.db.deleteWhere(session,
          where: (t) => t.userId.equals(existingUser.id!));

      // create new tokens
      final now = DateTime.now();
      final expiresAt = now.add(Duration(days: 30));
      final userToken = UserToken(
          userId: existingUser.id!,
          token: token,
          createdAt: now,
          expiresAt: expiresAt);

      // save token to database
      await UserToken.db.insertRow(session, userToken);

      // clear sensative data before returning
      existingUser.password = '';

      // return authResponse with the user and token
      return AuthResponse(user: existingUser, token: token);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  // Logout
  Future<bool> logoutUser(Session session, String token) async {
    // check for the token in user token table
    final userToken = await UserToken.db
        .findFirstRow(session, where: (t) => t.token.equals(token));
    // if the token exists delete it, if not return soft success
    if (userToken != null) {
      await UserToken.db.deleteRow(session, userToken);
    }

    // always return true (soft success)
    return true;
  }
}
