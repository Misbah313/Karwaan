import 'package:flutter/material.dart';
import 'package:karwaan_client/karwaan_client.dart';
import 'package:karwaan_flutter/core/services/auth_token_storage_helper.dart';
import 'package:karwaan_flutter/core/utils/exceptions/token_expired_exceptions.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

late final Client client;

class ServerpodClientService {
  final AuthTokenStorageHelper _authTokenStorage;

  ServerpodClientService(this._authTokenStorage);

  // initialize serverpod client service
  Future<void> initialize() async {
    client = Client(
      'http://localhost:8090',
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

      // save the token securly
      await _authTokenStorage.saveToken(authResponse.token);

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  // logout
  Future<bool> logoutUser(String token) async {
    try {
      await client.authentication.logoutUser(token);

      // delete the token
      await _authTokenStorage.deleteToken();

      return true;
    } catch (e) {
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
  Future<bool> get isLoggedIn async{
    final token = await _authTokenStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  // refresh token(will add later: it avoid forcing user to login again when access token expires(note: you've set the token for 30 days)).

}
