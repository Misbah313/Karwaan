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
      throw AppAuthException(message: 'No user or invalid token!');
    }

    // check if the card id (the comment want be add to) exists
    final card = await BoardCard.db.findById(session, cardId);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }

    // get the board which the card belong to
    final boardList = await BoardList.db.findById(session, card.list);
    if (boardList == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }

    final board = await Board.db.findById(session, boardList.board);
    if (board == null) {
      throw AppNotFoundException(resourceType: 'Board');
    }

    // check board access for the current user
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (b) => b.board.equals(board.id) & b.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not a member of the parent board!');
    }

    try {
      // validate comment content
      final trimmedContent = content.trim();
      if (trimmedContent.isEmpty) {
        throw RandomAppException(message: 'Comment message cannot be empty!');
      }

      final comment = Comment(
          card: card.id!,
          author: currentUser.id!,
          content: trimmedContent,
          createdAt: DateTime.now());

      final inserted = await Comment.db.insertRow(session, comment);
      if (inserted.id == null) {
        throw RandomAppException(message: 'Comment id is null after creation!');
      }
      return inserted;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to create comment. Please try again.');
    }
  }

  // get comment for card
  Future<List<CommentWithAuthor>> getCommentsForCard(
      Session session, int cardId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token!');
    }

    // card the parent card existence
    final card = await BoardCard.db.findById(session, cardId);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }

    // get parent board info(boardlist and board)
    final boardList = await BoardList.db.findById(session, card.list);
    if (boardList == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }

    final board = await Board.db.findById(session, boardList.board);
    if (board == null) {
      throw AppNotFoundException(resourceType: 'Board');
    }

    // check current user membership
    final memberShip = await BoardMember.db.findFirstRow(
      session,
      where: (b) => b.board.equals(board.id) & b.user.equals(currentUser.id!),
    );
    if (memberShip == null) {
      throw AppPermissionException(
          message: 'You are not a member in the parent board!');
    }

    try {
      // fetch comments
      final comments = await Comment.db.find(
        session,
        where: (c) => c.card.equals(cardId),
        orderBy: (c) => c.createdAt,
      );

      // fecth author ids
      final authorIds = comments.map((c) => c.author).toSet();

      final authors = await User.db.find(
        session,
        where: (u) => u.id.inSet(authorIds),
      );
      final authorMap = {for (var u in authors) u.id!: u};

      // map comments to commentWithAuthor
      return comments.map((c) {
        final auhtor = authorMap[c.author];
        if (c.id == null) {
          throw RandomAppException(
              message: 'Comment id is null after creation');
        }
        return CommentWithAuthor(
            id: c.id!,
            card: c.card,
            authorId: c.author,
            authorName: auhtor?.name ?? 'Unknown',
            content: c.content,
            createdAt: c.createdAt);
      }).toList();
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(message: 'Failed to get comments. Please try again');
    }
  }

  // update comment
  Future<Comment> updateComment(
      Session session, int commentId, String newContent, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token!');
    }

    // find the comment
    final comment = await Comment.db.findById(session, commentId);
    if (comment == null) {
      throw AppNotFoundException(resourceType: 'Comment');
    }

    // check the current user is owner/admin or the comment creator
    if (comment.author != currentUser.id) {
      throw AppPermissionException(
          message: 'Only the comment creator can update a comment!');
    }

    try {
      // validate new content
      final trimmedContent = newContent.trim();
      if (trimmedContent.isEmpty) {
        throw RandomAppException(message: 'Comment message cannot be empty');
      }

      // update the comment
      comment.content = trimmedContent;

      await Comment.db.updateRow(session, comment);
      return comment;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to update comment. Please try again!');
    }
  }

  // delete comment
  Future<bool> deleteComment(
      Session session, int commentId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token!');
    }

    // fetch the comment
    final comment = await Comment.db.findById(session, commentId);
    if (comment == null) {
      throw AppNotFoundException(resourceType: 'Comment');
    }

    // user role check
    final card = await BoardCard.db.findById(session, comment.card);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }
    final boardList = await BoardList.db.findById(session, card.list);
    if (boardList == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }

    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (m) =>
          m.board.equals(boardList.board) & m.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not member of the parent board!');
    }

    try {
      final isOwnerOrAdmin =
          membership.role == 'Owner' || membership.role == 'Admin';

      final isCommentAuthor = comment.author == currentUser.id!;

      if (!isOwnerOrAdmin && !isCommentAuthor) {
        throw AppPermissionException(
            message:
                'Only owners, admins, or the comment creator can delete this comment.');
      }

      // delete comment
      await Comment.db.deleteRow(session, comment);
      return true;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to delete comment. Please try again!');
    }
  }
}


 /*

  Add later:

    - pin comment()

    - react to comment
 */