import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('CommentEndpoint', (sessionBuilder, endpoints) {
    late User user;
    late Workspace workspace;
    late Board board;
    late BoardList list;
    late BoardCard card;
    late Comment comment;
    late Comment comment2;
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

      // create comment1
      comment = Comment(
          card: card.id!,
          author: user.id!,
          content: 'Commment 1 by user1',
          createdAt: DateTime.now());
      final insertedComment = await Comment.db.insertRow(session, comment);
      comment.id = insertedComment.id;

      // create comment1
      comment2 = Comment(
          card: card.id!,
          author: user.id!,
          content: 'Commment 2 by user1',
          createdAt: DateTime.now());
      final insertedComment2 = await Comment.db.insertRow(session, comment2);
      comment2.id = insertedComment2.id;
    });

    test('createComment', () async {
      final session = sessionBuilder.build();

      final newComment = await endpoints.comment.createComment(
          sessionBuilder, userToken, card.id!, 'Comment 2 by user 2');

      final db = await Comment.db.findFirstRow(
        session,
        where: (p0) => p0.card.equals(card.id) & p0.id.equals(newComment.id),
      );

      expect(db, isNotNull);
      expect(db?.author, equals(user.id));
    });

    test('getCommentsForCard', () async {
      await endpoints.comment.createComment(
          sessionBuilder, userToken, card.id!, 'Comment 3 by user 3');

      final commmets = await endpoints.comment
          .getCommentsForCard(sessionBuilder, card.id!, userToken);

      expect(commmets, isNotEmpty);
      expect(commmets.length, equals(2));
    });

    test('updateComment', () async {
      final session = sessionBuilder.build();

      final updated = await endpoints.comment.updateComment(
          sessionBuilder, comment.id!, 'updatedComment 1', userToken);

      expect(updated.card, equals(card.id));
      expect(updated.content, equals('updatedComment 1'));

      final db = await Comment.db.findFirstRow(
        session,
        where: (p0) =>
            p0.card.equals(card.id) &
            p0.id.equals(comment.id) &
            p0.content.equals('updatedComment 1'),
      );

      expect(db, isNotNull);
    });

    test('deleteComment', () async {
      final session = sessionBuilder.build();

      await endpoints.comment
          .deleteComment(sessionBuilder, comment.id!, userToken);

      final db = await Comment.db.findFirstRow(
        session,
        where: (p0) => p0.card.equals(card.id) & p0.id.equals(comment.id),
      );

      final db2 = await Comment.db.findFirstRow(session,
          where: (p0) => p0.card.equals(card.id) & p0.id.equals(comment2.id));

      expect(db, isNull);
      expect(db2, isNotNull);
    });
  });
}
