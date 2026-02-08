import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/client/app_theme_service.dart';
import 'package:karwaan_flutter/core/services/client/profile_image_service.dart';
import 'package:karwaan_flutter/core/services/workspace/app_naviagation_service.dart';
import 'package:karwaan_flutter/core/theme/theme_notifier.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/presentation/widgets/focus_time_calendar.dart';
import 'package:karwaan_flutter/presentation/widgets/dashboard_overall_progress_section.dart';
import 'package:karwaan_flutter/presentation/widgets/profile_avatar.dart';
import 'package:provider/provider.dart'; // Add this import

class DashboardRightSidebar extends StatelessWidget {
  final AuthUser user;
  final ProfileImageService profileImageService;
  final AppNavigationService navigationService;
  final AppThemeService themeService;

  const DashboardRightSidebar({
    super.key,
    required this.user,
    required this.profileImageService,
    required this.navigationService,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              left: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildProfileSection(context, themeNotifier),
                SizedBox(height: 20),
                _buildProgressSection(),
                SizedBox(height: 20),
                _buildCalendarSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileSection(
      BuildContext context, ThemeNotifier themeNotifier) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          ProfileAvatar(
            user: user,
            profileImageService: profileImageService,
          ),
          SizedBox(width: 12),
          _buildUserInfo(context),
          _buildProfileDropdown(context, themeNotifier),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.name,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(height: 2),
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDropdown(
      BuildContext context, ThemeNotifier themeNotifier) {
    return DropdownButton<String>(
      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      items: _buildDropdownItems(context, themeNotifier),
      onChanged: (value) => _handleDropdownChange(context, value),
      icon: Icon(
        Icons.arrow_drop_down,
        size: 20,
        color: Theme.of(context).iconTheme.color,
      ),
      underline: SizedBox(),
      style: Theme.of(context).textTheme.bodySmall
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(
      BuildContext context, ThemeNotifier themeNotifier) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      DropdownMenuItem(
        value: 'profile',
        child: Row(
          children: [
            Icon(Icons.person, size: 16),
            SizedBox(width: 8),
            Text('Profile', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      DropdownMenuItem(
        value: 'settings',
        child: Row(
          children: [
            Icon(Icons.settings, size: 16),
            SizedBox(width: 8),
            Text('Settings', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      DropdownMenuItem(
        value: 'logout',
        child: Row(
          children: [
            Icon(Icons.logout, size: 16),
            SizedBox(width: 8),
            Text('Logout', style: TextStyle(fontSize: 12, color: Colors.red)),
          ],
        ),
      ),
      DropdownMenuItem(
        value: 'toggle_theme',
        child: Row(
          children: [
            Icon(isDark ? Icons.light_mode : Icons.dark_mode, size: 16),
            SizedBox(width: 8),
            Text(
              isDark ? 'Light Theme' : 'Dark Theme',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ];
  }

  void _handleDropdownChange(BuildContext context, String? value) {
    switch (value) {
      case 'logout':
        navigationService.showLogoutDialog(context);
        break;
      case 'toggle_theme':
        themeService.toggleTheme(user);
        break;
      case 'profile':
      case 'settings':
        navigationService.navigateToProfile(context);
        break;
    }
  }

  Widget _buildProgressSection() {
    return SizedBox(
      width: double.infinity,
      child:  OverallProgressSection(),
    );
  }

  Widget _buildCalendarSection() {
    return SizedBox(
      width: double.infinity,
      child: FocusTimeCalendar(),
    );
  }
}
