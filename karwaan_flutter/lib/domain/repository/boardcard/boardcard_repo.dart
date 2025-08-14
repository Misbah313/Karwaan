import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardcard/create_board_card_credentails.dart';

abstract class BoardcardRepo {
  Future<BoardCard> createBoardCard(CreateBoardCardCredentails credentails);
  Future<List<BoardCard>> getListByBoardCard(int boardlistId);
  Future<BoardCard> updateBoardCard(BoardCardCredentails credentails);
  Future<bool> deleteBoardCard(int cardId);
}
