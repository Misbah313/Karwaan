import 'package:karwaan_server/src/endpoints/role_check.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('WorkspaceEndpoint', (sessionBuilder, endpoints) {
    late User owner;
    late User member;
    late String ownerToken;
    late String memberToken;

    setUp(() async {
      final session = sessionBuilder.build();

      // Insert owner into DB
      owner = User(
        name: 'Owner',
        email: 'owner@gmail.com',
        password: 'owner123',
      );
      final insertedOwner = await User.db.insertRow(session, owner);
      owner.id = insertedOwner.id;

      // insert member into DB
      member =
          User(name: 'User1', email: 'user1@gmail.com', password: 'user123');
      final insertedMember = await User.db.insertRow(session, member);
      member.id = insertedMember.id;

      // Create owner token
      ownerToken = 'owner-token';
      await UserToken.db.insertRow(
        session,
        UserToken(
          userId: owner.id!,
          token: ownerToken,
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(hours: 24)),
        ),
      );

      // create member token
      memberToken = 'member-token';
      await UserToken.db.insertRow(
          session,
          UserToken(
              userId: member.id!,
              token: memberToken,
              createdAt: DateTime.now(),
              expiresAt: DateTime.now().add(Duration(hours: 24))));
    });

    test('createWorkspace', () async {
      final session = sessionBuilder.build();

      // Call the endpoint
      final result = await endpoints.workspace.createWorkspace(
        sessionBuilder,
        'NewWorkspace',
        'A new test workspace',
        ownerToken,
      );

      // Verify
      expect(result, isNotNull);
      expect(result.name, equals('NewWorkspace'));
      expect(result.ownerId, equals(owner.id));

      // Check workspace membership
      final members = await WorkspaceMember.db.find(
        session,
        where: (m) => m.workspace.equals(result.id!),
      );
      expect(members, isNotEmpty);
      expect(members.first.user, equals(owner.id));
      expect(members.first.role, equals(Roles.owner));
    });

    test('getUserWorkspace', () async {
      // create a workspace for the user first
      final createdWorkspace = await endpoints.workspace.createWorkspace(
          sessionBuilder, 'WorkspaceForOwner', 'Description', ownerToken);

      // call get user workspace
      final result = await endpoints.workspace
          .getUserWorkspace(sessionBuilder, ownerToken);

      // verify
      expect(result, isNotEmpty);
      expect(result.length, 1);
      final workspace = result.first;

      expect(workspace.id, equals(createdWorkspace.id));
      expect(workspace.name, equals(createdWorkspace.name));
      expect(workspace.ownerId, equals(createdWorkspace.ownerId));
    });

    test('updateWorkspace', () async {
      final session = sessionBuilder.build();
      // create workspace for the user
      final createdWorkspace = await endpoints.workspace.createWorkspace(
          sessionBuilder, 'CreatedWorkspaceForOwner', 'Dec', ownerToken);

      // update the workspace
      final updated = await endpoints.workspace.updateWorkspace(
          sessionBuilder, createdWorkspace.id!, ownerToken,
          newName: 'UpdatedUserWorkspace');

      // verify
      expect(updated, isNotNull);
      expect(updated.id, equals(createdWorkspace.id));
      expect(updated.name, equals('UpdatedUserWorkspace'));
      expect(updated.ownerId, equals(owner.id));

      // fetch the workspace again to make sure db save the updated workspace
      final fetchedAfterUpdate =
          await Workspace.db.findById(session, createdWorkspace.id!);
      expect(fetchedAfterUpdate!.name, equals('UpdatedUserWorkspace'));
    });

    test('deleteWorkspace', () async {
      final session = sessionBuilder.build();

      // create workspace for the user first
      final created = await endpoints.workspace
          .createWorkspace(sessionBuilder, 'NewWorkspace', 'Dec', ownerToken);

      // call the delete workspace
      final deleted = await endpoints.workspace
          .deleteWorkspace(sessionBuilder, created.id!, ownerToken);

      // verify
      expect(deleted, isTrue);

      // verify the workspace is gone from db
      final wd = await Workspace.db.findById(session, created.id!);
      expect(wd, isNull);

      // verify no members remain for the workspace
      final memebers = await WorkspaceMember.db.findFirstRow(
        session,
        where: (p0) => p0.workspace.equals(created.id),
      );
      expect(memebers, isNull);
    });

    test('deleteWorkspace - admins/members can/nt delete workspace', () async {

      // create workspace for the member
      final created = await endpoints.workspace.createWorkspace(
          sessionBuilder, 'WorkspaceForMember', 'dec', ownerToken);

      // add the member to workspace
      await endpoints.workspaceMember.addMemberToWorkspace(
          sessionBuilder, member.id!, created.id!, ownerToken);

      // new member want to delete worksapce
      await expectLater(
          () => endpoints.workspace
              .deleteWorkspace(sessionBuilder, created.id!, memberToken),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message',
              contains('Only owners can delete workspace!'))));
    });
  });
}
