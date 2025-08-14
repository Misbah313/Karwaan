import 'package:flutter/material.dart';
import 'package:karwaan_client/karwaan_client.dart';
import 'package:karwaan_flutter/core/services/auth_token_storage_helper.dart';
import 'package:karwaan_flutter/core/utils/exceptions/token_expired_exceptions.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

late final Client client;

class ServerpodClientService {
  final AuthTokenStorageHelper _authTokenStorage;

  ServerpodClientService(this._authTokenStorage);

  // initialize serverpod client service (Long-term: Switch to .env before deploying (even to test servers).1: add flutter_dotenv package, 2:Create .env(SERVERPOD_URL=http://10.226.253.89:8080/) 3: Load it in main.dart(void main() aysnc { await dotev.load(fileName: '.env'); final serverpodUrl = dotenv.get('Serverpo Url')}), 4: update serverpod clinet(Client(serverpodUrl)));
  Future<void> initialize() async {
    client = Client(
      'http://10.226.253.89:8080/',
    )..connectivityMonitor = FlutterConnectivityMonitor();

    final storedToken = await _authTokenStorage.getToken();

    if (storedToken != null) {
      // Only log partial token in debug mode
      assert(() {
        debugPrint('Token loaded: ${storedToken.substring(0, 6)}...');
        return true;
      }());
    }
  }

  // ============================================= AUTHENTICATION =================================================== //

