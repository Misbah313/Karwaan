/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:karwaan_client/src/protocol/attachment.dart' as _i3;
import 'package:karwaan_client/src/protocol/user.dart' as _i4;
import 'package:karwaan_client/src/protocol/auth_response.dart' as _i5;
import 'package:karwaan_client/src/protocol/board_card.dart' as _i6;
import 'package:karwaan_client/src/protocol/board.dart' as _i7;
import 'package:karwaan_client/src/protocol/board_details.dart' as _i8;
import 'package:karwaan_client/src/protocol/board_list.dart' as _i9;
import 'package:karwaan_client/src/protocol/board_member.dart' as _i10;
import 'package:karwaan_client/src/protocol/board_member_details.dart' as _i11;
import 'package:karwaan_client/src/protocol/card_label.dart' as _i12;
import 'package:karwaan_client/src/protocol/label.dart' as _i13;
import 'package:karwaan_client/src/protocol/checklist.dart' as _i14;
import 'package:karwaan_client/src/protocol/checklist_item.dart' as _i15;
import 'package:karwaan_client/src/protocol/comment.dart' as _i16;
import 'package:karwaan_client/src/protocol/comment_withauthor.dart' as _i17;
import 'package:karwaan_client/src/protocol/workspace.dart' as _i18;
import 'package:karwaan_client/src/protocol/workspace_member.dart' as _i19;
import 'package:karwaan_client/src/protocol/workspace_member_details.dart'
    as _i20;
import 'package:karwaan_client/src/protocol/greeting.dart' as _i21;
import 'protocol.dart' as _i22;

