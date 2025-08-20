import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/domain/models/checklist/checklist.dart';
import 'package:karwaan_flutter/domain/models/checklist/create_checklist_credentails.dart';
import 'package:karwaan_flutter/domain/models/checklist/update_checklist_credentails.dart';
import 'package:karwaan_flutter/domain/repository/checklist/checklist_repo.dart';

class ChecklistRemoteRepo extends ChecklistRepo {
  final ServerpodClientService _clientService;

  ChecklistRemoteRepo(this._clientService);

  @override
  Future<Checklist> createChecklist(
      CreateChecklistCredentails credentails) async {
    try {
      final checklist = await _clientService.createChecklist(
          credentails.cardId, credentails.title);
          if(checklist.id == null) {
            throw Exception('Server returned null id!');
          }
      return Checklist(id: checklist.id, title: checklist.title);
    } catch (e) {
      debugPrint('Creation failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Checklist>> listCheckList(int cardId) async {
    try {
      final list = await _clientService.listCheckList(cardId);
      return list.map((e) => Checklist(id: e.id!, title: e.title)).toList();
    } catch (e) {
      debugPrint('Listing failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<Checklist> updateChecklist(
      UpdateChecklistCredentails credentails) async {
    try {
      final update = await _clientService.updatedChecklist(
          credentails.checklistId, credentails.newTitle);
      return Checklist(id: update.id!, title: update.title);
    } catch (e) {
      debugPrint('Updating failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> deleteChecklist(int checklistId) async {
    try {
      await _clientService.deleteChecklist(checklistId);
    } catch (e) {
      debugPrint('Deleting failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }
}
