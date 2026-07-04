import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/client/profile_image_service.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/domain/models/board/board_analytics.dart';
import 'package:karwaan_flutter/domain/models/board/board_analytics_state.dart';
import 'package:karwaan_flutter/domain/models/board/board_wrapper.dart';
import 'package:karwaan_flutter/domain/models/board/pin_board_state.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_analytics_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/pinn_board_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/main_layout_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/desk_board_card.dart';

class PinnedBoardsSection extends StatefulWidget {
  final AuthUser currentUser;
  final ProfileImageService imageService;
  const PinnedBoardsSection(
      {super.key, required this.currentUser, required this.imageService});

  @override
  State<PinnedBoardsSection> createState() => _PinnedBoardsSectionState();
}

class _PinnedBoardsSectionState extends State<PinnedBoardsSection> {
  @override
  void initState() {
    super.initState();
    context.read<PinnedBoardCubit>().getPinnedBoards();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PinnedBoardCubit, PinnedBoardState>(
      builder: (context, state) {
        if (state is PinnedBoardLoading) {
          return _buildLoadingState();
        }

        if (state is PinnedBoardError) {
          return _buildErrorState(state.error);
        }

        if (state is PinnedBoardLoaded) {
          final boards = state.pinnedBoards;

          if (boards.isEmpty) {
            return _buildEmptyState();
          }

          // Load analytics for pinned boards
          final boardIds = boards.map((e) => e.id).toList();
          context
              .read<BoardAnalyticsCubit>()
              .getAnalyticsForMultiBoards(boardIds);

          return BlocBuilder<BoardAnalyticsCubit, BoardAnalyticsState>(
            builder: (context, analyticsState) {
              return _buildPinnedBoardsGrid(boards, analyticsState);
            },
          );
        }

        return _buildEmptyState();
      },
    );
  }

  Widget _buildPinnedBoardsGrid(
      List<BoardWrapper> boards, BoardAnalyticsState analyticsState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Pinned Boards',
                style: Theme.of(context).textTheme.bodyMedium),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                context.read<PinnedBoardCubit>().getPinnedBoards();
              },
              tooltip: 'Refresh pinned boards',
            ),
          ],
        ),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: boards.length,
          itemBuilder: (context, index) {
            final board = boards[index];

            // Get analytics for this board
            BoardAnalytics? analytics;
            if (analyticsState is BoardAnalyticlistLoaded) {
              try {
                analytics = analyticsState.boardAnalytics
                    .firstWhere((a) => a.boardId == board.id);
              } catch (e) {
                // Analytics not loaded yet
              }
            }

            return DeskBoardCard(
              board: board,
              analytics: analytics,
              key: ValueKey(board.id),
              currentUser: widget.currentUser,
              imageService: widget.imageService,
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading pinned boards...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor.withAlpha(50),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.push_pin_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No pinned boards yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pin your favorite boards to see them here',
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // Navigate to boards page
              context.read<MainLayoutCubit>().changeMenu('Boards');
            },
            icon: Icon(Icons.explore_outlined),
            label: Text('Explore Boards'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red.withAlpha(50),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red[300],
          ),
          SizedBox(height: 16),
          Text(
            'Failed to load pinned boards',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<PinnedBoardCubit>().getPinnedBoards();
            },
            icon: Icon(Icons.refresh),
            label: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
