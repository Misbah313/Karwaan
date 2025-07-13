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
import '../endpoints/authentication_endpoint.dart' as _i2;
import '../endpoints/board_endpoint.dart' as _i3;
import '../endpoints/board_list_endpoint.dart' as _i4;
import '../endpoints/board_member_endpoint.dart' as _i5;
import '../endpoints/card_endpoint.dart' as _i6;
import '../endpoints/label_endpoint.dart' as _i7;
import '../endpoints/token_endpoint.dart' as _i8;
import '../endpoints/user_endpoint.dart' as _i9;
import '../endpoints/workspace_endpoint.dart' as _i10;
import '../endpoints/workspace_member_endpoint.dart' as _i11;
import '../greeting_endpoint.dart' as _i12;
import 'package:karwaan_server/src/generated/user.dart' as _i13;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'authentication': _i2.AuthenticationEndpoint()
        ..initialize(
          server,
          'authentication',
          null,
        ),
      'board': _i3.BoardEndpoint()
        ..initialize(
          server,
          'board',
          null,
        ),
      'boardList': _i4.BoardListEndpoint()
        ..initialize(
          server,
          'boardList',
          null,
        ),
      'boardMember': _i5.BoardMemberEndpoint()
        ..initialize(
          server,
          'boardMember',
          null,
        ),
      'card': _i6.CardEndpoint()
        ..initialize(
          server,
          'card',
          null,
        ),
      'label': _i7.LabelEndpoint()
        ..initialize(
          server,
          'label',
          null,
        ),
      'token': _i8.TokenEndpoint()
        ..initialize(
          server,
          'token',
          null,
        ),
      'user': _i9.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
      'workspace': _i10.WorkspaceEndpoint()
        ..initialize(
          server,
          'workspace',
          null,
        ),
      'workspaceMember': _i11.WorkspaceMemberEndpoint()
        ..initialize(
          server,
          'workspaceMember',
          null,
        ),
      'greeting': _i12.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
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
              (endpoints['authentication'] as _i2.AuthenticationEndpoint)
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
              (endpoints['authentication'] as _i2.AuthenticationEndpoint)
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
              (endpoints['authentication'] as _i2.AuthenticationEndpoint)
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
              (endpoints['board'] as _i3.BoardEndpoint).createBoard(
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
              (endpoints['board'] as _i3.BoardEndpoint).getUserBoard(
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
              (endpoints['board'] as _i3.BoardEndpoint).getUserBoards(
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
              (endpoints['board'] as _i3.BoardEndpoint).updateBoard(
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
              (endpoints['board'] as _i3.BoardEndpoint).deleteBoard(
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
              (endpoints['boardList'] as _i4.BoardListEndpoint).createBoardList(
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
              (endpoints['boardList'] as _i4.BoardListEndpoint).listBoardLists(
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
              (endpoints['boardList'] as _i4.BoardListEndpoint).updateBoardList(
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
              (endpoints['boardList'] as _i4.BoardListEndpoint).deleteBoardList(
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
              (endpoints['boardMember'] as _i5.BoardMemberEndpoint)
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
              (endpoints['boardMember'] as _i5.BoardMemberEndpoint)
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
              (endpoints['boardMember'] as _i5.BoardMemberEndpoint)
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
              (endpoints['boardMember'] as _i5.BoardMemberEndpoint)
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
              (endpoints['boardMember'] as _i5.BoardMemberEndpoint).leaveBoard(
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
              (endpoints['card'] as _i6.CardEndpoint).createCard(
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
              (endpoints['card'] as _i6.CardEndpoint).getListByCard(
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
              (endpoints['card'] as _i6.CardEndpoint).updateCard(
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
              (endpoints['card'] as _i6.CardEndpoint).deleteCard(
            session,
            params['cardId'],
            params['token'],
          ),
        ),
      },
    );
    connectors['label'] = _i1.EndpointConnector(
      name: 'label',
      endpoint: endpoints['label']!,
      methodConnectors: {
        'creatLabel': _i1.MethodConnector(
          name: 'creatLabel',
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
              (endpoints['label'] as _i7.LabelEndpoint).creatLabel(
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
              (endpoints['label'] as _i7.LabelEndpoint).getLabelsForBoard(
            session,
            params['boardId'],
            params['token'],
          ),
        ),
        'updateLable': _i1.MethodConnector(
          name: 'updateLable',
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
              (endpoints['label'] as _i7.LabelEndpoint).updateLable(
            session,
            params['labelId'],
            params['token'],
            newTitle: params['newTitle'],
            newColor: params['newColor'],
          ),
        ),
        'deleteLable': _i1.MethodConnector(
          name: 'deleteLable',
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
              (endpoints['label'] as _i7.LabelEndpoint).deleteLable(
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
              (endpoints['token'] as _i8.TokenEndpoint).validateToken(
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
              (endpoints['token'] as _i8.TokenEndpoint).logout(
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
        'createUser': _i1.MethodConnector(
          name: 'createUser',
          params: {
            'user': _i1.ParameterDescription(
              name: 'user',
              type: _i1.getType<_i13.User>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i9.UserEndpoint).createUser(
            session,
            params['user'],
          ),
        ),
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
              (endpoints['user'] as _i9.UserEndpoint).getUserById(
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
              (endpoints['user'] as _i9.UserEndpoint).getAllUsers(session),
        ),
        'updateUser': _i1.MethodConnector(
          name: 'updateUser',
          params: {
            'UpdatedUser': _i1.ParameterDescription(
              name: 'UpdatedUser',
              type: _i1.getType<_i13.User>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i9.UserEndpoint).updateUser(
            session,
            params['UpdatedUser'],
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
              (endpoints['user'] as _i9.UserEndpoint).deleteUser(
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
              (endpoints['workspace'] as _i10.WorkspaceEndpoint)
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
              (endpoints['workspace'] as _i10.WorkspaceEndpoint)
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
              (endpoints['workspace'] as _i10.WorkspaceEndpoint)
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
              (endpoints['workspace'] as _i10.WorkspaceEndpoint)
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
        'addMemeberToWorkspace': _i1.MethodConnector(
          name: 'addMemeberToWorkspace',
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
              (endpoints['workspaceMember'] as _i11.WorkspaceMemberEndpoint)
                  .addMemeberToWorkspace(
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
              (endpoints['workspaceMember'] as _i11.WorkspaceMemberEndpoint)
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
              (endpoints['workspaceMember'] as _i11.WorkspaceMemberEndpoint)
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
              (endpoints['workspaceMember'] as _i11.WorkspaceMemberEndpoint)
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
              (endpoints['workspaceMember'] as _i11.WorkspaceMemberEndpoint)
                  .leaveWorkspace(
            session,
            params['workspaceId'],
            params['token'],
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
              (endpoints['greeting'] as _i12.GreetingEndpoint).hello(
            session,
            params['name'],
          ),
        )
      },
    );
  }
}
