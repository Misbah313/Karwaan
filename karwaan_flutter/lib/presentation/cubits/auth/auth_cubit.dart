import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/auth_token_storage_helper.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_credentials.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';

class AuthCubit extends Cubit<AuthStateCheck> {
  final AuthRepo authRepo;
  bool _isProcessing = false;

  AuthCubit(this.authRepo) : super(AuthInitial());

  // Handles user login with email and password
  Future<void> login(AuthCredential credential) async {
    if (_isProcessing) return;
    _isProcessing = true;
    emit(AuthLoading());
    try {
      final user = await authRepo.loginUser(credential);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(ExceptionMapper.toMessage(e)));
      rethrow;
    } finally {
      _isProcessing = false;
    }
  }

  // Registers a new user account
  Future<void> register(AuthCredential credential, String name) async {
    if (_isProcessing) return;
    _isProcessing = true;
    emit(AuthLoading());

    try {
      await authRepo.registerUser(credential, name);
      emit(RegisterationSuccess(credential.email));
    } catch (e) {
      emit(AuthError(ExceptionMapper.toMessage(e)));
      rethrow;
    } finally {
      _isProcessing = false;
    }
  }

  /// Logs out the current user and clears all authentication data
  Future<void> logout() async {
    if (_isProcessing) return;
    _isProcessing = true;
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
      emit(AuthError(ExceptionMapper.toMessage(e)));
      rethrow;
    } finally {
      _isProcessing = false;
    }
  }

  // Checks if there's an active authenticated session
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
      emit(AuthError(ExceptionMapper.toMessage(e)));
    } finally {
      _isProcessing = false;
    }
  }

  // Permanently deletes user account
  Future<void> deleteUser(int userId) async {
    if (_isProcessing) return;
    _isProcessing = true;
    emit(AuthLoading());

    try {
      await authRepo.deleteUser(userId);
      emit(DeleteSuccessfully(userId));
    } catch (e) {
      emit(AuthError(ExceptionMapper.toMessage(e)));
      if (state is AuthAuthenticated) {
        emit(state);
      }
    } finally {
      _isProcessing = false;
    }
  }

  // update profile image
  void updateProfileImage(String newFileName) {
    if (state is AuthAuthenticated) {
      final user = (state as AuthAuthenticated).user;
      emit(AuthAuthenticated(user.copyWith(profileImage: newFileName)));
    }
  }

  void resetToUnAuthenticated() {
    emit(AuthUnAuthenticated());
  }
}
