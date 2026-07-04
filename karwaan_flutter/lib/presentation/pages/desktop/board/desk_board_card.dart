import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/client/profile_image_service.dart';
import 'package:karwaan_flutter/core/utils/search_function/search_cubit.dart';
import 'package:karwaan_flutter/core/utils/search_function/search_use_case.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/domain/models/board/board_analytics.dart';
import 'package:karwaan_flutter/domain/models/board/board_wrapper.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
import 'package:karwaan_flutter/domain/repository/boardlist/boardlist_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/pinn_board_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/card_assignee_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardlist/boardlist_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/comment/comment_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board_list/desk_boardlist.dart';

class DeskBoardCard extends StatelessWidget {
  final BoardWrapper board;
  final BoardAnalytics? analytics;
  final AuthUser currentUser;
  final ProfileImageService imageService;
  const DeskBoardCard(
      {super.key,
      required this.board,
      this.analytics,
      required this.currentUser,
      required this.imageService});

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
              child: Text(board.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            subtitle: Text(board.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          )),
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
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withAlpha(13)
              : Colors.black.withAlpha(5),
          border:
              Border.all(color: Theme.of(context).dividerColor.withAlpha(102)),
          borderRadius: BorderRadius.circular(12),
        ),
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
              Text('Created At ${_formatDate(board.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Use service directly instead of cubit for tracking
        await context.read<BoardRepo>().trackRecentBoard(board.id);
        final labelCubit = context.read<LabelCubit>();
        final commentCubit = context.read<CommentCubit>();
        final cardAssigneeCubit = context.read<CardAssigneeCubit>();

        // navigate to the board list page
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        BoardlistCubit(context.read<BoardlistRepo>()),
                  ),
                  BlocProvider(
                    create: (context) =>
                        BoardMemberCubit(context.read<BoardRepo>()),
                  ),
                  BlocProvider(
                    create: (context) =>
                        PinnedBoardCubit(context.read<BoardRepo>()),
                  )
                ],
                child: BlocProvider(
                    create: (context) => SearchCubit(SearchUseCase(
                        boardRepo: context.read<BoardRepo>(),
                        boardcardRepo: context.read<BoardcardRepo>())),
                    child: DeskBoardlist(
                      user: currentUser,
                      imageService: imageService,
                      board: board,
                      boardId: board.id,
                      boardcardRepo: context.read<BoardcardRepo>(),
                      labelCubit: labelCubit,
                      commentCubit: commentCubit,
                      cardAssigneeCubit: cardAssigneeCubit,
                    )),
              ),
            ));
      },
      child: Container(
        constraints: BoxConstraints(minHeight: 150),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withAlpha(13)
                : Colors.black.withAlpha(5),
            border: Border.all(
                color: Theme.of(context).dividerColor.withAlpha(102)),
            borderRadius: BorderRadius.circular(12)),
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
