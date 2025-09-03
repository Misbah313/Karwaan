import 'package:karwaan_server/src/endpoints/role_check.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('boardMemberEndpoint', (sessionBuilder, endpoints) {
    late User owner;
    late User member;
    late Workspace workspace;
    late Board board;
    late String ownerToken;
    late String memberToken;

    setUp(() async {
      final session = sessionBuilder.build();

      // create user + insert user
      owner =
          User(name: 'owner', email: 'owner@gmail.com', password: 'owner123');
      member = User(
          name: 'member', email: 'member@gmail.com', password: 'member123');

      final insertedOwner = await User.db.insertRow(session, owner);
      owner.id = insertedOwner.id;
      final insertedMember = await User.db.insertRow(session, member);
      member.id = insertedMember.id;

      // create workspace first
      workspace = Workspace(
          name: 'Workspace1', createdAt: DateTime.now(), ownerId: owner.id!);

      final insertedWorkspace =
          await Workspace.db.insertRow(session, workspace);
      workspace.id = insertedWorkspace.id;

      // add workspace members
      await WorkspaceMember.db.insertRow(
          session,
          WorkspaceMember(
              user: owner.id!,
              workspace: insertedWorkspace.id!,
              joinedAt: DateTime.now(),
              role: Roles.owner));

      await WorkspaceMember.db.insertRow(
          session,
          WorkspaceMember(
              user: member.id!,
              workspace: insertedWorkspace.id!,
              joinedAt: DateTime.now(),
              role: Roles.member));

      // create board
      board = Board(
          name: 'Board1',
          description: 'dec',
          workspaceId: insertedWorkspace.id!,
          createdBy: owner.id!,
          createdAt: DateTime.now());

      final insertedBoard = await Board.db.insertRow(session, board);
      board.id = insertedBoard.id;

      // add board members with role
      await BoardMember.db.insertRow(
          session,
          BoardMember(
              user: owner.id!,
              board: board.id!,
              joinedAt: DateTime.now(),
              role: Roles.owner));

      await BoardMember.db.insertRow(
          session,
          BoardMember(
              user: member.id!,
              board: board.id!,
              joinedAt: DateTime.now(),
              role: Roles.member));

      // create tokens
      ownerToken = 'owner-token';
      memberToken = 'member-token';

      await UserToken.db.insertRow(
          session,
          UserToken(
              userId: owner.id!,
              token: ownerToken,
              createdAt: DateTime.now(),
              expiresAt: DateTime.now().add(Duration(days: 1))));

      await UserToken.db.insertRow(
          session,
          UserToken(
              userId: member.id!,
              token: memberToken,
              createdAt: DateTime.now(),
              expiresAt: DateTime.now().add(Duration(days: 1))));
    });

    test('addMemberToBoard', () async {
      final session = sessionBuilder.build();

      // create new user to add
      final newUser = User(
          name: 'NewUser', email: 'newUser@gmail.com', password: 'newUser123');
      final insertedNewUser = await User.db.insertRow(session, newUser);
      newUser.id = insertedNewUser.id;

      // add the new user a member of the parent workspace
      await WorkspaceMember.db.insertRow(
          session,
          WorkspaceMember(
              user: newUser.id!,
              workspace: workspace.id!,
              joinedAt: DateTime.now()));

      final result = await endpoints.boardMember.addMemberToBoard(
          sessionBuilder, board.id!, newUser.email, ownerToken);

      expect(result, isNotNull);
      expect(result.user, equals(newUser.id));
      expect(result.board, equals(board.id));
      expect(result.role, equals(Roles.member));
    });

    test('removeMemberFromBoard', () async {
      final session = sessionBuilder.build();

      // owner tries to remove the member
      await endpoints.boardMember.removeMemberFromBoard(
          sessionBuilder, board.id!, member.id!, ownerToken);

      // confirm member removed
      final removed = await BoardMember.db.findFirstRow(
        session,
        where: (p0) => p0.board.equals(board.id) & p0.user.equals(member.id),
      );
      expect(removed, isNull);
    });

    test('getBoardMembers', () async {
      final result = await endpoints.boardMember
          .getBoardMembers(sessionBuilder, board.id!, ownerToken);

      expect(result, isNotEmpty);
      expect(result.any((m) => m.userId == owner.id), isTrue);
      expect(result.any((m) => m.userId == member.id), isTrue);
    });

    test('changeBoardMemberRole', () async {
      final result = await endpoints.boardMember.changeBoardMemberRole(
          sessionBuilder, board.id!, ownerToken, member.id!, Roles.admin);

      expect(result.role, equals(Roles.admin));
    });

    test('leaveBoard', () async {
      final session = sessionBuilder.build();
      await endpoints.boardMember
          .leaveBoard(sessionBuilder, board.id!, memberToken);

      // check the board members for the last member that has left
      final membership = await BoardMember.db.findFirstRow(
        session,
        where: (p0) => p0.board.equals(board.id) & p0.user.equals(member.id),
      );
      expect(membership, isNull);
    });
  });
}
