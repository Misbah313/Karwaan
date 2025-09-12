import 'package:karwaan_server/src/endpoints/role_check.dart';
import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class AttachmentEndpoint extends Endpoint {
  // upload attachment
  Future<Attachment> uploadAttachment(
      Session session, int cardId, String fileName, String token) async {
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token!');
    }

    // fetch the parent card
    final card = await BoardCard.db.findById(session, cardId);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }

    // fetch the parent boardlist + board
    final boardlist = await BoardList.db.findById(session, card.list);
    if (boardlist == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }
    final board = await Board.db.findById(session, boardlist.board);
    if (board == null) {
      throw AppNotFoundException(resourceType: 'Board');
    }

    // check current user membership
    final usermembership = await BoardMember.db.findFirstRow(
      session,
      where: (p0) =>
          p0.board.equals(board.id) & p0.user.equals(currentUser.id!),
    );
    if (usermembership == null) {
      throw AppPermissionException(
          message: 'You are not a member of the parent board!');
    }

    // validate file input
    final trimmedFileName = fileName.trim();
    if (trimmedFileName.isEmpty) {
      throw RandomAppException(message: 'File name cannot be empty!');
    }

    // check for duplications
    final duplication = await Attachment.db.findFirstRow(
      session,
      where: (p0) =>
          p0.card.equals(card.id) & p0.fileName.equals(trimmedFileName),
    );
    if (duplication != null) {
      throw RandomAppException(
          message: 'Another file with that name already exists!');
    }

    // ( normalize or restrict the filename format to avoid special characters or security risks **later..)

    try {
      // create attachment obj
      final attachment = Attachment(
          card: card.id!,
          uploadedBy: currentUser.id!,
          fileName: trimmedFileName);

      // insert into db
      final inserted = await Attachment.db.insertRow(session, attachment);
      if (inserted.id == null) {
        throw RandomAppException(
            message: 'Attachment id is null after uploading!');
      }

      return inserted;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to upload attachment. Please try again.');
    }
  }

  // list attachments
  Future<List<Attachment>> listAttachments(
      Session session, int cardId, String token) async {
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token!');
    }

    // fetch the parent card
    final card = await BoardCard.db.findById(session, cardId);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }

    // fetch the parent boardlist + board
    final boardlist = await BoardList.db.findById(session, card.list);
    if (boardlist == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }
    final board = await Board.db.findById(session, boardlist.board);
    if (board == null) {
      throw AppNotFoundException(resourceType: 'Board');
    }

    // check membership
    final usermembership = await BoardMember.db.findFirstRow(
      session,
      where: (p0) =>
          p0.board.equals(board.id) & p0.user.equals(currentUser.id!),
    );
    if (usermembership == null) {
      throw AppPermissionException(
          message: 'You are not a member of the parent board!');
    }

    try {
      // fetch the attachment
      final attachments = await Attachment.db.find(
        session,
        where: (p0) => p0.card.equals(card.id),
        orderBy: (p0) => p0.id,
      );
      return attachments;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to list attachment. Please try again.');
    }
  }

  // delete attachment
  Future<bool> deleteAttachment(
      Session session, int attachmentId, String token) async {
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token!');
    }

    // find the attachment by id
    final attachment = await Attachment.db.findById(session, attachmentId);
    if (attachment == null) {
      throw AppNotFoundException(resourceType: 'Attachment');
    }

    // fetch the parent card
    final card = await BoardCard.db.findById(session, attachment.card);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }

    // fetch the parent boardlist + board
    final boardlist = await BoardList.db.findById(session, card.list);
    if (boardlist == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }
    final board = await Board.db.findById(session, boardlist.board);
    if (board == null) {
      throw AppNotFoundException(resourceType: 'Board');
    }

    // check memberhsip
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (p0) =>
          p0.board.equals(board.id) & p0.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not a member on the parent board!');
    }

    // permission check
    final isElevated =
        membership.role == Roles.owner || membership.role == Roles.admin;
    final isCreator = attachment.uploadedBy == currentUser.id;
    if (!isElevated && !isCreator) {
      throw AppPermissionException(
          message:
              'Only owner, admins and creator of the attachments can delete them!');
    }

    try {
      // delete the attachment
      await Attachment.db.deleteRow(session, attachment);
      return true;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to delete attachment. Please try again.');
    }
  }
}
/*
 
 Can add later:
   
   - Rename attachment(int attachmentId, String newName)
   - move attachment to another card(int attachmentId, int newCardId)

   or can put all this tow inside update attachment method


  - downloadAttachment(int attachmentId).

  - getAttachmentDetails(int attachmentId).

  - paginateAttachments(cardId, page, size).

  - markAttachmentAsCover().

  - upload actual files to disk/cloud (not just name ref).
*/