/// {@category Endpoint}
class EndpointAttachment extends _i1.EndpointRef {
  EndpointAttachment(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'attachment';

  _i2.Future<_i3.Attachment> uploadAttachment(
    int cardId,
    String fileName,
    String token,
  ) =>
      caller.callServerEndpoint<_i3.Attachment>(
        'attachment',
        'uploadAttachment',
        {
          'cardId': cardId,
          'fileName': fileName,
          'token': token,
        },
      );

  _i2.Future<List<_i3.Attachment>> listAttachments(
    int cardId,
    String token,
  ) =>
      caller.callServerEndpoint<List<_i3.Attachment>>(
        'attachment',
        'listAttachments',
        {
          'cardId': cardId,
          'token': token,
        },
      );

  _i2.Future<bool> deleteAttachment(
    int attachmentId,
    String token,
  ) =>
      caller.callServerEndpoint<bool>(
        'attachment',
        'deleteAttachment',
        {
          'attachmentId': attachmentId,
          'token': token,
        },
      );
}

/// {@category Endpoint}
class EndpointAuthentication extends _i1.EndpointRef {
  EndpointAuthentication(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'authentication';

  _i2.Future<_i4.User> registerUser(
    String userName,
    String userEmail,
    String userPw,
  ) =>
      caller.callServerEndpoint<_i4.User>(
        'authentication',
        'registerUser',
        {
          'userName': userName,
          'userEmail': userEmail,
          'userPw': userPw,
        },
      );

  _i2.Future<_i5.AuthResponse> loginUser(
    String email,
    String pw,
  ) =>
      caller.callServerEndpoint<_i5.AuthResponse>(
        'authentication',
        'loginUser',
        {
          'email': email,
          'pw': pw,
        },
      );

  _i2.Future<bool> logoutUser(String token) => caller.callServerEndpoint<bool>(
        'authentication',
        'logoutUser',
        {'token': token},
      );
}

/// {@category Endpoint}
class EndpointBoardCard extends _i1.EndpointRef {
  EndpointBoardCard(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'boardCard';

  _i2.Future<_i6.BoardCard> createBoardCard(
    int boardListId,
    String token,
    String title, {
    String? dec,
  }) =>
      caller.callServerEndpoint<_i6.BoardCard>(
        'boardCard',
        'createBoardCard',
        {
          'boardListId': boardListId,
          'token': token,
          'title': title,
          'dec': dec,
        },
      );

  _i2.Future<List<_i6.BoardCard>> getListByBoardCard(
    int boardListId,
    String token,
  ) =>
      caller.callServerEndpoint<List<_i6.BoardCard>>(
        'boardCard',
        'getListByBoardCard',
        {
          'boardListId': boardListId,
          'token': token,
        },
      );

  _i2.Future<_i6.BoardCard> updateBoardCard(
    int cardId,
    String token,
    String newTitle,
    String? newDec,
    bool? completed,
  ) =>
      caller.callServerEndpoint<_i6.BoardCard>(
        'boardCard',
        'updateBoardCard',
        {
          'cardId': cardId,
          'token': token,
          'newTitle': newTitle,
          'newDec': newDec,
          'completed': completed,
        },
      );

  _i2.Future<bool> deleteBoardCard(
    int cardId,
    String token,
  ) =>
      caller.callServerEndpoint<bool>(
        'boardCard',
        'deleteBoardCard',
        {
          'cardId': cardId,
          'token': token,
        },
      );
}

/// {@category Endpoint}
class EndpointBoard extends _i1.EndpointRef {
  EndpointBoard(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'board';

  _i2.Future<_i7.Board> createBoard(
    int workspaceId,
    String name,
    String? description,
    String token,
  ) =>
      caller.callServerEndpoint<_i7.Board>(
        'board',
        'createBoard',
        {
          'workspaceId': workspaceId,
          'name': name,
          'description': description,
          'token': token,
        },
      );

  _i2.Future<_i8.BoardDetails> getUserBoard(
    int boardId,
    String token,
  ) =>
      caller.callServerEndpoint<_i8.BoardDetails>(
        'board',
        'getUserBoard',
        {
          'boardId': boardId,
          'token': token,
        },
      );

  _i2.Future<List<_i8.BoardDetails>> getUserBoards(String token) =>
      caller.callServerEndpoint<List<_i8.BoardDetails>>(
        'board',
        'getUserBoards',
        {'token': token},
      );

  _i2.Future<_i7.Board> updateBoard(
    int boardId,
    String token, {
    String? newName,
    String? newDec,
  }) =>
      caller.callServerEndpoint<_i7.Board>(
        'board',
        'updateBoard',
        {
          'boardId': boardId,
          'token': token,
          'newName': newName,
          'newDec': newDec,
        },
      );

  _i2.Future<bool> deleteBoard(
    int boardId,
    String token,
  ) =>
      caller.callServerEndpoint<bool>(
        'board',
        'deleteBoard',
        {
          'boardId': boardId,
          'token': token,
        },
      );

  _i2.Future<List<_i8.BoardDetails>> getBoardsByWorkspace(
    int workspaceId,
    String token,
  ) =>
      caller.callServerEndpoint<List<_i8.BoardDetails>>(
        'board',
        'getBoardsByWorkspace',
        {
          'workspaceId': workspaceId,
          'token': token,
        },
      );
}

/// {@category Endpoint}
class EndpointBoardList extends _i1.EndpointRef {
  EndpointBoardList(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'boardList';

  _i2.Future<_i9.BoardList> createBoardList(
    int boardId,
    String token,
    String title,
  ) =>
      caller.callServerEndpoint<_i9.BoardList>(
        'boardList',
        'createBoardList',
        {
          'boardId': boardId,
          'token': token,
          'title': title,
        },
      );

  _i2.Future<List<_i9.BoardList>> listBoardLists(
    int boardId,
    String token,
  ) =>
      caller.callServerEndpoint<List<_i9.BoardList>>(
        'boardList',
        'listBoardLists',
        {
          'boardId': boardId,
          'token': token,
        },
      );

  _i2.Future<_i9.BoardList> updateBoardList(
    int listId,
    String token,
    String newTitle,
  ) =>
      caller.callServerEndpoint<_i9.BoardList>(
        'boardList',
        'updateBoardList',
        {
          'listId': listId,
          'token': token,
          'newTitle': newTitle,
        },
      );

  _i2.Future<bool> deleteBoardList(
    int listId,
    String token,
  ) =>
      caller.callServerEndpoint<bool>(
        'boardList',
        'deleteBoardList',
        {
          'listId': listId,
          'token': token,
        },
      );
}

/// {@category Endpoint}
class EndpointBoardMember extends _i1.EndpointRef {
  EndpointBoardMember(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'boardMember';

  _i2.Future<_i10.BoardMember> addMemberToBoard(
    int boardId,
    String userToAddEmail,
    String token,
  ) =>
      caller.callServerEndpoint<_i10.BoardMember>(
        'boardMember',
        'addMemberToBoard',
        {
          'boardId': boardId,
          'userToAddEmail': userToAddEmail,
          'token': token,
        },
      );

  _i2.Future<void> removeMemberFromBoard(
    int boardId,
    int userToRemoveId,
    String token,
  ) =>
      caller.callServerEndpoint<void>(
        'boardMember',
        'removeMemberFromBoard',
        {
          'boardId': boardId,
          'userToRemoveId': userToRemoveId,
          'token': token,
        },
      );

  _i2.Future<List<_i11.BoardMemberDetails>> getBoardMembers(
    int boardId,
    String token,
  ) =>
      caller.callServerEndpoint<List<_i11.BoardMemberDetails>>(
        'boardMember',
        'getBoardMembers',
        {
          'boardId': boardId,
          'token': token,
        },
      );

  _i2.Future<_i10.BoardMember> changeBoardMemberRole(
    int boardId,
    String token,
    int userToChangeRole,
    String newRole,
  ) =>
      caller.callServerEndpoint<_i10.BoardMember>(
        'boardMember',
        'changeBoardMemberRole',
        {
          'boardId': boardId,
          'token': token,
          'userToChangeRole': userToChangeRole,
          'newRole': newRole,
        },
      );

  _i2.Future<void> leaveBoard(
    int boardId,
    String token,
  ) =>
      caller.callServerEndpoint<void>(
        'boardMember',
        'leaveBoard',
        {
          'boardId': boardId,
          'token': token,
        },
      );
}

/// {@category Endpoint}
class EndpointCardLabel extends _i1.EndpointRef {
  EndpointCardLabel(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'cardLabel';

  _i2.Future<_i12.CardLabel> assignLableToCard(
    int labelId,
    int cardId,
    String token,
  ) =>
      caller.callServerEndpoint<_i12.CardLabel>(
        'cardLabel',
        'assignLableToCard',
        {
          'labelId': labelId,
          'cardId': cardId,
          'token': token,
        },
      );

  _i2.Future<void> removeLabelFromCard(
    int cardId,
    int labelId,
    String token,
  ) =>
      caller.callServerEndpoint<void>(
        'cardLabel',
        'removeLabelFromCard',
        {
          'cardId': cardId,
          'labelId': labelId,
          'token': token,
        },
      );

  _i2.Future<List<_i13.Label>> getLabelForCard(
    int cardId,
    String token,
  ) =>
      caller.callServerEndpoint<List<_i13.Label>>(
        'cardLabel',
        'getLabelForCard',
        {
          'cardId': cardId,
          'token': token,
        },
      );

  _i2.Future<List<_i6.BoardCard>> getCardForLabel(
    int labelId,
    String token,
  ) =>
      caller.callServerEndpoint<List<_i6.BoardCard>>(
        'cardLabel',
        'getCardForLabel',
        {
          'labelId': labelId,
          'token': token,
        },
      );
}

/// {@category Endpoint}
class EndpointChecklist extends _i1.EndpointRef {
  EndpointChecklist(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'checklist';

  _i2.Future<_i14.CheckList> createChecklist(
    int cardId,
    String title,
    String token,
  ) =>
      caller.callServerEndpoint<_i14.CheckList>(
        'checklist',
        'createChecklist',
        {
          'cardId': cardId,
          'title': title,
          'token': token,
        },
      );

  _i2.Future<List<_i14.CheckList>> listChecklist(
    int cardId,
    String token,
  ) =>
      caller.callServerEndpoint<List<_i14.CheckList>>(
        'checklist',
        'listChecklist',
        {
          'cardId': cardId,
          'token': token,
        },
      );

  _i2.Future<_i14.CheckList> updateChecklist(
    int checklistId,
    String newTitle,
    String token,
  ) =>
      caller.callServerEndpoint<_i14.CheckList>(
        'checklist',
        'updateChecklist',
        {
          'checklistId': checklistId,
          'newTitle': newTitle,
          'token': token,
        },
      );

  _i2.Future<void> deleteChecklist(
    int checklistId,
    String token,
  ) =>
      caller.callServerEndpoint<void>(
        'checklist',
        'deleteChecklist',
        {
          'checklistId': checklistId,
          'token': token,
        },
      );
}

/// {@category Endpoint}
class EndpointChecklistItem extends _i1.EndpointRef {
  EndpointChecklistItem(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'checklistItem';

  _i2.Future<_i15.CheckListItem> createChecklistItem(
    int checklistId,
    String content,
    String token,
  ) =>
      caller.callServerEndpoint<_i15.CheckListItem>(
        'checklistItem',
        'createChecklistItem',
        {
          'checklistId': checklistId,
          'content': content,
          'token': token,
        },
      );

  _i2.Future<List<_i15.CheckListItem>> listChecklistItems(
    int checklistId,
    String token,
  ) =>
      caller.callServerEndpoint<List<_i15.CheckListItem>>(
        'checklistItem',
        'listChecklistItems',
        {
          'checklistId': checklistId,
          'token': token,
        },
      );

  _i2.Future<_i15.CheckListItem> updateChecklistItem(
    int checklistItemId,
    int checklistId,
    String newContent,
    String token,
  ) =>
      caller.callServerEndpoint<_i15.CheckListItem>(
        'checklistItem',
        'updateChecklistItem',
        {
          'checklistItemId': checklistItemId,
          'checklistId': checklistId,
          'newContent': newContent,
          'token': token,
        },
      );

  _i2.Future<_i15.CheckListItem> toggleChecklistItemStatus(
    int checklistItemId,
    String token,
  ) =>
      caller.callServerEndpoint<_i15.CheckListItem>(
        'checklistItem',
        'toggleChecklistItemStatus',
        {
          'checklistItemId': checklistItemId,
          'token': token,
        },
      );

  _i2.Future<void> deleteChecklistItem(
    int checklistItemId,
    String token,
  ) =>
      caller.callServerEndpoint<void>(
        'checklistItem',
        'deleteChecklistItem',
        {
          'checklistItemId': checklistItemId,
          'token': token,
        },
      );
}

/// {@category Endpoint}
class EndpointComment extends _i1.EndpointRef {
  EndpointComment(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'comment';

  _i2.Future<_i16.Comment> createComment(
    String token,
    int cardId,
    String content,
  ) =>
      caller.callServerEndpoint<_i16.Comment>(
        'comment',
        'createComment',
        {
          'token': token,
          'cardId': cardId,
          'content': content,
        },
      );

  _i2.Future<List<_i17.CommentWithAuthor>> getCommentsForCard(
    int cardId,
    String token,
  ) =>
      caller.callServerEndpoint<List<_i17.CommentWithAuthor>>(
        'comment',
        'getCommentsForCard',
        {
          'cardId': cardId,
          'token': token,
        },
      );

  _i2.Future<_i16.Comment> updateComment(
    int commentId,
    String newContent,
    String token,
  ) =>
      caller.callServerEndpoint<_i16.Comment>(
        'comment',
        'updateComment',
        {
          'commentId': commentId,
          'newContent': newContent,
          'token': token,
        },
      );

  _i2.Future<bool> deleteComment(
    int commentId,
    String token,
  ) =>
      caller.callServerEndpoint<bool>(
        'comment',
        'deleteComment',
        {
          'commentId': commentId,
          'token': token,
        },
      );
}

/// {@category Endpoint}
class EndpointLabel extends _i1.EndpointRef {
  EndpointLabel(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'label';

  _i2.Future<_i13.Label> createLabel(
    int boardId,
    String token,
    String title,
    String color,
  ) =>
      caller.callServerEndpoint<_i13.Label>(
        'label',
        'createLabel',
        {
          'boardId': boardId,
          'token': token,
          'title': title,
          'color': color,
        },
      );

  _i2.Future<List<_i13.Label>> getLabelsForBoard(
    int boardId,
    String token,
  ) =>
      caller.callServerEndpoint<List<_i13.Label>>(
        'label',
        'getLabelsForBoard',
        {
          'boardId': boardId,
          'token': token,
        },
      );

  _i2.Future<_i13.Label> updateLabel(
    int labelId,
    String token, {
    String? newTitle,
    String? newColor,
  }) =>
      caller.callServerEndpoint<_i13.Label>(
        'label',
        'updateLabel',
        {
          'labelId': labelId,
          'token': token,
          'newTitle': newTitle,
          'newColor': newColor,
        },
      );

  _i2.Future<bool> deleteLabel(
    int labelId,
    String token,
  ) =>
      caller.callServerEndpoint<bool>(
        'label',
        'deleteLabel',
        {
          'labelId': labelId,
          'token': token,
        },
      );
}

/// {@category Endpoint}
class EndpointToken extends _i1.EndpointRef {
  EndpointToken(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'token';

  _i2.Future<_i4.User?> validateToken(String token) =>
      caller.callServerEndpoint<_i4.User?>(
        'token',
        'validateToken',
        {'token': token},
      );

  _i2.Future<void> logout(String token) => caller.callServerEndpoint<void>(
        'token',
        'logout',
        {'token': token},
      );
}

/// {@category Endpoint}
class EndpointUser extends _i1.EndpointRef {
  EndpointUser(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  _i2.Future<_i4.User?> getUserById(int userId) =>
      caller.callServerEndpoint<_i4.User?>(
        'user',
        'getUserById',
        {'userId': userId},
      );

  _i2.Future<List<_i4.User>> getAllUsers() =>
      caller.callServerEndpoint<List<_i4.User>>(
        'user',
        'getAllUsers',
        {},
      );

  _i2.Future<_i4.User> updateUser(_i4.User updatedUser) =>
      caller.callServerEndpoint<_i4.User>(
        'user',
        'updateUser',
        {'updatedUser': updatedUser},
      );

  _i2.Future<bool> deleteUser(int id) => caller.callServerEndpoint<bool>(
        'user',
        'deleteUser',
        {'id': id},
      );
}

/// {@category Endpoint}
class EndpointWorkspace extends _i1.EndpointRef {
  EndpointWorkspace(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'workspace';

  _i2.Future<_i18.Workspace> createWorkspace(
    String name,
    String? description,
    String token,
  ) =>
      caller.callServerEndpoint<_i18.Workspace>(
        'workspace',
        'createWorkspace',
        {
          'name': name,
          'description': description,
          'token': token,
        },
      );

  _i2.Future<List<_i18.Workspace>> getUserWorkspace(String token) =>
      caller.callServerEndpoint<List<_i18.Workspace>>(
        'workspace',
        'getUserWorkspace',
        {'token': token},
      );

  _i2.Future<_i18.Workspace> updateWorkspace(
    int workspaceId,
    String token, {
    String? newName,
    String? newDes,
  }) =>
      caller.callServerEndpoint<_i18.Workspace>(
        'workspace',
        'updateWorkspace',
        {
          'workspaceId': workspaceId,
          'token': token,
          'newName': newName,
          'newDes': newDes,
        },
      );

  _i2.Future<bool> deleteWorkspace(
    int workspaceId,
    String token,
  ) =>
      caller.callServerEndpoint<bool>(
        'workspace',
        'deleteWorkspace',
        {
          'workspaceId': workspaceId,
          'token': token,
        },
      );
}

/// {@category Endpoint}
class EndpointWorkspaceMember extends _i1.EndpointRef {
  EndpointWorkspaceMember(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'workspaceMember';

  _i2.Future<_i19.WorkspaceMember> addMemberToWorkspace(
    int userToAddId,
    int workspaceId,
    String token,
  ) =>
      caller.callServerEndpoint<_i19.WorkspaceMember>(
        'workspaceMember',
        'addMemberToWorkspace',
        {
          'userToAddId': userToAddId,
          'workspaceId': workspaceId,
          'token': token,
        },
      );

  _i2.Future<void> removeMemberFromWorkspace(
    int workspaceId,
    int userToRemoveId,
    String token,
  ) =>
      caller.callServerEndpoint<void>(
        'workspaceMember',
        'removeMemberFromWorkspace',
        {
          'workspaceId': workspaceId,
          'userToRemoveId': userToRemoveId,
          'token': token,
        },
      );

  _i2.Future<List<_i20.WorkspaceMemberDetails>> getWorkspaceMember(
    int workspaceId,
    String token,
  ) =>
      caller.callServerEndpoint<List<_i20.WorkspaceMemberDetails>>(
        'workspaceMember',
        'getWorkspaceMember',
        {
          'workspaceId': workspaceId,
          'token': token,
        },
      );

  _i2.Future<_i19.WorkspaceMember> changeMemberRole(
    int workspaceId,
    String token,
    int targetUserId,
    String newRole,
  ) =>
      caller.callServerEndpoint<_i19.WorkspaceMember>(
        'workspaceMember',
        'changeMemberRole',
        {
          'workspaceId': workspaceId,
          'token': token,
          'targetUserId': targetUserId,
          'newRole': newRole,
        },
      );

  _i2.Future<void> leaveWorkspace(
    int workspaceId,
    String token,
  ) =>
      caller.callServerEndpoint<void>(
        'workspaceMember',
        'leaveWorkspace',
        {
          'workspaceId': workspaceId,
          'token': token,
        },
      );

  _i2.Future<_i19.WorkspaceMember> addMemberByEmail(
    String email,
    int workspaceId,
    String token,
    String role,
  ) =>
      caller.callServerEndpoint<_i19.WorkspaceMember>(
        'workspaceMember',
        'addMemberByEmail',
        {
          'email': email,
          'workspaceId': workspaceId,
          'token': token,
          'role': role,
        },
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i21.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i21.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i22.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    attachment = EndpointAttachment(this);
    authentication = EndpointAuthentication(this);
    boardCard = EndpointBoardCard(this);
    board = EndpointBoard(this);
    boardList = EndpointBoardList(this);
    boardMember = EndpointBoardMember(this);
    cardLabel = EndpointCardLabel(this);
    checklist = EndpointChecklist(this);
    checklistItem = EndpointChecklistItem(this);
    comment = EndpointComment(this);
    label = EndpointLabel(this);
    token = EndpointToken(this);
    user = EndpointUser(this);
    workspace = EndpointWorkspace(this);
    workspaceMember = EndpointWorkspaceMember(this);
    greeting = EndpointGreeting(this);
  }

  late final EndpointAttachment attachment;

  late final EndpointAuthentication authentication;

  late final EndpointBoardCard boardCard;

  late final EndpointBoard board;

  late final EndpointBoardList boardList;

  late final EndpointBoardMember boardMember;

  late final EndpointCardLabel cardLabel;

  late final EndpointChecklist checklist;

  late final EndpointChecklistItem checklistItem;

  late final EndpointComment comment;

  late final EndpointLabel label;

  late final EndpointToken token;

  late final EndpointUser user;

  late final EndpointWorkspace workspace;

  late final EndpointWorkspaceMember workspaceMember;

  late final EndpointGreeting greeting;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'attachment': attachment,
        'authentication': authentication,
        'boardCard': boardCard,
        'board': board,
        'boardList': boardList,
        'boardMember': boardMember,
        'cardLabel': cardLabel,
        'checklist': checklist,
        'checklistItem': checklistItem,
        'comment': comment,
        'label': label,
        'token': token,
        'user': user,
        'workspace': workspace,
        'workspaceMember': workspaceMember,
        'greeting': greeting,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
