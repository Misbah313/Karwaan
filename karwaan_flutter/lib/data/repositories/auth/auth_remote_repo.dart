import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/data/mappers/auth/auth_response_mapper.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_credentials.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';

class AuthRemoteRepo implements AuthRepo {
  final ServerpodClientService _clientService;

  AuthRemoteRepo(this._clientService);

  @override
  Future<AuthUser> registerUser(AuthCredential credential, String name) async {
    try {
      final user = await _clientService.registerUser(
          credential.email, credential.password, name);

      debugPrint('Registered user: ${user.id} | ${user.email}');

      if (user.id == null) {
        throw Exception('Server returned null user ID');
      }

      return AuthUser(
        id: user.id!,
        name: user.name,
        email: user.email,
        token: '', // Explicit empty token
      );
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow; // Let AuthCubit handle the error
    }
  }

  // Login
  @override
  Future<AuthUser> loginUser(AuthCredential credential) async {
    try {
      final authres =
          await _clientService.loginUser(credential.email, credential.password);

      debugPrint('Login response: ${authres.token}');

      if (authres.token.isEmpty) {
        throw Exception('Server returned empty token');
      }

      return authres.toDomain();
    } catch (e) {
      debugPrint('Login failed for ${credential.email}: $e');
      rethrow;
    }
  }

  // Logout
  @override
  Future<bool> logoutUser(String token) async {
    try {
      debugPrint('Attempting logout form remote repo');
      await _clientService.logoutUser(token);

      return true;
    } catch (e) {
      debugPrint('Logout failed: $e');
      rethrow;
    }
  }

  // validate token
  @override
  Future<AuthUser?> validateToken(String incomingToken) async {
    // Renamed parameter
    try {
      final user = await _clientService.getCurrentUser();
      if (user == null) return null;

      final storedToken = await _clientService.getToken(); // Renamed variable
      if (storedToken != incomingToken) {
        debugPrint(
            'Token mismatch: stored $storedToken vs incoming $incomingToken');
        return null;
      }

      return AuthUser(
        id: user.id!,
        name: user.name,
        email: user.email,
        token: storedToken ?? '',
      );
    } catch (e) {
      debugPrint('Token validation error: $e');
      return null;
    }
  }

  /* check login status
  @override
  Future<bool> get isLoggedIn => _clientService.isLoggedIn; */

  // delete user
  @override
  Future<void> deleteUser(int userId) async {
    try {
      await _clientService.deleteUser(userId);
    } catch (e) {
      rethrow;
    }
  }
}
