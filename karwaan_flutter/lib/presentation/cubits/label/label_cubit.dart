import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
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
      emit(LabelError(ExceptionMapper.toMessage(e)));
    }
  }

  // get labels for board
  Future<void> getLabelsForBoard(int boardId) async {
    emit(LabelLoading());
    try {
      final label = await labelRepo.getLabelsForBoard(boardId);
      emit(LabelListLoaded(label));
    } catch (e) {
      emit(LabelError(ExceptionMapper.toMessage(e)));
    }
  }

  // update label
  Future<void> updateLabel(UpdateLabelCredentails credentails) async {
    emit(LabelLoading());
    try {
      final updated = await labelRepo.updateLabel(credentails);
      emit(LabelUpdated(updated));
    } catch (e) {
      emit(LabelError(ExceptionMapper.toMessage(e)));
    }
  }

  // delete label
  Future<void> deleteLabel(int labelId) async {
    emit(LabelLoading());
    try {
      await labelRepo.deleteLabel(labelId);
      emit(LabelDeleted(labelId));
    } catch (e) {
      emit(LabelError(ExceptionMapper.toMessage(e)));
    }
  }
}
