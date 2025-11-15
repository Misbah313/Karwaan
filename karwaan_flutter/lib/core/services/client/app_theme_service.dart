import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/theme/theme_notifier.dart';
import 'package:karwaan_flutter/core/theme/theme_service.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';

class AppThemeService {
  final ThemeService themeService;
  final ThemeNotifier themeNotifier;

  AppThemeService({
    required this.themeService,
    required this.themeNotifier,
  });

  void toggleTheme(AuthUser user) {
    final newTheme = themeNotifier.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    themeNotifier.setThemeMode(newTheme);
    themeService.saveUserTheme(user.id, newTheme == ThemeMode.dark);
  }

  ThemeMode get currentTheme => themeNotifier.themeMode;
}
