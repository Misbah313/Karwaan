import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/attachment/attachment_state.dart';
import 'package:karwaan_flutter/domain/models/attachment/upload_attachment_credentails.dart';
import 'package:karwaan_flutter/domain/repository/attachment/attachment_repo.dart';

class AttachmentCubit extends Cubit<AttachmentState> {
  final AttachmentRepo attachmentRepo;

  AttachmentCubit(this.attachmentRepo) : super(AttachmentInitial());

  // upload attachment
  Future<void> uploadAttachment(UploadAttachmentCredentails credentails) async {
    emit(AttachmentLoading());
    try {
      final upload = await attachmentRepo.uploadAttachment(credentails);
      emit(AttachmentUploaded(upload));
    } catch (e) {
      emit(AttachmentError(ExceptionMapper.toMessage(e)));
    }
  }

  // list attachment
  Future<void> listAttachment(int cardId) async {
    emit(AttachmentLoading());
    try {
      final list = await attachmentRepo.listAttachment(cardId);
      emit(AttachmentListLoaded(list));
    } catch (e) {
      emit(AttachmentError(ExceptionMapper.toMessage(e)));
    }
  }

  // delete attachment
  Future<void> deleteAttachment(int attachmentId) async {
    emit(AttachmentLoading());
    try {
      await attachmentRepo.deleteAttachment(attachmentId);
      emit(AttachmentDeleted(attachmentId));
    } catch (e) {
      emit(AttachmentError(ExceptionMapper.toMessage(e)));
    }
  }
}
