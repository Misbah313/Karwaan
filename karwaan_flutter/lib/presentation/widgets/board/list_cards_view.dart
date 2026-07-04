import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_state.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
import 'package:karwaan_flutter/domain/repository/cardlabel/cardlabel_repo.dart';
import 'package:karwaan_flutter/domain/repository/checklist/checklist_repo.dart';
import 'package:karwaan_flutter/domain/repository/label/label_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/card_assignee_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/cardlabel/cardlabel_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/comment/comment_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/cards/cards.dart';
import 'package:karwaan_flutter/presentation/widgets/cards/error_cards_view.dart';
import 'package:lottie/lottie.dart';

class ListCardsView extends StatelessWidget {
  final int listId;
  final int boardId;
  final BoardCardCubit cardCubit;
  final BoardcardRepo boardcardRepo;
  final List<BoardMemberDetails> boardMembers;
  final CommentCubit commentCubit;
  final CardAssigneeCubit cardAssigneeCubit;
  const ListCardsView(
      {super.key,
      required this.listId,
      required this.boardId,
      required this.cardCubit,
      required this.boardcardRepo,
      required this.boardMembers,
      required this.commentCubit, required this.cardAssigneeCubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardCardCubit, BoardCardState>(
      bloc: cardCubit,
      buildWhen: (previous, current) {
        return current is BoardCardListLoaded ||
            current is BoardCardError ||
            current is BoardCardLoading;
      },
      builder: (context, state) {
        if (state is BoardCardLoading || state is BoardCardInitial) {
          return Center(child: Lottie.asset('asset/ani/load.json'));
        }

        if (state is BoardCardError) {
          return ErrorCardsView(
            message: state.error,
            onRetry: () => cardCubit.getListByBoardCard(listId),
          );
        }

        if (state is BoardCardListLoaded) {
          final cards = state.boardCard;

          if (cards.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: cards.length,
            itemBuilder: (context, index) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: cardCubit),
                BlocProvider(
                  create: (_) => CardlabelCubit(context.read<CardlabelRepo>())
                    ..getLabelForCard(cards[index].id),
                ),
                BlocProvider(
                  create: (_) => LabelCubit(context.read<LabelRepo>())
                    ..getLabelsForBoard(boardId),
                ),
                BlocProvider(
                  create: (_) => ChecklistCubit(context.read<ChecklistRepo>())
                    ..listChecklist(cards[index].id),
                ),
              ],
              child: Cards(
                card: cards[index],
                cardCubit: cardCubit,
                boardMembers: boardMembers,
                commentCubit: commentCubit,
                cardAssigneeCubit: cardAssigneeCubit,
              ),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Lottie.asset(
            'asset/ani/emptys.json',
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          const SizedBox(height: 16),
          Text(
            'Create your first card to get started!',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
