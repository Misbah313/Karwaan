import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('BoardCardEndpoint', (sessionBuilder, endpoints) {
    late User user;
    late Workspace workspace;
    late Board board;
    late BoardList list;
    late BoardCard card;
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

      // create the parent boardlist
      list = BoardList(
          board: board.id!,
          title: 'List',
          createdAt: DateTime.now(),
          createdBy: user.id!);
      final insertedlist = await BoardList.db.insertRow(session, list);
      list.id = insertedlist.id;

      // create the user token
      userToken = 'user-token';
      await UserToken.db.insertRow(
          session,
          UserToken(
              userId: user.id!,
              token: userToken,
              createdAt: DateTime.now(),
              expiresAt: DateTime.now().add(Duration(days: 1))));

      // create the card
      card = BoardCard(
          title: 'Card',
          createdBy: user.id!,
          list: list.id!,
          createdAt: DateTime.now(),
          isCompleted: false);
      final insertedCard = await BoardCard.db.insertRow(session, card);
      card.id = insertedCard.id;
    });

    test('createBoardCard', () async {
      final session = sessionBuilder.build();

      final card = await endpoints.boardCard
          .createBoardCard(sessionBuilder, list.id!, userToken, 'NewCard');

      // check the db to make sure the card created
      final db = await BoardCard.db.findFirstRow(
        session,
        where: (p0) =>
            p0.list.equals(list.id) &
            p0.title.equals(card.title) &
            p0.createdBy.equals(user.id),
      );

      expect(db, isNotNull);
    });

    test('getlistByCard', () async {
      await endpoints.boardCard
          .createBoardCard(sessionBuilder, list.id!, userToken, 'Card1');

      // get the list cards
      final result = await endpoints.boardCard
          .getListByBoardCard(sessionBuilder, list.id!, userToken);

      expect(result, isNotEmpty);
      expect(result.length, equals(2));
    });

    test('updateBoardCard', () async {
      final session = sessionBuilder.build();
      final result = await endpoints.boardCard.updateBoardCard(
          sessionBuilder, card.id!, userToken, 'updatedCard', '', true);

      final db = await BoardCard.db.findFirstRow(session,
          where: (p0) =>
              p0.list.equals(list.id) &
              p0.id.equals(result.id) &
              p0.title.equals(result.title) &
              p0.isCompleted.equals(result.isCompleted));

      expect(db, isNotNull);
    });

    test('deleteBoardCard', () async {
      final session = sessionBuilder.build();

       await endpoints.boardCard
          .deleteBoardCard(sessionBuilder, card.id!, userToken);

      final db = await BoardCard.db.findFirstRow(
        session,
        where: (p0) => p0.list.equals(list.id) & p0.id.equals(card.id),
      );

      expect(db, isNull);
    });
  });
}
