import 'package:karwaan_server/src/endpoints/role_check.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('boardListEndpoint', (sessionbuilder, endpoints) {
    late User user;
    late Workspace workspace;
    late Board board;
    late BoardList list;
    late String userToken;

    setUp(() async {
      final session = sessionbuilder.build();

      // create the user
      user = User(name: 'user', email: 'user@gmail.com', password: 'user123');
      final insertedUser = await User.db.insertRow(session, user);
      user.id = insertedUser.id;

      // create the parent workspace
      workspace = Workspace(
          name: 'Workspace',
          description: 'Wdec',
          createdAt: DateTime.now(),
          ownerId: user.id!);
      final insertedWorkspace =
          await Workspace.db.insertRow(session, workspace);
      workspace.id = insertedWorkspace.id;

      await WorkspaceMember.db.insertRow(
          session,
          WorkspaceMember(
              user: user.id!,
              workspace: workspace.id!,
              joinedAt: DateTime.now()));

      // create the parent board
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
              user: user.id!, board: board.id!, joinedAt: DateTime.now(), role: Roles.owner));

      // create the user token
      userToken = 'user-token';
      await UserToken.db.insertRow(
          session,
          UserToken(
              userId: user.id!,
              token: userToken,
              createdAt: DateTime.now(),
              expiresAt: DateTime.now().add(Duration(days: 1))));

      // create the list now
      list = BoardList(
          board: board.id!,
          title: 'List1',
          createdAt: DateTime.now(),
          createdBy: user.id!);
      final insertedList = await BoardList.db.insertRow(session, list);
      list.id = insertedList.id;
    });

    test('createBoardList', () async {
      final session = sessionbuilder.build();
      final list1 = await endpoints.boardList
          .createBoardList(sessionbuilder, board.id!, userToken, 'list2');

      final db = await BoardList.db.findFirstRow(
        session,
        where: (p0) => p0.board.equals(board.id) & p0.id.equals(list1.id),
      );

      expect(db, isNotNull);
    });

    test('listBoardList', () async {
      final result = await endpoints.boardList
          .listBoardLists(sessionbuilder, board.id!, userToken);

      expect(result, isNotEmpty);
      expect(result.length, equals(1));
    });

    test('updateBoardList', () async {
      final session = sessionbuilder.build();
      final result = await endpoints.boardList
          .updateBoardList(sessionbuilder, list.id!, userToken, 'card2');

      final db = await BoardList.db.findFirstRow(
        session,
        where: (p0) =>
            p0.board.equals(board.id) & p0.title.equals(result.title),
      );

      expect(db?.board, equals(board.id));
      expect(db?.title, equals('card2'));
    });

    test('deleteBoardList', () async {
      final session = sessionbuilder.build();

      await endpoints.boardList
          .deleteBoardList(sessionbuilder, list.id!, userToken);

      final db = await BoardList.db.findFirstRow(
        session,
        where: (p0) => p0.board.equals(board.id) & p0.id.equals(list.id),
      );

      expect(db, isNull);
    });
  });
}
