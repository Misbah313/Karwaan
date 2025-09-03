import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('ChecklistEndpoint', (sessionBuilder, endpoints) {
    late User user;
    late Workspace workspace;
    late Board board;
    late BoardList list;
    late BoardCard card;
    late CheckList checkList;
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

      // create the label
      label = Label(
          title: 'userLabel',
          color: '0XFF303030',
          board: board.id!,
          createdBy: user.id!);
      final insertedLabel = await Label.db.insertRow(session, label);
      label.id = insertedLabel.id;

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

      // create checklist
      checkList = CheckList(
          title: 'Checklist',
          card: card.id!,
          createdAt: DateTime.now(),
          createdBy: user.id!);
      final insertedChecklist =
          await CheckList.db.insertRow(session, checkList);
      checkList.id = insertedChecklist.id;
    });

    test('createChecklist', () async {
      final session = sessionBuilder.build();

      final created = await endpoints.checklist
          .createChecklist(sessionBuilder, card.id!, 'newChecklist', userToken);

      final db = await CheckList.db.findFirstRow(
        session,
        where: (p0) =>
            p0.card.equals(card.id) &
            p0.title.equals(created.title) &
            p0.id.equals(created.id),
      );

      expect(db, isNotNull);
    });

    test('listChecklist', () async {
      final result = await endpoints.checklist
          .listChecklist(sessionBuilder, card.id!, userToken);

      expect(result, isNotEmpty);
      expect(result.length, equals(1));
    });

    test('updateChecklist', () async {
      final session = sessionBuilder.build();

      final result = await endpoints.checklist.updateChecklist(
          sessionBuilder, checkList.id!, 'updateChecklist', userToken);

      final db = await CheckList.db.findFirstRow(
        session,
        where: (p0) => p0.card.equals(card.id) & p0.title.equals(result.title),
      );

      expect(db, isNotNull);
      expect(db?.title, equals(result.title));
    });

    test('deleteChecklist', () async {
      final session = sessionBuilder.build();

      await endpoints.checklist
          .deleteChecklist(sessionBuilder, checkList.id!, userToken);

      final db = await CheckList.db.findFirstRow(
        session,
        where: (p0) => p0.card.equals(card.id) & p0.id.equals(checkList.id),
      );

      expect(db, isNull);
    });
  });
}
