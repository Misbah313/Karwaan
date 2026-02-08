import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class AnalyticsEndpoint extends Endpoint {
  // Get board analytics
  Future<BoardAnalytics> getBoardAnalytics(
      Session session, int boardId, String token) async {
    // get the current user
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid ID!');
    }

    // check current user board membership
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (p0) => p0.board.equals(boardId) & p0.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not a member of this board!');
    }

    try {
      // fetch the board by id to access its name
      final board = await Board.db.findById(session, boardId);
      final String? fetchedBoardName = board?.name;
      // get all boardlist in this board
      final boardlist = await BoardList.db.find(
        session,
        where: (p0) => p0.board.equals(boardId),
      );
      if (boardlist.isEmpty) {
        return BoardAnalytics(
            boardId: boardId,
            boardName: fetchedBoardName,
            totalCards: 0,
            completedCards: 0,
            completionPercentage: 0.0,
            lastUpdate: DateTime.now());
      }

      // get all boardCards across all boardlist in this board
      final listIds = boardlist.map((l) => l.id!).toSet();
      final boardCards = await BoardCard.db
          .find(session, where: (p0) => p0.list.inSet(listIds));

      // calculate analytics
      final totalCards = boardCards.length;
      final completedTasks = boardCards.where((c) => c.isCompleted).length;
      final completionPercentages =
          totalCards > 0 ? (completedTasks / totalCards) * 100 : 0.0;

      // calculate card perList
      final cardPerList = <String, int>{};
      for (final list in boardlist) {
        final listCard = boardCards.where((l) => l.list == list.id).length;
        cardPerList[list.title] = listCard;
      }

      // return the analytics
      return BoardAnalytics(
          boardId: boardId,
          boardName: fetchedBoardName,
          totalCards: totalCards,
          completedCards: completedTasks,
          completionPercentage: completionPercentages,
          lastUpdate: DateTime.now(),
          cardPerList: cardPerList);
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message:
              'Failed to create get the board analytics. Please try again.');
    }
  }

  // get analytics for multiple boards(for dashboard boards)
  Future<List<BoardAnalytics>> getAnalyticsForMultiBoards(Session session,
      List<int> boardIds, String token) async {
    // get the current user
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or Invalid ID!');
    }

    final results = <BoardAnalytics>[];
    
    for (final boardId in boardIds) {
      try {
        final analytics =
            await getBoardAnalytics(session, boardId, token);
        results.add(analytics);
      } catch (e) {
        // Skip failed boards but continue with others
        session.log('Failed to get analytics for board $boardId: $e');
      }
    }

    return results;
  }

  // Overall analytics
  Future<OverAllAnalytics> getOverAllAnalytics(
      Session session, String token) async {
    // get the current user
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'Invalid user or expired token!');
    }

    // get all worksapce user is a member of
    try {
      final worksapceMembership = await WorkspaceMember.db.find(
        session,
        where: (p0) => p0.user.equals(currentUser.id),
      );
      if (worksapceMembership.isEmpty) {
        return OverAllAnalytics(
            userId: currentUser.id!,
            totalBoard: 0,
            totalCard: 0,
            completedCards: 0,
            completionPercentage: 0.0,
            lastUpdate: DateTime.now());
      }

      final worksapceIds = worksapceMembership.map((i) => i.workspace).toSet();

      // get all boards in this workspace
      final boards = await Board.db.find(
        session,
        where: (p0) => p0.workspaceId.inSet(worksapceIds),
      );

      if (boards.isEmpty) {
        return OverAllAnalytics(
            userId: currentUser.id!,
            totalBoard: 0,
            totalCard: 0,
            completedCards: 0,
            completionPercentage: 0.0,
            lastUpdate: DateTime.now());
      }

      final boardIds = boards.map((i) => i.id!).toSet();

      // get all list in these boards
      final boardlists = await BoardList.db.find(
        session,
        where: (p0) => p0.board.inSet(boardIds),
      );

      if (boardlists.isEmpty) {
        return OverAllAnalytics(
            userId: currentUser.id!,
            totalBoard: boards.length,
            totalCard: 0,
            completedCards: 0,
            completionPercentage: 0.0,
            lastUpdate: DateTime.now());
      }

      final listIds = boardlists.map((i) => i.id!).toSet();

      // Get all cards accorss all workspaces
      final allCards = await BoardCard.db.find(
        session,
        where: (p0) => p0.list.inSet(listIds),
      );

      // calculate overall analytics
      final totalCards = allCards.length;
      final completedCards = allCards.where((i) => i.isCompleted).length;
      final completionPercentage =
          totalCards > 0 ? (completedCards / totalCards) * 100 : 0.0;

      // calculate cards per workspace
      final cardPerWorkspace = <String, int>{};
      final cardsPerStatus = <String, int>{
        'completed': completedCards,
        'pending': totalCards - completedCards,
      };

      for (final workspaceId in worksapceIds) {
        final workspace = await Workspace.db.findById(session, workspaceId);
        if (workspace != null) {
          // get boards in this workspace
          final workspaceBoards =
              boards.where((o) => o.workspaceId == workspaceId);
          final workspaceBoardIds = workspaceBoards.map((i) => i.id!).toSet();

          // get lists in these boards
          final workspaceLists =
              boardlists.where((e) => workspaceBoardIds.contains(e.board));
          final workspaceListIds = workspaceLists.map((e) => e.id!).toSet();

          // count cards in this workspace
          final workspaceCards =
              allCards.where((e) => workspaceListIds.contains(e.list)).length;
          cardPerWorkspace[workspace.name] = workspaceCards;
        }
      }

      return OverAllAnalytics(
          userId: currentUser.id!,
          totalBoard: boards.length,
          totalCard: totalCards,
          completedCards: completedCards,
          completionPercentage: completionPercentage,
          cardsPerWorkspace: cardPerWorkspace,
          cardsPerStatus: cardsPerStatus,
          lastUpdate: DateTime.now());
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message:
              'Failed to create get the overall analytics. Please try again.');
    }
  }
}
