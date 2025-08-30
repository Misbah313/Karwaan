import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';

class ThemeService {
  final ServerpodClientService _clientService;

  ThemeService(this._clientService);

  // update theme
  Future<void> saveUserTheme(int userId, bool isDarkMode) async {
    try {
      await _clientService.saveUserTheme(isDarkMode, userId);
    } catch (e) {
      debugPrint('Failed from theme service: ${e.toString()}');
      rethrow;
    }
  }

  // get theme
  Future<bool> loadUserTheme(int userId) async {
    try {
      final theme = await _clientService.loadUserTheme(userId);
      return theme ?? false;
    } catch (e) {
      debugPrint('Loading theme failed from theme service: ${e.toString()}');
      return false;
    }
  }
}
