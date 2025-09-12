import 'package:karwaan_server/src/endpoints/role_check.dart';
import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class ChecklistEndpoint extends Endpoint {
  // create checklist
  Future<CheckList> createChecklist(
      Session session, int cardId, String title, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token');
    }

    // check card exists
    final card = await BoardCard.db.findById(session, cardId);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }

    // get board
    final boardList = await BoardList.db.findById(session, card.list);
    if (boardList == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }

    // check membership
    final member = await BoardMember.db.findFirstRow(
      session,
      where: (b) =>
          b.board.equals(boardList.board) & b.user.equals(currentUser.id!),
    );
    if (member == null) {
      throw AppPermissionException(
          message: 'You are not a member of the parent board!');
    }

    try {
      // validate tile
      final trimmedTitle = title.trim();
      if (trimmedTitle.isEmpty) {
        throw RandomAppException(message: 'CheckList title cannot be emtpy!');
      }

      // create and insert checklist
      final checklist = CheckList(
          title: trimmedTitle,
          card: cardId,
          createdAt: DateTime.now(),
          createdBy: currentUser.id!);

      final duplicated = await CheckList.db.findFirstRow(
        session,
        where: (c) => c.card.equals(cardId) & c.title.equals(trimmedTitle),
      );
      if (duplicated != null) {
        throw RandomAppException(
            message: 'Another checklist with the same title already exists!');
      }

      final inserted = await CheckList.db.insertRow(session, checklist);
      if (inserted.id == null) {
        throw RandomAppException(
            message: 'Checklist id is null after creations!');
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
          message: 'Failed to create checklist. Please try again!');
    }
  }

  // Listing all checklists under a card
  Future<List<CheckList>> listChecklist(
      Session session, int cardId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token!');
    }

    // find the card
    final card = await BoardCard.db.findById(session, cardId);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }

    // get the parent board
    final boardList = await BoardList.db.findById(session, card.list);
    if (boardList == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }

    // check membership
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (w) =>
          w.board.equals(boardList.board) & w.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not a member of the parent board!');
    }

    try {
      // fetch checklist
      final checklist = await CheckList.db.find(
        session,
        where: (t) => t.card.equals(cardId),
        orderBy: (c) => c.createdAt,
      );

      return checklist;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to fetch checklist. Please try again.');
    }
  }

  // Updating the checklist's title
  Future<CheckList> updateChecklist(
      Session session, int checklistId, String newTitle, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token!');
    }

    // fetch the checklist by id
    final checklist = await CheckList.db.findById(session, checklistId);
    if (checklist == null) {
      throw AppNotFoundException(resourceType: 'Checklist');
    }

    // fetch the parent card
    final card = await BoardCard.db.findById(session, checklist.card);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }

    // fetch parent board
    final boardList = await BoardList.db.findById(session, card.list);
    if (boardList == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }
    final board = await Board.db.findById(session, boardList.board);
    if (board == null) {
      throw AppNotFoundException(resourceType: 'Board');
    }

    // membership check
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (b) => b.board.equals(board.id) & b.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not a member of the parent board!');
    }

    // permission check
    if (membership.role != Roles.owner &&
        membership.role != Roles.admin &&
        checklist.createdBy != currentUser.id!) {
      throw AppPermissionException(
          message:
              'Only owner, admins and creator of the checklist can update them!');
    }

    try {
      // validate new title
      final trimmedTitle = newTitle.trim();
      if (trimmedTitle.isEmpty) {
        throw RandomAppException(message: 'Checklist title cannot be empty!');
      }

      // check for duplicates
      final duplicate = await CheckList.db.findFirstRow(
        session,
        where: (w) =>
            w.card.equals(checklist.card) &
            w.title.equals(trimmedTitle) &
            w.id.notEquals(checklistId),
      );
      if (duplicate != null) {
        throw RandomAppException(
            message: 'Another checklist with the same title already exists!');
      }

      // updated the title
      checklist.title = trimmedTitle;
      await CheckList.db.updateRow(session, checklist);
      return checklist;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to update the checklist. Please try again.');
    }
  }

  // delete checklist
  Future<void> deleteChecklist(
      Session session, int checklistId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token!');
    }

    // fetch checklist by checklist id
    final checklist = await CheckList.db.findById(session, checklistId);
    if (checklist == null) {
      throw AppNotFoundException(resourceType: 'Checklist');
    }

    // fetch parent card
    final card = await BoardCard.db.findById(session, checklist.card);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }

    // fetch parent boardlist + board
    final boardlist = await BoardList.db.findById(session, card.list);
    if (boardlist == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }
    final board = await Board.db.findById(session, boardlist.board);
    if (board == null) {
      throw AppNotFoundException(resourceType: 'Board');
    }

    // check membership
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (p0) =>
          p0.board.equals(board.id) & p0.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not a member of the parent board!');
    }

    try {
      final isElevator =
          membership.role == Roles.owner || membership.role == Roles.admin;
      final isCreator = checklist.createdBy == currentUser.id!;
      if (!isElevator && !isCreator) {
        throw RandomAppException(
            message:
                'Only owners, admins and checklist creator can delete them!');
      }

      // delete
      await CheckList.db.deleteRow(session, checklist);
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to delete checklist. Please try again.');
    }
  }
}

/*
  Add Later:
  -----------

       // ✅ Reorder Checklists in a Card
         - Allow users to drag/drop checklists.
         - Store and update a `position` field to control the order.

       // ✅ Archive/Unarchive Checklist
         - Add `isArchived` boolean field.
         - Provide endpoints to archive/unarchive instead of hard deletion.

       // ✅ Clone Checklist
         - Duplicate an existing checklist (with/without its items) into the same or another card.

      // ✅ Move Checklist to Another Card
        - Update its `card` reference with appropriate permission checks on the destination card.

      // ✅ Checklist Activity Log
        - Track who created, updated, or deleted a checklist for audit and collaboration.

      // ✅ Toggle Checklist Visibility
        - Add `isPrivate` field. Only the creator or board admins can view if true.

      // ✅ Share Checklist via Token/Link
        - Generate secure token or link for external sharing (read-only).

      // ✅ Checklist Due Date / Reminder
        - Add `dueDate` and `reminderTime` fields.
        - Schedule reminders using a background job/notification.

      // ✅ Assign Users to a Checklist
        - Link checklist with user IDs responsible for completing it.

      // ✅ Checklist Progress Endpoint
        - Return completion % based on checked items (e.g. 3/5 = 60%).

      // ✅ Attach Files to Checklists
        - Allow file upload (handled later via `AttachmentEndpoint`).

      // ✅ Comment on a Checklist (optional)
        - Similar to cards, support a comment thread per checklist.

*/
