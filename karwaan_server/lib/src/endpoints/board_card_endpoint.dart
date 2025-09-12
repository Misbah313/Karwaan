import 'package:karwaan_server/src/endpoints/role_check.dart';
import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class BoardCardEndpoint extends Endpoint {
  // create card
  Future<BoardCard> createBoardCard(
      Session session, int boardListId, String token, String title,
      {String? dec}) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or expired token!');
    }

    // check if the boadlist you want to the card to actually exists
    final boardList = await BoardList.db.findById(session, boardListId);
    if (boardList == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }

    try {
      // validate card data
      final trimmedTitle = title.trim();
      if (trimmedTitle.isEmpty) {
        throw RandomAppException(message: 'Card title cannot be empty!');
      }

      // set the required fields and create the card obj
      final card = BoardCard(
        title: trimmedTitle,
        createdBy: currentUser.id!,
        description: dec?.trim(),
        list: boardListId,
        createdAt: DateTime.now(),
        isCompleted: false,
      );

      // insert the created card into the db
      final insertedCard = await BoardCard.db.insertRow(session, card);
      return insertedCard;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(message: 'Failed to create card. Please try again.');
    }
  }

  // get cards by list
  Future<List<BoardCard>> getListByBoardCard(
      Session session, int boardListId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token!');
    }

    // validate the board list exist
    final boardList = await BoardList.db.findById(session, boardListId);
    if (boardList == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }

    // check user permission
    // make sure the current user is a member of the board that contains this board list
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (b) =>
          b.board.equals(boardList.board) & b.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not a member of the parent board!');
    }

    try {
      // Query all cards linked to this board list
      // fetch all card
      final fetch = await BoardCard.db.find(
        session,
        where: (c) => c.list.equals(boardListId),
        orderBy: (c) => c.createdAt,
      );

      return fetch;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to get list by card. Please try again.');
    }
  }

  // upadate cards
  Future<BoardCard> updateBoardCard(Session session, int cardId, String token,
      String newTitle, String? newDec, bool? completed) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or expired token!');
    }

    // fetch card by card id
    final card = await BoardCard.db.findById(session, cardId);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }

    // check user permission
    // Fetch the board/list that the card belongs to
    final boardList = await BoardList.db.findById(
      session,
      card.list,
    );
    if (boardList == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }

    // Confirm the user is a member of the parent board
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (b) =>
          b.board.equals(boardList.board) & b.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not a member of the parent board!');
    }

    // validate the updated data

    try {
      // make sure title is not empty
      final trimmedTitle = newTitle.trim();
      if (trimmedTitle.isEmpty) {
        throw RandomAppException(message: 'Card title cannot be empty!');
      }

      card.title = trimmedTitle;

      // validate other fields
      if (newDec != null) {
        card.description = newDec.trim();
      }
      if (completed != null) {
        card.isCompleted = completed;
      }

      // save the changes
      await BoardCard.db.updateRow(session, card);
      return card;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(message: 'Failed to update card. Please try again.');
    }
  }

  // delete cards
  Future<bool> deleteBoardCard(
      Session session, int cardId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token!');
    }

    // fetch card by card id
    final card = await BoardCard.db.findById(session, cardId);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }

    // check user permission
    // Fetch the board list the card belongs to
    final boardList = await BoardList.db.findById(session, card.list);
    if (boardList == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }

    // Check if the user is a member of the parent board
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (m) =>
          m.board.equals(boardList.board) & m.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not a member of the parent board!');
    }

    try {
      // check if the user role allow deleting
      if (membership.role == Roles.owner ||
          membership.role == Roles.admin ||
          card.createdBy == currentUser.id!) {
        // allow deletion

        await BoardCard.db.deleteRow(session, card);
        return true;
      } else {
        throw RandomAppException(
            message: "You don't have the permission to delete this card!");
      }
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(message: 'Failed to delete card. Please try again.');
    }
  }
}

/*
  Add Later:
  ----------

    // ✅ Reorder Cards in a List (Drag & Drop)
      - Add `position` field to Card model
      - Allow updating `position` to reorder cards in a list

    // ✅ Archive / Unarchive Card
      - Add `isArchived` field
      - Add endpoints to archive or unarchive a card instead of deleting

    // ✅ Move Card to Another List
      - Allow changing `card.list` with permission checks

    // ✅ Clone/Duplicate Card
      - Copy a card and its checklists, labels, and attachments to the same or another list

    // ✅ Card Activity Log
      - Track and return actions like create, update, move, assign, complete, etc.

    // ✅ Assign Users to Card
      - Add `assignedUserIds` list or many-to-many link table
      - Allow assigning/removing users

    // ✅ Due Date & Reminder
      - Add `dueDate` and `reminderTime` fields
      - Schedule reminders using background job/notifications

    // ✅ Attachments to Cards
      - Link files using `AttachmentEndpoint`
      - Allow upload, preview, delete

    // ✅ Toggle Card Completion (Separate Endpoint)
      - Simple endpoint to flip `isCompleted`

    // ✅ Paginated Get Cards
      - Add pagination to `getListByCard` with limit & offset

    // ✅ Search Cards by Title/Description
      - Allow text search across a list or board

    // ✅ Tag/Label Filtering
      - Return cards that match specific label(s)

    // ✅ Get Card Summary
      - Return total checklists, items, completion %, assigned users

    // ✅ Card Sharing (read-only link)
      - Generate tokenized links to allow external viewing

    // ✅ Card Color or Priority Field
      - Add optional color tag or priority level (Low, Medium, High)
      
*/
