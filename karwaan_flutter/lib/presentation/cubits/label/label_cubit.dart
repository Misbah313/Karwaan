import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/label/create_label_credentails.dart';
import 'package:karwaan_flutter/domain/models/label/label_state.dart';
import 'package:karwaan_flutter/domain/models/label/update_label_credentails.dart';
import 'package:karwaan_flutter/domain/repository/label/label_repo.dart';

class LabelCubit extends Cubit<LabelState> {
  final LabelRepo labelRepo;

  LabelCubit(this.labelRepo) : super(LabelInitial());

  // create label
  Future<void> createLabel(CreateLabelCredentails credentails) async {
    emit(LabelLoading());
    try {
      debugPrint('Starting creating label from cubit');
      final label = await labelRepo.createLabel(credentails);
      debugPrint('Lable created from cubit: ${label.id}');
      emit(LabelCreated(label));
    } catch (e) {
      emit(LabelError('Creation failed from cubit: ${e.toString()}'));
    }
  }

  // get labels for board
  Future<void> getLabelsForBoard(int boardId) async {
    emit(LabelLoading());
    try {
      final label = await labelRepo.getLabelsForBoard(boardId);
      emit(LabelListLoaded(label));
    } catch (e) {
      emit(LabelError('Fetching label failed from cubit: ${e.toString()}'));
    }
  }

  // update label
  Future<void> updateLabel(UpdateLabelCredentails credentails) async {
    emit(LabelLoading());
    try {
      debugPrint('Staring updating label from cubit.');
      final updated = await labelRepo.updateLabel(credentails);
      debugPrint('Label has been updated to : ${updated.title}, ${updated.color}');
      emit(LabelUpdated(updated));
    } catch (e) {
      emit(LabelError('Updating failed from cubit: ${e.toString()}'));
    }
  }

  // delete label
  Future<void> deleteLabel(int labelId) async {
    emit(LabelLoading());
    try {
      await labelRepo.deleteLabel(labelId);
      emit(LabelDeleted(labelId));
    } catch (e) {
      emit(LabelError('Deletion failed from cubit: ${e.toString()}'));
    }
  }
}
