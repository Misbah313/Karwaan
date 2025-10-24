import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/board/board.dart';
import 'package:karwaan_flutter/domain/models/board/board_analytics.dart';
import 'package:karwaan_flutter/domain/models/board/board_analytics_state.dart';
import 'package:karwaan_flutter/domain/models/board/recent_board_states.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_analytics_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/recent_board_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/desk_board_card.dart';

class RecentBoardsSection extends StatefulWidget {
  const RecentBoardsSection({super.key});

  @override
  _RecentBoardsSectionState createState() => _RecentBoardsSectionState();
}

class _RecentBoardsSectionState extends State<RecentBoardsSection> {
  Timer? _refreshTimer;
  List<int> _currentBoardIds = [];
  Map<int, BoardAnalytics> _currentAnalytics = {};
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (mounted && _currentBoardIds.isNotEmpty) {
        _refreshAnalyticsSilently();
      }
    });
  }

  void _refreshAnalyticsSilently() {
    context
        .read<BoardAnalyticsCubit>()
        .getAnalyticsForMultiBoards(_currentBoardIds);
  }

  void _loadData() {
    context.read<RecentBoardCubit>().getUserRecentBoards();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentBoardCubit, RecentBoardStates>(
      buildWhen: (previous, current) {
        // Only rebuild when state actually changes
        return current is! RecentBoardLoading;
      },
      builder: (context, recentState) {
        if (recentState is RecentBoardLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (recentState is RecentBoardError) {
          return _buildErrorState(recentState.error);
        }

        if (recentState is RecentBoardlistLoaded) {
          // Only update board IDs if they actually changed
          final newBoardIds = recentState.boards.map((e) => e.id).toList();
          final boardsChanged = !_listEquals(newBoardIds, _currentBoardIds);

          if (boardsChanged || _isInitialLoad) {
            _currentBoardIds = newBoardIds;
            _isInitialLoad = false;

            // Load analytics only when boards change
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context
                  .read<BoardAnalyticsCubit>()
                  .getAnalyticsForMultiBoards(_currentBoardIds);
            });
          }

          return BlocConsumer<BoardAnalyticsCubit, BoardAnalyticsState>(
            listenWhen: (previous, current) {
              // Only listen when we get new analytics data
              return current is BoardAnalyticlistLoaded;
            },
            listener: (context, analyticsState) {
              if (analyticsState is BoardAnalyticlistLoaded) {
                setState(() {
                  _currentAnalytics = {
                    for (var analytics in analyticsState.boardAnalytics)
                      analytics.boardId: analytics
                  };
                });
              }
            },
            builder: (context, analyticsState) {
              // Use cached analytics, no need to rebuild for analytics state changes
              final boardsWithAnalytics = recentState.boards.map((board) {
                final analytics = _currentAnalytics[board.id];
                return (board: board, analytics: analytics);
              }).toList();

              return _buildRecentBoardsGrid(boardsWithAnalytics);
            },
          );
        }

        return _buildEmptyState();
      },
    );
  }

  bool _listEquals(List<int> list1, List<int> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  Widget _buildRecentBoardsGrid(
      List<({Board board, BoardAnalytics? analytics})> boards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            'Recently Opened Boards',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ]),
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
            final item = boards[index];
            return DeskBoardPage(
              board: item.board,
              analytics: item.analytics,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.dashboard, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No recently opened boards',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Open a board to see it here',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          SizedBox(height: 16),
          Text(
            'Failed to load recent boards',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
