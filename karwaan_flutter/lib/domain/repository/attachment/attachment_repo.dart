import 'package:karwaan_flutter/domain/models/attachment/attachment.dart';
import 'package:karwaan_flutter/domain/models/attachment/upload_attachment_credentails.dart';

abstract class AttachmentRepo {
  Future<Attachment> uploadAttachment(UploadAttachmentCredentails credentails);
  Future<List<Attachment>> listAttachment(int cardId);
  Future<bool> deleteAttachment(int attachmentId);
}