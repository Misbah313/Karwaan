import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class WorkspaceEndpoint extends Endpoint {
  // Create workspce
  Future<Workspace> createWorkspace(
      Session session, String name, String? description, String token) async {
    // check the current user login(validate the token)
    final user = await TokenEndpoint().validateToken(session, token);

    if (user == null) {
      throw Exception('Invalid or expired token!');
    }

    try {
      final createdWorkspace = Workspace(
        name: name,
        description: description,
        createdAt: DateTime.now(),
        ownerId: user.id!,
      );

      await Workspace.db.insertRow(session, createdWorkspace);

      final ownerMember = WorkspaceMember(
          user: user.id!,
          role: 'Owner',
          workspace: createdWorkspace.id!,
          joinedAt: DateTime.now());

      await WorkspaceMember.db.insertRow(session, ownerMember);
      return createdWorkspace;
    } catch (e) {
      throw Exception('Failed to create Workspace: $e');
    }
  }

  // Get user workspaces
  Future<List<Workspace>> getUserWorkspace(
      Session session, String token) async {
    // check the current user login(validate the token)
    final user = await TokenEndpoint().validateToken(session, token);

    if (user == null) {
      throw Exception('User not found/ inValid token!');
    }

    // 2. Find all WorkspaceMember rows where user == current user ID
    final members = await WorkspaceMember.db.find(
      session,
      where: (t) => t.user.equals(user.id!),
    );

    // 3. Extract workspace IDs from those rows
    final workspaceId = members.map((m) => m.workspace).toSet();
    // 4. Use Workspace.db.findByIds(...) to get the actual Workspace list
    final workspaces = await Workspace.db.find(
      session,
      where: (t) => t.id.inSet(workspaceId),
    );
    // 5. Return that list
    return workspaces;
  }

  // Add member to workspace
  Future<void> addMemberToWorkspace(Session session, int workspaceId,
      int userToAddId, String role, String token) async {
    // check the current user login(validate the token)
    final user = await TokenEndpoint().validateToken(session, token);

    if (user == null) {
      throw Exception('User not found/ inValid token!');
    }

    // 2. Look up their WorkspaceMember entry in this workspace
    final currentMemberShip = await WorkspaceMember.db.findFirstRow(session,
        where: (t) => t.user.equals(user.id) & t.workspace.equals(workspaceId));
    // 3. If their role is not 'Owner' or 'Admin', throw error
    if (currentMemberShip == null ||
        (currentMemberShip.role != 'Owner' &&
            currentMemberShip.role != 'Admin')) {
      throw Exception(
          'Permission denied: Only Owner or Admin can add members.');
    }

    // 4. Check if userIdToAdd is already a member of this workspace
    final existingMember = await WorkspaceMember.db.findFirstRow(session,
        where: (t) =>
            t.user.equals(userToAddId) & t.workspace.equals(workspaceId));
    // 5. If yes, throw error
    if (existingMember != null) {
      throw Exception('This user is already a member of this workspace!');
    }

    try {
      // 6. Create WorkspaceMember entry with workspaceId, userIdToAdd, role, DateTime.now()
      final newMember = WorkspaceMember(
          user: userToAddId,
          workspace: workspaceId,
          joinedAt: DateTime.now(),
          role: role);

      // 7. Insert into database
      await WorkspaceMember.db.insertRow(session, newMember);
    } catch (e) {
      throw Exception('Failed to add member: $e');
    }
  }

  // Remove member from workspace
  Future<void> removeMemFromWorkspace(Session session, int workspaceId,
      int userToRemoveId, String token) async {
    // get the current user(validate the token)
    final currentUser = await TokenEndpoint().validateToken(session, token);

    // Check If Current User Has Access
    final accessedUser = await WorkspaceMember.db.findFirstRow(
      session,
      where: (w) =>
          w.workspace.equals(workspaceId) & w.user.equals(currentUser?.id!),
    );

    // if the user is not a member of workspace throw error
    if (accessedUser == null) {
      throw Exception('You’re not even in this workspace.');
    }

    // get the current user role in this workspace
    if (accessedUser.role != 'Owner' && accessedUser.role != 'Admin') {
      throw Exception('Permission denied!');
    }

    //  Safety Check: Prevent Removing the Owner(check if the user you want to remove is not owner of admin)
    final userToRemoveMem = await WorkspaceMember.db.findFirstRow(
      session,
      where: (u) =>
          u.workspace.equals(workspaceId) & u.user.equals(userToRemoveId),
    );

    // if user to remove member is not a part of workspace of a member then throw error
    if (userToRemoveMem == null) {
      throw Exception('User to remove is not part of the workspace.');
    }

    // if user to remove member is the Owner throw error
    if (userToRemoveMem.role == 'Owner') {
      throw Exception(
          "Owner can't remove themselves. Transfer ownership first.");
    }

    // otherwise perform deletion
    try {
      await WorkspaceMember.db.deleteWhere(session,
          where: (t) =>
              t.user.equals(userToRemoveId) & t.workspace.equals(workspaceId));
    } catch (e) {
      throw Exception('Failed to remove member: $e');
    }
  }

  // Update workspace
  Future<Workspace> updateWorkspace(
      Session session, int workspaceId, String token,
      {String? newName, String? newDes}) async {
    // check the current user(validate the token)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null) {
      throw Exception('Invalid or expired token!');
    }

    // confirm the current user is a member of workspace
    final membership = await WorkspaceMember.db.findFirstRow(
      session,
      where: (c) =>
          c.user.equals(currentUser.id) & c.workspace.equals(workspaceId),
    );
    if (membership == null) {
      throw Exception('Your are not a member of this workspace!');
    }

    // check the current user role in the workspace
    if (membership.role != 'Owner') {
      throw Exception('Only Owner/Admin can update workspace.');
    }

    // fetch the existing workspace
    final workspace = await Workspace.db.findById(session, workspaceId);

    if (workspace == null) {
      throw Exception('Workspace not found!');
    }

    // check if the new Name and description are valid and trimed
    if (newName != null) {
      if (newName.trim().isEmpty) {
        throw Exception('Workspace name cannot be empty!');
      }
      workspace.name = newName.trim();
    }

    if (newDes != null) {
      workspace.description = newDes.trim();
    }

    // update the workspace with new name and dec
    try {
      await Workspace.db.updateRow(session, workspace);
      return workspace;
    } catch (e) {
      throw Exception('Failed to update workspace: $e');
    }
  }

  // Delete workspace
  Future<bool> deleteWorkspace(
      Session session, int workspaceId, String token) async {
    // get the current user(validate token)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null) {
      throw Exception('Invalid or expired token!');
    }

    // find the workspace
    final workspace = await Workspace.db.findById(session, workspaceId);
    if (workspace == null) {
      throw Exception('No workspace found');
    }

    final member = await WorkspaceMember.db.findFirstRow(
      session,
      where: (w) =>
          w.user.equals(currentUser.id) & w.workspace.equals(workspace.id),
    );
    if (member == null) {
      throw Exception('You are not a member of this workspace!');
    }

    // is the user owner of this workspace
    if (member.role != 'Owner') {
      throw Exception('Only owners can delete workspace!');
    }
    try {
      // delete maually workspace memebers before deleting workspace
      await WorkspaceMember.db
          .deleteWhere(session, where: (m) => m.workspace.equals(workspaceId));

      // delete the workspace
      await Workspace.db.deleteRow(session, workspace);
      return true;
    } catch (e) {
      throw Exception('Failed to delete workspace: $e');
    }
  }
}

/*

 WHAT CAN BE ADD LATER:
   🔄 Invite via Email:	Invite users not yet registered (pending invites?).
   👀 View All Members:	See all members & roles in workspace.
   🔄 Change Member Role:	Promote to Admin / Demote.
   📦 Archive Workspace:	Soft-delete instead of hard-delete.
   🧩 Workspace Settings:	Rename, change visibility (public/private), avatar, etc.
   📊 Workspace Analytics:	Number of boards, users, tasks, etc.
 */
