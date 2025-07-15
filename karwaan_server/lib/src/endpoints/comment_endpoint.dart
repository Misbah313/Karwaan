import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class CommentEndpoint extends Endpoint {
  // create comment on card
  Future<Comment> createComment(
      Session session, String token, int cardId, String content) async {
    // validate token(Get the current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // check if the card id (the comment want be add to) exists
    final card = await Card.db.findById(session, cardId);
    if (card == null) {
      throw Exception('No card found!');
    }

    // get the board which the card belong to
    final boardList = await BoardList.db
        .findFirstRow(session, where: (b) => b.board.equals(card.list));
    if (boardList == null) {
      throw Exception('No parent board found!');
    }

    final board = await Board.db.findById(session, boardList.board);
    if (board == null) {
      throw Exception('Board not found!');
    }

    // check board access for the current user
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (b) => b.board.equals(board.id) & b.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw Exception('You are not a member of the parent board!');
    }

    try {
      // validate comment content
      final trimmedContent = content.trim();
      if (trimmedContent.isEmpty) {
        throw Exception('Comment message cannot be empty!');
      }

      final comment = Comment(
          card: card.id!,
          author: currentUser.id!,
          content: trimmedContent,
          createdAt: DateTime.now());

      await Comment.db.insertRow(session, comment);
      return comment;
    } catch (e) {
      throw Exception(e);
    }
  }

  // get comment for card
  Future<List<Comment>> getCommentsForCard(
      Session session, int cardId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // card the parent card existence
    final card = await Card.db.findById(session, cardId);
    if (card == null) {
      throw Exception('Card not found!');
    }

    // get parent board info(boardlist and board)
    final boardList = await BoardList.db.findFirstRow(
      session,
      where: (b) => b.board.equals(card.list),
    );
    if (boardList == null) {
      throw Exception('BoardList not found!');
    }

    final board = await Board.db.findById(session, boardList.board);
    if (board == null) {
      throw Exception('Parent board not found!');
    }

    // check current user membership
    final memberShip = await BoardMember.db.findFirstRow(
      session,
      where: (b) => b.board.equals(board.id) & b.user.equals(currentUser.id!),
    );
    if (memberShip == null) {
      throw Exception('You are not a member in the parent board!');
    }

    try {
      // fetch comments
      final comments = await Comment.db.find(
        session,
        where: (c) => c.card.equals(cardId),
        orderBy: (c) => c.createdAt,
      );

      return comments;
    } catch (e) {
      throw Exception(e);
    }
  }

  // update comment
  Future<Comment> updateComment(
      Session session, int commentId, String newContent, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // find the comment
    final comment = await Comment.db.findById(session, commentId);
    if (comment == null) {
      throw Exception('No comment found!');
    }

    // check the current user is owner/admin or the comment creator
    if (comment.author != currentUser.id) {
      throw Exception('Only the comment creator can update a comment!');
    }

    try {
      // validate new content
      final trimmedContent = newContent.trim();
      if (trimmedContent.isEmpty) {
        throw Exception('Comment message cannot be empty');
      }

      // update the comment
      comment.content = trimmedContent;

      await Comment.db.updateRow(session, comment);
      return comment;
    } catch (e) {
      throw Exception(e);
    }
  }

  // delete comment
  Future<bool> deleteComment(
      Session session, int commentId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // fetch the comment
    final comment = await Comment.db.findById(session, commentId);
    if (comment == null) {
      throw Exception('Comment not found!');
    }

    // user role check
    final card = await Card.db.findById(session, comment.card);
    if (card == null) {
      throw Exception('Card not found');
    }
    final boardList = await BoardList.db.findFirstRow(
      session,
      where: (b) => b.board.equals(card.list),
    );
    if (boardList == null) {
      throw Exception('BoardList not found!');
    }

    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (m) =>
          m.board.equals(boardList.board) & m.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw Exception('You are not member of the parent board!');
    }

    try {
      final isOwnerOrAdmin =
          membership.role == 'Owner' || membership.role == 'Admin';

      final isCommentAuthor = comment.author == currentUser.id!;

      if (!isOwnerOrAdmin && !isCommentAuthor) {
        throw Exception(
            'Only owners, admins, or the comment creator can delete this comment.');
      }

      // delete comment
      await Comment.db.deleteRow(session, comment);
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
}


 /*

  Add later:

    - pin comment()

    - react to comment
 */