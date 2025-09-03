import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('checklistItemEndpoint', (sessionBuilder, endpoints) {
    late User user;
    late Workspace workspace;
    late Board board;
    late BoardList list;
    late BoardCard card;
    late CheckList checkList;
    late CheckListItem checkListItem;
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

      // create checklist item
      checkListItem = CheckListItem(
          checklist: checkList.id!,
          content: 'Item1',
          isDone: false,
          createdBy: user.id!);
      final insertedChecklistItem =
          await CheckListItem.db.insertRow(session, checkListItem);
      checkListItem.id = insertedChecklistItem.id;
    });

    test('createChecklistItem', () async {
      final session = sessionBuilder.build();

      final result = await endpoints.checklistItem.createChecklistItem(
          sessionBuilder, checkList.id!, 'Item2', userToken);

      final db = await CheckListItem.db.findFirstRow(
        session,
        where: (p0) =>
            p0.checklist.equals(checkList.id) &
            p0.content.equals(result.content),
      );

      expect(db, isNotNull);
    });

    test('listChecklistItem', () async {
      await endpoints.checklistItem.createChecklistItem(
          sessionBuilder, checkList.id!, 'Item3', userToken);

      final result = await endpoints.checklistItem
          .listChecklistItems(sessionBuilder, checkList.id!, userToken);

      expect(result, isNotEmpty);
      expect(result.length, equals(2));
    });

    test('updateChecklistItem', () async {
      final session = sessionBuilder.build();

      final updated = await endpoints.checklistItem.updateChecklistItem(
          sessionBuilder,
          checkListItem.id!,
          checkList.id!,
          'UpdatedItem',
          userToken);

      final db = await CheckListItem.db.findFirstRow(
        session,
        where: (p0) =>
            p0.checklist.equals(checkList.id) &
            p0.content.equals(updated.content),
      );

      expect(db, isNotNull);
    });

    test('toggleChecklistItem', () async {
      final session = sessionBuilder.build();

      await endpoints.checklistItem.toggleChecklistItemStatus(
          sessionBuilder, checkListItem.id!, userToken);

      final db = await CheckListItem.db.findFirstRow(
        session,
        where: (p0) =>
            p0.checklist.equals(checkList.id) & p0.isDone.equals(true),
      );

      expect(db?.id, equals(checkListItem.id));
      expect(db, isNotNull);
    });

    test('deleteChecklistItem', () async {
      final session = sessionBuilder.build();

      await endpoints.checklistItem
          .deleteChecklistItem(sessionBuilder, checkListItem.id!, userToken);

      final db = await CheckListItem.db.findFirstRow(session,
          where: (p0) => p0.checklist.equals(checkList.id));

      expect(db, isNull);
    });
  });
}
