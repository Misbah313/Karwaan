import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/auth_token_storage_helper.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_credentials.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';

class AuthCubit extends Cubit<AuthStateCheck> {
  final AuthRepo authRepo;
  bool _isProcessing = false;

  AuthCubit(this.authRepo) : super(AuthInitial());

  /// Handles user login with email and password
  /// [credential] Contains email and password for authentication
  Future<void> login(AuthCredential credential) async {
    if (_isProcessing) return;
    _isProcessing = true;
    emit(AuthLoading());

    try {
      final user = await authRepo.loginUser(credential);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_authErrorHelper(e)));
      rethrow;
    } finally {
      _isProcessing = false;
    } 
  }

  /// Registers a new user account
  /// [credential] Contains email and password
  /// [name] User's display name
  Future<void> register(AuthCredential credential, String name) async {
    if (_isProcessing) return;
    _isProcessing = true;
    emit(AuthLoading());

    try {
      await authRepo.registerUser(credential, name);
      emit(RegisterationSuccess(credential.email));
    } catch (e) {
      emit(AuthError(_authErrorHelper(e)));
      rethrow;
    } finally {
      _isProcessing = false;
    }
  }

  /// Logs out the current user and clears all authentication data
  Future<void> logout() async {
    if (_isProcessing) return;
    _isProcessing = true;

    // Capture current user before state change
    final currentUser =
        (state is AuthAuthenticated) ? (state as AuthAuthenticated).user : null;

    emit(AuthLoading());

    try {
      if (currentUser == null) {
        // No active session but ensure storage is clean
        await AuthTokenStorageHelper().deleteToken();
      } else {
        // Perform API logout and local cleanup
        await authRepo.logoutUser(currentUser.token);
        await AuthTokenStorageHelper().deleteToken();
      }

      // Verify token was actually deleted
      final remainingToken = await AuthTokenStorageHelper().getToken();
      if (remainingToken != null) {
        await AuthTokenStorageHelper().deleteToken(); // Second attempt
        throw Exception('Failed to clear authentication data');
      }

      emit(AuthUnAuthenticated());
    } catch (e) {
      emit(AuthError('We couldn\'t log you out properly. Please try again.'));
      rethrow;
    } finally {
      _isProcessing = false;
    }
  }

  /// Checks if there's an active authenticated session
  Future<void> checkAuth() async {
    if (_isProcessing) return;
    _isProcessing = true;
    emit(AuthLoading());

    try {
      final storedToken = await AuthTokenStorageHelper().getToken();

      if (storedToken == null || storedToken.isEmpty) {
        emit(AuthUnAuthenticated());
        return;
      }

      final user = await authRepo.validateToken(storedToken);
      user != null
          ? emit(AuthAuthenticated(user))
          : emit(AuthUnAuthenticated());
    } catch (e) {
      // Clear potentially corrupted token
      await AuthTokenStorageHelper().deleteToken();
      emit(AuthError('Session verification failed. Please log in again.'));
    } finally {
      _isProcessing = false;
    }
  }

  /// Permanently deletes user account
  /// [userId] ID of user to delete
  Future<void> deleteUser(int userId) async {
    if (_isProcessing) return;
    _isProcessing = true;
    emit(AuthLoading());

    try {
      await authRepo.deleteUser(userId);
      emit(DeleteSuccessfully(userId));
    } catch (e) {
      emit(AuthError(
          'We couldn\'t delete your account. Please try again later.'));
      if (state is AuthAuthenticated) {
        emit(state); // Revert to authenticated state
      }
    } finally {
      _isProcessing = false;
    }
  }

  /// Converts technical errors to user-friendly messages
  String _authErrorHelper(dynamic e) {
    final error = e.toString();

    if (error.contains('Invalid credentials')) {
      return 'The email or password you entered is incorrect';
    }
    if (error.contains('Network error')) {
      return 'Connection failed. Please check your internet';
    }
    if (error.contains('already exists')) {
      return 'This email is already registered';
    }
    return 'Something went wrong. Please try again';
  }

 void resetToUnAuthenticated() {
  emit(AuthUnAuthenticated());
}
}
