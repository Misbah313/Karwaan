import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class RecenBoardEndpoint extends Endpoint {
  // track access
  Future<void> trackBoardAccess(
      Session session, int boardId, String token) async {
    // get the current user
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid ID!');
    }

    // membership check
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (p0) => p0.board.equals(boardId) & p0.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not a member of this board!');
    }

    try {
      final existing = await UserRecentBoards.db.findFirstRow(session,
          where: (p0) =>
              p0.userId.equals(currentUser.id!) & p0.boardId.equals(boardId));
      if (existing != null) {
        existing.lastAccess = DateTime.now();
        await UserRecentBoards.db.updateRow(session, existing);
      } else {
        final recentBoard = UserRecentBoards(
            userId: currentUser.id!,
            boardId: boardId,
            lastAccess: DateTime.now());
        await UserRecentBoards.db.insertRow(session, recentBoard);
      }
    } catch (e) {
      throw RandomAppException(message: 'Failed to track recent board access');
    }
  }

  // recent boards
  Future<List<Board>> getRecentBoards(Session session, String token,
      {int limit = 2}) async {
    // get the current user
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'NO user or invalid id');
    }
    try {
      final recentBoards = await UserRecentBoards.db.find(session,
          where: (p0) => p0.userId.equals(currentUser.id!),
          orderBy: (m) => m.lastAccess,
          orderDescending: true,
          limit: limit);

      if (recentBoards.isEmpty) return [];

      final boardIds = recentBoards.map((m) => m.boardId).toSet();
      final boards = await Board.db.find(
        session,
        where: (p0) => p0.id.inSet(boardIds),
      );
      return boards;
    } catch (e) {
      return [];
    }
  }
}
