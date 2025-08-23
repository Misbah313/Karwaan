import 'package:karwaan_flutter/domain/models/attachment/attachment.dart';

abstract class AttachmentState {}

class AttachmentInitial extends AttachmentState {}

class AttachmentLoading extends AttachmentState {}

class AttachmentListLoaded extends AttachmentState {
  final List<Attachment> attachments;

  AttachmentListLoaded(this.attachments);
}

class AttachmentUploaded extends AttachmentState {
  final Attachment attachment;

  AttachmentUploaded(this.attachment);
}

class AttachmentDeleted extends AttachmentState {
  final int attachmentId;

  AttachmentDeleted(this.attachmentId);
}

class AttachmentError extends AttachmentState {
  final String error;

  AttachmentError(this.error);
}
