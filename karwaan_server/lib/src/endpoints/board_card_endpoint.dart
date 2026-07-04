import 'package:karwaan_server/src/endpoints/card_label_endpoint.dart';
import 'package:karwaan_server/src/endpoints/role_check.dart';
import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class BoardCardEndpoint extends Endpoint {
  // create card
  Future<BoardCard> createBoardCard(
      Session session, int boardListId, String token, String title,
      {String? dec,
      List<int>? assignedUserIds,
      List<int>? assignedLabelIds}) async {
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

      if (assignedUserIds != null && assignedUserIds.isNotEmpty) {
        await assignUsersToCard(
            session, insertedCard.id!, token, assignedUserIds);
      }

      if (assignedLabelIds != null && assignedLabelIds.isNotEmpty) {
        for (final assignLabelId in assignedLabelIds) {
          await CardLabelEndpoint().assignLableToCard(
              session, assignLabelId, insertedCard.id!, token);
        }
      }
      if (assignedLabelIds != null && assignedLabelIds.length > 4) {
        throw RandomAppException(message: 'Max 4 labels allowed per card');
      }
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

      final cardsWithAssignees = <BoardCard>[];
      for (final card in fetch) {
        final assignments = await BoardCardAssignment.db
            .find(session, where: (a) => a.card.equals(card.id!));
        final assignedUserIds = assignments.map((a) => a.user).toList();

        final cardWithAssignees = card.copyWith(assignedUsers: assignedUserIds);
        cardsWithAssignees.add(cardWithAssignees);
      }

      return cardsWithAssignees;
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

  Future<List<BoardCard>> getAllUserCards(Session session, String token) async {
    final user = await TokenEndpoint().validateToken(session, token);
    if (user == null || user.id == null) {
      throw AppAuthException(message: 'No user or expired token!');
    }

    try {
      // Get all workspaces user member of
      final workspaces = await WorkspaceMember.db.find(
        session,
        where: (p0) => p0.user.equals(user.id!),
      );
      if (workspaces.isEmpty) {
        return [];
      }

      final workspaceId = workspaces.map((i) => i.workspace).toSet();

      // get all boards in user workspaces
      final boards = await Board.db.find(
        session,
        where: (p0) => p0.workspaceId.inSet(workspaceId),
      );
      if (boards.isEmpty) {
        return [];
      }

      final boardIds = boards.map((b) => b.id!).toSet();

      // get all lists in these boards
      final boardlist = await BoardList.db.find(
        session,
        where: (p0) => p0.board.inSet(boardIds),
      );
      if (boardlist.isEmpty) {
        return [];
      }

      final boardlistIds = boardlist.map((l) => l.id!).toSet();

      // get all cards in these lists
      final cards = await BoardCard.db.find(session,
          where: (p0) => p0.list.inSet(boardlistIds),
          orderBy: (p0) => p0.createdAt);

      final cardsWithAssignees = <BoardCard>[];
      for (final card in cards) {
        final assignments = await BoardCardAssignment.db
            .find(session, where: (a) => a.card.equals(card.id!));

        final assignedUserIds = assignments.map((a) => a.user).toList();

        final cardWithAssignees = card.copyWith(assignedUsers: assignedUserIds);
        cardsWithAssignees.add(cardWithAssignees);
      }
      return cardsWithAssignees;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(message: 'Failed to get all card. Please try again.');
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

  // assign users to a card
  Future<List<BoardCardAssignment>> assignUsersToCard(
      Session session, int cardId, String token, List<int> userIds) async {
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or expired token!');
    }

    // fetch cards
    final card = await BoardCard.db.findById(session, cardId);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }

    // check permission
    final boardList = await BoardList.db.findById(session, card.list);
    if (boardList == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }

    final membership = await BoardMember.db.findFirstRow(session,
        where: (m) =>
            m.board.equals(boardList.board) & m.user.equals(currentUser.id!));
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not a member of the parent board!');
    }

    final assignements = <BoardCardAssignment>[];

    try {
      // process each user
      for (final userId in userIds) {
        // check for user
        final userToAssing = await User.db.findById(session, userId);
        if (userToAssing == null) {
          throw AppNotFoundException(resourceType: 'User');
        }

        // check for user membership in parent board
        final userMembership = await BoardMember.db.findFirstRow(session,
            where: (m) =>
                m.board.equals(boardList.board) & m.user.equals(userId));
        if (userMembership == null) {
          throw AppPermissionException(
              message:
                  'User ID $userId is not a member of this board and cannot be assigned!');
        }

        // check if already assigned
        final existingAssignment = await BoardCardAssignment.db.findFirstRow(
            session,
            where: (m) => m.card.equals(cardId) & m.user.equals(userId));
        if (existingAssignment == null) {
          final assignment = BoardCardAssignment(
              card: cardId,
              user: userId,
              assignedBy: currentUser.id!,
              assignedAt: DateTime.now());

          final inserted =
              await BoardCardAssignment.db.insertRow(session, assignment);
          assignements.add(inserted);
        }
      }

      if (assignements.isNotEmpty) {
        final allAssignments = await BoardCardAssignment.db
            .find(session, where: (a) => a.card.equals(cardId));
        final allAssignedUserIds = allAssignments.map((a) => a.user).toList();

        final card = await BoardCard.db.findById(session, cardId);
        if (card != null) {
          final updatedCard = card.copyWith(assignedUsers: allAssignedUserIds);
          await BoardCard.db.updateRow(session, updatedCard);
        }
      }

      return assignements;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(message: 'Failed to assign user. Please try again.');
    }
  }

  // remove user from a card
  Future<bool> removeUserFromCard(
      Session session, int cardId, String token, List<int> userIds) async {
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or expired token!');
    }

    // fetch the card
    final card = await BoardCard.db.findById(session, cardId);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }

    // Check permission
    final boardList = await BoardList.db.findById(session, card.list);
    if (boardList == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }

    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (m) =>
          m.board.equals(boardList.board) & m.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not a member of the parent board!');
    }

    // Optional: Only allow removing assignments if you're the one who assigned them or you're an admin/owner
    // For now, allow any board member to remove assignments
    try {
      for (final userId in userIds) {
        await BoardCardAssignment.db.deleteWhere(
          session,
          where: (a) => a.card.equals(cardId) & a.user.equals(userId),
        );
      }

      final remainingAssignments = await BoardCardAssignment.db
          .find(session, where: (a) => a.card.equals(cardId));
      final remaingUserIds = remainingAssignments.map((a) => a.user).toList();

      final card = await BoardCard.db.findById(session, cardId);
      if (card != null) {
        final updatedCard = card.copyWith(assignedUsers: remaingUserIds);
        await BoardCard.db.updateRow(session, updatedCard);
      }

      return true;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to remove assigned user. Please try again.');
    }
  }

