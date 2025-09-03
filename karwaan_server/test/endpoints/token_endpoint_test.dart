import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('TokenEndpoint', (sessionBuilder, endpoints) {
    late User user;
    late String userToken;

    setUp(() async {
      final session = sessionBuilder.build();

      user = User(name: 'user', email: 'user@gmail.com', password: 'user123');
      final insertedUser = await User.db.insertRow(session, user);
      user.id = insertedUser.id;

      // create token for the user
      userToken = 'user-token';
      await UserToken.db.insertRow(
          session,
          UserToken(
              userId: user.id!,
              token: userToken,
              createdAt: DateTime.now(),
              expiresAt: DateTime.now().add(Duration(days: 1))));
    });

    test('validateToken', () async {
      final valid =
          await endpoints.token.validateToken(sessionBuilder, userToken);

      expect(valid, isNotNull);
    });

    test('logout - delete token', () async {
      final session = sessionBuilder.build();

      await endpoints.token.logout(sessionBuilder, userToken);

      final db = await UserToken.db.findFirstRow(
        session,
        where: (p0) => p0.token.equals(userToken),
      );

      expect(db, isNull);
    });
  });
}
