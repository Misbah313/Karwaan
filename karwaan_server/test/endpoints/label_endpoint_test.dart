import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('LabelEndpoint', (sessionBuilder, endpoints) {
    late User user;
    late Workspace workspace;
    late Board board;
    late Label label;
    late String userToken;

    setUp(() async {
      final session = sessionBuilder.build();

      // create user
      user = User(name: 'user', email: 'user@gmail.com', password: 'user123');
      final insertedUser = await User.db.insertRow(session, user);
      user.id = insertedUser.id;

      // create parent workspace
      workspace = Workspace(
          name: 'Workspace', createdAt: DateTime.now(), ownerId: user.id!);
      final insertedWorkspace =
          await Workspace.db.insertRow(session, workspace);
      workspace.id = insertedWorkspace.id;

      await WorkspaceMember.db.insertRow(
          session,
          WorkspaceMember(
              user: user.id!,
              workspace: workspace.id!,
              joinedAt: DateTime.now()));

      // create parent board
      board = Board(
          name: 'Board',
          description: 'Bdec',
          workspaceId: workspace.id!,
          createdBy: user.id!,
          createdAt: DateTime.now());
      final insertedBoard = await Board.db.insertRow(session, board);
      board.id = insertedBoard.id;

      await BoardMember.db.insertRow(
          session,
          BoardMember(
              user: user.id!, board: board.id!, joinedAt: DateTime.now()));

      // create the user token
      userToken = 'user-token';
      await UserToken.db.insertRow(
          session,
          UserToken(
              userId: user.id!,
              token: userToken,
              createdAt: DateTime.now(),
              expiresAt: DateTime.now().add(Duration(days: 1))));

      // create the label
      label = Label(
          title: 'userLabel',
          color: '0XFF303030',
          board: board.id!,
          createdBy: user.id!);
      final insertedLabel = await Label.db.insertRow(session, label);
      label.id = insertedLabel.id;
    });

    test('createLabel', () async {
      final session = sessionBuilder.build();

      final created = await endpoints.label.createLabel(
          sessionBuilder, board.id!, userToken, 'Label1', '#FF0000');

      final db = await Label.db.findFirstRow(
        session,
        where: (p0) =>
            p0.board.equals(board.id) &
            p0.title.equals(created.title) &
            p0.color.equals(created.color),
      );

      expect(db, isNotNull);
    });

    test('getLabelForBoard', () async {
      final result = await endpoints.label
          .getLabelsForBoard(sessionBuilder, board.id!, userToken);

      expect(result, isNotEmpty);
      expect(result.length, equals(1));
    });

    test('updateLabel', () async {
      final session = sessionBuilder.build();

      final updated = await endpoints.label.updateLabel(
          sessionBuilder, label.id!, userToken,
          newTitle: 'updatedLabel', newColor: '#00FF00');

      final db = await Label.db.findFirstRow(
        session,
        where: (p0) =>
            p0.board.equals(board.id) &
            p0.title.equals(updated.title) &
            p0.color.equals(updated.color),
      );
      expect(db, isNotNull);
      expect(db?.title, equals(updated.title));
      expect(db?.color, equals(updated.color));
    });

    test('deleteLabel', () async {
      final session = sessionBuilder.build();

      await endpoints.label.deleteLabel(sessionBuilder, label.id!, userToken);

      final db = await Label.db.findById(session, label.id!);

      expect(db, isNull);
    });
  });
}
