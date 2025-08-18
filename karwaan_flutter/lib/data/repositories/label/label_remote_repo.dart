import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/domain/models/label/create_label_credentails.dart';
import 'package:karwaan_flutter/domain/models/label/label.dart';
import 'package:karwaan_flutter/domain/models/label/update_label_credentails.dart';
import 'package:karwaan_flutter/domain/repository/label/label_repo.dart';

class LabelRemoteRepo extends LabelRepo {
  final ServerpodClientService _clientService;

  LabelRemoteRepo(this._clientService);

  @override
  Future<Label> createLabel(CreateLabelCredentails credentails) async {
    try {
      final label = await _clientService.createLabel(
          credentails.boardId, credentails.title, credentails.color);

      if (label.id == null) {
        throw Exception('Server returned label with null ID');
      }

      return Label(
          id: label.id, // Now safe because of the null check above
          boardId: label.board,
          title: label.title,
          color: label.color);
    } catch (e) {
      debugPrint('Creation failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Label>> getLabelsForBoard(int boardId) async {
    try {
      final list = await _clientService.getLabelsForBoard(boardId);
      return list
          .map((e) => Label(
                id: e.id!,
                boardId: e.board,
                title: e.title,
                color: e.color,
              ))
          .toList();
    } catch (e) {
      debugPrint(
          'Getting labes for board failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<Label> updateLabel(UpdateLabelCredentails credentails) async {
    try {
      final updated = await _clientService.updateLabel(
          credentails.labelId, credentails.newTitle, credentails.newColor);
      return Label(
          id: updated.id!,
          boardId: updated.board,
          title: updated.title,
          color: updated.color);
    } catch (e) {
      debugPrint('Updating failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<bool> deleteLabel(int labelId) async {
    try {
      return await _clientService.deleteLabel(labelId);
    } catch (e) {
      debugPrint('Deletion failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }
}
