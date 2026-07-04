import 'package:karwaan_flutter/domain/models/board/board.dart';
import 'package:karwaan_flutter/domain/models/board/board_analytics.dart';
import 'package:karwaan_flutter/domain/models/board/board_credentials.dart';
import 'package:karwaan_flutter/domain/models/board/board_details.dart';
import 'package:karwaan_flutter/domain/models/board/board_member.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_change_role_model.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_credentails.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';
import 'package:karwaan_flutter/domain/models/board/board_wrapper.dart';
import 'package:karwaan_flutter/domain/models/board/create_board_credentials.dart';
import 'package:karwaan_flutter/domain/models/board/overall_analytics.dart';

abstract class BoardRepo {
  Future<Board> createBoard(CreateBoardCredentials credentials);
  Future<List<Board>> getUserBoards();
  Future<Board> updateBoard(BoardCredentials credentials);
  Future<bool> deleteBoard(int boardId);
  Future<List<BoardDetails>> getBoardsByWorkspace(int workspaceId);
  Future<BoardMember> addMemberToBoard(BoardMemberCredentails credentails);
  Future<void> removeMemberFromBoard(BoardMemberCredentails credentails);
  Future<List<BoardMemberDetails>> getBoardMembers(int boardId);
  Future<BoardMember> changeBoardMemberRole(BoardMemberChangeRoleModel change);
  Future<void> leaveBoard(int boardId);
  Future<void> trackRecentBoard(int boardId);
  Future<List<Board>> getUserRecentBoards();
  Future<BoardAnalytics> getBoardAnalytics(int boardId);
  Future<List<BoardAnalytics>> getAnalyticsForMultiBoards(List<int> boardIds);
  Future<OverallAnalytics> getOverAllAnalytics();
  Future<void> pinBoard(int boardId);
  Future<void> unpinBoard(int boardId);
  Future<List<BoardWrapper>> getPinnedBoards();
  Future<bool> isBoardPinned(int baordId);
}
