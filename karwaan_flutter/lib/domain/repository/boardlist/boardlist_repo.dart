import 'package:karwaan_flutter/domain/models/boardlist/boardlist.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardlist/create_board_list_credentails.dart';

abstract class BoardlistRepo {
  Future<Boardlist> createBoardList(CreateBoardListCredentails credentails);
  Future<List<Boardlist>> listBoardLists(int boardId);
  Future<Boardlist> updateBoardList(BoardlistCredentails credentails);
  Future<bool> deleteBoardList(int listId);
}
