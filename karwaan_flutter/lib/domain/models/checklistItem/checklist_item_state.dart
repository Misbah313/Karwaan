import 'package:karwaan_flutter/domain/models/checklistItem/checklist_item.dart';

abstract class ChecklistItemState {}

class ChecklistItemInitial extends ChecklistItemState {}

class ChecklistItemLoading extends ChecklistItemState {}

class ChecklistItemListLoaded extends ChecklistItemState {
  final List<ChecklistItem> checklistItems;

  ChecklistItemListLoaded(this.checklistItems);
}

class ChecklistItemUpdated extends ChecklistItemState {
  final ChecklistItem checklistItem;

  ChecklistItemUpdated(this.checklistItem);
}

class ChecklistItemCreated extends ChecklistItemState {
  final ChecklistItem checklistItem;

  ChecklistItemCreated(this.checklistItem);
}

class ChecklistItemToggled extends ChecklistItemState {
  final ChecklistItem checklistItem;

  ChecklistItemToggled(this.checklistItem);
}

class ChecklistItemDeleted extends ChecklistItemState {
  final int checklistItemId;

  ChecklistItemDeleted(this.checklistItemId);
}

class ChecklistItemError extends ChecklistItemState {
  final String error;

  ChecklistItemError(this.error);
}
