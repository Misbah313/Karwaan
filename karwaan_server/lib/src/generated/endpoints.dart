/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/attachment_endpoint.dart' as _i2;
import '../endpoints/authentication_endpoint.dart' as _i3;
import '../endpoints/board_endpoint.dart' as _i4;
import '../endpoints/board_list_endpoint.dart' as _i5;
import '../endpoints/board_member_endpoint.dart' as _i6;
import '../endpoints/card_endpoint.dart' as _i7;
import '../endpoints/card_label_endpoint.dart' as _i8;
import '../endpoints/checklist_endpoint.dart' as _i9;
import '../endpoints/checklist_item_endpoint.dart' as _i10;
import '../endpoints/comment_endpoint.dart' as _i11;
import '../endpoints/label_endpoint.dart' as _i12;
import '../endpoints/token_endpoint.dart' as _i13;
import '../endpoints/user_endpoint.dart' as _i14;
import '../endpoints/workspace_endpoint.dart' as _i15;
import '../endpoints/workspace_member_endpoint.dart' as _i16;
import '../greeting_endpoint.dart' as _i17;
import 'package:karwaan_server/src/generated/user.dart' as _i18;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'attachment': _i2.AttachmentEndpoint()
        ..initialize(
          server,
          'attachment',
          null,
        ),
      'authentication': _i3.AuthenticationEndpoint()
        ..initialize(
          server,
          'authentication',
          null,
        ),
      'board': _i4.BoardEndpoint()
        ..initialize(
          server,
          'board',
          null,
        ),
      'boardList': _i5.BoardListEndpoint()
        ..initialize(
          server,
          'boardList',
          null,
        ),
      'boardMember': _i6.BoardMemberEndpoint()
        ..initialize(
          server,
          'boardMember',
          null,
        ),
      'card': _i7.CardEndpoint()
        ..initialize(
          server,
          'card',
          null,
        ),
      'cardLabel': _i8.CardLabelEndpoint()
        ..initialize(
          server,
          'cardLabel',
          null,
        ),
      'checklist': _i9.ChecklistEndpoint()
        ..initialize(
          server,
          'checklist',
          null,
        ),
      'checklistItem': _i10.ChecklistItemEndpoint()
        ..initialize(
          server,
          'checklistItem',
          null,
        ),
      'comment': _i11.CommentEndpoint()
        ..initialize(
          server,
          'comment',
          null,
        ),
      'label': _i12.LabelEndpoint()
        ..initialize(
          server,
          'label',
          null,
        ),
      'token': _i13.TokenEndpoint()
        ..initialize(
          server,
          'token',
          null,
        ),
      'user': _i14.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
      'workspace': _i15.WorkspaceEndpoint()
        ..initialize(
          server,
          'workspace',
          null,
        ),
      'workspaceMember': _i16.WorkspaceMemberEndpoint()
        ..initialize(
          server,
          'workspaceMember',
          null,
        ),
      'greeting': _i17.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['attachment'] = _i1.EndpointConnector(
      name: 'attachment',
      endpoint: endpoints['attachment']!,
      methodConnectors: {
        'uploadAttachment': _i1.MethodConnector(
          name: 'uploadAttachment',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['attachment'] as _i2.AttachmentEndpoint)
                  .uploadAttachment(
            session,
            params['cardId'],
            params['fileName'],
            params['token'],
          ),
        ),
        'listAttachments': _i1.MethodConnector(
          name: 'listAttachments',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['attachment'] as _i2.AttachmentEndpoint)
                  .listAttachments(
            session,
            params['cardId'],
            params['token'],
          ),
        ),
        'deleteAttachment': _i1.MethodConnector(
          name: 'deleteAttachment',
          params: {
            'attachmentId': _i1.ParameterDescription(
              name: 'attachmentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['attachment'] as _i2.AttachmentEndpoint)
                  .deleteAttachment(
            session,
            params['attachmentId'],
            params['token'],
          ),
        ),
      },
    );
    connectors['authentication'] = _i1.EndpointConnector(
      name: 'authentication',
      endpoint: endpoints['authentication']!,
      methodConnectors: {
        'registerUser': _i1.MethodConnector(
          name: 'registerUser',
          params: {
            'userName': _i1.ParameterDescription(
              name: 'userName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'userEmail': _i1.ParameterDescription(
              name: 'userEmail',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'userPw': _i1.ParameterDescription(
              name: 'userPw',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authentication'] as _i3.AuthenticationEndpoint)
                  .registerUser(
            session,
            params['userName'],
            params['userEmail'],
            params['userPw'],
          ),
        ),
        'loginUser': _i1.MethodConnector(
          name: 'loginUser',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'pw': _i1.ParameterDescription(
              name: 'pw',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authentication'] as _i3.AuthenticationEndpoint)
                  .loginUser(
            session,
            params['email'],
            params['pw'],
          ),
        ),
        'logoutUser': _i1.MethodConnector(
          name: 'logoutUser',
          params: {
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authentication'] as _i3.AuthenticationEndpoint)
                  .logoutUser(
            session,
            params['token'],
          ),
        ),
      },
    );
    connectors['board'] = _i1.EndpointConnector(
      name: 'board',
      endpoint: endpoints['board']!,
      methodConnectors: {
        'createBoard': _i1.MethodConnector(
          name: 'createBoard',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['board'] as _i4.BoardEndpoint).createBoard(
            session,
            params['workspaceId'],
            params['name'],
            params['description'],
            params['token'],
          ),
        ),
        'getUserBoard': _i1.MethodConnector(
          name: 'getUserBoard',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['board'] as _i4.BoardEndpoint).getUserBoard(
            session,
            params['boardId'],
            params['token'],
          ),
        ),
        'getUserBoards': _i1.MethodConnector(
          name: 'getUserBoards',
          params: {
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['board'] as _i4.BoardEndpoint).getUserBoards(
            session,
            params['token'],
          ),
        ),
        'updateBoard': _i1.MethodConnector(
          name: 'updateBoard',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newName': _i1.ParameterDescription(
              name: 'newName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newDec': _i1.ParameterDescription(
              name: 'newDec',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['board'] as _i4.BoardEndpoint).updateBoard(
            session,
            params['boardId'],
            params['token'],
            newName: params['newName'],
            newDec: params['newDec'],
          ),
        ),
        'deleteBoard': _i1.MethodConnector(
          name: 'deleteBoard',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['board'] as _i4.BoardEndpoint).deleteBoard(
            session,
            params['boardId'],
            params['token'],
          ),
        ),
      },
    );
    connectors['boardList'] = _i1.EndpointConnector(
      name: 'boardList',
      endpoint: endpoints['boardList']!,
      methodConnectors: {
        'createBoardList': _i1.MethodConnector(
          name: 'createBoardList',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['boardList'] as _i5.BoardListEndpoint).createBoardList(
            session,
            params['boardId'],
            params['token'],
            params['title'],
          ),
        ),
        'listBoardLists': _i1.MethodConnector(
          name: 'listBoardLists',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['boardList'] as _i5.BoardListEndpoint).listBoardLists(
            session,
            params['boardId'],
            params['token'],
          ),
        ),
        'updateBoardList': _i1.MethodConnector(
          name: 'updateBoardList',
          params: {
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newTitle': _i1.ParameterDescription(
              name: 'newTitle',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['boardList'] as _i5.BoardListEndpoint).updateBoardList(
            session,
            params['listId'],
            params['token'],
            params['newTitle'],
          ),
        ),
        'deleteBoardList': _i1.MethodConnector(
          name: 'deleteBoardList',
          params: {
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['boardList'] as _i5.BoardListEndpoint).deleteBoardList(
            session,
            params['listId'],
            params['token'],
          ),
        ),
      },
    );
    connectors['boardMember'] = _i1.EndpointConnector(
      name: 'boardMember',
      endpoint: endpoints['boardMember']!,
      methodConnectors: {
        'addMemberToBoard': _i1.MethodConnector(
          name: 'addMemberToBoard',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'userToAddId': _i1.ParameterDescription(
              name: 'userToAddId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['boardMember'] as _i6.BoardMemberEndpoint)
                  .addMemberToBoard(
            session,
            params['boardId'],
            params['userToAddId'],
            params['token'],
          ),
        ),
        'removeMemberFromBoard': _i1.MethodConnector(
          name: 'removeMemberFromBoard',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'userToRemoveId': _i1.ParameterDescription(
              name: 'userToRemoveId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['boardMember'] as _i6.BoardMemberEndpoint)
                  .removeMemberFromBoard(
            session,
            params['boardId'],
            params['userToRemoveId'],
            params['token'],
          ),
        ),
        'getBoardMembers': _i1.MethodConnector(
          name: 'getBoardMembers',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['boardMember'] as _i6.BoardMemberEndpoint)
                  .getBoardMembers(
            session,
            params['boardId'],
            params['token'],
          ),
        ),
        'changeBoardMemberRole': _i1.MethodConnector(
          name: 'changeBoardMemberRole',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'userToChangeRole': _i1.ParameterDescription(
              name: 'userToChangeRole',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newRole': _i1.ParameterDescription(
              name: 'newRole',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['boardMember'] as _i6.BoardMemberEndpoint)
                  .changeBoardMemberRole(
            session,
            params['boardId'],
            params['token'],
            params['userToChangeRole'],
            params['newRole'],
          ),
        ),
        'leaveBoard': _i1.MethodConnector(
          name: 'leaveBoard',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['boardMember'] as _i6.BoardMemberEndpoint).leaveBoard(
            session,
            params['boardId'],
            params['token'],
          ),
        ),
      },
    );
    connectors['card'] = _i1.EndpointConnector(
      name: 'card',
      endpoint: endpoints['card']!,
      methodConnectors: {
        'createCard': _i1.MethodConnector(
          name: 'createCard',
          params: {
            'boardListId': _i1.ParameterDescription(
              name: 'boardListId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'dec': _i1.ParameterDescription(
              name: 'dec',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['card'] as _i7.CardEndpoint).createCard(
            session,
            params['boardListId'],
            params['token'],
            params['title'],
            dec: params['dec'],
          ),
        ),
        'getListByCard': _i1.MethodConnector(
          name: 'getListByCard',
          params: {
            'boardListId': _i1.ParameterDescription(
              name: 'boardListId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['card'] as _i7.CardEndpoint).getListByCard(
            session,
            params['boardListId'],
            params['token'],
          ),
        ),
        'updateCard': _i1.MethodConnector(
          name: 'updateCard',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newTitle': _i1.ParameterDescription(
              name: 'newTitle',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newDec': _i1.ParameterDescription(
              name: 'newDec',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'completed': _i1.ParameterDescription(
              name: 'completed',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['card'] as _i7.CardEndpoint).updateCard(
            session,
            params['cardId'],
            params['token'],
            params['newTitle'],
            params['newDec'],
            params['completed'],
          ),
        ),
        'deleteCard': _i1.MethodConnector(
          name: 'deleteCard',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['card'] as _i7.CardEndpoint).deleteCard(
            session,
            params['cardId'],
            params['token'],
          ),
        ),
      },
    );
    connectors['cardLabel'] = _i1.EndpointConnector(
      name: 'cardLabel',
      endpoint: endpoints['cardLabel']!,
      methodConnectors: {
        'assignLableToCard': _i1.MethodConnector(
          name: 'assignLableToCard',
          params: {
            'labelId': _i1.ParameterDescription(
              name: 'labelId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cardLabel'] as _i8.CardLabelEndpoint)
                  .assignLableToCard(
            session,
            params['labelId'],
            params['cardId'],
            params['token'],
          ),
        ),
        'removeLabelFromCard': _i1.MethodConnector(
          name: 'removeLabelFromCard',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'labelId': _i1.ParameterDescription(
              name: 'labelId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cardLabel'] as _i8.CardLabelEndpoint)
                  .removeLabelFromCard(
            session,
            params['cardId'],
            params['labelId'],
            params['token'],
          ),
        ),
        'getLabelForCard': _i1.MethodConnector(
          name: 'getLabelForCard',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cardLabel'] as _i8.CardLabelEndpoint).getLabelForCard(
            session,
            params['cardId'],
            params['token'],
          ),
        ),
        'getCardForLabel': _i1.MethodConnector(
          name: 'getCardForLabel',
          params: {
            'labelId': _i1.ParameterDescription(
              name: 'labelId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cardLabel'] as _i8.CardLabelEndpoint).getCardForLabel(
            session,
            params['labelId'],
            params['token'],
          ),
        ),
      },
    );
    connectors['checklist'] = _i1.EndpointConnector(
      name: 'checklist',
      endpoint: endpoints['checklist']!,
      methodConnectors: {
        'createChecklist': _i1.MethodConnector(
          name: 'createChecklist',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['checklist'] as _i9.ChecklistEndpoint).createChecklist(
            session,
            params['cardId'],
            params['title'],
            params['token'],
          ),
        ),
        'listChecklist': _i1.MethodConnector(
          name: 'listChecklist',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['checklist'] as _i9.ChecklistEndpoint).listChecklist(
            session,
            params['cardId'],
            params['token'],
          ),
        ),
        'updateChecklist': _i1.MethodConnector(
          name: 'updateChecklist',
          params: {
            'checklistId': _i1.ParameterDescription(
              name: 'checklistId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newTitle': _i1.ParameterDescription(
              name: 'newTitle',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['checklist'] as _i9.ChecklistEndpoint).updateChecklist(
            session,
            params['checklistId'],
            params['newTitle'],
            params['token'],
          ),
        ),
        'deleteChecklist': _i1.MethodConnector(
          name: 'deleteChecklist',
          params: {
            'checklistId': _i1.ParameterDescription(
              name: 'checklistId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['checklist'] as _i9.ChecklistEndpoint).deleteChecklist(
            session,
            params['checklistId'],
            params['token'],
          ),
        ),
      },
    );
    connectors['checklistItem'] = _i1.EndpointConnector(
      name: 'checklistItem',
      endpoint: endpoints['checklistItem']!,
      methodConnectors: {
        'createChecklistItem': _i1.MethodConnector(
          name: 'createChecklistItem',
          params: {
            'checklistId': _i1.ParameterDescription(
              name: 'checklistId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'content': _i1.ParameterDescription(
              name: 'content',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['checklistItem'] as _i10.ChecklistItemEndpoint)
                  .createChecklistItem(
            session,
            params['checklistId'],
            params['content'],
            params['token'],
          ),
        ),
        'listChecklistItems': _i1.MethodConnector(
          name: 'listChecklistItems',
          params: {
            'checklistId': _i1.ParameterDescription(
              name: 'checklistId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['checklistItem'] as _i10.ChecklistItemEndpoint)
                  .listChecklistItems(
            session,
            params['checklistId'],
            params['token'],
          ),
        ),
        'updateChecklistItem': _i1.MethodConnector(
          name: 'updateChecklistItem',
          params: {
            'checklistItemId': _i1.ParameterDescription(
              name: 'checklistItemId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'checklistId': _i1.ParameterDescription(
              name: 'checklistId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newContent': _i1.ParameterDescription(
              name: 'newContent',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['checklistItem'] as _i10.ChecklistItemEndpoint)
                  .updateChecklistItem(
            session,
            params['checklistItemId'],
            params['checklistId'],
            params['newContent'],
            params['token'],
          ),
        ),
        'toggleChecklistItemStatus': _i1.MethodConnector(
          name: 'toggleChecklistItemStatus',
          params: {
            'checklistItemId': _i1.ParameterDescription(
              name: 'checklistItemId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['checklistItem'] as _i10.ChecklistItemEndpoint)
                  .toggleChecklistItemStatus(
            session,
            params['checklistItemId'],
            params['token'],
          ),
        ),
        'deleteChecklistItem': _i1.MethodConnector(
          name: 'deleteChecklistItem',
          params: {
            'checklistItemId': _i1.ParameterDescription(
              name: 'checklistItemId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['checklistItem'] as _i10.ChecklistItemEndpoint)
                  .deleteChecklistItem(
            session,
            params['checklistItemId'],
            params['token'],
          ),
        ),
      },
    );
    connectors['comment'] = _i1.EndpointConnector(
      name: 'comment',
      endpoint: endpoints['comment']!,
      methodConnectors: {
        'createComment': _i1.MethodConnector(
          name: 'createComment',
          params: {
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'content': _i1.ParameterDescription(
              name: 'content',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['comment'] as _i11.CommentEndpoint).createComment(
            session,
            params['token'],
            params['cardId'],
            params['content'],
          ),
        ),
        'getCommentsForCard': _i1.MethodConnector(
          name: 'getCommentsForCard',
          params: {
            'cardId': _i1.ParameterDescription(
              name: 'cardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['comment'] as _i11.CommentEndpoint).getCommentsForCard(
            session,
            params['cardId'],
            params['token'],
          ),
        ),
        'updateComment': _i1.MethodConnector(
          name: 'updateComment',
          params: {
            'commentId': _i1.ParameterDescription(
              name: 'commentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newContent': _i1.ParameterDescription(
              name: 'newContent',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['comment'] as _i11.CommentEndpoint).updateComment(
            session,
            params['commentId'],
            params['newContent'],
            params['token'],
          ),
        ),
        'deleteComment': _i1.MethodConnector(
          name: 'deleteComment',
          params: {
            'commentId': _i1.ParameterDescription(
              name: 'commentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['comment'] as _i11.CommentEndpoint).deleteComment(
            session,
            params['commentId'],
            params['token'],
          ),
        ),
      },
    );
    connectors['label'] = _i1.EndpointConnector(
      name: 'label',
      endpoint: endpoints['label']!,
      methodConnectors: {
        'createLabel': _i1.MethodConnector(
          name: 'createLabel',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'color': _i1.ParameterDescription(
              name: 'color',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['label'] as _i12.LabelEndpoint).createLabel(
            session,
            params['boardId'],
            params['token'],
            params['title'],
            params['color'],
          ),
        ),
        'getLabelsForBoard': _i1.MethodConnector(
          name: 'getLabelsForBoard',
          params: {
            'boardId': _i1.ParameterDescription(
              name: 'boardId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['label'] as _i12.LabelEndpoint).getLabelsForBoard(
            session,
            params['boardId'],
            params['token'],
          ),
        ),
        'updateLabel': _i1.MethodConnector(
          name: 'updateLabel',
          params: {
            'labelId': _i1.ParameterDescription(
              name: 'labelId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newTitle': _i1.ParameterDescription(
              name: 'newTitle',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newColor': _i1.ParameterDescription(
              name: 'newColor',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['label'] as _i12.LabelEndpoint).updateLabel(
            session,
            params['labelId'],
            params['token'],
            newTitle: params['newTitle'],
            newColor: params['newColor'],
          ),
        ),
        'deleteLabel': _i1.MethodConnector(
          name: 'deleteLabel',
          params: {
            'labelId': _i1.ParameterDescription(
              name: 'labelId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['label'] as _i12.LabelEndpoint).deleteLabel(
            session,
            params['labelId'],
            params['token'],
          ),
        ),
      },
    );
    connectors['token'] = _i1.EndpointConnector(
      name: 'token',
      endpoint: endpoints['token']!,
      methodConnectors: {
        'validateToken': _i1.MethodConnector(
          name: 'validateToken',
          params: {
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['token'] as _i13.TokenEndpoint).validateToken(
            session,
            params['token'],
          ),
        ),
        'logout': _i1.MethodConnector(
          name: 'logout',
          params: {
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['token'] as _i13.TokenEndpoint).logout(
            session,
            params['token'],
          ),
        ),
      },
    );
    connectors['user'] = _i1.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'getUserById': _i1.MethodConnector(
          name: 'getUserById',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i14.UserEndpoint).getUserById(
            session,
            params['userId'],
          ),
        ),
        'getAllUsers': _i1.MethodConnector(
          name: 'getAllUsers',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i14.UserEndpoint).getAllUsers(session),
        ),
        'updateUser': _i1.MethodConnector(
          name: 'updateUser',
          params: {
            'updatedUser': _i1.ParameterDescription(
              name: 'updatedUser',
              type: _i1.getType<_i18.User>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i14.UserEndpoint).updateUser(
            session,
            params['updatedUser'],
          ),
        ),
        'deleteUser': _i1.MethodConnector(
          name: 'deleteUser',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i14.UserEndpoint).deleteUser(
            session,
            params['id'],
          ),
        ),
      },
    );
    connectors['workspace'] = _i1.EndpointConnector(
      name: 'workspace',
      endpoint: endpoints['workspace']!,
      methodConnectors: {
        'createWorkspace': _i1.MethodConnector(
          name: 'createWorkspace',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i15.WorkspaceEndpoint)
                  .createWorkspace(
            session,
            params['name'],
            params['description'],
            params['token'],
          ),
        ),
        'getUserWorkspace': _i1.MethodConnector(
          name: 'getUserWorkspace',
          params: {
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i15.WorkspaceEndpoint)
                  .getUserWorkspace(
            session,
            params['token'],
          ),
        ),
        'updateWorkspace': _i1.MethodConnector(
          name: 'updateWorkspace',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newName': _i1.ParameterDescription(
              name: 'newName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newDes': _i1.ParameterDescription(
              name: 'newDes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i15.WorkspaceEndpoint)
                  .updateWorkspace(
            session,
            params['workspaceId'],
            params['token'],
            newName: params['newName'],
            newDes: params['newDes'],
          ),
        ),
        'deleteWorkspace': _i1.MethodConnector(
          name: 'deleteWorkspace',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i15.WorkspaceEndpoint)
                  .deleteWorkspace(
            session,
            params['workspaceId'],
            params['token'],
          ),
        ),
      },
    );
    connectors['workspaceMember'] = _i1.EndpointConnector(
      name: 'workspaceMember',
      endpoint: endpoints['workspaceMember']!,
      methodConnectors: {
        'addMemberToWorkspace': _i1.MethodConnector(
          name: 'addMemberToWorkspace',
          params: {
            'userToAddId': _i1.ParameterDescription(
              name: 'userToAddId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspaceMember'] as _i16.WorkspaceMemberEndpoint)
                  .addMemberToWorkspace(
            session,
            params['userToAddId'],
            params['workspaceId'],
            params['token'],
          ),
        ),
        'removeMemberFromWorkspace': _i1.MethodConnector(
          name: 'removeMemberFromWorkspace',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'userToRemoveId': _i1.ParameterDescription(
              name: 'userToRemoveId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspaceMember'] as _i16.WorkspaceMemberEndpoint)
                  .removeMemberFromWorkspace(
            session,
            params['workspaceId'],
            params['userToRemoveId'],
            params['token'],
          ),
        ),
        'getWorkspaceMember': _i1.MethodConnector(
          name: 'getWorkspaceMember',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspaceMember'] as _i16.WorkspaceMemberEndpoint)
                  .getWorkspaceMember(
            session,
            params['workspaceId'],
            params['token'],
          ),
        ),
        'changeMemberRole': _i1.MethodConnector(
          name: 'changeMemberRole',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'targetUserId': _i1.ParameterDescription(
              name: 'targetUserId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newRole': _i1.ParameterDescription(
              name: 'newRole',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspaceMember'] as _i16.WorkspaceMemberEndpoint)
                  .changeMemberRole(
            session,
            params['workspaceId'],
            params['token'],
            params['targetUserId'],
            params['newRole'],
          ),
        ),
        'leaveWorkspace': _i1.MethodConnector(
          name: 'leaveWorkspace',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspaceMember'] as _i16.WorkspaceMemberEndpoint)
                  .leaveWorkspace(
            session,
            params['workspaceId'],
            params['token'],
          ),
        ),
        'addMemberByEmail': _i1.MethodConnector(
          name: 'addMemberByEmail',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspaceMember'] as _i16.WorkspaceMemberEndpoint)
                  .addMemberByEmail(
            session,
            params['email'],
            params['workspaceId'],
            params['token'],
            params['role'],
          ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['greeting'] as _i17.GreetingEndpoint).hello(
            session,
            params['name'],
          ),
        )
      },
    );
  }
}
