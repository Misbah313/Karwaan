import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/checklist/checklist_state.dart';
import 'package:karwaan_flutter/domain/models/checklist/create_checklist_credentails.dart';
import 'package:karwaan_flutter/domain/models/checklist/update_checklist_credentails.dart';
import 'package:karwaan_flutter/domain/repository/checklist/checklist_repo.dart';

class ChecklistCubit extends Cubit<ChecklistState> {
  final ChecklistRepo checklistRepo;

  ChecklistCubit(this.checklistRepo) : super(ChecklistInitial());

  // create checklist
  Future<void> createChecklist(CreateChecklistCredentails credentails) async {
    emit(ChecklistLoading());
    try {
      final checklist = await checklistRepo.createChecklist(credentails);
      emit(ChecklistCreated(checklist));
    } catch (e) {
      emit(ChecklistError(ExceptionMapper.toMessage(e)));
    }
  }

  // list checklists
  Future<void> listChecklist(int cardId) async {
    emit(ChecklistLoading());
    try {
      final list = await checklistRepo.listCheckList(cardId);
      emit(ChecklistListLoaded(list));
    } catch (e) {
      emit(ChecklistError(ExceptionMapper.toMessage(e)));
    }
  }

  // update checklist
  Future<void> updateChecklist(UpdateChecklistCredentails credentails) async {
    emit(ChecklistLoading());
    try {
      final updated = await checklistRepo.updateChecklist(credentails);
      emit(ChecklistUpdated(updated));
    } catch (e) {
      emit(ChecklistError(ExceptionMapper.toMessage(e)));
    }
  }

  // delete checklist
  Future<void> deleteChecklist(int checklistId) async {
    emit(ChecklistLoading());
    try {
      await checklistRepo.deleteChecklist(checklistId);
      emit(ChecklistDeleted(checklistId));
    } catch (e) {
      emit(ChecklistError(ExceptionMapper.toMessage(e)));
    }
  }
}
