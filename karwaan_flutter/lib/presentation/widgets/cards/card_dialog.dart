import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_state.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/card_assignee_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/comment/comment_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/cards/card_detailed_panel.dart';
import 'package:karwaan_flutter/presentation/widgets/cards/card_info_section.dart';

class CardDialog extends StatefulWidget {
  final BoardCard card;
  final BoardCardCubit cardCubit;
  final List<BoardMemberDetails> boardMembers;
  final CommentCubit commentCubit;
  final CardAssigneeCubit cardAssigneeCubit;
  const CardDialog(
      {super.key,
      required this.card,
      required this.cardCubit,
      required this.boardMembers,
      required this.commentCubit,
      required this.cardAssigneeCubit});

  @override
  State<CardDialog> createState() => _CardDialogState();
}

class _CardDialogState extends State<CardDialog> {
  CardDetailView _currentView = CardDetailView.comments;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      insetPadding: const EdgeInsets.all(30),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.card.title,
                      style: Theme.of(context).textTheme.bodyLarge),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close))
                ],
              ),
              const SizedBox(height: 15),
              // main contents
              Expanded(
                  child: BlocListener<BoardCardCubit, BoardCardState>(
                listener: (context, state) {
                  if (state is BoardCardError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<BannerManager>().show(state.error);
                    });
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // right side card info
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: SingleChildScrollView(
                        child: CardInfoSection(
                          card: widget.card,
                          cardCubit: widget.cardCubit,
                          boardMembers: widget.boardMembers,
                          currentView: _currentView,
                          onViewChange: (view) {
                            setState(() {
                              _currentView = view;
                            });
                          },
                          commentCubit: widget.commentCubit,
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    // left side card items
                    Expanded(
                        child: CardDetailsPanel(
                      view: _currentView,
                      cardId: widget.card.id,
                      commentCubit: widget.commentCubit,
                      cardAssigneeCubit: widget.cardAssigneeCubit,
                      boardMembers: widget.boardMembers,
                    ))
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
