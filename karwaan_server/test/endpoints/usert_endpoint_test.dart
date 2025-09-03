import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('UserEndpoint', (sessionBuilder, endpoints) {
    late User user;
    late User user1;
    late User user2;
    late String userToken;
    late String userToken1;
    late String userToken2;

    setUp(() async {
      final session = sessionBuilder.build();

      // create user
      user = User(name: 'user', email: 'user@gmail.com', password: 'user123');
      final insertedUser = await User.db.insertRow(session, user);
      user.id = insertedUser.id;

      // create user1
      user1 = User(
          name: 'user1',
          email: 'user1@gmail.com',
          password: 'user1123',
          isDarkMode: false);
      final insertedUser1 = await User.db.insertRow(session, user1);
      user1.id = insertedUser1.id;

      // create user2
      user2 =
          User(name: 'user2', email: 'user2@gmail.com', password: 'user2123');
      final insertedUser2 = await User.db.insertRow(session, user2);
      user2.id = insertedUser2.id;

      // create token for the user
      userToken = 'user-token';
      await UserToken.db.insertRow(
          session,
          UserToken(
              userId: user.id!,
              token: userToken,
              createdAt: DateTime.now(),
              expiresAt: DateTime.now().add(Duration(days: 1))));

      // create token for the user1
      userToken1 = 'user-token1';
      await UserToken.db.insertRow(
          session,
          UserToken(
              userId: user1.id!,
              token: userToken1,
              createdAt: DateTime.now(),
              expiresAt: DateTime.now().add(Duration(days: 1))));

      // create token for the user2
      userToken2 = 'user-token2';
      await UserToken.db.insertRow(
          session,
          UserToken(
              userId: user2.id!,
              token: userToken2,
              createdAt: DateTime.now(),
              expiresAt: DateTime.now().add(Duration(days: 1))));
    });

    test('getUserById', () async {
      final result = await endpoints.user.getUserById(sessionBuilder, user.id!);

      expect(result, isNotNull);
      expect(result?.email, equals('user@gmail.com'));
    });

    test('getAllUsers', () async {
      final result = await endpoints.user.getAllUsers(sessionBuilder);

      final emails = result.map((e) => e.email).toList();
      final ids = result.map((i) => i.id).toList();

      expect(result, isNotEmpty);
      expect(result.length, equals(3));
      expect(
          emails,
          containsAll(
              ['user@gmail.com', 'user1@gmail.com', 'user2@gmail.com']));
      expect(ids.length, equals(3));
      expect(ids, containsAll([user.id, user1.id, user2.id]));
    });

    test('updateUser', () async {
      final session = sessionBuilder.build();

      final updated = await endpoints.user.updateUser(sessionBuilder, user);

      final db = await User.db.findById(session, user.id!);

      expect(db?.id, updated.id);
    });

    test('deleteUser', () async {
      final session = sessionBuilder.build();

      await endpoints.user.deleteUser(sessionBuilder, user1.id!);
      final db = await User.db.findById(session, user1.id!);
      expect(db, isNull);
    });

    test('setUserTheme', () async {
      final session = sessionBuilder.build();

      await endpoints.user.updateUserTheme(sessionBuilder, user1.id!, true);
      final db = await User.db.findFirstRow(
        session,
        where: (p0) => p0.id.equals(user1.id) & p0.isDarkMode.equals(true),
      );

      expect(db, isNotNull);
    });

    test('getUserTheme', () async {
          await endpoints.user.updateUserTheme(sessionBuilder, user1.id!, true);
      final result =
          await endpoints.user.getUserTheme(sessionBuilder, user1.id!);
      expect(result, isTrue);
    });
  });
}
