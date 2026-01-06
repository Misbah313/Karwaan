import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod_auth_server/module.dart' as auth;
import 'package:serverpod/serverpod.dart';

class GoogleIntegrationEndpoint extends Endpoint {
  // integrate Google login with your own user + token models
  Future<AuthResponse> integrateGoogleUser(
      Session session, auth.UserInfo googleUser) async {
    try {
      session.log("Starting Google user integration for: ${googleUser.email}");

      // find or create user
      final user = await findOrCreateUserFromGoogle(session, googleUser);

      // generate secure token
      final token = await generateSecureToken(session, user);

      session.log("Google user integration completed for: ${user.name}");
      return AuthResponse(user: user..password = '', token: token);
    } catch (e) {
      session.log("Google user integration error: $e");
      throw Exception(e.toString());
    }
  }

  // find or create user from Google data
  Future<User> findOrCreateUserFromGoogle(
      Session session, auth.UserInfo googleUser) async {
    session.log("Searching for user with email: ${googleUser.email}");

    // check for existing user
    var existingUser = await User.db.findFirstRow(
      session,
      where: (u) => u.email.equals(googleUser.email!),
    );

    if (existingUser != null) {
      session.log("Found existing user: ${existingUser.name}");
      return existingUser;
    }

    // create new user
    session.log("Creating new user from Google data");
    final newUser = await User.db.insertRow(
      session,
      User(
        name: googleUser.userName ?? 'Google User',
        email: googleUser.email!,
        password: '', // no password for Google users
        profileImage: googleUser.imageUrl,
      ),
    );

    session.log("New user created: ${newUser.name} (ID: ${newUser.id})");
    return newUser;
  }

  // generate secure UUID-based token, deleting old ones first
  Future<String> generateSecureToken(Session session, User user) async {
    final uuid = Uuid();
    final tokenValue = "google_${uuid.v4()}";

    // delete old tokens for this user
    await UserToken.db
        .deleteWhere(session, where: (t) => t.userId.equals(user.id!));

    final now = DateTime.now();
    final expiresAt = now.add(Duration(days: 30));

    final token = UserToken(
      userId: user.id!,
      token: tokenValue,
      createdAt: now,
      expiresAt: expiresAt,
    );

    await UserToken.db.insertRow(session, token);
    session.log("New token generated for userID: ${user.id}");

    return tokenValue;
  }
}
