import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/board/board.dart';
import 'package:karwaan_flutter/domain/models/board/board_analytics.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
import 'package:karwaan_flutter/domain/repository/boardlist/boardlist_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_analytics_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardlist/boardlist_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardlist/boardlist_gate.dart';

class DeskBoardPage extends StatelessWidget {
  final Board board;
  final BoardAnalytics? analytics;
  const DeskBoardPage({super.key, required this.board, this.analytics});

  // build header with the menu button
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: ListTile(
            title: SizedBox(
              child: Text(board.boardName,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            subtitle: Text(board.boardDescription,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          )),
          IconButton(
              onPressed: () => _showBoardMenu(context),
              icon: Icon(Icons.more_vert,
                  color: Theme.of(context).iconTheme.color)),
        ],
      ),
    );
  }

  Widget _buildAnalyticsFotter(BuildContext context, BoardAnalytics analytics) {
    final double targetProgress = analytics.completionPercentage / 100;

    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.onSurface
            ])),
        child: Column(
          children: [
            // Animated progress bar
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
              tween: Tween<double>(
                begin: 0,
                end: targetProgress,
              ),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    targetProgress == 1.0 ? Colors.green : Colors.blue,
                  ),
                );
              },
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${analytics.completedCards}/${analytics.totalCards} tasks',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                // Animated percentage counter
                TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 500),
                  tween: Tween<double>(
                    begin: 0,
                    end: analytics.completionPercentage,
                  ),
                  builder: (context, value, child) {
                    return Text(
                      '${value.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: analytics.completionPercentage == 100
                                ? Colors.green
                                : Colors.blue,
                          ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // build footer with the creation date
  Widget _buildFooter(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.onSurface
              ])),
          child: Row(
            children: [
              Icon(Icons.calendar_today,
                  size: 16, color: Theme.of(context).iconTheme.color),
              SizedBox(width: 4),
              Text('Created At ${_formatDate(board.createAt)}',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // show workspace menu
  void _showBoardMenu(BuildContext context) {
    showBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (bottomSheetContext) {
        return Text('empyt');
        // BoardMenu(
        //   board: board,
        // );
      },
    );
  }

  void _refreshThisBoard(BuildContext context) {
    context.read<BoardAnalyticsCubit>().getAnalyticsForMultiBoards([board.id]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Use service directly instead of cubit for tracking
        await context.read<BoardRepo>().trackRecentBoard(board.id);

        // navigate to the board list page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<BoardlistCubit>(
              create: (context) =>
                  BoardlistCubit(context.read<BoardlistRepo>()),
              child: BoardlistGate(
                boardlistRepo: context.read<BoardlistRepo>(),
                boardId: board.id,
                boardcardRepo: context.read<BoardcardRepo>(),
                boardName: board.boardName,
              ),
            ),
          ),
        ).then((_) {
          _refreshThisBoard(context);
        });
      },
      child: Container(
        constraints: BoxConstraints(minHeight: 150),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.onSurface
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.blueGrey.shade100, blurRadius: 6)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeader(context),
            if (analytics != null)
              _buildAnalyticsFotter(context, analytics!)
            else
              _buildFooter(context)
          ],
        ),
      ),
    );
  }
}
