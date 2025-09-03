import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('CardLabelEndpoint', (sessionBuilder, endpoints) {
    late User user;
    late Workspace workspace;
    late Board board;
    late BoardList list;
    late BoardCard card;
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
    });

    test('assignLabelToCard', () async {
      final session = sessionBuilder.build();

      final assign = await endpoints.cardLabel
          .assignLableToCard(sessionBuilder, label.id!, card.id!, userToken);

      final db = await CardLabel.db.findFirstRow(
        session,
        where: (p0) => p0.card.equals(card.id) & p0.label.equals(label.id),
      );

      expect(db, isNotNull);
      expect(assign.card, equals(card.id));
      expect(assign.label, equals(label.id));
    });

    test('removeLabelFromCard', () async {
      final session = sessionBuilder.build();

      await endpoints.cardLabel
          .assignLableToCard(sessionBuilder, label.id!, card.id!, userToken);

      await endpoints.cardLabel
          .removeLabelFromCard(sessionBuilder, card.id!, label.id!, userToken);

      final db = await CardLabel.db.findFirstRow(
        session,
        where: (p0) => p0.card.equals(card.id) & p0.label.equals(label.id),
      );

      expect(db?.label, isNull);
    });

    test('getLabelForCard', () async {
      await endpoints.cardLabel
          .assignLableToCard(sessionBuilder, label.id!, card.id!, userToken);
      final result = await endpoints.cardLabel
          .getLabelForCard(sessionBuilder, card.id!, userToken);

      expect(result, isNotEmpty);
      expect(result.length, equals(1));    
    });

    test('getCardForLabel', () async{

      await endpoints.cardLabel.assignLableToCard(sessionBuilder, label.id!, card.id!, userToken);

      final result = await endpoints.cardLabel.getCardForLabel(sessionBuilder, label.id!, userToken);

      expect(result, isNotEmpty);
      expect(result.length, equals(1));
    });
  });
}
