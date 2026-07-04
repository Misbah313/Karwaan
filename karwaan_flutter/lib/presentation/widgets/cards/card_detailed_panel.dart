import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_state.dart';
import 'package:karwaan_flutter/domain/models/boardcard/card_assignee_state.dart';
import 'package:karwaan_flutter/domain/models/comment/comment_state.dart';
import 'package:karwaan_flutter/domain/models/comment/create_comment_credentails.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/card_assignee_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/comment/comment_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';

enum CardDetailView {
  comments,
  members,
  labels,
  checklist,
  attachments,
}

class CardDetailsPanel extends StatefulWidget {
  final CardDetailView view;
  final int cardId;
  final CommentCubit commentCubit;
  final List<BoardMemberDetails> boardMembers;
  final CardAssigneeCubit cardAssigneeCubit;
  const CardDetailsPanel(
      {super.key,
      required this.view,
      required this.cardId,
      required this.commentCubit,
      required this.boardMembers,
      required this.cardAssigneeCubit});

  @override
  State<CardDetailsPanel> createState() => _CardDetailsPanelState();
}

class _CardDetailsPanelState extends State<CardDetailsPanel> {
  @override
  void initState() {
    super.initState();
    widget.commentCubit.getCommentsForCard(widget.cardId);
    widget.cardAssigneeCubit.getCardAssignees(widget.cardId);
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (widget.view) {
      case CardDetailView.comments:
        content = _buildCommentSection();
        break;
      case CardDetailView.members:
        content = _buildAssignedUsersSection();
        break;
      case CardDetailView.labels:
        content = _buildPlaceholder('Labels Section');
        break;
      case CardDetailView.checklist:
        content = _buildPlaceholder('Checklist Section');
        break;
      case CardDetailView.attachments:
        content = _buildPlaceholder('Attachments Section');
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: content,
    );
  }

  Widget _buildPlaceholder(String text) {
    return Container(
      key: ValueKey(text), // 🔥 important for animation
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    final controller = TextEditingController();

    return Container(
      key: const ValueKey('comments'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          // comments list
          Expanded(
              child: BlocBuilder<CommentCubit, CommentState>(
            bloc: widget.commentCubit,
            builder: (context, state) {
              if (state is CommentLoading || state is CommentInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CommentForCardListLoaded) {
                if (state.comments.isEmpty) {
                  return Center(
                    child: Text(
                      'No comments yet!',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state.comments.length,
                  itemBuilder: (context, index) {
                    final comment = state.comments[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: 0.5)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // avatar
                          CircleAvatar(
                            radius: 16,
                            child: Text(
                              comment.authorName[0],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(width: 10),

                          // content
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comment.authorName,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(height: 4),
                              Text(
                                comment.content,
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          )),

                          PopupMenuButton<String>(
                            iconColor: Theme.of(context).iconTheme.color,
                            color: Theme.of(context).colorScheme.primary,
                            onSelected: (value) {
                              if (value == 'delete') {
                                widget.commentCubit
                                    .deleteCommentOptimized(comment.id);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  mouseCursor: MouseCursor.defer,
                                  value: 'delete',
                                  child: Text(
                                    'Delete',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ))
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              }

              if (state is CommentError) {
                return Center(
                  child: Text(
                    state.error,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.red),
                  ),
                );
              }

              return const SizedBox();
            },
          )),

          const SizedBox(height: 10),

          // input section
          Row(
            children: [
              Expanded(
                  child: Textfield(
                      text: 'Write a comment...',
                      obsecureText: false,
                      controller: controller)),
              const SizedBox(width: 8),
              IconButton(
                icon:
                    Icon(Icons.send, color: Theme.of(context).iconTheme.color),
                onPressed: () {
                  final text = controller.text.trim();
                  if (text.isEmpty) return;

                  widget.commentCubit.createCommentOptimized(
                      CreateCommentCredentails(
                          cardId: widget.cardId, content: text));
                  controller.clear();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAssignedUsersSection() {
    return Container(
      key: const ValueKey('members'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.02))),
      child: Column(
        children: [
          // assigness
          Expanded(
              child: BlocBuilder<CardAssigneeCubit, CardAssigneeState>(
            bloc: widget.cardAssigneeCubit,
            builder: (context, state) {
              if (state is CardAssigneeInitial ||
                  state is CardAssigneeLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is CardAssigneeLoaded) {
                if (state.assignees.isEmpty) {
                  return Center(
                    child: Text('No Assigness yet!',
                        style: Theme.of(context).textTheme.bodySmall),
                  );
                }

                return ListView.builder(
                  itemCount: state.assignees.length,
                  itemBuilder: (context, index) {
                    final assingess = state.assignees[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // avatar
                          CircleAvatar(
                            radius: 20,
                            child: Text(
                              assingess.name[0],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),

                          const SizedBox(width: 10),

                          // user
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                assingess.name,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                assingess.email,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          )),

                          PopupMenuButton<String>(
                            iconColor: Theme.of(context).iconTheme.color,
                            color: Theme.of(context).colorScheme.primary,
                            onSelected: (value) {
                              if (value == 'remove') {
                                widget.cardAssigneeCubit.removeUsers(
                                    widget.cardId, [assingess.id]);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  mouseCursor: MouseCursor.defer,
                                  value: 'remove',
                                  child: Text(
                                    'Remove',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ))
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              }

              if (state is CardAssigneeError) {
                return Center(
                  child: Text(
                    state.error,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.red),
                  ),
                );
              }

              return const SizedBox();
            },
          )),

          const SizedBox(height: 10),

          // assign new users
        ],
      ),
    );
  }
}
