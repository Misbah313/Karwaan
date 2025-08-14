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
      throw Exception('No user or invalid token!');
    }

    // fetch the parent card
    final card = await BoardCard.db.findById(session, cardId);
    if (card == null) {
      throw Exception('Card not found!');
    }

    // fetch the parent boardlist + board
    final boardlist = await BoardList.db.findFirstRow(
      session,
      where: (p0) => p0.board.equals(card.list),
    );
    if (boardlist == null) {
      throw Exception('Parent boardlist not found!');
    }
    final board = await Board.db.findById(session, boardlist.board);
    if (board == null) {
      throw Exception('Parent board not found!');
    }

    // check current user membership
    final usermembership = await BoardMember.db.findFirstRow(
      session,
      where: (p0) =>
          p0.board.equals(board.id) & p0.user.equals(currentUser.id!),
    );
    if (usermembership == null) {
      throw Exception('You are not a member of the parent board!');
    }

    // validate file input
    final trimmedFileName = fileName.trim();
    if (trimmedFileName.isEmpty) {
      throw Exception('File name cannot be empty!');
    }

    // check for duplications
    final duplication = await Attachment.db.findFirstRow(
      session,
      where: (p0) =>
          p0.card.equals(card.id) & p0.fileName.equals(trimmedFileName),
    );
    if (duplication != null) {
      throw Exception('Another file with that name already exists!');
    }

    // ( normalize or restrict the filename format to avoid special characters or security risks **later..)

    try {
      // create attachment obj
      final attachment = Attachment(
          card: card.id!,
          uploadedBy: currentUser.id!,
          fileName: trimmedFileName);

      // insert into db
      await Attachment.db.insertRow(session, attachment);

      return attachment;
    } catch (e) {
      throw Exception(e);
    }
  }

  // list attachments
  Future<List<Attachment>> listAttachments(
      Session session, int cardId, String token) async {
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // fetch the parent card
    final card = await BoardCard.db.findById(session, cardId);
    if (card == null) {
      throw Exception('Parent card not found!');
    }

    // fetch the parent boardlist + board
    final boardlist = await BoardList.db.findFirstRow(
      session,
      where: (p0) => p0.board.equals(card.list),
    );
    if (boardlist == null) {
      throw Exception('Parent boardlist not found!');
    }
    final board = await Board.db.findById(session, boardlist.board);
    if (board == null) {
      throw Exception('Parent board not found!');
    }

    // check membership
    final usermembership = await BoardMember.db.findFirstRow(
      session,
      where: (p0) =>
          p0.board.equals(board.id) & p0.user.equals(currentUser.id!),
    );
    if (usermembership == null) {
      throw Exception('You are not a member of the parent board!');
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
      throw Exception(e);
    }
  }

  // delete attachment
  Future<bool> deleteAttachment(
      Session session, int attachmentId, String token) async {
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // find the attachment by id
    final attachment = await Attachment.db.findById(session, attachmentId);
    if (attachment == null) {
      throw Exception('Attachment not found!');
    }

    // fetch the parent card
    final card = await BoardCard.db.findById(session, attachment.card);
    if (card == null) {
      throw Exception('Parent card not found!');
    }

    // fetch the parent boardlist + board
    final boardlist = await BoardList.db.findFirstRow(
      session,
      where: (p0) => p0.board.equals(card.list),
    );
    if (boardlist == null) {
      throw Exception('Parent boardlist not found!');
    }
    final board = await Board.db.findById(session, boardlist.board);
    if (board == null) {
      throw Exception('Parent board not found!');
    }

    // check memberhsip
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (p0) =>
          p0.board.equals(board.id) & p0.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw Exception('You are not a member on the parent board!');
    }

    // permission check
    final isElevated =
        membership.role == Roles.owner || membership.role == Roles.admin;
    final isCreator = attachment.uploadedBy == currentUser.id;
    if (!isElevated && !isCreator) {
      throw Exception(
          'Only owner, admins and creator of the attachments can delete them!');
    }

    try {
      // delete the attachment
      await Attachment.db.deleteRow(session, attachment);
      return true;
    } catch (e) {
      throw Exception(e);
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
