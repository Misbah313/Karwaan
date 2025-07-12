import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class TokenEndpoint extends Endpoint {
  Future<User?> validateToken(Session session, String token) async {
// validate token(Check if the token exists and is still valid. and return the associated user)
    final userToken = await UserToken.db
        .findFirstRow(session, where: (t) => t.token.equals(token));

    if (userToken == null) return null;

    final now = DateTime.now();
    if (userToken.expiresAt.isBefore(now)) {
      // token is expires
      await UserToken.db.deleteRow(session, userToken);
      return null;
    }

    final user = await User.db.findById(session, userToken.userId);
    return user;
  }

  // handle logout(delete or expires user. and logos out the user)
  Future<void> logout(Session session, String token) async {
    final userToken = await UserToken.db
        .findFirstRow(session, where: (t) => t.token.equals(token));

    if (userToken != null) {
      await UserToken.db.deleteRow(session, userToken);
    }
  }
}
