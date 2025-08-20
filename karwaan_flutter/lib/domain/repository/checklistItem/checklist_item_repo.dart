import 'package:karwaan_flutter/domain/models/checklistItem/checklist_item.dart';
import 'package:karwaan_flutter/domain/models/checklistItem/create_checklist_item_credentails.dart';
import 'package:karwaan_flutter/domain/models/checklistItem/update_checklist_item_credentails.dart';

abstract class ChecklistItemRepo {
  Future<ChecklistItem> createChecklistItem(
      CreateChecklistItemCredentails credentails);
  Future<List<ChecklistItem>> listChecklistItem(int checklistId);
  Future<ChecklistItem> updatedChecklistItem(
      UpdateChecklistItemCredentails credentails);
  Future<ChecklistItem> toggleChecklistItemStatus(int checklistItemId);
  Future<void> deleteChecklistItem(int checklistItemId);
}
