import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_assignment.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardcard/create_board_card_credentails.dart';

abstract class BoardcardRepo {
  Future<BoardCard> createBoardCard(CreateBoardCardCredentails credentails);
  Future<List<BoardCard>> getListByBoardCard(int boardlistId);
  Future<List<BoardCard>> getAllUserCards();
  Future<BoardCard> updateBoardCard(BoardCardCredentails credentails);
  Future<bool> deleteBoardCard(int cardId);

  
  Future<List<BoardCardAssignment>> assignUsersToCard(
      int cardId, List<int> userIds);
  Future<bool> removeUsersFromCard(int cardId, List<int> userIds);
  Future<List<AuthUser>> getCardAssignees(int cardId);
  Future<List<BoardCard>> getMyAssignedCards();
}
