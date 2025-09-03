import 'package:karwaan_server/src/endpoints/hashing_pw.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('AuthenticationEndpoint', (sessionBuilder, endpoints) {
    late User user;

    setUp(() async {
      final session = sessionBuilder.build();
      // create user
      user = User(
          name: 'user',
          email: 'user@gmail.com',
          password: encryptPassword('user123'));
      final insertedUser = await User.db.insertRow(session, user);
      user.id = insertedUser.id;

      // create user token
    });

    test('registerUser', () async {
      final session = sessionBuilder.build();
      final user = await endpoints.authentication
          .registerUser(sessionBuilder, 'Ali', 'ali@gmail.com', 'ali123');

      final db = await User.db.findFirstRow(
        session,
        where: (p0) => p0.name.equals(user.name) & p0.id.equals(user.id),
      );

      expect(db, isNotNull);
    });

    test('loginUser', () async {
      final session = sessionBuilder.build();
      await endpoints.authentication.loginUser(
          sessionBuilder, user.email, 'user123');

      // check db
      final db = await UserToken.db.findFirstRow(
        session,
        where: (p0) => p0.userId.equals(user.id),
      );

      expect(db, isNotNull);
    });

    test('logoutUser', () async{
      final session = sessionBuilder.build();

     final logout = await endpoints.authentication.loginUser(sessionBuilder, user.email, 'user123');

      await endpoints.authentication.logoutUser(sessionBuilder, logout.token);

      // check the token
      final dbt = await UserToken.db.findFirstRow(session, where: (p0) => p0.token.equals(logout.token),);
      expect(dbt, isNull);      
    });
  });
}
