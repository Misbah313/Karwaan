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
import 'package:karwaan_client/src/protocol/user.dart' as _i3;
import 'package:karwaan_client/src/protocol/auth_response.dart' as _i4;
import 'package:karwaan_client/src/protocol/board.dart' as _i5;
import 'package:karwaan_client/src/protocol/board_details.dart' as _i6;
import 'package:karwaan_client/src/protocol/workspace.dart' as _i7;
import 'package:karwaan_client/src/protocol/greeting.dart' as _i8;
import 'protocol.dart' as _i9;

/// {@category Endpoint}
class EndpointAuthentication extends _i1.EndpointRef {
  EndpointAuthentication(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'authentication';

  _i2.Future<_i3.User> registerUser(
    String userName,
    String userEmail,
    String userPw,
  ) =>
      caller.callServerEndpoint<_i3.User>(
        'authentication',
        'registerUser',
        {
          'userName': userName,
          'userEmail': userEmail,
          'userPw': userPw,
        },
      );

  _i2.Future<_i4.AuthResponse> loginUser(
    String email,
    String pw,
  ) =>
      caller.callServerEndpoint<_i4.AuthResponse>(
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
class EndpointBoard extends _i1.EndpointRef {
  EndpointBoard(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'board';

  _i2.Future<_i5.Board> createBoard(
    int workspaceId,
    String name,
    String? description,
    String token,
  ) =>
      caller.callServerEndpoint<_i5.Board>(
        'board',
        'createBoard',
        {
          'workspaceId': workspaceId,
          'name': name,
          'description': description,
          'token': token,
        },
      );

  _i2.Future<_i6.BoardDetails> getUserBoard(
    int boardId,
    String token,
  ) =>
      caller.callServerEndpoint<_i6.BoardDetails>(
        'board',
        'getUserBoard',
        {
          'boardId': boardId,
          'token': token,
        },
      );

  _i2.Future<List<_i6.BoardDetails>> getUserBoards(String token) =>
      caller.callServerEndpoint<List<_i6.BoardDetails>>(
        'board',
        'getUserBoards',
        {'token': token},
      );

  _i2.Future<_i5.Board> updateBoard(
    int boardId,
    String token, {
    String? newName,
    String? newDec,
  }) =>
      caller.callServerEndpoint<_i5.Board>(
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
}

/// {@category Endpoint}
class EndpointToken extends _i1.EndpointRef {
  EndpointToken(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'token';

  _i2.Future<_i3.User?> validateToken(String token) =>
      caller.callServerEndpoint<_i3.User?>(
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

  _i2.Future<_i3.User> createUser(_i3.User user) =>
      caller.callServerEndpoint<_i3.User>(
        'user',
        'createUser',
        {'user': user},
      );

  _i2.Future<_i3.User?> getUserById(int userId) =>
      caller.callServerEndpoint<_i3.User?>(
        'user',
        'getUserById',
        {'userId': userId},
      );

  _i2.Future<List<_i3.User>> getAllUsers() =>
      caller.callServerEndpoint<List<_i3.User>>(
        'user',
        'getAllUsers',
        {},
      );

  _i2.Future<_i3.User> updateUser(_i3.User UpdatedUser) =>
      caller.callServerEndpoint<_i3.User>(
        'user',
        'updateUser',
        {'UpdatedUser': UpdatedUser},
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

  _i2.Future<_i7.Workspace> createWorkspace(
    String name,
    String? description,
    String token,
  ) =>
      caller.callServerEndpoint<_i7.Workspace>(
        'workspace',
        'createWorkspace',
        {
          'name': name,
          'description': description,
          'token': token,
        },
      );

  _i2.Future<List<_i7.Workspace>> getUserWorkspace(String token) =>
      caller.callServerEndpoint<List<_i7.Workspace>>(
        'workspace',
        'getUserWorkspace',
        {'token': token},
      );

  _i2.Future<void> addMemberToWorkspace(
    int workspaceId,
    int userToAddId,
    String role,
    String token,
  ) =>
      caller.callServerEndpoint<void>(
        'workspace',
        'addMemberToWorkspace',
        {
          'workspaceId': workspaceId,
          'userToAddId': userToAddId,
          'role': role,
          'token': token,
        },
      );

  _i2.Future<void> removeMemFromWorkspace(
    int workspaceId,
    int userToRemoveId,
    String token,
  ) =>
      caller.callServerEndpoint<void>(
        'workspace',
        'removeMemFromWorkspace',
        {
          'workspaceId': workspaceId,
          'userToRemoveId': userToRemoveId,
          'token': token,
        },
      );

  _i2.Future<_i7.Workspace> updateWorkspace(
    int workspaceId,
    String token, {
    String? newName,
    String? newDes,
  }) =>
      caller.callServerEndpoint<_i7.Workspace>(
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

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i8.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i8.Greeting>(
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
          _i9.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    authentication = EndpointAuthentication(this);
    board = EndpointBoard(this);
    token = EndpointToken(this);
    user = EndpointUser(this);
    workspace = EndpointWorkspace(this);
    greeting = EndpointGreeting(this);
  }

  late final EndpointAuthentication authentication;

  late final EndpointBoard board;

  late final EndpointToken token;

  late final EndpointUser user;

  late final EndpointWorkspace workspace;

  late final EndpointGreeting greeting;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'authentication': authentication,
        'board': board,
        'token': token,
        'user': user,
        'workspace': workspace,
        'greeting': greeting,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
