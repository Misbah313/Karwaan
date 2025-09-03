import 'dart:io';

import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('FileEndpoint', (sessionBuilder, endpoints) {
    late User user;
    late String userToken;

    setUp(() async {
      final session = sessionBuilder.build();

      // create user
      user = User(name: 'user', email: 'user@gmail.com', password: 'user123');
      final insertedUser = await User.db.insertRow(session, user);
      user.id = insertedUser.id;

      // create userToken
      userToken = 'user-token';
      await UserToken.db.insertRow(
          session,
          UserToken(
              userId: user.id!,
              token: userToken,
              createdAt: DateTime.now(),
              expiresAt: DateTime.now().add(Duration(days: 1))));
    });

    test('uploadProfilePic', () async {
      final session = sessionBuilder.build();

      final fileBytes = [1, 2, 3, 4, 5];
      final result = await endpoints.file.uploadProfilePicture(
          sessionBuilder, user.id!, 'profile.png', fileBytes);

      // check if the file upload on desk
      final disk = File('uploads/profile_pictures/$result');
      expect(await disk.exists(), isTrue);

      // check if db updated after upload
      final db = await User.db.findById(session, user.id!);
      expect(db?.profileImage, equals(result));
    });

    test('deleteProfilePic', () async {
      final session = sessionBuilder.build();
      final fileBytes = [1, 2, 3, 4, 5];
      final result = await endpoints.file.uploadProfilePicture(
          sessionBuilder, user.id!, 'profile.png', fileBytes);

      final file = File('uploads/profile_pictures/$result');

      final deleted =
          await endpoints.file.deleteProfilePicture(sessionBuilder, user.id!);

      expect(deleted, isTrue);
      expect(await file.exists(), isFalse);

      final db = await User.db.findById(session, user.id!);
      expect(db?.profileImage, isNull);
    });
  });
}
