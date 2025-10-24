import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_analytics_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/overall_analytic_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/recent_board_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/auth/account_control_page.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/desk_recent_board_section.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/workspace/desk_home_header.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/workspace/workspace_section.dart';
import 'package:karwaan_flutter/presentation/widgets/focus_time_calendar.dart';
import 'package:karwaan_flutter/presentation/widgets/overall_progress_section.dart';
import 'package:lottie/lottie.dart';

class DeskHomePage extends StatefulWidget {
  const DeskHomePage({super.key});

  @override
  State<DeskHomePage> createState() => _DeskHomePageState();
}

class _DeskHomePageState extends State<DeskHomePage> {
  final Map<String, String> _profileImageCache = {};
  late final ServerpodClientService _serverpodService;

  @override
  void initState() {
    super.initState();
    _serverpodService = context.read<ServerpodClientService>();
  }

  Future<String> _getProfileImageUrl(String? filename) async {
    if (filename == null) return '';

    if (_profileImageCache.containsKey(filename)) {
      return _profileImageCache[filename]!;
    }

    final url = await _serverpodService.getProfilePictureUrl(filename);
    _profileImageCache[filename] = url;
    return url;
  }

  void _logoutConfirmation(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Logout', style: Theme.of(context).textTheme.bodyLarge),
        content: Text('Are you sure want to logout?',
            style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child:
                Text('Cancel', style: Theme.of(context).textTheme.titleSmall),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<AuthCubit>().logout();
            },
            child: Text(
              'Logout',
              style: GoogleFonts.alef(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(AuthUser user) {
    return FutureBuilder<String>(
      future: _getProfileImageUrl(user.profileImage),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          );
        }

        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.person,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          );
        }

        try {
          final imageData = snapshot.data!;
          return SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage: MemoryImage(base64Decode(
                  imageData.replaceFirst('data:image/jpeg;base64,', ''))),
            ),
          );
        } catch (e) {
          return SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.person,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<AuthCubit, AuthStateCheck>(
        buildWhen: (previous, current) {
          return current is AuthAuthenticated &&
                  previous is! AuthAuthenticated ||
              current is AuthLoading && previous is! AuthLoading ||
              current is AuthError && previous is! AuthError;
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Lottie.asset('asset/ani/load.json');
          } else if (state is AuthAuthenticated) {
            final user = state.user;

            return Row(
              children: [
                // Left sidebar
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(10),
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top section
                      Column(
                        children: [
                          // Karwaan logo
                          Image.asset('asset/images/logo.png',
                              fit: BoxFit.scaleDown),
                          const SizedBox(height: 10),

                          // Dashboard
                          GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon:
                                      Icon(Icons.dashboard, color: Colors.blue),
                                ),
                                const SizedBox(width: 8),
                                Text('DashBoard',
                                    style:
                                        GoogleFonts.alef(color: Colors.blue)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Board
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.space_dashboard_rounded,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Board',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Analysis
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.analytics_outlined,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Analysis',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Teams
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.people_alt_outlined,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Teams',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Settings
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.settings,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Settings',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),

                      // Logout
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => _logoutConfirmation(context),
                            icon: Icon(
                              Icons.logout_outlined,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Main content
                Expanded(
                  child: Column(
                    children: [
                      // Header
                      DeskHomeHeader(user: user),

                      // Divider
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          thickness: 1,
                          color: Theme.of(context)
                              .dividerColor
                              .withValues(alpha: 0.3),
                        ),
                      ),

                      // Main content area
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Workspace content
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: const WorkspaceSection(),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 15),

                                // Recent boards
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: MultiBlocProvider(
                                          providers: [
                                            BlocProvider<BoardAnalyticsCubit>(
                                              create: (context) =>
                                                  BoardAnalyticsCubit(context
                                                      .read<BoardRepo>()),
                                            ),
                                            BlocProvider<RecentBoardCubit>(
                                              create: (context) =>
                                                  RecentBoardCubit(context
                                                      .read<BoardRepo>()),
                                            ),
                                          ],
                                          child: RecentBoardsSection(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right sidebar - COMPLETED()
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border(
                          left: BorderSide(
                              color: Colors.white.withValues(alpha: 0.2), width: 1))),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Profile section (fixed height)
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              _buildProfileAvatar(user),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      user.email,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color
                                                ?.withValues(alpha: 0.7),
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              DropdownButton<String>(
                                items: [
                                  DropdownMenuItem(
                                    value: 'profile',
                                    child: Row(
                                      children: [
                                        Icon(Icons.person, size: 16),
                                        SizedBox(width: 8),
                                        Text('Profile',
                                            style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'settings',
                                    child: Row(
                                      children: [
                                        Icon(Icons.settings, size: 16),
                                        SizedBox(width: 8),
                                        Text('Settings',
                                            style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'logout',
                                    child: Row(
                                      children: [
                                        Icon(Icons.logout, size: 16),
                                        SizedBox(width: 8),
                                        Text('Logout',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.red)),
                                      ],
                                    ),
                                    onTap: () => _logoutConfirmation(context),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value == 'logout') {
                                    _logoutConfirmation(context);
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AccountControlPage(),
                                        ));
                                  }
                                },
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                underline: SizedBox(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        // Progress Chart
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: BlocProvider(
                              create: (context) => OverallAnalyticsCubit(
                                  context.read<BoardRepo>()),
                              child: const OverallProgressSection(),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Calendar - Make it scrollable
                        Flexible(
                          flex: 2,
                          child: SizedBox(
                            width: double.infinity,
                            child: FocusTimeCalendar(),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
          return Center(
            child: Text(
              'Something went wrong...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        },
      ),
    );
  }
}
