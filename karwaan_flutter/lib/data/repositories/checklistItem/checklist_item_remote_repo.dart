import 'package:flutter/rendering.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/domain/models/checklistItem/checklist_item.dart';
import 'package:karwaan_flutter/domain/models/checklistItem/create_checklist_item_credentails.dart';
import 'package:karwaan_flutter/domain/models/checklistItem/update_checklist_item_credentails.dart';
import 'package:karwaan_flutter/domain/repository/checklistItem/checklist_item_repo.dart';

class ChecklistItemRemoteRepo extends ChecklistItemRepo {
  final ServerpodClientService _clientService;

  ChecklistItemRemoteRepo(this._clientService);

  @override
  Future<ChecklistItem> createChecklistItem(
      CreateChecklistItemCredentails credentails) async {
    try {
      final create = await _clientService.createChecklistItem(
          credentails.checklistId, credentails.content);
          if(create.id == null) {
            throw Exception('Server returned null id!');
          }
      return ChecklistItem(
          id: create.id, content: create.content, isDone: create.isDone);
    } catch (e) {
      debugPrint('Creation failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<ChecklistItem>> listChecklistItem(int checklistId) async {
    try {
      final list = await _clientService.listCheckListItem(checklistId);
      return list
          .map((e) =>
              ChecklistItem(id: e.id!, content: e.content, isDone: e.isDone))
          .toList();
    } catch (e) {
      debugPrint('Listing failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<ChecklistItem> updatedChecklistItem(
      UpdateChecklistItemCredentails credentails) async {
    try {
      final updated = await _clientService.updateChecklistItem(
          credentails.checklistItemId,
          credentails.checklistId,
          credentails.newContent);
      return ChecklistItem(
          id: updated.id!, content: updated.content, isDone: updated.isDone);
    } catch (e) {
      debugPrint('Updating failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<ChecklistItem> toggleChecklistItemStatus(int checklistItemId) async {
    try {
      final toggled =
          await _clientService.toggleChecklistItemStatus(checklistItemId);
      return ChecklistItem(
          id: toggled.id!, content: toggled.content, isDone: toggled.isDone);
    } catch (e) {
      debugPrint('Toggle failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> deleteChecklistItem(int checklistItemId) async {
    try {
      await _clientService.deleteChecklistItem(checklistItemId);
    } catch (e) {
      debugPrint('Deleting failed from remote repo: ${e.toString()}');
    }
  }
}
