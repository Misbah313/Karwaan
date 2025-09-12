import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/checklistItem/checklist_item_state.dart';
import 'package:karwaan_flutter/domain/models/checklistItem/create_checklist_item_credentails.dart';
import 'package:karwaan_flutter/domain/models/checklistItem/update_checklist_item_credentails.dart';
import 'package:karwaan_flutter/domain/repository/checklistItem/checklist_item_repo.dart';

class ChecklistItemCubit extends Cubit<ChecklistItemState> {
  final ChecklistItemRepo checklistItemRepo;

  ChecklistItemCubit(this.checklistItemRepo) : super(ChecklistItemInitial());

  // created checklist item
  Future<void> createChecklistItem(
      CreateChecklistItemCredentails credentails) async {
    emit(ChecklistItemLoading());
    try {
      final created = await checklistItemRepo.createChecklistItem(credentails);
      emit(ChecklistItemCreated(created));
    } catch (e) {
      emit(ChecklistItemError(ExceptionMapper.toMessage(e)));
    }
  }

  // list checklist item
  Future<void> listChecklistItem(int checklistId) async {
    emit(ChecklistItemLoading());
    try {
      final list = await checklistItemRepo.listChecklistItem(checklistId);
      emit(ChecklistItemListLoaded(list));
    } catch (e) {
      emit(ChecklistItemError(ExceptionMapper.toMessage(e)));
    }
  }

  // update checklist item
  Future<void> updateChecklistItem(
      UpdateChecklistItemCredentails credentails) async {
    emit(ChecklistItemLoading());
    try {
      final updated = await checklistItemRepo.updatedChecklistItem(credentails);
      emit(ChecklistItemUpdated(updated));
    } catch (e) {
      emit(ChecklistItemError(ExceptionMapper.toMessage(e)));
    }
  }

  // toggel checklist item
  Future<void> toggleChecklistItem(int checklistItemId) async {
    emit(ChecklistItemLoading());
    try {
      final toggled =
          await checklistItemRepo.toggleChecklistItemStatus(checklistItemId);
      emit(ChecklistItemToggled(toggled));
    } catch (e) {
      emit(ChecklistItemError(ExceptionMapper.toMessage(e)));
    }
  }

  // delete checklist item
  Future<void> deleteChecklistItem(int checklistItemId) async {
    emit(ChecklistItemLoading());
    try {
      await checklistItemRepo.deleteChecklistItem(checklistItemId);
      emit(ChecklistItemDeleted(checklistItemId));
    } catch (e) {
      emit(ChecklistItemError(ExceptionMapper.toMessage(e)));
    }
  }
}
