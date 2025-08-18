import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/domain/models/cardlabel/cardlabel.dart';
import 'package:karwaan_flutter/domain/models/cardlabel/cardlabel_credentails.dart';
import 'package:karwaan_flutter/domain/models/label/label.dart';
import 'package:karwaan_flutter/domain/repository/cardlabel/cardlabel_repo.dart';

class CardlabelRemoteRepo extends CardlabelRepo {
  final ServerpodClientService _clientService;

  CardlabelRemoteRepo(this._clientService);

  @override
  Future<Cardlabel> assignLabelToCard(CardlabelCredentails credentails) async {
    try {
      final cardlabel = await _clientService.assignLabelToCard(
          credentails.labelId, credentails.cardId);
      debugPrint('Label id: ${cardlabel.id}');
      if (cardlabel.id == null) {
        throw Exception('Cardlabel id is null!');
      }

      return Cardlabel(
          id: cardlabel.id, cardId: cardlabel.card, labelId: cardlabel.label);
    } catch (e) {
      debugPrint('Assign failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> removeLabelFromCard(CardlabelCredentails credentails) async {
    try {
      final removed = await _clientService.removeLabelFromCard(
          credentails.cardId, credentails.labelId);
      return removed;
    } catch (e) {
      debugPrint('Remove failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Label>> getLabelsforCard(int cardId) async {
    try {
      final labels = await _clientService.getLabelsforCard(cardId);
      return labels
          .map((e) => Label(
              id: e.id!, boardId: e.board, title: e.title, color: e.color))
          .toList();
    } catch (e) {
      debugPrint(
          'Fetching labels for the card failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Cardlabel>> getCardsForLabel(int labelId) async {
    try {
      final cardlabel = await _clientService.getCardsForLabel(labelId);
      return cardlabel
          .map((e) => Cardlabel(id: e.id!, cardId: e.id!, labelId: labelId))
          .toList();
    } catch (e) {
      debugPrint(
          'Getting cards for label failed from remote repo: ${e.toString()} ');
      rethrow;
    }
  }
}
