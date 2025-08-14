import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardcard/create_board_card_credentails.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';

class BoardCardRemoteRepo extends BoardcardRepo {
  final ServerpodClientService _clientService;

  BoardCardRemoteRepo(this._clientService);

  @override
  Future<BoardCard> createBoardCard(
      CreateBoardCardCredentails credentails) async {
    try {
      final create = await _clientService.createBoardCard(
          credentails.id, credentails.title, credentails.description);
      return BoardCard(
          id: create.id!,
          boardListId: create.list,
          title: create.title,
          description: create.description ?? '',
          createdAt: create.createdAt,
          isCompleted: create.isCompleted);
    } catch (e) {
      debugPrint(
          'Board card creation failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<BoardCard>> getListByBoardCard(int boardlistId) async {
    try {
      final list = await _clientService.getListByBoardCard(boardlistId);
      return list
          .map((e) => BoardCard(
              id: e.id!,
              boardListId: e.list,
              title: e.title,
              description: e.description ?? '',
              createdAt: e.createdAt,
              isCompleted: e.isCompleted))
          .toList();
    } catch (e) {
      debugPrint(
          'Board card fetching failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<BoardCard> updateBoardCard(BoardCardCredentails credentails) async {
    try {
      final update = await _clientService.updateBoardCard(credentails.cardId,
          credentails.newTitle, credentails.newDec, credentails.isCompleted);
      return BoardCard(
          id: update.id!,
          boardListId: update.list,
          title: update.title,
          description: update.description ?? '',
          createdAt: update.createdAt,
          isCompleted: update.isCompleted);
    } catch (e) {
      debugPrint(
          'Board card updating failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<bool> deleteBoardCard(int cardId) async {
    try {
      return await _clientService.deleteBoardCard(cardId);
    } catch (e) {
      debugPrint(
          'Board card deletion failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }
}
