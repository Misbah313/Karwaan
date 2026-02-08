import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/client/app_theme_service.dart';
import 'package:karwaan_flutter/core/services/client/profile_image_service.dart';
import 'package:karwaan_flutter/core/services/workspace/app_naviagation_service.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_dialog_service.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';
import 'package:karwaan_flutter/core/theme/theme_notifier.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/domain/models/board/board_analytics.dart';
import 'package:karwaan_flutter/domain/models/board/board_preview_analytics_state.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_preview_analytics_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_preview_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_context_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/profile_avatar.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/simple_pie_chart.dart';
import 'package:karwaan_flutter/presentation/widgets/workspace/workspace_member_card.dart';
import 'package:provider/provider.dart';

class BoardPageRightsideBar extends StatelessWidget {
  final AuthUser user;
  final ProfileImageService profileImageService;
  final AppNavigationService navigationService;
  final AppThemeService themeService;
  final MemberService memberService;

  const BoardPageRightsideBar({
    super.key,
    required this.user,
    required this.profileImageService,
    required this.navigationService,
    required this.themeService,
    required this.memberService,
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
                      color:
                          Theme.of(context).dividerColor.withValues(alpha: 0.4),
                      width: 1))),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildProfileSection(context, themeNotifier),
                const SizedBox(height: 20),
                // Workspace Members section
                _buildWorkspaceMembersSection(),
                const SizedBox(height: 20),
                // single selected board progress section
                BlocBuilder<BoardPreviewCubit, int?>(
                    builder: (context, boardId) {
                  if (boardId == null) {
                    return _emptyBoardPreview(context);
                  }
                  return BlocBuilder<BoardPreviewAnalyticsCubit,
                      BoardPreviewAnalyticsState>(
                    builder: (context, state) {
                      if (state is AnalyticsIdle) {
                        return _emptyBoardPreview(context);
                      }

                      if (state is AnalyticsPreviewLoading) {
                        return _buildLoadingState(context);
                      }

                      if (state is AnalyticsPreviewError) {
                        return _buildErrorPreview(context, state.message);
                      }

                      if (state is AnalyticsPreviewLoaded) {
                        return _buildSingleBoardPreview(
                            context, state.analytics);
                      }

                      return _emptyBoardPreview(context);
                    },
                  );
                })
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        const SizedBox(height: 5),
        Text(
          'Loading',
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    );
  }

  Widget _buildErrorPreview(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Failed to load analytics',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.red),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSingleBoardPreview(
      BuildContext context, BoardAnalytics analytics) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withAlpha(13)
                : Colors.black.withAlpha(5),
            border: Border.all(
                color: Theme.of(context).dividerColor.withAlpha(102)),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header with board name
              Row(
                children: [
                  Expanded(
                    child: Text(
                      analytics.boardName ?? 'Board ${analytics.boardId}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildProgressOverView(context, analytics),
              const SizedBox(height: 20),
              SimplePieChart(analytics: analytics)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressOverView(
      BuildContext context, BoardAnalytics analytics) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard(context, 'Total Cards', analytics.totalCards.toString(),
            Icons.task_outlined, Colors.blue),
        _buildStatCard(
            context,
            'Completed',
            analytics.completedCards.toString(),
            Icons.check_circle,
            Colors.green),
        _buildStatCard(
            context,
            'Progress',
            '${analytics.completionPercentage.toStringAsFixed(1)}%',
            Icons.trending_up,
            Colors.orange)
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration:
              BoxDecoration(color: color.withAlpha(40), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(title,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[600], fontSize: 10)),
      ],
    );
  }

  Widget _buildProfileSection(
      BuildContext context, ThemeNotifier themeNotifier) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4))),
      child: Row(
        children: [
          ProfileAvatar(user: user, profileImageService: profileImageService),
          const SizedBox(width: 12),
          _buildUserInfo(context),
          _buildProfileDropdown(context, themeNotifier)
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
        const SizedBox(height: 2),
        Text(user.email,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
            maxLines: 1)
      ],
    ));
  }

  Widget _buildProfileDropdown(
      BuildContext context, ThemeNotifier themeNotifier) {
    return DropdownButton<String>(
      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      items: _buildDropDownItems(context, themeNotifier),
      onChanged: (value) => _handleDropdownChange(context, value),
      icon: Icon(
        Icons.arrow_drop_down,
        size: 20,
        color: Theme.of(context).iconTheme.color,
      ),
      underline: SizedBox(),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  List<DropdownMenuItem<String>> _buildDropDownItems(
      BuildContext context, ThemeNotifier themeNotifier) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      DropdownMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, size: 16),
              const SizedBox(width: 8),
              Text(
                'Profile',
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          )),
      DropdownMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings, size: 16),
              const SizedBox(width: 8),
              Text('Settings', style: Theme.of(context).textTheme.bodySmall)
            ],
          )),
      DropdownMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 16),
              const SizedBox(width: 8),
              Text(
                'Logout',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.red),
              )
            ],
          )),
      DropdownMenuItem(
          value: 'toggle_theme',
          child: Row(
            children: [
              Icon(isDark ? Icons.light_mode : Icons.dark_mode, size: 16),
              const SizedBox(width: 8),
              Text(isDark ? 'Light Theme' : 'Dark Theme',
                  style: Theme.of(context).textTheme.bodySmall)
            ],
          ))
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

  // empty state for empty preview of boards
  Widget _emptyBoardPreview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Board Preview', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(
            'Select a board to preview its progress and activity.',
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }

  Widget _buildWorkspaceMembersSection() {
    return BlocBuilder<WorkspaceContextCubit, WorkspaceContextState>(
      builder: (context, workspaceState) {
        if (workspaceState.workspaceId == null) {
          return _buildGlobalMessage(context);
        }

        return BlocProvider.value(
            value: context.read<WorkspaceMemberCubit>()
              ..getWorkspaceMembers(workspaceState.workspaceId!),
            child: WorkspaceMemberCard(
              workspaceId: workspaceState.workspaceId!,
              memberService: memberService,
              currentUserEmail: user.name,
              memberDialogService:
                  MemberDialogServiceImpl(memberService: memberService),
            ));
      },
    );
  }

  Widget _buildGlobalMessage(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withAlpha(13)
                : Colors.black.withAlpha(5),
            border: Border.all(
                color: Theme.of(context).dividerColor.withAlpha(102)),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workspace Members',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'You must navigate to a workspace from dashboard to see its members!',
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}
