import 'package:flutter/widgets.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardlist/create_board_list_credentails.dart';
import 'package:karwaan_flutter/domain/repository/boardlist/boardlist_repo.dart';

class BoardlistRemoteRepo extends BoardlistRepo {
  final ServerpodClientService _clientService;

  BoardlistRemoteRepo(this._clientService);

  @override
  Future<Boardlist> createBoardList(
      CreateBoardListCredentails credentails) async {
    try {
      final create = await _clientService.createBoardList(
          credentails.boardListId, credentails.boardListName);
      debugPrint('Received boardlist: ${create.id}');
      if(create.id == null) {
        throw Exception('Server returned null id!');
      }
      return Boardlist(
          id: create.id!,
          boardlistTitle: create.title,
          createdAt: create.createdAt);
    } catch (e) {
      debugPrint('Creation failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Boardlist>> listBoardLists(int boardId) async {
    try {
      final list = await _clientService.listBoardLists(boardId);
      return list
          .map(
            (e) => Boardlist(
                id: e.id!, boardlistTitle: e.title, createdAt: e.createdAt),
          )
          .toList();
    } catch (e) {
      debugPrint('listing boardlist failed from remote repo : ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<Boardlist> updateBoardList(BoardlistCredentails credentails) async {
    try {
      final updated = await _clientService.updateBoardList(
          credentails.id, credentails.newTitle);
      return Boardlist(
          id: updated.id!,
          boardlistTitle: updated.title,
          createdAt: updated.createdAt);
    } catch (e) {
      debugPrint('Failed to update from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<bool> deleteBoardList(int listId) async {
    try {
      return await _clientService.deleteBoardList(listId);
    } catch (e) {
      debugPrint('Failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }
}
