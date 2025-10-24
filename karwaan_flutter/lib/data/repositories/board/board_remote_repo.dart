import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/domain/models/board/board.dart';
import 'package:karwaan_flutter/domain/models/board/board_analytics.dart';
import 'package:karwaan_flutter/domain/models/board/board_credentials.dart';
import 'package:karwaan_flutter/domain/models/board/board_details.dart';
import 'package:karwaan_flutter/domain/models/board/board_member.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_change_role_model.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_credentails.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';
import 'package:karwaan_flutter/domain/models/board/create_board_credentials.dart';
import 'package:karwaan_flutter/domain/models/board/overall_analytics.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';

class BoardRemoteRepo extends BoardRepo {
  final ServerpodClientService _clientService;

  BoardRemoteRepo(this._clientService);

  @override
  Future<Board> createBoard(CreateBoardCredentials credentials) async {
    try {
      debugPrint('Starting creating board from remote repo!');
      final board = await _clientService.createBoard(credentials.workspaceId,
          credentials.boardName, credentials.boardDescription);
      debugPrint('Board created from remote repo by the name of ${board.name}');
      if (board.id == null) {
        throw Exception('Server returned null id for the board');
      }

      return Board(
          id: board.id!,
          boardName: board.name,
          boardDescription: board.description,
          createAt: board.createdAt);
    } catch (e) {
      debugPrint(' create Failed from board remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Board>> getUserBoards() async {
    try {
      final boards = await _clientService.getUserBoards();
      return boards
          .map(
            (e) => Board(
                id: e.id!,
                boardName: e.name,
                boardDescription: e.description!,
                createAt: e.createdAt),
          )
          .toList();
    } catch (e) {
      debugPrint(
          'get user boards Failed from board remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<Board> updateBoard(BoardCredentials credentials) async {
    try {
      final updatedBoard = await _clientService.updateBoard(
          credentials.id, credentials.boardName, credentials.boardDescription);
      return Board(
          id: updatedBoard.id!,
          boardName: updatedBoard.name,
          boardDescription: updatedBoard.description,
          createAt: updatedBoard.createdAt);
    } catch (e) {
      debugPrint('update board Failed from board remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<bool> deleteBoard(int boardId) async {
    try {
      await _clientService.deleteBoard(boardId);
      return true;
    } catch (e) {
      debugPrint('delete Failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<BoardDetails>> getBoardsByWorkspace(int workspaceId) async {
    try {
      final list = await _clientService.getBoardsByWorkspace(workspaceId);
      return list
          .map((e) => BoardDetails(
              id: e.id!,
              workspaceId: e.workspaceId,
              name: e.name,
              description: e.description!,
              createdAt: e.createdAt))
          .toList();
    } catch (e) {
      debugPrint(
          'get boards by workspace Failed from remote repo : ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<BoardMember> addMemberToBoard(
      BoardMemberCredentails credentails) async {
    try {
      final member = await _clientService.addMemberToBoard(
          credentails.boardId, credentails.userName);
      if (member.id == null) {
        throw Exception('Server return null id!!');
      }

      return BoardMember(
          id: member.id!, boardId: member.board, userId: member.user);
    } catch (e) {
      debugPrint(
          'Failed to add member to board from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> removeMemberFromBoard(BoardMemberCredentails credentails) async {
    try {
      await _clientService.removeMemberFromBoard(
          credentails.boardId, credentails.userId);
    } catch (e) {
      debugPrint(
          'Failed to remove user from board from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<BoardMemberDetails>> getBoardMembers(int boardId) async {
    try {
      final members = await _clientService.getBoardMembers(boardId);
      return members
          .map((e) => BoardMemberDetails(
              userId: e.userId,
              userName: e.userName,
              userEmail: e.email!,
              userRole: e.role,
              joinedAt: e.joinedAt))
          .toList();
    } catch (e) {
      debugPrint(
          'Failed to get board members from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<BoardMember> changeBoardMemberRole(
      BoardMemberChangeRoleModel change) async {
    try {
      final role = await _clientService.changeBoardMemberRole(
          change.boardId, change.targetUserId, change.newRole);
      return BoardMember(id: role.id!, boardId: role.board, userId: role.user);
    } catch (e) {
      debugPrint(
          'Failed ro change board member role from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> leaveBoard(int boardId) async {
    try {
      await _clientService.leaveBoard(boardId);
    } catch (e) {
      debugPrint('Leaving board from remote repo error: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> trackRecentBoard(int boardId) async {
    try {
      await _clientService.trackUserBoard(boardId);
    } catch (e) {
      debugPrint('Tracking board filled from remote');
      rethrow;
    }
  }

  @override
  Future<List<Board>> getUserRecentBoards() async {
    try {
      final boards = await _clientService.getUserRecentBoards();
      return boards
          .map((m) => Board(
              id: m.id!,
              boardName: m.name,
              boardDescription: m.description,
              createAt: m.createdAt))
          .toList(); // ← Add .toList() here
    } catch (e) {
      debugPrint('get user recent boards failed: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<BoardAnalytics> getBoardAnalytics(int boardId) async {
    try {
      final analytics = await _clientService.getBoardAnalytics(boardId);
      return BoardAnalytics(
          boardId: boardId,
          totalCards: analytics.totalCards,
          completedCards: analytics.completedCards,
          completionPercentage: analytics.completionPercentage,
          lastUpdate: analytics.lastUpdate);
    } catch (e) {
      debugPrint('analytics failed from remote: $e');
      rethrow;
    }
  }

  @override
  Future<List<BoardAnalytics>> getAnalyticsForMultiBoards(
      List<int> boardIds) async {
    try {
      final analyticsList =
          await _clientService.getAnalyticsForMultiBoards(boardIds);
      return analyticsList
          .map((analytics) => BoardAnalytics(
                boardId: analytics.boardId,
                totalCards: analytics.totalCards,
                completedCards: analytics.completedCards,
                completionPercentage: analytics.completionPercentage,
                cardPerList: analytics.cardPerList, // ADD THIS
                lastUpdate: analytics.lastUpdate,
              ))
          .toList();
    } catch (e) {
      debugPrint('get multi analytics failed from remote: $e');
      rethrow;
    }
  }

  @override
  Future<OverallAnalytics> getOverAllAnalytics() async {
    try {
      final overall = await _clientService.getOverAllAnalytics();
      return OverallAnalytics(
          userId: overall.userId,
          totalCards: overall.totalCard,
          totalBoard: overall.totalBoard,
          compeletedCards: overall.completedCards,
          completionPercentage: overall.completionPercentage,
          lastUpdate: overall.lastUpdate);
    } catch (e) {
      debugPrint('overall analytics failed from remote: $e');
      rethrow;
    }
  }
}
