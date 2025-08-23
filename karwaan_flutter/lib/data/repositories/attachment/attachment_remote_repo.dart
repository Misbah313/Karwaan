import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/domain/models/attachment/attachment.dart';
import 'package:karwaan_flutter/domain/models/attachment/upload_attachment_credentails.dart';
import 'package:karwaan_flutter/domain/repository/attachment/attachment_repo.dart';

class AttachmentRemoteRepo extends AttachmentRepo {
  final ServerpodClientService _clientService;

  AttachmentRemoteRepo(this._clientService);

  @override
  Future<Attachment> uploadAttachment(
      UploadAttachmentCredentails credentails) async {
    try {
      final attchment = await _clientService.uploadAttachment(
          credentails.cardId, credentails.fileName);
      if (attchment.id == null) {
        throw Exception('Server returned null id for the attachment');
      }
      return Attachment(
          id: attchment.id,
          cardId: attchment.card,
          fileName: attchment.fileName);
    } catch (e) {
      debugPrint('Uploading failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Attachment>> listAttachment(int cardId) async {
    try {
      final list = await _clientService.listAttachment(cardId);
      return list
          .map(
              (e) => Attachment(id: e.id, cardId: e.card, fileName: e.fileName))
          .toList();
    } catch (e) {
      debugPrint('Listing failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<bool> deleteAttachment(int attachmentId) async {
    try {
      return await _clientService.deleteAttachment(attachmentId);
    } catch (e) {
      debugPrint('Deletion failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }
}
