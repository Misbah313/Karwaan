import 'package:karwaan_server/src/endpoints/role_check.dart';
import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class ChecklistItemEndpoint extends Endpoint {
  // create Checklist Item
  Future<CheckListItem> createChecklistItem(
      Session session, int checklistId, String content, String token) async {
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // fetch the parent checklist by id
    final checklist = await CheckList.db.findById(session, checklistId);
    if (checklist == null) {
      throw Exception('Parent checklist not found!');
    }

    // fetch the parent card
    final card = await BoardCard.db.findById(session, checklist.card);
    if (card == null) {
      throw Exception('Parent card not found!');
    }

    // fetch the parent boardlist + board
    final boardlist = await BoardList.db.findById(session, card.list);
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
      throw Exception('You are not a member of the parent board!');
    }

    try {
      // valide the content item
      final trimmedContent = content.trim();
      if (trimmedContent.isEmpty) {
        throw Exception('Checklist item title cannot be empty');
      }

      // check for duplicates
      final duplicate = await CheckListItem.db.findFirstRow(session,
          where: (p0) =>
              p0.checklist.equals(checklistId) &
              p0.content.equals(trimmedContent));
      if (duplicate != null) {
        throw Exception(
            'Another checklist item with the same content already exists!');
      }

      // create checklist item obj
      final checklistitem = CheckListItem(
          checklist: checklistId,
          content: trimmedContent,
          isDone: false,
          createdBy: currentUser.id!);

    final inserted = await CheckListItem.db.insertRow(session, checklistitem);
    if(inserted.id == null) {
      throw Exception('Item id is null after creation!');
    }

      return inserted;
    } catch (e) {
      throw Exception(e);
    }
  }

  // listChecklistItems
  Future<List<CheckListItem>> listChecklistItems(
      Session session, int checklistId, String token) async {
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // fetch checklist by id
    final checklist = await CheckList.db.findById(session, checklistId);
    if (checklist == null) {
      throw Exception('Checklist not found!');
    }

    // fetch parent card
    final card = await BoardCard.db.findById(session, checklist.card);
    if (card == null) {
      throw Exception('Parent card not found!');
    }

    // fetch the parent boardlist + board
    final boardlist = await BoardList.db.findById(session, card.list);
    if (boardlist == null) {
      throw Exception('Parent boardlist not found!');
    }
    final board = await Board.db.findById(session, boardlist.board);
    if (board == null) {
      throw Exception('Parent board not found!');
    }

    // check membership
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (p0) =>
          p0.board.equals(board.id) & p0.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw Exception('You are not a member of the parent board!');
    }

    try {
      // fetch all items
      final items = await CheckListItem.db.find(
        session,
        where: (p0) => p0.checklist.equals(checklistId),
        orderBy: (p0) => p0.id,
      );

      return items;
    } catch (e) {
      throw Exception(e);
    }
  }

  // updateChecklistItem
  Future<CheckListItem> updateChecklistItem(
      Session session,
      int checklistItemId,
      int checklistId,
      String newContent,
      String token) async {
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    final checklistItem =
        await CheckListItem.db.findById(session, checklistItemId);
    if (checklistItem == null) {
      throw Exception('Checklist item not found!');
    }

    // fetch the parent checklist
    final checklist = await CheckList.db.findById(session, checklistId);
    if (checklist == null) {
      throw Exception('Parent checklist not found!');
    }

    // fetch the parent card
    final card = await BoardCard.db.findById(session, checklist.card);
    if (card == null) {
      throw Exception('Parent card not found!');
    }

    // fetch the parent boardlist + board
    final boardlist = await BoardList.db.findById(session, card.list);
    if (boardlist == null) {
      throw Exception('Parent boardlist not found!');
    }
    final board = await Board.db.findById(session, boardlist.board);
    if (board == null) {
      throw Exception('Parent board not found!');
    }

    // check current user membership on the parent board
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (p0) =>
          p0.board.equals(board.id) & p0.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw Exception('You are not a member of the parent board!');
    }

    final isElevated =
        membership.role == Roles.owner || membership.role == Roles.admin;
    final isCreator = checklist.createdBy == currentUser.id;
    if (!isElevated && !isCreator) {
      throw Exception(
          'Only owners, admins and creators can update checklist items');
    }

    try {
      // validate the udpated content
      final trimmedContent = newContent.trim();
      if (trimmedContent.isEmpty) {
        throw Exception('Checklist item content cannot be empty!');
      }

      // update
      checklistItem.content = trimmedContent;

      // check duplicate
      final duplicate = await CheckListItem.db.findFirstRow(
        session,
        where: (p0) =>
            p0.checklist.equals(checklistItem.checklist) &
            p0.content.equals(trimmedContent) &
            p0.id.notEquals(checklistItem.id),
      );
      if (duplicate != null) {
        throw Exception('Another checklist item with the same content exists!');
      }

      await CheckListItem.db.updateRow(session, checklistItem);
      return checklistItem;
    } catch (e) {
      throw Exception(e);
    }
  }

  // toggleChecklistItemStatus
  Future<CheckListItem> toggleChecklistItemStatus(
      Session session, int checklistItemId, String token) async {
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // find the checklist item by id
    final checklistItem =
        await CheckListItem.db.findById(session, checklistItemId);
    if (checklistItem == null) {
      throw Exception('Checklist item not found!');
    }

    // fetch the parent checklist
    final checklist =
        await CheckList.db.findById(session, checklistItem.checklist);
    if (checklist == null) {
      throw Exception('Parent checklist not found!');
    }

    // fetch the parent card
    final card = await BoardCard.db.findById(session, checklist.card);
    if (card == null) {
      throw Exception('Parent card not found!');
    }

    // get boardlist + board
    final boardlist = await BoardList.db.findById(session, card.list);
    if (boardlist == null) {
      throw Exception('Parent boardlist not found!');
    }
    final board = await Board.db.findById(session, boardlist.board);
    if (board == null) {
      throw Exception('Parent board not found!');
    }

    // check user membership on the parent board
    final usermembership = await BoardMember.db.findFirstRow(
      session,
      where: (p0) =>
          p0.board.equals(board.id) & p0.user.equals(currentUser.id!),
    );
    if (usermembership == null) {
      throw Exception('You are not a member of the parent board!');
    }

    try {
      // permission
      final isElevated =
          usermembership.role == 'Owner' || usermembership.role == 'Admin';
      final isCreator = checklistItem.createdBy == currentUser.id!;
      if (!isElevated && !isCreator) {
        throw Exception(
            'Only owner, admins and creator of the checklist item can toggle the status.');
      }

      // toggle
      checklistItem.isDone = !checklistItem.isDone;

      // update the checklist item in db
      await CheckListItem.db.updateRow(session, checklistItem);
      return checklistItem;
    } catch (e) {
      throw Exception(e);
    }
  }

  // deleteChecklistItem
  Future<void> deleteChecklistItem(
      Session session, int checklistItemId, String token) async {
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or expired token!');
    }

    // find the checklist item by id
    final checklistItem =
        await CheckListItem.db.findById(session, checklistItemId);
    if (checklistItem == null) {
      throw Exception('Checklist item not found!');
    }

    // fetch parent checklist via checklistItem.checklist
    final checklist =
        await CheckList.db.findById(session, checklistItem.checklist);
    if (checklist == null) {
      throw Exception('Checklist not found!');
    }

    // fetch the parent card
    final card = await BoardCard.db.findById(session, checklist.card);
    if (card == null) {
      throw Exception('Card not found!');
    }

    // fetch the parent boardlist + board
    final boardlist = await BoardList.db.findById(session, card.list);
    if (boardlist == null) {
      throw Exception('Parent boardlist not found!');
    }
    final board = await Board.db.findById(session, boardlist.board);
    if (board == null) {
      throw Exception('Parent board not found!');
    }

    // check current user membership on the parent board
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (p0) =>
          p0.board.equals(board.id) & p0.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw Exception('You are not a member of the parent board!');
    }

    try {
      // check if the current user can delete the checklist item
      final isElevated =
          membership.role == 'Owner' || membership.role == 'Admin';
      final isCreator = checklistItem.createdBy == currentUser.id!;
      if (!isElevated && !isCreator) {
        throw Exception(
            'Only owner, admins and creators can delete their checklist items!');
      }

      // delete
      await CheckListItem.db.deleteRow(session, checklistItem);
    } catch (e) {
      throw Exception(e);
    }
  }
}

 /*
  Add Later:
  ----------

       // ✅ Reorder Checklist Items
        - Add an integer `position` field and let users drag & drop items.
        - Endpoint: reorderChecklistItem(int checklistItemId, int newPosition)

       // ✅ Assign Users to an Item
        - Many tools let you “assign” a person to a checklist item.
        - Endpoint: assignChecklistItem(int itemId, int userId)

       // ✅ Set Item Due Date / Reminder
        - Add `dueDate` & `reminderTime` fields.
        - Endpoint: setChecklistItemDueDate(int itemId, DateTime dueDate)

       // ✅ Comment Thread per Checklist Item
        - Similar to cards, let users comment on a specific checklist item.

       // ✅ Attach Files to Items
        - Re‑use AttachmentEndpoint once it’s built.

       // ✅ Checklist Item Activity Log
        - Track who toggled, edited, or deleted an item.

       // ✅ Soft Delete (Archive) Items
        - Add `isArchived` boolean and endpoints to archive/unarchive.

       // ✅ Bulk Toggle / Bulk Delete
        - Endpoint to toggle or delete multiple items at once.

       // ✅ Convert Item → Card
        - Promote a checklist item into its own card (like Trello).
*/

