// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:karwaan_flutter/domain/models/board/board.dart';
// import 'package:karwaan_flutter/domain/models/board/board_analytics.dart';
// import 'package:karwaan_flutter/domain/models/board/board_analytics_state.dart';
// import 'package:karwaan_flutter/domain/models/board/recent_board_states.dart';
// import 'package:karwaan_flutter/presentation/cubits/board/board_analytics_cubit.dart';
// import 'package:karwaan_flutter/presentation/cubits/board/recent_board_cubit.dart';
// import 'package:karwaan_flutter/presentation/pages/desktop/board/desk_board_card.dart';

// class RecentBoardsSection extends StatefulWidget {
//   const RecentBoardsSection({super.key});

//   @override
//   _RecentBoardsSectionState createState() => _RecentBoardsSectionState();
// }

// class _RecentBoardsSectionState extends State<RecentBoardsSection> {
//   @override
//   void initState() {
//     super.initState();
//     // Load data only once when widget is created
//     context.read<RecentBoardCubit>().getUserRecentBoards();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RecentBoardCubit, RecentBoardStates>(
//       builder: (context, recentState) {
//         if (recentState is RecentBoardLoading) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (recentState is RecentBoardError) {
//           return _buildErrorState(recentState.error);
//         }

//         if (recentState is RecentBoardlistLoaded) {
//           // Load analytics once when boards are loaded
//           final boardIds = recentState.boards.map((e) => e.id).toList();
//           context
//               .read<BoardAnalyticsCubit>()
//               .getAnalyticsForMultiBoards(boardIds);

//           return BlocBuilder<BoardAnalyticsCubit, BoardAnalyticsState>(
//             builder: (context, analyticsState) {
//               final boardsWithAnalytics = recentState.boards.map((board) {
//                 // Get analytics for each board - they'll update individually
//                 BoardAnalytics? analytics;
//                 if (analyticsState is BoardAnalyticlistLoaded) {
//                   analytics = analyticsState.boardAnalytics.firstWhere(
//                       (a) => a.boardId == board.id);
//                 }
//                 return (board: board, analytics: analytics);
//               }).toList();

//               return _buildRecentBoardsGrid(boardsWithAnalytics);
//             },
//           );
//         }

//         return _buildEmptyState();
//       },
//     );
//   }

//   Widget _buildRecentBoardsGrid(
//       List<({Board board, BoardAnalytics? analytics})> boards) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Recently Opened Boards',
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             IconButton(
//               icon: Icon(Icons.refresh),
//               onPressed: () {
//                 // Manual refresh only when user asks for it
//                 context.read<RecentBoardCubit>().getUserRecentBoards();
//               },
//               tooltip: 'Refresh boards',
              
//             ),
//           ],
//         ),
//         const SizedBox(height: 15),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 1.5,
//           ),
//           itemCount: boards.length,
//           itemBuilder: (context, index) {
//             final item = boards[index];
//             return DeskBoardPage(
//               board: item.board,
//               analytics: item.analytics,
//               // Each board rebuilds independently when its analytics change
//               key: ValueKey(item.board.id),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyState() {
//     return Container(
//       padding: EdgeInsets.all(32),
//       child: Column(
//         children: [
//           Icon(Icons.dashboard, size: 64, color: Colors.grey[400]),
//           SizedBox(height: 16),
//           Text(
//             'No recently opened boards',
//             style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Open a board to see it here',
//             style: TextStyle(color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState(String error) {
//     return Container(
//       padding: EdgeInsets.all(32),
//       child: Column(
//         children: [
//           Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
//           SizedBox(height: 16),
//           Text(
//             'Failed to load recent boards',
//             style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//           ),
//           SizedBox(height: 8),
//           Text(
//             error,
//             style: TextStyle(color: Colors.grey[500]),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {
//               context.read<RecentBoardCubit>().getUserRecentBoards();
//             },
//             child: Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }
// }
