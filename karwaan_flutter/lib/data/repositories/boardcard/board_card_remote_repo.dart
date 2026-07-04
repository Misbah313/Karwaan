import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/client/serverpod_client_service.dart';
import 'package:karwaan_flutter/data/mappers/auth/user_mapper.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_assignment.dart';
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
          credentails.id, credentails.title, credentails.description,
          assignedUserIds: credentails.assignedUserIds,
          assignedLabelIds: credentails.assignedLabelIds);
      return BoardCard(
          id: create.id!,
          boardListId: create.list,
          title: create.title,
          description: create.description ?? '',
          createdAt: create.createdAt,
          isCompleted: create.isCompleted,
          assignedUserIds: create.assignedUsers,
          );
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
              isCompleted: e.isCompleted,
              assignedUserIds: e.assignedUsers,
              ))
          .toList();
    } catch (e) {
      debugPrint(
          'Board card fetching failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<BoardCard>> getAllUserCards() async {
    try {
      final cards = await _clientService.getAllUserCards();
      debugPrint('Raw cards from service: ${cards.length}');
      final mapppedCards = cards
          .map((e) => BoardCard(
              id: e.id!,
              boardListId: e.list,
              title: e.title,
              description: e.description ?? '',
              createdAt: e.createdAt,
              isCompleted: e.isCompleted,
              assignedUserIds: e.assignedUsers,
              ))
          .toList();
      debugPrint('mapped cards: ${mapppedCards.length}');
      return mapppedCards;
    } catch (e) {
      debugPrint('cards fetching failed from remote repo: $e');
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
          isCompleted: update.isCompleted,
          assignedUserIds: update.assignedUsers,
          );
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

  // New assignment methods implementation
  @override
  Future<List<BoardCardAssignment>> assignUsersToCard(
      int cardId, List<int> userIds) async {
    try {
      final assignments =
          await _clientService.assignUsersToCard(cardId, userIds);
      return assignments
          .map((a) => BoardCardAssignment(
                id: a.id!,
                cardId: a.card,
                userId: a.user,
                assignedBy: a.assignedBy,
                assignedAt: a.assignedAt,
              ))
          .toList();
    } catch (e) {
      debugPrint('Assign users failed: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<bool> removeUsersFromCard(int cardId, List<int> userIds) async {
    try {
      return await _clientService.removeUsersFromCard(cardId, userIds);
    } catch (e) {
      debugPrint('Remove users failed: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<AuthUser>> getCardAssignees(int cardId) async {
    try {
      final users = await _clientService.getCardAssignees(cardId);
      return users.map((user) => user.toAuthUser()).toList();
    } catch (e) {
      debugPrint('Get assignees failed: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<BoardCard>> getMyAssignedCards() async {
    try {
      final cards = await _clientService.getMyAssignedCards();
      return cards
          .map((e) => BoardCard(
              id: e.id!,
              boardListId: e.list,
              title: e.title,
              description: e.description ?? '',
              createdAt: e.createdAt,
              isCompleted: e.isCompleted,
              assignedUserIds: e.assignedUsers,))
          .toList();
    } catch (e) {
      debugPrint('Get my assigned cards failed: ${e.toString()}');
      rethrow;
    }
  }
}
