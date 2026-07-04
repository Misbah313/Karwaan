import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_credentails.dart';
import 'package:karwaan_flutter/domain/models/cardlabel/cardlabel_credentails.dart';
import 'package:karwaan_flutter/domain/models/cardlabel/cardlabel_state.dart';
import 'package:karwaan_flutter/domain/models/label/label_state.dart';
import 'package:karwaan_flutter/domain/repository/attachment/attachment_repo.dart';
import 'package:karwaan_flutter/domain/repository/checklist/checklist_repo.dart';
import 'package:karwaan_flutter/domain/repository/comment/comment_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/attachment/attachment_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/cardlabel/cardlabel_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/comment/comment_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/boardlist,boardcard/attachment/attachment_dialog.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/boardlist,boardcard/checklist/checklist_dialog.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/boardlist,boardcard/comment/comment_dialog.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';

class CardWidget extends StatefulWidget {
  final BoardCard card;
  final BoardCardCubit cardCubit;
  const CardWidget({super.key, required this.card, required this.cardCubit});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool isCheckBoxHover = false;
  @override
  Widget build(BuildContext context) {
    // Confirm delete dialog
    Future<void> confirmDeleteCard(int cardId) async {
      await showDialog(
        context: context,
        builder: (dialogCtx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              'Delete Card',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            content: Text(
                'Are you sure you want to delete this card? This cannot be undone.',
                style: Theme.of(context).textTheme.bodyMedium),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.titleSmall,
                  )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Theme.of(context).colorScheme.primary),
                onPressed: () {
                  widget.cardCubit.deleteBoardCard(widget.card.id);
                  Navigator.pop(context);
                },
                child: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          );
        },
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          color:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.white.withValues(alpha: 0.08),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top label color strips
            BlocBuilder<CardlabelCubit, CardlabelState>(
              builder: (context, state) {
                if (state is CardLabelLoading || state is CardLabelInitial) {
                  return Center(
                    child: Lottie.asset('asset/ani/load.json',
                        height: MediaQuery.of(context).size.height * 0.2),
                  );
                }
                if (state is CardLabelForCardListLoaded) {
                  final cardLabels = state.labels;
                  if (cardLabels.isEmpty) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: cardLabels.map((label) {
                        return Tooltip(
                          message: label.title,
                          child: Container(
                            width: 50,
                            height: 6,
                            margin: const EdgeInsets.only(left: 4, top: 6),
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

            // Main card content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  if (widget.card.isCompleted)
                    // Checkbox for completion
                    Checkbox(
                      activeColor: Colors.green,
                      checkColor: Colors.grey.shade300,
                      side: BorderSide(color: Theme.of(context).dividerColor),
                      value: widget.card.isCompleted,
                      onChanged: (val) {
                        widget.cardCubit.updateBoardCard(
                          BoardCardCredentails(
                            cardId: widget.card.id,
                            newTitle: widget.card.title,
                            newDec: widget.card.description,
                            isCompleted: val ?? false,
                          ),
                        );
                      },
                    )
                  else
                    MouseRegion(
                      onEnter: (_) => setState(() => isCheckBoxHover = true),
                      onExit: (_) => setState(() => isCheckBoxHover = false),
                      child: Container(
                        width: 48, // Fixed width for hover area
                        height: 48, // Fixed height for hover area
                        alignment: Alignment.center,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: isCheckBoxHover ? 48 : 0,
                          child: AnimatedOpacity(
                            opacity: isCheckBoxHover ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 150),
                            child: Checkbox(
                              activeColor: Colors.green,
                              checkColor: Colors.grey.shade300,
                              side: BorderSide(
                                  color: Theme.of(context).dividerColor),
                              value: widget.card.isCompleted,
                              onChanged: (val) {
                                widget.cardCubit.updateBoardCard(
                                  BoardCardCredentails(
                                    cardId: widget.card.id,
                                    newTitle: widget.card.title,
                                    newDec: widget.card.description,
                                    isCompleted: val ?? false,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Task title with smooth transition
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      child: Text(
                        widget.card.title,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),

                  // Popup menu for card actions
                  PopupMenuButton<_CardAction>(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                    icon: Icon(
                      Icons.more_vert,
                      size: 20,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onSelected: (action) {
                      switch (action) {
                        case _CardAction.edit:
                          _showEditCardDialog(
                              context, widget.card, widget.cardCubit);
                          break;
                        case _CardAction.delete:
                          confirmDeleteCard(widget.card.id);
                          break;
                        case _CardAction.editLabels:
                          _showEditLabelsDialog(context, widget.card);
                          break;
                        case _CardAction.checklist:
                          _showChecklistDialogPage(context, widget.card.id);
                          break;
                        case _CardAction.comment:
                          _showCommentDialogPage(context, widget.card.id);
                          break;
                        case _CardAction.attachment:
                          _showAttachmentDialogPage(context, widget.card.id);
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                          value: _CardAction.edit,
                          child: Text('Edit',
                              style: Theme.of(context).textTheme.bodyMedium)),
                      PopupMenuItem(
                        value: _CardAction.editLabels,
                        child: Text('Edit Labels',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      PopupMenuItem(
                        value: _CardAction.delete,
                        child: Text('Delete',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      PopupMenuItem(
                        value: _CardAction.checklist,
                        child: Text('Checklist',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      PopupMenuItem(
                        value: _CardAction.comment,
                        child: Text('Comments',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      PopupMenuItem(
                        value: _CardAction.attachment,
                        child: Text('Attachments',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Card actions enum
enum _CardAction { edit, delete, editLabels, checklist, comment, attachment }

// Edit card dialog
Future<void> _showEditCardDialog(
    BuildContext context, BoardCard card, BoardCardCubit cardCubit) async {
  final titleController = TextEditingController(text: card.title);
  final descController = TextEditingController(text: card.description);

  await showDialog(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text('Edit Card', style: Theme.of(context).textTheme.bodyLarge),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Textfield(
              text: 'Title', obsecureText: false, controller: titleController),
          const SizedBox(height: 8),
          Textfield(
              text: 'Description',
              obsecureText: false,
              controller: descController),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child:
                Text('Cancel', style: Theme.of(context).textTheme.titleSmall)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Theme.of(context).colorScheme.primary),
          onPressed: () {
            final newTitle = titleController.text.trim();
            final newDesc = descController.text.trim();

            if (newTitle.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Title cannot be empty'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            cardCubit.updateBoardCard(
              BoardCardCredentails(
                cardId: card.id,
                newTitle: newTitle,
                newDec: newDesc,
                isCompleted: card.isCompleted,
              ),
            );
            Navigator.of(dialogCtx).pop();
          },
          child: Text('Save', style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    ),
  );
}

// Edit labels dialog
Future<void> _showEditLabelsDialog(BuildContext context, BoardCard card) async {
  final cardLabelCubit = context.read<CardlabelCubit>();
  final labelCubit = context.read<LabelCubit>();

  await showDialog(
    context: context,
    builder: (dialogContext) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: labelCubit),
          BlocProvider.value(value: cardLabelCubit),
        ],
        child: BlocListener<CardlabelCubit, CardlabelState>(
          listener: (context, state) {
            if (state is CardLabelAssigned) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Label has been assigned successfully.'),
                backgroundColor: Colors.green,
              ));
              cardLabelCubit.getLabelForCard(card.id);
            }
            if (state is CardLabelRemoved) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Label has been removed successfully.'),
                backgroundColor: Colors.green,
              ));
              Navigator.pop(context);
              cardLabelCubit.getLabelForCard(card.id);
            }
            if (state is CardLabelError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ));
            }
          },
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text('Edit Labels',
                style: Theme.of(context).textTheme.bodyLarge),
            content: SizedBox(
              width: double.maxFinite,
              child: Builder(
                builder: (innerContext) {
                  return BlocBuilder<LabelCubit, LabelState>(
                    builder: (context, labelState) {
                      if (labelState is LabelListLoaded) {
                        final boardLabels = labelState.labels;
                        final assignedLabelIds = <int>[];

                        final cardLabelState =
                            innerContext.read<CardlabelCubit>().state;
                        if (cardLabelState is CardLabelForCardListLoaded) {
                          assignedLabelIds
                              .addAll(cardLabelState.labels.map((l) => l.id!));
                        }

                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.6,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: boardLabels.map((label) {
                                final isAssigned =
                                    assignedLabelIds.contains(label.id);
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _parseLabelColor(label.color),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(label.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        IconButton(
                                          icon: Icon(
                                            isAssigned
                                                ? Icons.close
                                                : Icons.add_circle,
                                            color: isAssigned
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                          onPressed: () {
                                            if (isAssigned) {
                                              innerContext
                                                  .read<CardlabelCubit>()
                                                  .removeLabelFromCard(
                                                    CardlabelCredentails(
                                                      labelId: label.id!,
                                                      cardId: card.id,
                                                    ),
                                                  );
                                            } else {
                                              innerContext
                                                  .read<CardlabelCubit>()
                                                  .assignLabelToCard(
                                                    CardlabelCredentails(
                                                      labelId: label.id!,
                                                      cardId: card.id,
                                                    ),
                                                  );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('Close',
                    style: Theme.of(context).textTheme.titleSmall),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// show checklist dialog page
void _showChecklistDialogPage(BuildContext context, int cardId) {
  showDialog(
    context: context,
    builder: (context) {
      final cubit = ChecklistCubit(context.read<ChecklistRepo>());
      cubit.listChecklist(cardId);
      return BlocProvider.value(
        value: cubit,
        child: ChecklistDialog(cardId: cardId, checklistCubit: cubit),
      );
    },
  );
}

// show comment dialog page
void _showCommentDialogPage(BuildContext context, int cardId) {
  showDialog(
    context: context,
    builder: (context) {
      final cubit = CommentCubit(context.read<CommentRepo>());
      cubit.getCommentsForCard(cardId);
      return BlocProvider.value(
        value: cubit,
        child: CommentDialog(cardId: cardId, commentCubit: cubit),
      );
    },
  );
}

// show attachment dialog page
void _showAttachmentDialogPage(BuildContext context, int cardId) {
  showDialog(
    context: context,
    builder: (context) {
      final cubit = AttachmentCubit(context.read<AttachmentRepo>());
      cubit.listAttachment(cardId);
      return BlocProvider.value(
        value: cubit,
        child: AttachmentDialog(cardId: cardId, attachmentCubit: cubit),
      );
    },
  );
}

// convert string color for a flutter color
Color _parseLabelColor(String colorString) {
  if (colorString.startsWith('#')) {
    String hex = colorString.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
  return Color(int.parse(colorString)); // Fallback for non-hex format
}
