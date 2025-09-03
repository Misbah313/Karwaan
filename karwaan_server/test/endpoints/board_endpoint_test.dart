import 'package:karwaan_server/src/endpoints/role_check.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('BoardEndpoint', (sessionBuilder, endpoints) async {
    late User owner;
    late User member;
    late User fakeUser;
    late String ownerToken;
    late String memberToken;
    late String fakeUserToken;

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

      // insert the fake user into db
      fakeUser =
          User(name: 'fakeUser', email: 'fake@gmail.com', password: 'fake123');
      final insertedFakeUser = await User.db.insertRow(session, fakeUser);
      fakeUser.id = insertedFakeUser.id;

      // Create owner token
      ownerToken = 'owner-token1';
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
      memberToken = 'member-token2';
      await UserToken.db.insertRow(
          session,
          UserToken(
              userId: member.id!,
              token: memberToken,
              createdAt: DateTime.now(),
              expiresAt: DateTime.now().add(Duration(hours: 24))));

      // create a token for the fake user
      fakeUserToken = 'fake-token';
    });

    test('createBoard', () async {
      final session = sessionBuilder.build();

      // create workspace
      final workspace = await endpoints.workspace
          .createWorkspace(sessionBuilder, 'Workspace', 'dec', ownerToken);

      // create the board
      final board = await endpoints.board.createBoard(
          sessionBuilder, workspace.id!, 'Board1', 'decBoard', ownerToken);

      // verify
      expect(board, isNotNull);
      expect(board.name, equals('Board1'));
      expect(board.createdBy, equals(owner.id));

      // check board membership
      final members = await BoardMember.db.find(
        session,
        where: (p0) => p0.board.equals(board.id),
      );
      expect(members, isNotEmpty);
      expect(members.first.user, equals(owner.id));
      expect(members.first.role, equals(Roles.owner));
    });

    test('getUserBoard', () async {
      // create workspace
      final createdWorkspace = await endpoints.workspace
          .createWorkspace(sessionBuilder, 'Workspace', 'Wdec', ownerToken);

      // create board
      final createdBoard = await endpoints.board.createBoard(
          sessionBuilder, createdWorkspace.id!, 'Board', 'Bdec', ownerToken);

      // get user board members
      final userBoard = await endpoints.board
          .getUserBoard(sessionBuilder, createdBoard.id!, ownerToken);

      expect(userBoard.workspaceId, equals(createdWorkspace.id));
      expect(userBoard.name, equals(createdBoard.name));
      expect(userBoard.id, equals(createdBoard.id));

      // invalid token exception
      await expectLater(
          () => endpoints.board
              .getUserBoard(sessionBuilder, createdBoard.id!, fakeUserToken),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message',
              contains('No user or invalid token!'))));

      // board not found exception
      await expectLater(
          () => endpoints.board.getUserBoard(sessionBuilder, 44, ownerToken),
          throwsA(isA<Exception>().having(
              (e) => e.toString(), 'message', contains("Board not found!"))));

      // not member exception
      await expectLater(
          () => endpoints.board
              .getUserBoard(sessionBuilder, createdBoard.id!, memberToken),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message',
              contains("You're not a member of this board"))));
    });

    test('getUserBoards', () async {
      // create worksapce
      final createdWorkspace = await endpoints.workspace
          .createWorkspace(sessionBuilder, 'Workspace', 'Wdec', ownerToken);

      // create1 board
      final createdBoard = await endpoints.board.createBoard(
          sessionBuilder, createdWorkspace.id!, 'Board', 'Bdec', ownerToken);

      // create2 board
      final createdBoard2 = await endpoints.board.createBoard(
          sessionBuilder, createdWorkspace.id!, 'board2', 'B2dec', ownerToken);

      // get all boards where user is a member of
      final userBoards =
          await endpoints.board.getUserBoards(sessionBuilder, ownerToken);

      expect(userBoards, isNotEmpty);
      expect(userBoards.length, equals(2));

      // check the first board
      final board1 = userBoards.firstWhere((b) => b.id == createdBoard.id);
      expect(board1.name, equals(createdBoard.name));
      expect(board1.workspaceId, equals(createdBoard.workspaceId));
      expect(board1.members, contains(owner.name));

      // check the second board
      final board2 = userBoards.firstWhere((b) => b.id == createdBoard2.id);
      expect(board2.name, equals(createdBoard2.name));
      expect(board2.workspaceId, equals(createdBoard2.workspaceId));
      expect(board2.members, contains(owner.name));
    });

    test('updateBoard', () async {
      final session = sessionBuilder.build();
      // create parent workspace
      final workspace = await endpoints.workspace
          .createWorkspace(sessionBuilder, 'Workspace', 'Wdec', ownerToken);

      // create board
      final board = await endpoints.board.createBoard(
          sessionBuilder, workspace.id!, 'Board', 'Bdec', ownerToken);

      // update the board
      final updatedBoard = await endpoints.board.updateBoard(
          sessionBuilder, board.id!, ownerToken,
          newName: 'NewBoard');

      expect(updatedBoard.id, equals(board.id));
      expect(updatedBoard.workspaceId, equals(workspace.id));
      expect(updatedBoard.name, equals('NewBoard'));
      expect(updatedBoard, isNotNull);

      // fetch the board again to make sure the db save the updated board
      final fetchedBoard = await Board.db.findById(session, updatedBoard.id!);
      expect(fetchedBoard!.name, equals('NewBoard'));
    });

    test('deleteBoard', () async {
      final session = sessionBuilder.build();
      // crate parent workspace
      final workspace = await endpoints.workspace
          .createWorkspace(sessionBuilder, 'Workspace', 'Wdec', ownerToken);

      // create board
      final board = await endpoints.board.createBoard(
          sessionBuilder, workspace.id!, 'board', 'bdec', ownerToken);

      // delete the board
      final deleted = await endpoints.board
          .deleteBoard(sessionBuilder, board.id!, ownerToken);

      expect(deleted, isTrue);

      // verify the the board has gone from the db
      final db = await Board.db.findById(session, board.id!);
      expect(db, isNull);

      // verify there is no board member left after board deletion
      final members = await BoardMember.db.findFirstRow(
        session,
        where: (p0) => p0.board.equals(board.id),
      );
      expect(members, isNull);
    });
  });
}
