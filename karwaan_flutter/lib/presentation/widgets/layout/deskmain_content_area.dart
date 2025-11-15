import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/utils/search_function/search_cubit.dart';
import 'package:karwaan_flutter/core/utils/search_function/search_use_case.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_analytics_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/recent_board_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/desk_recent_board_section.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/workspace/desk_home_header.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/workspace/workspace_section.dart';

class MainContentArea extends StatelessWidget {
  final int currentPageIndex;
  final AuthUser user;
  final PageController controller;

  const MainContentArea({
    super.key,
    required this.currentPageIndex,
    required this.user,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildDashboardContent(context, user),
        _buildBoardsPage(context),
        _buildSimplePage(context, 'Analytics Page'),
        _buildSimplePage(context, 'Teams Page'),
        _buildSimplePage(context, 'Settings Page'),
      ],
    );
  }

  Widget _buildDashboardContent(BuildContext context,AuthUser user) {
  return Column(
    children: [
      BlocProvider(
        create: (context) => SearchCubit(
          SearchUseCase(
            boardRepo: context.read<BoardRepo>(),
            boardcardRepo: context.read<BoardcardRepo>(),
          ),
        ),
        child: DeskHomeHeader(user: user),
      ),
      _buildDivider(context),
      Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWorkspaceSection(),
                const SizedBox(height: 15),
                _buildRecentBoardsSection(),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        thickness: 1,
        color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildWorkspaceSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: const WorkspaceSection(),
          ),
        ),
      ],
    );
  }

  ///
  Widget _buildRecentBoardsSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: MultiBlocProvider(
              providers: [
                BlocProvider<BoardAnalyticsCubit>(
                  create: (context) => BoardAnalyticsCubit(
                    context.read<BoardRepo>(),
                  ),
                ),
                BlocProvider<RecentBoardCubit>(
                  create: (context) => RecentBoardCubit(
                    context.read<BoardRepo>(),
                  ),
                ),
              ],
              child: RecentBoardsSection(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBoardsPage(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Boards',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        _buildDivider(context),
        Expanded(
          child: Center(
            child: Text(
              'All your boards content will appear here',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimplePage(BuildContext context, String title) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        _buildDivider(context),
        Expanded(
          child: Center(
            child: Text(
              '$title Content',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}
