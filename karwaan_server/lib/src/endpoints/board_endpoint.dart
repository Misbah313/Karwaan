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

    // get the current workspace
    final currentWorkspace = await Workspace.db
        .findFirstRow(session, where: (b) => b.id.equals(workspaceId));
    if (currentWorkspace == null) {
      throw Exception("Workspace doesn't exists!");
    }

    // check the user is a member in that workspace
    if (currentUser == null || currentUser.id == null) {
      throw Exception("Invalid user or user ID.");
    }
    final membership = await WorkspaceMember.db.findFirstRow(session,
        where: (m) =>
            m.user.equals(currentUser.id!) & m.workspace.equals(workspaceId));
    if (membership == null) {
      throw Exception('You are not member of this workspace!');
    }

    // check and trim the board name
    if (name.trim().isEmpty) {
      throw Exception("Board name can't be empty!");
    }

    // check for board name duplicates
    final existingNames = await Board.db.findFirstRow(
      session,
      where: (n) =>
          n.name.equals(name.trim()) & n.workspaceId.equals(workspaceId),
    );

    if (existingNames != null) {
      throw Exception(
          "A board with that name already exists in this workspace.");
    }

    try {
      // create a board
      final createdBoard = Board(
          name: name.trim(),
          workspaceId: workspaceId,
          createdBy: currentUser.id!,
          createdAt: DateTime.now(),
          description: description);

      // insert the created board to db
      await Board.db.insertRow(session, createdBoard);

      // board member
      final boardmember = BoardMember(
          user: currentUser.id!,
          board: createdBoard.id!,
          joinedAt: DateTime.now(),
          role: Roles.owner);

      // insert the new member to board members
      await BoardMember.db.insertRow(session, boardmember);

      return createdBoard;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Get user boards
  Future<BoardDetails> getUserBoard(
      Session session, int boardId, String token) async {
    // get the current user(validate their token)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // confirm membership
    final isMember = await BoardMember.db.findFirstRow(session,
        where: (b) => b.user.equals(currentUser.id) & b.board.equals(boardId));
    if (isMember == null) {
      throw Exception("You're not a member of this board");
    }

    // fetch the board for that user
    final board = await Board.db.findById(session, boardId);
    if (board == null) {
      throw Exception("Board not found!");
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
          name: board.name,
          members: memberNames,
          description: board.description);

      return boardDetails;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Get all boards where user is a member
  Future<List<BoardDetails>> getUserBoards(
      Session session, String token) async {
    // 1. Validate user token
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
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
          name: board.name,
          members: memberNames,
          description: board.description,
        ));
      }

      // 7. Return list of board details
      return boardDetailsList;
    } catch (e) {
      throw Exception(e);
    }
  }

  // updated board
  Future<Board> updateBoard(Session session, int boardId, String token,
      {String? newName, String? newDec}) async {
    // get the current user<validate token>
    final currentUser = await TokenEndpoint().validateToken(session, token);

    if (currentUser == null || currentUser.id == null) {
      throw Exception('Invalid user or inspired token!!');
    }

    // get the board by id
    final board = await Board.db
        .findFirstRow(session, where: (u) => u.id.equals(boardId));
    if (board == null) {
      throw Exception('No board found!');
    }

    // check user permission(should be Owner)
    final member = await BoardMember.db.findFirstRow(session,
        where: (b) => b.board.equals(boardId) & b.user.equals(currentUser.id!));
    if (member == null) {
      throw Exception('You are not a member!');
    }
    if (member.role != Roles.owner && member.role != Roles.admin) {
      throw Exception('Only owner and admin can update the board!!');
    }

    // Store original values before changes
    final originalName = board.name;
    final originalDec = board.description;

    // validate new values
    if (newName != null) {
      final trimmedName = newName.trim();
      if (trimmedName.isEmpty) {
        throw Exception('Board name cannot be empty!');
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
        throw Exception(
            'Another board with the same name already exists in the workspace!');
      }

      board.name = trimmedName;
    }

    if (newDec != null) {
      board.description = newDec.trim();
    }

    // No-op guard: check if anything actually changed
    if (board.name == originalName && board.description == originalDec) {
      return board; // Nothing to update
    }

    try {
      // persists changes
      await Board.db.updateRow(session, board);

      return board;
    } catch (e) {
      throw Exception(e);
    }
  }

  // delete board
  Future<bool> deleteBoard(Session session, int boardId, String token) async {
    // get the current user(validate token)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('Invalid User or expired token!!');
    }

    // Load the board
    final board = await Board.db.findById(session, boardId);
    if (board == null) {
      throw Exception('No board found!');
    }

    // check current user membership
    final member = await BoardMember.db.findFirstRow(
      session,
      where: (m) => m.board.equals(boardId) & m.user.equals(currentUser.id!),
    );
    if (member == null) {
      throw Exception('You are not a member!');
    }
    if (member.role != Roles.owner && member.role != Roles.admin) {
      throw Exception('Only owner and admin can delete a board!!');
    }

    try {
      // perform  member deletion
      await BoardMember.db
          .deleteWhere(session, where: (i) => i.board.equals(boardId));

      // perform board deletion
      await Board.db.deleteRow(session, board);

      return true;
    } catch (e) {
      throw Exception(e);
    }
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