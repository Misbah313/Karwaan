import 'dart:io';
import 'dart:convert';

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
      'http://10.169.70.89:8080/',
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

// Upload profile picture
  Future<String> uploadProfilePicture(File imageFile, int userId) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final fileName = imageFile.path.split('/').last;

      final result = await client.file.uploadProfilePicture(
        userId,
        fileName,
        bytes,
      );

      return result;
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

// Delete profile picture
  Future<bool> deleteProfilePicture(int userId) async {
    try {
      return await client.file.deleteProfilePicture(userId);
    } catch (e) {
      throw Exception('Failed to delete profile picture: $e');
    }
  }

  // get profile picture
  Future<String> getProfilePictureUrl(String? filename) async {
    if (filename == null || filename.isEmpty) return '';

    try {
      // Call the endpoint to get the image data
      final imageData = await client.file.serveProfilePicture(filename);

      // Convert the bytes to a base64 data URL
      final base64Image = base64Encode(imageData);
      return 'data:image/jpeg;base64,$base64Image';
    } catch (e) {
      debugPrint('Error getting profile picture: $e');
      return '';
    }
  }

  // update user theme
  Future<bool> saveUserTheme(bool isDarkMode, int userId) async {
    try {
      return await client.user.updateUserTheme(userId, isDarkMode);
    } catch (e) {
      rethrow;
    }
  }

  // get user theme
  Future<bool?> loadUserTheme(int userId) async {
    try {
      return await client.user.getUserTheme(userId);
    } catch (e) {
      return null;
    }
  }
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

  // ============================================================ LABEL + CARDLABEL ==================================================== //

  // ==> LABEL:

  // create label
  Future<Label> createLabel(int boardId, String title, String color) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final create =
          await client.label.createLabel(boardId, token, title, color);
      return create;
    } catch (e) {
      rethrow;
    }
  }

  // get labels for board
  Future<List<Label>> getLabelsForBoard(int boardId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final labels = await client.label.getLabelsForBoard(boardId, token);
      return labels;
    } catch (e) {
      rethrow;
    }
  }

  // update label
  Future<Label> updateLabel(
      int labelId, String newTitle, String newColor) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final updated = await client.label
          .updateLabel(labelId, token, newTitle: newTitle, newColor: newColor);
      return updated;
    } catch (e) {
      rethrow;
    }
  }

  // delete label
  Future<bool> deleteLabel(int labelId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      return await client.label.deleteLabel(labelId, token);
    } catch (e) {
      rethrow;
    }
  }

  // ===> CARD LABEL:

  // assign label to card
  Future<CardLabel> assignLabelToCard(int labelId, int cardId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final cardlabel =
          await client.cardLabel.assignLableToCard(labelId, cardId, token);
      return cardlabel;
    } catch (e) {
      rethrow;
    }
  }

  // remove label from card
  Future<void> removeLabelFromCard(int cardId, int labelId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      await client.cardLabel.removeLabelFromCard(cardId, labelId, token);
    } catch (e) {
      rethrow;
    }
  }

  // get labels for card
  Future<List<Label>> getLabelsforCard(int cardId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final labels = await client.cardLabel.getLabelForCard(cardId, token);
      return labels;
    } catch (e) {
      rethrow;
    }
  }

  // get cards for label
  Future<List<BoardCard>> getCardsForLabel(int labelId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final cards = await client.cardLabel.getCardForLabel(labelId, token);
      return cards;
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================= CHECKLIST + CHECKLIST ITEM ====================================================== //

  // ===> CHECKLIST:

  // create checklist
  Future<CheckList> createChecklist(int cardId, String title) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final checklist =
          await client.checklist.createChecklist(cardId, title, token);
      return checklist;
    } catch (e) {
      rethrow;
    }
  }

  // list checklist
  Future<List<CheckList>> listCheckList(int cardId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final list = await client.checklist.listChecklist(cardId, token);
      return list;
    } catch (e) {
      rethrow;
    }
  }

  // update checklist
  Future<CheckList> updatedChecklist(int checklistId, String newTitle) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final updated =
          await client.checklist.updateChecklist(checklistId, newTitle, token);
      return updated;
    } catch (e) {
      rethrow;
    }
  }

  // delete checklist
  Future<void> deleteChecklist(int checklistId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      await client.checklist.deleteChecklist(checklistId, token);
    } catch (e) {
      rethrow;
    }
  }

  // CHECKLIST ITEM:

  // create checklist item
  Future<CheckListItem> createChecklistItem(
      int checklistId, String content) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final item = await client.checklistItem
          .createChecklistItem(checklistId, content, token);
      return item;
    } catch (e) {
      rethrow;
    }
  }

  // list checklist item
  Future<List<CheckListItem>> listCheckListItem(int checklistId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final list =
          await client.checklistItem.listChecklistItems(checklistId, token);
      return list;
    } catch (e) {
      rethrow;
    }
  }

  // update checklist item
  Future<CheckListItem> updateChecklistItem(
      int checklistItemId, int checklistId, String newContent) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final update = await client.checklistItem
          .updateChecklistItem(checklistItemId, checklistId, newContent, token);
      return update;
    } catch (e) {
      rethrow;
    }
  }

  // toggle checklistitem status
  Future<CheckListItem> toggleChecklistItemStatus(int checklistItemId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final toggled = await client.checklistItem
          .toggleChecklistItemStatus(checklistItemId, token);
      return toggled;
    } catch (e) {
      rethrow;
    }
  }

  // delete checklist item
  Future<void> deleteChecklistItem(int checklistItemId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      await client.checklistItem.deleteChecklistItem(checklistItemId, token);
    } catch (e) {
      rethrow;
    }
  }

  // ========================================================================= COMMENT ========================================================== //

  // create comment
  Future<Comment> createComment(int cardId, String content) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final comment =
          await client.comment.createComment(token, cardId, content);
      return comment;
    } catch (e) {
      rethrow;
    }
  }

  // get comments for card
  Future<List<CommentWithAuthor>> getCommentsForCard(int cardId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final list = await client.comment.getCommentsForCard(cardId, token);
      return list;
    } catch (e) {
      rethrow;
    }
  }

  // update comment
  Future<Comment> updateComment(int commentId, String newContent) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final updated =
          await client.comment.updateComment(commentId, newContent, token);
      return updated;
    } catch (e) {
      rethrow;
    }
  }

  // delete comment
  Future<bool> deleteComment(int commentId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      return await client.comment.deleteComment(commentId, token);
    } catch (e) {
      rethrow;
    }
  }

  // ================================================================== ATTACHMENT ======================================================================= //

  // upload attachment
  Future<Attachment> uploadAttachment(int cardId, String fileName) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final upload =
          await client.attachment.uploadAttachment(cardId, fileName, token);
      return upload;
    } catch (e) {
      rethrow;
    }
  }

  // list attachment
  Future<List<Attachment>> listAttachment(int cardId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      final list = await client.attachment.listAttachments(cardId, token);
      return list;
    } catch (e) {
      rethrow;
    }
  }

  // delete attachment
  Future<bool> deleteAttachment(int attachmentId) async {
    try {
      final token = await _authTokenStorage.getToken();
      if (token == null) {
        throw Exception('Please login first!');
      }

      return await client.attachment.deleteAttachment(attachmentId, token);
    } catch (e) {
      rethrow;
    }
  }
}
