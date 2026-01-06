import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/workspace/app_naviagation_service.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_context_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/side_bar_item.dart';
import 'package:provider/provider.dart';

class LeftSidebar extends StatelessWidget {
  final String selectedMenu;
  final AppNavigationService navigationService;

  const LeftSidebar({
    super.key,
    required this.selectedMenu,
    required this.navigationService,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.1,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSection(context),
              _buildLogoutSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Column(
      children: [
        // Karwaan logo
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Image.asset(
            'asset/images/webkarwaan.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 40),
        _buildMenuItems(context),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      (icon: Icons.dashboard, label: 'Dashboard', index: 0),
      (icon: Icons.space_dashboard_rounded, label: 'Boards', index: 1),
      (icon: Icons.analytics_outlined, label: 'Analysis', index: 2),
      (icon: Icons.people_alt_outlined, label: 'Teams', index: 3),
      (icon: Icons.settings, label: 'Settings', index: 4),
    ];

    return Column(
      children: menuItems.map((item) {
        return Column(
          children: [
            SideBarItem(
              icon: item.icon,
              label: item.label,
              selected: selectedMenu == item.label,
              onTap: () {
                if (item.label == "Boards") {
                  context.read<WorkspaceContextCubit>().clearCurrentWorkspace();
                }
                navigationService.navigateToPage(item.index, item.label);
              },
            ),
            const SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SideBarItem(
          icon: Icons.logout_outlined,
          label: 'Logout',
          selected: selectedMenu == 'Logout',
          onTap: () => navigationService.showLogoutDialog(context),
        ),
      ],
    );
  }
}
