import 'package:karwaan_server/src/endpoints/role_check.dart';
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
      throw AppAuthException(message: 'Invalid or expired token!');
    }

    try {
      final now = DateTime.now();

      final createdWorkspace = Workspace(
        name: name,
        description: description,
        createdAt: now,
        ownerId: user.id!,
      );

      await Workspace.db.insertRow(session, createdWorkspace);

      final insertedWorkspace = (await Workspace.db.findFirstRow(
        session,
        where: (p0) =>
            p0.name.equals(name) &
            p0.ownerId.equals(user.id!) &
            p0.createdAt.equals(now),
      ));

      if (insertedWorkspace == null) {
        throw RandomAppException(
            message: 'Failed to retrieve inserted worksapce.');
      }

      final ownerMember = WorkspaceMember(
          user: user.id!,
          role: Roles.owner,
          workspace: insertedWorkspace.id!,
          joinedAt: now);

      await WorkspaceMember.db.insertRow(session, ownerMember);
      return insertedWorkspace;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to create workspace. Please try again.');
    }
  }

  // Get user workspaces
  Future<List<Workspace>> getUserWorkspace(
      Session session, String token) async {
    // check the current user login(validate the token)
    final user = await TokenEndpoint().validateToken(session, token);

    if (user == null) {
      throw AppAuthException(message: 'Invalid user or expired token!');
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

  // Update workspace
  Future<Workspace> updateWorkspace(
      Session session, int workspaceId, String token,
      {String? newName, String? newDes}) async {
    // check the current user(validate the token)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null) {
      throw AppAuthException(message: 'Invalid or expired token!');
    }

    // confirm the current user is a member of workspace
    final membership = await WorkspaceMember.db.findFirstRow(
      session,
      where: (c) =>
          c.user.equals(currentUser.id) & c.workspace.equals(workspaceId),
    );
    if (membership == null) {
      throw AppPermissionException(
          message: 'You are not a member of this workspace!');
    }

    // check the current user role in the workspace
    if (membership.role != Roles.owner && membership.role != Roles.admin) {
      throw AppPermissionException(
          message: 'Only Owner/Admin can update workspace.');
    }

    // fetch the existing workspace
    final workspace = await Workspace.db.findById(session, workspaceId);

    if (workspace == null) {
      throw AppNotFoundException(resourceType: 'Workspace');
    }

    // check if the new Name and description are valid and trimed
    if (newName != null) {
      if (newName.trim().isEmpty) {
        throw RandomAppException(message: 'Workspace name cannot be empty!');
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
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to update workspace. Please try again.');
    }
  }

  // Delete workspace
  Future<bool> deleteWorkspace(
      Session session, int workspaceId, String token) async {
    // get the current user(validate token)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null) {
      throw AppAuthException(message: 'Invalid or expired token!');
    }

    // find the workspace
    final workspace = await Workspace.db.findById(session, workspaceId);
    if (workspace == null) {
      throw AppNotFoundException(resourceType: 'Workspace');
    }

    final member = await WorkspaceMember.db.findFirstRow(
      session,
      where: (w) =>
          w.user.equals(currentUser.id) & w.workspace.equals(workspace.id),
    );
    if (member == null) {
      throw AppNotFoundException(resourceType: 'Workspace');
    }

    // is the user owner of this workspace
    if (member.role != Roles.owner) {
      throw AppPermissionException(
          message: 'Only owners can delete workspace!');
    }
    try {
      // delete maually workspace memebers before deleting workspace
      await WorkspaceMember.db
          .deleteWhere(session, where: (m) => m.workspace.equals(workspaceId));

      // delete the workspace
      await Workspace.db.deleteRow(session, workspace);
      return true;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(
          message: 'Failed to delete workspace. Please try again.');
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