  // get the current user
  Future<User?> getCurrentUser() async {
    final token = await _authTokenStorage.getToken();
    if (token == null) {
      return null;
    }

    try {
      final user = await client.token.validateToken(token);
      if (user == null) {
        await _authTokenStorage.deleteToken();
        throw TokenExpiredExceptions();
      }

      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // login
  Future<AuthResponse> loginUser(String email, String pw) async {
    try {
      // authenticate with my custom endpoint
      final authResponse = await client.authentication.loginUser(email, pw);

      await client.token.validateToken(authResponse.token);

      // save the token securly
      await _authTokenStorage.saveToken(authResponse.token);

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  // logout
  Future<void> logoutUser(String token) async {
    try {
      debugPrint('A. Starting server logout');
      await client.authentication.logoutUser(token);
      debugPrint('B. Deleting local token');
      await _authTokenStorage.deleteToken();
      await Future.delayed(Duration(milliseconds: 100));

      final verifyDeletion = await _authTokenStorage.getToken();
      debugPrint('C. Token after deletion: ${verifyDeletion ?? "Null"}');

      if (verifyDeletion != null) {
        throw Exception('Token was not deleted properly!');
      }
    } catch (e) {
      debugPrint('D. Force deleting token due to error: $e');
      await _authTokenStorage.deleteToken();
      rethrow;
    }
  }

  // register
  Future<User> registerUser(String email, String pw, String userName) async {
    try {
      // register the new user
      final user =
          await client.authentication.registerUser(userName, email, pw);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Is user logged in
  Future<bool> get isLoggedIn async {
    final token = await _authTokenStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  // refresh token(will add later: it avoid forcing user to login again when access token expires(note: you've set the token for 30 days)).

  // get token
  Future<String?> getToken() async {
    final token = await _authTokenStorage.getToken();

    return token;
  }

  // delete user
  Future<void> deleteUser(int userId) async {
    try {
      await _authTokenStorage.deleteToken();
      await client.user.deleteUser(userId);
    } catch (e) {
      rethrow;
    }
  }

  // update user

  // =============================================== WORKSPACE ====================================================== //

  // create workspace
  Future<Workspace> createWorkspace(
      String workspaceName, String workspaceDec) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login before preforming this action.');
      }
      final workspace = await client.workspace
          .createWorkspace(workspaceName, workspaceDec, token);

      return workspace;
    } catch (e) {
      rethrow;
    }
  }

  // get user workspace
  Future<List<Workspace>> getUserWorkspace() async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login before preforming this action.');
      }
      final workspace = await client.workspace.getUserWorkspace(token);

      return workspace;
    } catch (e) {
      rethrow;
    }
  }

  // update workspace
  Future<Workspace> updateWorkspace(
      String newName, String newDec, int workspaceId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login before preforming this action.');
      }
      final update = await client.workspace.updateWorkspace(workspaceId, token,
          newName: newName, newDes: newDec);

      return update;
    } catch (e) {
      rethrow;
    }
  }

  // delete workspace
  Future<bool> deleteWorkspace(int workspaceId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login before preforming this action.');
      }
      await client.workspace.deleteWorkspace(workspaceId, token);

      return true;
    } catch (e) {
      rethrow;
    }
  }

  // add member to workspace
  Future<WorkspaceMember> addMemberToWorkspace(
      int workspaceId, int userToAddId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login before preforming this action.');
      }
      final workspaceMember = await client.workspaceMember
          .addMemberToWorkspace(userToAddId, workspaceId, token);

      return workspaceMember;
    } catch (e) {
      rethrow;
    }
  }

  // add member by email
  Future<WorkspaceMember> addMemberByEmail(
      String email, int workspaceId, String role) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) throw Exception('Not Authenticated');
      return client.workspaceMember
          .addMemberByEmail(email, workspaceId, token, role);
    } catch (e) {
      rethrow;
    }
  }

  // remove member from workspace
  Future<void> removeMemberFromWorkspace(
      int workspaceId, int userToRemoveId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login before preforming this action.');
      }
      final workspaceMember = await client.workspaceMember
          .removeMemberFromWorkspace(workspaceId, userToRemoveId, token);

      return workspaceMember;
    } catch (e) {
      rethrow;
    }
  }

  // get workspace member(later)
  Future<List<WorkspaceMemberDetails>> getWorkspaceMembers(
      int workspaceId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login before performing this action');
      }
      final members =
          await client.workspaceMember.getWorkspaceMember(workspaceId, token);

      return members;
    } catch (e) {
      rethrow;
    }
  }

  // change member role(later)
  Future<WorkspaceMember> changeMemberRole(
    int targetUserId,
    int workspaceId,
    String newRole,
  ) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) throw Exception('Not Authenticated!');

      // Correct parameter order to match endpoint:
      // 1. workspaceId, 2. token, 3. targetUserId, 4. newRole
      return client.workspaceMember
          .changeMemberRole(workspaceId, token, targetUserId, newRole);
    } catch (e) {
      rethrow;
    }
  }

  // leave workspace
  Future<void> leaveWorkspace(int workspaceId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login before preforming this action.');
      }

      await client.workspaceMember.leaveWorkspace(workspaceId, token);
    } catch (e) {
      rethrow;
    }
  }

  // ===================================================== BOARD ========================================================== //

  // create board
  Future<Board> createBoard(
      int workspaceId, String name, String description) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login before performing this action!!');
      }

      debugPrint('Startin creating board from serverpodclientservcie!');
      final board =
          await client.board.createBoard(workspaceId, name, description, token);
      debugPrint(
          'board creatd from serverpodclientservice by name of ${board.name}');

      return board;
    } catch (e) {
      rethrow;
    }
  }

  // ger user boardss
  Future<List<BoardDetails>> getUserBoards() async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final boards = await client.board.getUserBoards(token);

      return boards;
    } catch (e) {
      rethrow;
    }
  }

  // update board
  Future<Board> updateBoard(
      int boardId, String newName, String newDescription) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!!');
      }

      final updatedBoard = await client.board.updateBoard(boardId, token,
          newName: newName, newDec: newDescription);

      return updatedBoard;
    } catch (e) {
      rethrow;
    }
  }

  // delete board
  Future<bool> deleteBoard(int boardId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!!');
      }
      await client.board.deleteBoard(boardId, token);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  // get boards by workspace
  Future<List<BoardDetails>> getBoardsByWorkspace(int workspaceId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!!');
      }

      final list = await client.board.getBoardsByWorkspace(workspaceId, token);
      return list;
    } catch (e) {
      rethrow;
    }
  }

  // add member to board
  Future<BoardMember> addMemberToBoard(int boardId, String email) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }
      final member =
          await client.boardMember.addMemberToBoard(boardId, email, token);
      if (member.id == null) {
        throw Exception(
            'Failed to add member from client service: Server returned invalid datat!');
      }

      return member;
    } catch (e) {
      rethrow;
    }
  }

  // remove member from board
  Future<void> removeMemberFromBoard(int boardId, int userToRemoveId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!!');
      }

      await client.boardMember
          .removeMemberFromBoard(boardId, userToRemoveId, token);
    } catch (e) {
      rethrow;
    }
  }

  // get board members
  Future<List<BoardMemberDetails>> getBoardMembers(int boardId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final members = await client.boardMember.getBoardMembers(boardId, token);
      return members;
    } catch (e) {
      rethrow;
    }
  }

  // change board member role
  Future<BoardMember> changeBoardMemberRole(
      int boardId, int userToChangeRoleId, String newRole) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final change = await client.boardMember
          .changeBoardMemberRole(boardId, token, userToChangeRoleId, newRole);
      return change;
    } catch (e) {
      rethrow;
    }
  }

  // leave board
  Future<void> leaveBoard(int boardId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      await client.boardMember.leaveBoard(boardId, token);
    } catch (e) {
      rethrow;
    }
  }

  // ========================================================= BOARD LIST ==================================================== //

  // create board list
  Future<BoardList> createBoardList(int boardId, String title) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final boardlist =
          await client.boardList.createBoardList(boardId, token, title);
      return boardlist;
    } catch (e) {
      rethrow;
    }
  }

  // get board list
  Future<List<BoardList>> listBoardLists(int boardId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final list = await client.boardList.listBoardLists(boardId, token);
      return list;
    } catch (e) {
      rethrow;
    }
  }

  // update board list
  Future<BoardList> updateBoardList(int listId, String newTitle) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final update =
          await client.boardList.updateBoardList(listId, token, newTitle);
      return update;
    } catch (e) {
      rethrow;
    }
  }

  // delete board list
  Future<bool> deleteBoardList(int listId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      return await client.boardList.deleteBoardList(listId, token);
    } catch (e) {
      rethrow;
    }
  }

  // =========================================================== BOARD CARD ========================================================== //

  // create board card
  Future<BoardCard> createBoardCard(
      int boardlistId, String title, String description) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final card =
          await client.boardCard.createBoardCard(boardlistId, token, title);
      return card;
    } catch (e) {
      rethrow;
    }
  }

  // get list by boardCard
  Future<List<BoardCard>> getListByBoardCard(int boardlistId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final list =
          await client.boardCard.getListByBoardCard(boardlistId, token);
      return list;
    } catch (e) {
      rethrow;
    }
  }

  // update board card
  Future<BoardCard> updateBoardCard(
      int cardId, String newTitle, String newDec, bool isCompleted) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final updated = await client.boardCard
          .updateBoardCard(cardId, token, newTitle, newDec, isCompleted);
      return updated;
    } catch (e) {
      rethrow;
    }
  }

  // delete board card
  Future<bool> deleteBoardCard(int cardId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      return await client.boardCard.deleteBoardCard(cardId, token);
    } catch (e) {
      rethrow;
    }
  }
}
