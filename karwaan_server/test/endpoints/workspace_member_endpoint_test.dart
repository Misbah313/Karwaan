import 'package:karwaan_server/src/endpoints/role_check.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('WorkspaceMemberEndpoint', (sessionBuilder, endpoints) {
    late User owner;
    late User admin;
    late User member;
    late Workspace workspace;
    late String ownerToken;
    late String adminToken;
    late String memberToken;

    setUp(() async {
      final session = sessionBuilder.build();

      // Create users
      owner = User(name: 'Owner', email: 'owner@example.com', password: '123');
      admin = User(name: 'Admin', email: 'admin@example.com', password: '123');
      member =
          User(name: 'Member', email: 'member@example.com', password: '123');

      final insertedOwner = await User.db.insertRow(session, owner);
      owner.id = insertedOwner.id;
      final insertedAdmin = await User.db.insertRow(session, admin);
      admin.id = insertedAdmin.id;
      final insertedMember = await User.db.insertRow(session, member);
      member.id = insertedMember.id;

      // Create workspace
      workspace = Workspace(
        name: 'Workspace1',
        createdAt: DateTime.now(),
        ownerId: owner.id!,
      );
      final insertedWorkspace =
          await Workspace.db.insertRow(session, workspace);
      workspace.id = insertedWorkspace.id;

      // Add workspace members with roles
      await WorkspaceMember.db.insertRow(
        session,
        WorkspaceMember(
          user: owner.id!,
          workspace: workspace.id!,
          joinedAt: DateTime.now(),
          role: Roles.owner,
        ),
      );
      await WorkspaceMember.db.insertRow(
        session,
        WorkspaceMember(
          user: admin.id!,
          workspace: workspace.id!,
          joinedAt: DateTime.now(),
          role: Roles.admin,
        ),
      );
      await WorkspaceMember.db.insertRow(
        session,
        WorkspaceMember(
          user: member.id!,
          workspace: workspace.id!,
          joinedAt: DateTime.now(),
          role: Roles.member,
        ),
      );

      // Create tokens
      ownerToken = 'token-owner';
      adminToken = 'token-admin';
      memberToken = 'token-member';

      await UserToken.db.insertRow(
        session,
        UserToken(
          userId: owner.id!,
          token: ownerToken,
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(Duration(hours: 1)),
        ),
      );
      await UserToken.db.insertRow(
        session,
        UserToken(
          userId: admin.id!,
          token: adminToken,
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(Duration(hours: 1)),
        ),
      );
      await UserToken.db.insertRow(
        session,
        UserToken(
          userId: member.id!,
          token: memberToken,
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(Duration(hours: 1)),
        ),
      );
    });

    test('addMemberToWorkspace - owner can add member', () async {
      final session = sessionBuilder.build();

      // Create new user to add
      final newUser =
          User(name: 'NewUser', email: 'newuser@example.com', password: '123');
      final insertedNewUser = await User.db.insertRow(session, newUser);
      newUser.id = insertedNewUser.id;

      final result = await endpoints.workspaceMember.addMemberToWorkspace(
        sessionBuilder,
        newUser.id!,
        workspace.id!,
        ownerToken,
      );

      expect(result, isNotNull);
      expect(result.user, equals(newUser.id));
      expect(result.workspace, equals(workspace.id));
      expect(result.role, equals(Roles.member));
    });

    test('removeMemberFromWorkspace - owner can remove a member', () async {
      final session = sessionBuilder.build();

      // Owner removes the member
      await endpoints.workspaceMember.removeMemberFromWorkspace(
        sessionBuilder,
        workspace.id!,
        member.id!,
        ownerToken,
      );

      // Confirm member removed
      final removed = await WorkspaceMember.db.findFirstRow(
        session,
        where: (m) =>
            m.workspace.equals(workspace.id!) & m.user.equals(member.id!),
      );
      expect(removed, isNull);
    });

    test('removeMemberFromWorkspace - fails if removing last owner', () async {
      final session = sessionBuilder.build();

      // Try to remove the owner themselves (should fail)
      expect(
        () async {
          await endpoints.workspaceMember.removeMemberFromWorkspace(
            sessionBuilder,
            workspace.id!,
            owner.id!,
            ownerToken,
          );
        },
        throwsA(predicate(
          (e) =>
              e is Exception &&
              e.toString().contains('You cannot remove yourself'),
        )),
      );
    });

    test('getWorkspaceMember - returns all members with details', () async {
      final result = await endpoints.workspaceMember.getWorkspaceMember(
        sessionBuilder,
        workspace.id!,
        ownerToken,
      );

      expect(result, isNotEmpty);
      expect(result.any((m) => m.userId == owner.id), isTrue);
      expect(result.any((m) => m.userId == admin.id), isTrue);
      expect(result.any((m) => m.userId == member.id), isTrue);
    });

    test('changeMemberRole - owner can change member role', () async {
      final session = sessionBuilder.build();

      final changedMember = await endpoints.workspaceMember.changeMemberRole(
        sessionBuilder,
        workspace.id!,
        ownerToken,
        member.id!,
        Roles.admin,
      );

      expect(changedMember.role, equals(Roles.admin));
    });

    test('leaveWorkspace - member can leave workspace', () async {
      final session = sessionBuilder.build();

      // Member leaves workspace
      await endpoints.workspaceMember.leaveWorkspace(
        sessionBuilder,
        workspace.id!,
        memberToken,
      );

      final check = await WorkspaceMember.db.findFirstRow(
        session,
        where: (m) =>
            m.workspace.equals(workspace.id!) & m.user.equals(member.id!),
      );
      expect(check, isNull);
    });

    test('leaveWorkspace - owner cannot leave if last owner', () async {
      final session = sessionBuilder.build();

      // Try to leave as last owner (should throw)
      expect(
        () async {
          await endpoints.workspaceMember.leaveWorkspace(
            sessionBuilder,
            workspace.id!,
            ownerToken,
          );
        },
        throwsA(predicate(
          (e) =>
              e is Exception &&
              e.toString().contains('You are the last owner!'),
        )),
      );
    });
  });
}
