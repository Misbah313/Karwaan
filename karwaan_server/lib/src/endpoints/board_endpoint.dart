import 'package:karwaan_server/src/endpoints/role_check.dart';
import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class BoardEndpoint extends Endpoint {
  // Create board
  Future<Board> createBoard(Session session, int workspaceId, String name,
      String? description, String token) async {
    // get the current user(validate token)
    final currentUser = await TokenEndpoint().validateToken(session, token);

    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token');
    }

    // get the current workspace
    final currentWorkspace = await Workspace.db.findById(session, workspaceId);
    if (currentWorkspace == null) {
      throw AppNotFoundException(resourceType: 'Workspace');
    }

    final membership = await WorkspaceMember.db.findFirstRow(session,
        where: (m) =>
            m.user.equals(currentUser.id!) & m.workspace.equals(workspaceId));
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not member of this workspace!');
    }

    // check and trim the board name
    if (name.trim().isEmpty) {
      throw RandomAppException(message: "Board name can't be empty!");
    }

    // check for board name duplicates
    final existingNames = await Board.db.findFirstRow(
      session,
      where: (n) =>
          n.name.equals(name.trim()) & n.workspaceId.equals(workspaceId),
    );

    if (existingNames != null) {
      throw RandomAppException(
          message: "A board with that name already exists in this workspace.");
    }

    try {
      // create a board
      final createdBoard = Board(
          name: name.trim(),
          workspaceId: workspaceId,
          createdBy: currentUser.id!,
          createdAt: DateTime.now(),
          description: description ?? '');

      // insert the created board to db
      final insertedBoard = await Board.db.insertRow(session, createdBoard);

      // board member
      final boardmember = BoardMember(
          user: currentUser.id!,
          board: insertedBoard.id!,
          joinedAt: DateTime.now(),
          role: Roles.owner);

      // insert the new member to board members
      await BoardMember.db.insertRow(session, boardmember);

      return insertedBoard;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(message: 'Failed to create board. Please try again.');
    }
  }

  // Get user boards
  Future<BoardDetails> getUserBoard(
      Session session, int boardId, String token) async {
    // get the current user(validate their token)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token!');
    }

    // fetch the board for that user
    final board = await Board.db.findById(session, boardId);
    if (board == null) {
      throw AppNotFoundException(resourceType: 'Board');
    }

    // confirm membership
    final isMember = await BoardMember.db.findFirstRow(session,
        where: (b) => b.user.equals(currentUser.id) & b.board.equals(boardId));
    if (isMember == null) {
      throw AppPermissionException(
          message: "You're not a member of this board");
    }

    try {
      // find all members in this board
      final members = await BoardMember.db.find(
        session,
        where: (m) => m.board.equals(boardId),
      );

      // Extract user IDs
      final userId = members.map((e) => e.user).toSet();

      // Fetch user obj for those IDs
      final users =
          await User.db.find(session, where: (u) => u.id.inSet(userId));

      // Extract just member names
      final memberNames = users.map((e) => e.name).toList();

      // assemble board details
      final boardDetails = BoardDetails(
          id: board.id!,
          workspaceId: board.workspaceId,
          name: board.name,
          members: memberNames,
          description: board.description,
          createdAt: DateTime.now());

      return boardDetails;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to get user boards. Please try again.');
    }
  }

  // Get all boards where user is a member
  Future<List<BoardDetails>> getUserBoards(
      Session session, String token) async {
    // 1. Validate user token
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token!');
    }

    try {
      // 2. Find all board memberships for this user
      final memberships = await BoardMember.db.find(
        session,
        where: (bm) => bm.user.equals(currentUser.id!),
      );

      // 3. Extract board IDs
      final boardIds = memberships.map((m) => m.board).toSet();

      if (boardIds.isEmpty) {
        // 4. Return empty list if no boards
        return [];
      }

      // 5. Fetch boards by IDs
      final boards = await Board.db.find(
        session,
        where: (b) => b.id.inSet(boardIds),
      );

      // 6. For each board, fetch members and assemble details
      List<BoardDetails> boardDetailsList = [];

      for (final board in boards) {
        // Find members of this board
        final members = memberships.where((m) => m.board == board.id).toList();

        // Extract user IDs for members of this board
        final userIds = members.map((m) => m.user).toSet();

        // Fetch user objects
        final users =
            await User.db.find(session, where: (u) => u.id.inSet(userIds));

        // Extract member names
        final memberNames = users.map((u) => u.name).toList();

        // Create board details
        boardDetailsList.add(BoardDetails(
            id: board.id!,
            workspaceId: board.workspaceId,
            name: board.name,
            members: memberNames,
            description: board.description,
            createdAt: DateTime.now()));
      }

      // 7. Return list of board details
      return boardDetailsList;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to get user board. Please try again.');
    }
  }

  // updated board
  Future<Board> updateBoard(Session session, int boardId, String token,
      {String? newName, String? newDec}) async {
    // get the current user<validate token>
    final currentUser = await TokenEndpoint().validateToken(session, token);

    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'Invalid user or inspired token!!');
    }

    // get the board by id
    final board = await Board.db
        .findFirstRow(session, where: (u) => u.id.equals(boardId));
    if (board == null) {
      throw AppNotFoundException(resourceType: 'Board');
    }

    final workspace = await Workspace.db.findById(session, board.workspaceId);
    if (workspace == null) {
      throw AppNotFoundException(resourceType: 'Workspace');
    }

    // check user permission(should be Owner)
    final member = await BoardMember.db.findFirstRow(session,
        where: (b) => b.board.equals(boardId) & b.user.equals(currentUser.id!));
    if (member == null) {
      throw AppPermissionException(message: 'You are not a member!');
    }
    if (member.role != Roles.owner && member.role != Roles.admin) {
      throw AppPermissionException(
          message: 'Only owner and admin can update the board!!');
    }

    // Store original values before changes
    final originalName = board.name;
    final originalDec = board.description;

    // validate new values
    if (newName != null) {
      final trimmedName = newName.trim();
      if (trimmedName.isEmpty) {
        throw RandomAppException(message: 'Board name cannot be empty!');
      }

      // check duplicate name withten the workspace
      final duplicate = await Board.db.findFirstRow(
        session,
        where: (d) =>
            d.id.notEquals(boardId) &
            d.name.equals(trimmedName) &
            d.workspaceId.equals(board.workspaceId),
      );
      if (duplicate != null) {
        throw RandomAppException(
            message:
                'Another board with the same name already exists in the workspace!');
      }

      board.name = trimmedName;
    }

    if (newDec != null) {
      board.description = newDec.trim();
    }

    // No-op guard: check if anything actually changed
    final nameChanged =
        newName != null && newName.trim() != originalName.trim();
    final descChanged = newDec != null && newDec.trim() != (originalDec.trim());
    if (!nameChanged && !descChanged) {
      return board; // No changes
    }

    try {
      // persists changes
      await Board.db.updateRow(session, board);

      return board;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(message: 'Failed to update board. Please try again.');
    }
  }

  // delete board
  Future<bool> deleteBoard(Session session, int boardId, String token) async {
    // get the current user(validate token)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'Invalid User or expired token!!');
    }

    // Load the board
    final board = await Board.db.findById(session, boardId);
    if (board == null) {
      throw AppNotFoundException(resourceType: 'Board');
    }

    // check current user membership
    final member = await BoardMember.db.findFirstRow(
      session,
      where: (m) => m.board.equals(boardId) & m.user.equals(currentUser.id!),
    );
    if (member == null) {
      throw AppPermissionException(message: 'You are not a member!');
    }
    if (member.role != Roles.owner && member.role != Roles.admin) {
      throw AppPermissionException(
          message: 'Only owner and admin can delete a board!!');
    }

    try {
      // perform  member deletion
      await BoardMember.db
          .deleteWhere(session, where: (i) => i.board.equals(boardId));

      // perform board deletion
      await Board.db.deleteRow(session, board);

      return true;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(message: 'Failed to delete board. Please try again.');
    }
  }

  // get boards by workspace
  Future<List<BoardDetails>> getBoardsByWorkspace(
    Session session,
    int workspaceId,
    String token,
  ) async {
    // Validate user token
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw AppAuthException(message: 'No user or invalid token!');
    }

    // Check workspace exists
    final workspace = await Workspace.db.findById(session, workspaceId);
    if (workspace == null) {
      throw AppNotFoundException(resourceType: 'Workspace');
    }

    // Check user membership in workspace
    final membership = await WorkspaceMember.db.findFirstRow(session,
        where: (m) =>
            m.user.equals(currentUser.id!) & m.workspace.equals(workspaceId));
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not a member of this workspace!');
    }

    // Fetch all boards in the workspace
    final boards = await Board.db.find(
      session,
      where: (b) => b.workspaceId.equals(workspaceId),
    );

    // Convert to BoardDetails without members info
    final boardDetailsList = boards.map((board) {
      return BoardDetails(
        id: board.id!,
        workspaceId: board.workspaceId,
        name: board.name,
        description: board.description,
        createdAt: board.createdAt,
        members: [], // empty list since you don't want to fetch members here
      );
    }).toList();

    return boardDetailsList;
  }
}

 /*

  Add later:
   
    - add memeber to board
    - remove member from board
    - get boards member
    - change member role
    - reOrder list(🔶 Great UX, not critical for v1, but important later for drag-drop.)
    - archeived board(🟣 Soft-delete instead of full removal.)
 */