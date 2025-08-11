import 'package:karwaan_server/src/endpoints/role_check.dart';
import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class BoardMemberEndpoint extends Endpoint {
  // add member to board
  Future<BoardMember> addMemberToBoard(
      Session session, int boardId, String userToAddEmail, String token) async {
    // validate token(get user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or expired token!');
    }

    // check if the board has exists
    final board = await Board.db.findById(session, boardId);
    if (board == null) {
      throw Exception('Board not found!');
    }

    // confirm current user is member of board
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (b) => b.board.equals(boardId) & b.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw Exception('You are not a member of this board!');
    }
    if (membership.role != Roles.owner && membership.role != Roles.admin) {
      throw Exception('Only owner and admins can add members!');
    }

    // check if the user need to be acutally exists
    final targetUser = await User.db.findFirstRow(
      session,
      where: (p0) => p0.email.equals(userToAddEmail),
    );
    if (targetUser == null) {
      throw Exception('No user has been found!');
    }

    // board.workspaceId came from your Board model
    final targetUserMembership = await WorkspaceMember.db.findFirstRow(
      session,
      where: (w) =>
          w.workspace.equals(board.workspaceId) & w.user.equals(targetUser.id!),
    );
    if (targetUserMembership == null) {
      throw Exception('User is not a member of parent workspace!');
    }

    // check if the target user need to be add is not already a member of the board
    final boardMember = await BoardMember.db.findFirstRow(
      session,
      where: (b) => b.board.equals(boardId) & b.user.equals(targetUser.id!),
    );
    if (boardMember != null) {
      throw Exception('That user is already a member!');
    }

    try {
      // create and insert board member row for the new user
      final newBoardMember = BoardMember(
          user: targetUser.id!,
          board: boardId,
          joinedAt: DateTime.now(),
          role: Roles.member);

     final insertedMember = await BoardMember.db.insertRow(session, newBoardMember);

      return insertedMember;
    } catch (e) {
      throw Exception(e);
    }
  }

  // remove member from board
  Future<void> removeMemberFromBoard(
      Session session, int boardId, int userToRemoveId, String token) async {
    // validate token(get user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or expired token!');
    }

    // verify board exists
    final boardExists = await Board.db.findById(session, boardId);
    if (boardExists == null) {
      throw Exception('No board has been found!');
    }

    // confirm current user is a member of that board
    final boardMemberShip = await BoardMember.db.findFirstRow(
      session,
      where: (m) => m.board.equals(boardId) & m.user.equals(currentUser.id!),
    );
    if (boardMemberShip == null) {
      throw Exception('You are not a member of this board!');
    }
    if (boardMemberShip.role != Roles.owner) {
      throw Exception('Only owners can remove board members!');
    }

    // check user existings
    final checkRemoveUserExistings =
        await User.db.findById(session, userToRemoveId);
    if (checkRemoveUserExistings == null) {
      throw Exception('No user found!');
    }

    // find the target member row
    final targetMember = await BoardMember.db.findFirstRow(
      session,
      where: (b) => b.board.equals(boardId) & b.user.equals(userToRemoveId),
    );
    if (targetMember == null) {
      throw Exception('This user is not a member of this board');
    }

    // protect owner
    if (targetMember.role == Roles.owner) {
      // count how many owners are in this board
      final count = await BoardMember.db.count(
        session,
        where: (o) => o.board.equals(boardId) & o.role.equals(Roles.owner),
      );
      if (count <= 1) {
        throw Exception('Cannot remove the last board owner!');
      }
    }

    try {
      // delete membership row
      await BoardMember.db.deleteRow(session, targetMember);
    } catch (e) {
      throw Exception(e);
    }
  }

  // get board members
  Future<List<BoardMemberDetails>> getBoardMembers(
      Session session, int boardId, String token) async {
    // validate token(get the current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // confirm the board exists
    final board = await Board.db.findById(session, boardId);
    if (board == null) {
      throw Exception('No board found!');
    }

    // check the requester is a member of that board
    final requestor = await BoardMember.db.findFirstRow(
      session,
      where: (r) => r.board.equals(boardId) & r.user.equals(currentUser.id!),
    );
    if (requestor == null) {
      throw Exception('You are not a member of this board!');
    }

    try {
      // fetch all board member row
      final fetchedBoard = await BoardMember.db.find(
        session,
        where: (f) => f.board.equals(boardId),
      );

      // fetch all related user rows
      final userIds = fetchedBoard.map((e) => e.user).toSet();

      final users = await User.db.find(
        session,
        where: (u) => u.id.inSet(userIds),
      );

      List<BoardMemberDetails> detailedMembers = [];

      for (final member in fetchedBoard) {
        final user = users.firstWhere((element) => element.id == member.user);

        detailedMembers.add(BoardMemberDetails(
            userId: user.id!,
            userName: user.name,
            role: member.role!,
            joinedAt: member.joinedAt,
            email: user.email));
      }

      return detailedMembers;
    } catch (e) {
      throw Exception(e);
    }
  }

  // change board member roles
  Future<BoardMember> changeBoardMemberRole(Session session, int boardId,
      String token, int userToChangeRole, String newRole) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // cofirm board exists
    final board = await Board.db.findById(session, boardId);
    if (board == null) {
      throw Exception('No board found!');
    }

    // check requestor memberShip and role
    final requestor = await BoardMember.db.findFirstRow(
      session,
      where: (m) => m.board.equals(boardId) & m.user.equals(currentUser.id!),
    );
    if (requestor == null) {
      throw Exception('You are not a member of this board!');
    }
    if (requestor.role != Roles.owner && requestor.role != Roles.admin) {
      throw Exception('Only owner and admins can change members role!');
    }

    // confirm target user membership
    final targetMember = await BoardMember.db.findFirstRow(
      session,
      where: (b) => b.board.equals(boardId) & b.user.equals(userToChangeRole),
    );
    if (targetMember == null) {
      throw Exception('That user is not a member of this board!');
    }

    // protect owners
    if (targetMember.role == Roles.owner && newRole != Roles.owner) {
      // count owner
      final count = await BoardMember.db.count(
        session,
        where: (o) => o.board.equals(boardId) & o.role.equals(Roles.owner),
      );
      if (count <= 1) {
        throw Exception('Cannot demote the last board owner!');
      }
    }

    try {
      // Validate newRole is one of the allowed strings ('Owner', 'Admin', 'Member')
      const allowedRoles = {Roles.owner, Roles.admin, Roles.member};
      if (!allowedRoles.contains(newRole)) {
        throw Exception('Invalid role.');
      }

      // assign the new role
      if (targetMember.role == newRole) return targetMember;

      targetMember.role = newRole;

      // persist changes
      await BoardMember.db.updateRow(session, targetMember);

      return targetMember;
    } catch (e) {
      throw Exception(e);
    }
  }

  // leave board
  Future<void> leaveBoard(Session session, int boardId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or expired token!');
    }

    // confirm board exists
    final board = await Board.db.findById(session, boardId);
    if (board == null) {
      throw Exception('No board exists!');
    }

    // confirm user is a member of board
    final memberShip = await BoardMember.db.findFirstRow(session,
        where: (u) => u.board.equals(boardId) & u.user.equals(currentUser.id!));
    if (memberShip == null) {
      throw Exception('You are not a member of this board!');
    }

    // prevent the last owner from leaving
    if (memberShip.role == Roles.owner) {
      final count = await BoardMember.db.count(
        session,
        where: (b) => b.board.equals(boardId) & b.role.equals(Roles.owner),
      );
      if (count <= 1) {
        throw Exception(
            'You are the last owner! Assign a new owner before leaving!');
      }
    }

    try {
      // delete membership(leave board)
      await BoardMember.db.deleteRow(session, memberShip);
    } catch (e) {
      throw Exception(e);
    }
  }
}

/*

   Add later:
      
      1. Invite Member (with email invite & token)
       Send an email invitation with a join link to new users.
       Create a token or invite code that expires.
       Let users join board via invitation.

      2. Accept / Decline Invitation
       Handle invited users accepting or declining board invites.
       Update membership status accordingly.

      3. Get Member Roles / Permissions
       Return a list or map of roles and their allowed permissions.
       Useful for frontend to show user capabilities dynamically.

      4. Update Member Settings
       Allow members to update their notification preferences or other board-specific settings.

      5. Search Board Members
       Provide search or filter for board members by name, email, role, etc.

      7. Bulk Add Members
       Add multiple users to a board at once (e.g., batch import).

      8. Audit Log / History
       Track membership changes: role changes, additions, removals.
       Useful for admins to review member activity.

      9. Get Board Owner(s)
       Quickly get a list of owners or the primary owner.

      10. Transfer Ownership
       A method to transfer owner role explicitly from one user to another.
 
 */
