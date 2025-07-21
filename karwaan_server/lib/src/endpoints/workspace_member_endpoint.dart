import 'package:karwaan_server/src/endpoints/role_check.dart';
import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class WorkspaceMemberEndpoint extends Endpoint {
  // add members to workspace
  Future<WorkspaceMember> addMemberToWorkspace(
      Session session, int userToAddId, int workspaceId, String token) async {
    // validate token(get user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or expired token!');
    }

    // confirm current user workspace membership
    final member = await WorkspaceMember.db.findFirstRow(
      session,
      where: (u) =>
          u.workspace.equals(workspaceId) & u.user.equals(currentUser.id!),
    );
    if (member == null) {
      throw Exception('You are not a member of this workspace!');
    }
    if (member.role != Roles.owner && member.role != Roles.admin) {
      throw Exception('Only owner and admin can add members!!');
    }

    // check the user need to be add actually exists
    final newUser = await User.db.findById(session, userToAddId);
    if (newUser == null) {
      throw Exception("This user doesn't exists!");
    }

    // check the user need to be add is not already a member of the workspace
    final checkNewUser = await WorkspaceMember.db.findFirstRow(
      session,
      where: (n) =>
          n.workspace.equals(workspaceId) & n.user.equals(newUser.id!),
    );
    if (checkNewUser != null) {
      throw Exception('User is already a member of this workspace!');
    }

    // create and insert workspace member row for the new user
    final newWorkspaceMember = WorkspaceMember(
        user: newUser.id!,
        workspace: workspaceId,
        joinedAt: DateTime.now(),
        role: Roles.member);

    await WorkspaceMember.db.insertRow(session, newWorkspaceMember);

    return newWorkspaceMember;
  }

  // remove member from workspace
  Future<void> removeMemberFromWorkspace(Session session, int workspaceId,
      int userToRemoveId, String token) async {
    // validate token(get user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or expired token!');
    }

    // confirm current user membership
    final membership = await WorkspaceMember.db.findFirstRow(
      session,
      where: (m) =>
          m.workspace.equals(workspaceId) & m.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw Exception('You are not a member of this workspace!');
    }
    if (membership.role != Roles.owner) {
      throw Exception('Only owners can remove members!');
    }

    // check the user to remove is actually member of this workspace
    final targetMember = await WorkspaceMember.db.findFirstRow(
      session,
      where: (e) =>
          e.workspace.equals(workspaceId) & e.user.equals(userToRemoveId),
    );
    if (targetMember == null) {
      throw Exception("That user is not a member of this workspace");
    }

    // check if the target member is not an owner
    if (targetMember.role == Roles.owner) {
      // count all owners in this workspace
      final countOwner = await WorkspaceMember.db.count(
        session,
        where: (c) =>
            c.workspace.equals(workspaceId) & c.role.equals(Roles.owner),
      );
      if (countOwner <= 1) {
        throw Exception('Cannot remove the last owner from the workspace!');
      }
    }

    if (userToRemoveId == currentUser.id) {
      throw Exception(
          "You cannot remove yourself. Use 'leave workspace' instead.");
    }

    // safely remove the target owner
    await WorkspaceMember.db.deleteRow(session, targetMember);
  }

  // get workspace members
  Future<List<WorkspaceMemberDetails>> getWorkspaceMember(
      Session session, int workspaceId, String token) async {
    // validate token(get user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or expired token!');
    }

    // confirm the requester is a member of the workspace
    final requestor = await WorkspaceMember.db.findFirstRow(
      session,
      where: (r) =>
          r.workspace.equals(workspaceId) & r.user.equals(currentUser.id!),
    );
    if (requestor == null) {
      throw Exception('You are not a member!');
    }

    // fetch all the members for the workspace
    final members = await WorkspaceMember.db.find(
      session,
      where: (m) => m.workspace.equals(workspaceId),
    );

    // Fetch all users whose IDs appear in the workspace members
    final userIds = members.map((e) => e.user).toSet();

    final users = await User.db.find(
      session,
      where: (u) => u.id.inSet(userIds),
    );

    List<WorkspaceMemberDetails> detailedMembers = [];

    for (final member in members) {
      final user = users.firstWhere((element) => element.id == member.user);

      detailedMembers.add(WorkspaceMemberDetails(
          userId: user.id!,
          userName: user.name,
          role: member.role!,
          joinedAt: member.joinedAt,
          email: user.email));
    }

    return detailedMembers;
  }

  // change member role
  Future<WorkspaceMember> changeMemberRole(Session session, int workspaceId,
      String token, int targetUserId, String newRole) async {
    // validate token(get user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or expired token!');
    }

    // cofirm current user is a member of workspace
    final currentMemberCheck = await WorkspaceMember.db.findFirstRow(
      session,
      where: (c) =>
          c.workspace.equals(workspaceId) & c.user.equals(currentUser.id!),
    );
    if (currentMemberCheck == null) {
      throw Exception('You are not a member!');
    }

    // check current user role
    if (currentMemberCheck.role != Roles.owner &&
        currentMemberCheck.role != Roles.admin) {
      throw Exception('Only owner and admin can change the member roles!!');
    }

    // find the target member in the workspace by id
    final targetMember = await WorkspaceMember.db.findFirstRow(
      session,
      where: (p0) =>
          p0.workspace.equals(workspaceId) & p0.user.equals(targetUserId),
    );
    if (targetMember == null) {
      throw Exception('This user is not a member of workspace!');
    }

    // prevent role change that would remove the last owner
    // check if the target member is not an owner
    if (targetMember.role == Roles.owner) {
      // count all owners in this workspace
      final countOwner = await WorkspaceMember.db.count(
        session,
        where: (c) =>
            c.workspace.equals(workspaceId) & c.role.equals(Roles.owner),
      );
      if (countOwner <= 1) {
        throw Exception('Cannot remove the last owner from the workspace!');
      }
    }

    // valid new role
    final validRoles = [Roles.owner, Roles.admin, Roles.member];
    if (!validRoles.contains(newRole)) {
      throw Exception('Invalid role provided!');
    }

    // assgin the new role to the target user
    targetMember.role = newRole;

    // persist changes
    await WorkspaceMember.db.updateRow(session, targetMember);

    return targetMember;
  }

  // leave workspace
  Future<void> leaveWorkspace(
      Session session, int workspaceId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // check if the workspace exists
    final workspace = await Workspace.db.findById(session, workspaceId);
    if (workspace == null) {
      throw Exception('No workspace found!');
    }

    // check if the requestor is a member of workspace
    final requestor = await WorkspaceMember.db.findFirstRow(
      session,
      where: (w) =>
          w.workspace.equals(workspaceId) & w.user.equals(currentUser.id!),
    );
    if (requestor == null) {
      throw Exception('You are not a member of this workspace!');
    }

    // last owner protection
    if (requestor.role == Roles.owner) {
      final count = await WorkspaceMember.db.count(
        session,
        where: (c) =>
            c.workspace.equals(workspaceId) & c.role.equals(Roles.owner),
      );
      if (count <= 1) {
        throw Exception(
            'You are the last owner! Assing a new owner before leaving the workspace!');
      }
    }

    // delete membership (leave workspace)
    await WorkspaceMember.db.deleteRow(session, requestor);
  }
}

 /*

   Add later:
      
      1. Invite Member (with email invite & token)
       Send an email invitation with a join link to new users.
       Create a token or invite code that expires.
       Let users join workspace via invitation.

      2. Accept / Decline Invitation
       Handle invited users accepting or declining workspace invites.
       Update membership status accordingly.

      3. Get Member Roles / Permissions
       Return a list or map of roles and their allowed permissions.
       Useful for frontend to show user capabilities dynamically.

      4. Update Member Settings
       Allow members to update their notification preferences or other workspace-specific settings.

      5. Search Workspace Members
       Provide search or filter for workspace members by name, email, role, etc.

      7. Bulk Add Members
       Add multiple users to a workspace at once (e.g., batch import).

      8. Audit Log / History
       Track membership changes: role changes, additions, removals.
       Useful for admins to review member activity.

      9. Get Workspace Owner(s)
       Quickly get a list of owners or the primary owner.

      10. Transfer Ownership
       A method to transfer owner role explicitly from one user to another.
 
 */