// Get all assigned users for a card with details
  Future<List<User>> getCardAssignees(
    Session session,
    int cardId,
    String token,
  ) async {
    // Validate token
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or expired token!');
    }

    // Fetch card
    final card = await BoardCard.db.findById(session, cardId);
    if (card == null) {
      throw AppNotFoundException(resourceType: 'Card');
    }

    // Check permission
    final boardList = await BoardList.db.findById(session, card.list);
    if (boardList == null) {
      throw AppNotFoundException(resourceType: 'Boardlist');
    }

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
      // Get all assignments for this card
      final assignments = await BoardCardAssignment.db.find(
        session,
        where: (a) => a.card.equals(cardId),
      );

      if (assignments.isEmpty) {
        return [];
      }

      // Get all user IDs
      final userIds = assignments.map((a) => a.user).toSet();

      // Fetch all users
      final users = await User.db.find(
        session,
        where: (u) => u.id.inSet(userIds),
      );

      return users;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to fetch assigned users. Please try again.');
    }
  }

// Get all cards assigned to current user
  Future<List<BoardCard>> getMyAssignedCards(
    Session session,
    String token,
  ) async {
    // Validate token
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or expired token!');
    }

    try {
      // Get all assignments for this user
      final assignments = await BoardCardAssignment.db.find(
        session,
        where: (a) => a.user.equals(currentUser.id!),
      );

      if (assignments.isEmpty) {
        return [];
      }

      final cardIds = assignments.map((a) => a.card).toSet();

      // Get all cards
      final cards = await BoardCard.db.find(
        session,
        where: (c) => c.id.inSet(cardIds),
        orderBy: (c) => c.createdAt,
      );

      final cardsWithAssignees = <BoardCard>[];
      for (final card in cards) {
        final cardAssignments = await BoardCardAssignment.db
            .find(session, where: (a) => a.card.equals(card.id!));
        final assignedUserIds = cardAssignments.map((a) => a.user).toList();
        final cardWithAssignees = card.copyWith(assignedUsers: assignedUserIds);
        cardsWithAssignees.add(cardWithAssignees);
      }

      return cardsWithAssignees;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to fetch your assigned cards. Please try again.');
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
