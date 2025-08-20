import 'package:karwaan_flutter/domain/models/checklist/checklist.dart';
import 'package:karwaan_flutter/domain/models/checklist/create_checklist_credentails.dart';
import 'package:karwaan_flutter/domain/models/checklist/update_checklist_credentails.dart';

abstract class ChecklistRepo {
  Future<Checklist> createChecklist(CreateChecklistCredentails credentails);
  Future<List<Checklist>> listCheckList(int cardId);
  Future<Checklist> updateChecklist(UpdateChecklistCredentails credentails);
  Future<void> deleteChecklist(int checklistId);
}