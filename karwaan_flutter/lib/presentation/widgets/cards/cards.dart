import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_state.dart';
import 'package:karwaan_flutter/domain/models/cardlabel/cardlabel_state.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/card_assignee_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/cardlabel/cardlabel_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/comment/comment_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/cards/card_dialog.dart';
import 'package:lottie/lottie.dart';

class Cards extends StatefulWidget {
  final BoardCard card;
  final BoardCardCubit cardCubit;
  final List<BoardMemberDetails> boardMembers;
  final CommentCubit commentCubit;
  final CardAssigneeCubit cardAssigneeCubit;
  const Cards(
      {super.key,
      required this.card,
      required this.cardCubit,
      required this.boardMembers,
      required this.commentCubit,
      required this.cardAssigneeCubit});

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  bool isCardHover = false;

  // assigned users
  Widget _buildAssignedUsers() {
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

        final visibleUsers = users.take(2).toList();
        final remaining = users.length - visibleUsers.length;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...visibleUsers.map((user) {
              return Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: user.avatarUrl != null
                      ? Tooltip(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.5),
                          ),
                          message: user.userName,
                          textStyle: Theme.of(context).textTheme.bodySmall,
                          child: CircleAvatar(
                              radius: 10,
                              backgroundImage: NetworkImage(user.avatarUrl!)),
                        )
                      : Tooltip(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.5),
                          ),
                          message: user.userName,
                          textStyle: Theme.of(context).textTheme.bodySmall,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.5),
                            child: Text(
                              user.userName[0],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8),
                            ),
                          ),
                        ));
            }),
            if (remaining > 0)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '+$remaining',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                        ),
                  ),
                ),
              )
          ],
        );
      },
    );

    // if (ids == null || ids.isEmpty) return const SizedBox();

    // // O(1) lookup
    // final memberMap = {
    //   for (var m in widget.boardMembers) m.userId: m,
    // };

    // final users =
    //     ids.map((id) => memberMap[id]).whereType<BoardMemberDetails>().toList();

    // if (users.isEmpty) return const SizedBox();

    // final visibleUsers = users.take(2).toList();
    // final remaining = users.length - visibleUsers.length;

    // return Row(
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     ...visibleUsers.map((user) {
    //       return Padding(
    //           padding: const EdgeInsets.only(left: 4),
    //           child: user.avatarUrl != null
    //               ? Tooltip(
    //                   decoration: BoxDecoration(
    //                     color: Theme.of(context)
    //                         .colorScheme
    //                         .primary
    //                         .withValues(alpha: 0.5),
    //                   ),
    //                   message: user.userName,
    //                   textStyle: Theme.of(context).textTheme.bodySmall,
    //                   child: CircleAvatar(
    //                       radius: 10,
    //                       backgroundImage: NetworkImage(user.avatarUrl!)),
    //                 )
    //               : Tooltip(
    //                   decoration: BoxDecoration(
    //                     color: Theme.of(context)
    //                         .colorScheme
    //                         .primary
    //                         .withValues(alpha: 0.5),
    //                   ),
    //                   message: user.userName,
    //                   textStyle: Theme.of(context).textTheme.bodySmall,
    //                   child: CircleAvatar(
    //                     radius: 10,
    //                     backgroundColor: Theme.of(context)
    //                         .colorScheme
    //                         .primary
    //                         .withValues(alpha: 0.5),
    //                     child: Text(
    //                       user.userName[0],
    //                       style: TextStyle(
    //                           color: Colors.white,
    //                           fontWeight: FontWeight.bold,
    //                           fontSize: 8),
    //                     ),
    //                   ),
    //                 ));
    //     }),
    //     if (remaining > 0)
    //       Padding(
    //         padding: const EdgeInsets.only(left: 4),
    //         child: Container(
    //           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    //           decoration: BoxDecoration(
    //             color: Colors.grey.withValues(alpha: 0.2),
    //             borderRadius: BorderRadius.circular(10),
    //           ),
    //           child: Text(
    //             '+$remaining',
    //             style: Theme.of(context).textTheme.bodySmall?.copyWith(
    //                   fontSize: 10,
    //                 ),
    //           ),
    //         ),
    //       )
    //   ],
    // );
  }

  @override
  Widget build(BuildContext context) {
    final bool showCheckbox = widget.card.isCompleted || isCardHover;

    return MouseRegion(
      onEnter: (_) => setState(() => isCardHover = true),
      onExit: (_) => setState(() => isCardHover = false),
      child: Material(
        elevation: 0,
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => BlocProvider.value(
                value: widget.cardCubit,
                child: CardDialog(
                  card: widget.card,
                  cardCubit: widget.cardCubit,
                  boardMembers: widget.boardMembers,
                  commentCubit: widget.commentCubit,
                  cardAssigneeCubit: widget.cardAssigneeCubit,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: isCardHover
                    ? Colors.blue.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.25),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ===== LABEL STRIPS =====
                BlocBuilder<CardlabelCubit, CardlabelState>(
                  builder: (context, state) {
                    if (state is CardLabelLoading ||
                        state is CardLabelInitial) {
                      return Center(
                        child: Lottie.asset(
                          'asset/ani/load.json',
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                      );
                    }

                    if (state is CardLabelForCardListLoaded) {
                      final cardLabels = state.labels;

                      if (cardLabels.isEmpty) {
                        return const SizedBox();
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: cardLabels.take(8).map((label) {
                            return Tooltip(
                              message: label.title,
                              child: Container(
                                width: 50, // keep your original size
                                height: 6,
                                margin: const EdgeInsets.only(top: 6),
                                decoration: BoxDecoration(
                                  color: _parseLabelColor(label.color),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),

                /// ===== CARD CONTENT =====
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        padding: EdgeInsets.only(left: showCheckbox ? 32 : 0),
                        child: Row(
                          children: [
                            /// TITLE (takes all remaining space)
                            Expanded(
                              child: Text(
                                widget.card.title,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),

                            /// 🔥 ASSIGNED USERS (RIGHT SIDE)
                            _buildAssignedUsers(),
                          ],
                        ),
                      ),

                      /// CHECKBOX OVERLAY
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 120),
                        opacity: showCheckbox ? 1 : 0,
                        child: IgnorePointer(
                          ignoring: !showCheckbox,
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.green,
                              side: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                              value: widget.card.isCompleted,
                              onChanged: (val) {
                                widget.cardCubit.updateBoardCardOptimized(
                                    BoardCardCredentails(
                                      cardId: widget.card.id,
                                      newTitle: widget.card.title,
                                      newDec: widget.card.description,
                                      isCompleted: val ?? false,
                                    ),
                                    widget.card.boardListId);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Convert string color to Flutter Color
Color _parseLabelColor(String colorString) {
  if (colorString.startsWith('#')) {
    String hex = colorString.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
  return Color(int.parse(colorString)); // fallback
}
