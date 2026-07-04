import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_state.dart';
import 'package:karwaan_flutter/domain/models/comment/comment.dart';
import 'package:karwaan_flutter/domain/models/comment/comment_state.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/comment/comment_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/cards/card_detailed_panel.dart';
import 'package:karwaan_flutter/presentation/widgets/editable_field_withsave.dart';

class CardInfoSection extends StatefulWidget {
  final BoardCard card;
  final BoardCardCubit cardCubit;
  final List<BoardMemberDetails> boardMembers;
  final Function(CardDetailView) onViewChange;
  final CardDetailView currentView;
  final CommentCubit commentCubit;
  const CardInfoSection(
      {super.key,
      required this.card,
      required this.cardCubit,
      required this.boardMembers,
      required this.onViewChange,
      required this.currentView,
      required this.commentCubit});

  @override
  State<CardInfoSection> createState() => _CardInfoSectionState();
}

class _CardInfoSectionState extends State<CardInfoSection> {
  @override
  void initState() {
    super.initState();
    widget.commentCubit.getCommentsForCard(widget.card.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // textfield with save for card title
          _buildEditableName(context),
          const SizedBox(height: 12),

          // textfield with save for card description
          _buildEditableDescription(context),

          const SizedBox(height: 15),

          // assigned members
          _buildAssignedUsers(),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // comments count
              BlocBuilder<CommentCubit, CommentState>(
                bloc: widget.commentCubit,
                builder: (context, state) {
                  int count = 0;

                  if (state is CommentForCardListLoaded) {
                    count = state.comments
                        .where((c) => c.cardId == widget.card.id)
                        .length;
                  }

                  return _buildSectionItem(
                    title: 'Comments',
                    count: count,
                    viewType: CardDetailView.comments,
                  );
                },
              ),

              // checklist
              _buildSectionItem(
                  title: 'Checklist',
                  count: 5,
                  viewType: CardDetailView.checklist),

              // checklist item

              // labels
              _buildSectionItem(
                  title: 'Labels', count: 5, viewType: CardDetailView.labels),

              // attachments
              _buildSectionItem(
                  title: 'Attachments',
                  count: 2,
                  viewType: CardDetailView.attachments)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEditableName(BuildContext context) {
    return EditableFieldWithSave(
        initialValue: widget.card.title,
        label: 'Card Title',
        onSave: (newTitle) {
          final credentails = BoardCardCredentails(
              cardId: widget.card.id,
              newTitle: newTitle,
              newDec: widget.card.description,
              isCompleted: widget.card.isCompleted);
          widget.cardCubit
              .updateBoardCardOptimized(credentails, widget.card.boardListId);
        });
  }

  Widget _buildEditableDescription(BuildContext context) {
    return EditableFieldWithSave(
        maxLines: 2,
        initialValue: widget.card.description,
        label: 'Card Description',
        onSave: (newDec) {
          final credentails = BoardCardCredentails(
              cardId: widget.card.id,
              newTitle: widget.card.title,
              newDec: newDec,
              isCompleted: widget.card.isCompleted);
          widget.cardCubit
              .updateBoardCardOptimized(credentails, widget.card.boardListId);
        });
  }

  Widget _buildAssignedUsers() {
    final isSelected = widget.currentView == CardDetailView.members;
    // final ids = widget.card.assignedUserIds;
   return BlocBuilder<BoardCardCubit, BoardCardState>(
      bloc: widget.cardCubit,
      builder: (context, state) {
        if (state is! BoardCardListLoaded) return const SizedBox.shrink();
        final card = state.boardCard.firstWhere((c) => c.id == widget.card.id,
            orElse: () => widget.card);
        final ids = card.assignedUserIds;

        if (ids == null || ids.isEmpty) return const SizedBox();

        // O(1) lookup
        final memberMap = {
          for (var m in widget.boardMembers) m.userId: m,
        };

        final users = ids
            .map((id) => memberMap[id])
            .whereType<BoardMemberDetails>()
            .toList();

        if (users.isEmpty) return const SizedBox();

        final visibleUsers = users.toList();

        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            widget.onViewChange(CardDetailView.members);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isSelected
                        ? Colors.blue
                        : Colors.white.withValues(alpha: 0.2))),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  'Assigned Users',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                ...visibleUsers.map((user) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: user.avatarUrl != null
                        ? CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(user.avatarUrl!),
                          )
                        : CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.5),
                            child: Text(
                              user.userName[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 8,
                              ),
                            ),
                          ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );

    // // O(1) lookup
    // final memberMap = {
    //   for (var m in widget.boardMembers) m.userId: m,
    // };

    // final users =
    //     ids.map((id) => memberMap[id]).whereType<BoardMemberDetails>().toList();

    // if (users.isEmpty) return const SizedBox();

    // final visibleUsers = users.toList();

    // return InkWell(
    //   borderRadius: BorderRadius.circular(8),
    //   onTap: () {
    //     widget.onViewChange(CardDetailView.members);
    //   },
    //   child: Container(
    //     decoration: BoxDecoration(
    //         color: Colors.white.withValues(alpha: 0.05),
    //         borderRadius: BorderRadius.circular(8),
    //         border: Border.all(
    //             color: isSelected
    //                 ? Colors.blue
    //                 : Colors.white.withValues(alpha: 0.2))),
    //     padding: const EdgeInsets.all(10),
    //     child: Row(
    //       children: [
    //         Text(
    //           'Assigned Users',
    //           style: Theme.of(context).textTheme.bodyMedium,
    //         ),
    //         const Spacer(),
    //         ...visibleUsers.map((user) {
    //           return Padding(
    //             padding: const EdgeInsets.only(left: 4),
    //             child: user.avatarUrl != null
    //                 ? CircleAvatar(
    //                     radius: 20,
    //                     backgroundImage: NetworkImage(user.avatarUrl!),
    //                   )
    //                 : CircleAvatar(
    //                     radius: 20,
    //                     backgroundColor: Theme.of(context)
    //                         .colorScheme
    //                         .primary
    //                         .withValues(alpha: 0.5),
    //                     child: Text(
    //                       user.userName[0],
    //                       style: const TextStyle(
    //                         color: Colors.white,
    //                         fontWeight: FontWeight.bold,
    //                         fontSize: 8,
    //                       ),
    //                     ),
    //                   ),
    //           );
    //         }),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _buildSectionItem({
    required String title,
    required int? count,
    required CardDetailView viewType,
  }) {
    final isSelected = widget.currentView == viewType;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => widget.onViewChange(viewType),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: isSelected
                    ? Colors.blue
                    : Colors.white.withValues(alpha: 0.2))),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('$count', style: const TextStyle(fontSize: 12)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
