import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('AttachmentEndpoint', (sessionBuilder, endpoints) {
    late User user;
    late Workspace workspace;
    late Board board;
    late BoardList boardList;
    late BoardCard card;
    late Attachment attachment;
    late String fileName;
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
          description: 'dec',
          workspaceId: workspace.id!,
          createdBy: user.id!,
          createdAt: DateTime.now());
      final insertedBoard = await Board.db.insertRow(session, board);
      board.id = insertedBoard.id;

      await BoardMember.db.insertRow(
          session,
          BoardMember(
              user: user.id!, board: board.id!, joinedAt: DateTime.now()));

      // create parent boardlist
      boardList = BoardList(
          board: board.id!,
          title: 'List',
          createdAt: DateTime.now(),
          createdBy: user.id!);
      final insertedBoardList =
          await BoardList.db.insertRow(session, boardList);
      boardList.id = insertedBoardList.id;

      // create parent card
      card = BoardCard(
          title: 'Card',
          createdBy: user.id!,
          list: boardList.id!,
          createdAt: DateTime.now(),
          isCompleted: false);
      final insertedCard = await BoardCard.db.insertRow(session, card);
      card.id = insertedCard.id;

      // file name
      fileName = 'FileName';

      // user Token
      userToken = 'user-token';
      await UserToken.db.insertRow(
          session,
          UserToken(
              userId: user.id!,
              token: userToken,
              createdAt: DateTime.now(),
              expiresAt: DateTime.now().add(Duration(days: 1))));

      // create attachment
      attachment =
          Attachment(card: card.id!, uploadedBy: user.id!, fileName: fileName);
      final insertedAttachment =
          await Attachment.db.insertRow(session, attachment);
      attachment.id = insertedAttachment.id;
    });

    test('uploadAttachment', () async {
      String newFile = 'newFile';

      final result = await endpoints.attachment
          .uploadAttachment(sessionBuilder, card.id!, newFile, userToken);

      expect(result.card, equals(card.id));
      expect(result.fileName, equals('newFile'));
      expect(result.uploadedBy, equals(user.id));
    });

    test('listAttachments', () async {
      // fileName 1
      String file1 = 'file1';

      // fileName 2
      String file2 = 'file2';

      // upload attachment 1
      await endpoints.attachment
          .uploadAttachment(sessionBuilder, card.id!, file1, userToken);

      // upload attachment 2
      await endpoints.attachment
          .uploadAttachment(sessionBuilder, card.id!, file2, userToken);

      // list the attachements
      final list = await endpoints.attachment
          .listAttachments(sessionBuilder, card.id!, userToken);

      expect(list, isNotEmpty);
      expect(list.length, equals(3));
    });

    test('deleteAttachment', () async {
      final session = sessionBuilder.build();
      await endpoints.attachment
          .deleteAttachment(sessionBuilder, attachment.id!, userToken);

      // check the db
      final db = await Attachment.db.findFirstRow(
        session,
        where: (p0) => p0.card.equals(card.id) & p0.fileName.equals(fileName),
      );

      expect(db, isNull);
    });
  });
}
