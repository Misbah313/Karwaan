import 'package:karwaan_flutter/domain/models/checklist/checklist.dart';

abstract class ChecklistState {}

class ChecklistInitial extends ChecklistState {}

class ChecklistLoading extends ChecklistState {}

class ChecklistListLoaded extends ChecklistState {
  final List<Checklist> checklist;

  ChecklistListLoaded(this.checklist);
}

class ChecklistCreated extends ChecklistState {
  final Checklist checklist;

  ChecklistCreated(this.checklist);
}

class ChecklistUpdated extends ChecklistState {
  final Checklist checklistId;

  ChecklistUpdated(this.checklistId);
}

class ChecklistDeleted extends ChecklistState {
  final int checklistId;

  ChecklistDeleted(this.checklistId);
}

class ChecklistError extends ChecklistState {
  final String error;

  ChecklistError(this.error);
}
