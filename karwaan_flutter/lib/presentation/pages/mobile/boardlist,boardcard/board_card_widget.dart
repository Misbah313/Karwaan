import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_credentails.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';

class CardWidget extends StatelessWidget {
  final BoardCard card;
  final BoardCardCubit cardCubit; // pass the cubit for updates
  const CardWidget({super.key, required this.card, required this.cardCubit});

  @override
  Widget build(BuildContext context) {
    // show confim delete card dialog
    Future<void> confirmDeleteCard(int cardId) async {
      await showDialog(
        context: context,
        builder: (dialogCtx) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.grey.shade300,
            title: const Text('Delete Card'),
            content: Text(
              'Are you sure you want to delete this card? This cannot be undone.',
              style: GoogleFonts.alef(fontSize: 16, color: Colors.black87),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(),
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  cardCubit.deleteBoardCard(card.id);
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.blueGrey.shade300, Colors.grey.shade300]),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* Top label color (hardcoded for now)
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue, // future: card.labelColor
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
          ),
          */
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Checkbox for completion
                Checkbox(
                  activeColor: Colors.green,
                  checkColor: Colors.grey.shade300,
                  side: BorderSide(color: Colors.grey.shade400),
                  value: card.isCompleted,
                  onChanged: (val) {
                    // Update the card completion status
                    cardCubit.updateBoardCard(
                      BoardCardCredentails(
                        cardId: card.id,
                        newTitle: card.title,
                        newDec: card.description,
                        isCompleted: val ?? false,
                        // future: add other fields
                      ),
                    );
                  },
                ),

                // Task title
                Expanded(
                  child: Text(
                    card.title,
                    style: GoogleFonts.alef(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                        decoration: card.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: Colors.grey.shade700),
                  ),
                ),

                // Edit icon
                PopupMenuButton<_CardAction>(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: Colors.grey.shade700,
                  ),
                  onSelected: (action) {
                    switch (action) {
                      case _CardAction.edit:
                        _showEditCardDialog(context, card, cardCubit);
                        break;
                      case _CardAction.delete:
                        confirmDeleteCard(card.id);
                        break;
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                        value: _CardAction.edit,
                        child: Text(
                          'Edit',
                          style: GoogleFonts.alef(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500),
                        )),
                    PopupMenuItem(
                        value: _CardAction.delete,
                        child: Text(
                          'Delete',
                          style: GoogleFonts.alef(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500),
                        )),
                  ],
                ),

                // Popup menu for future actions (delete, move, labels)
                /*
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, size: 20),
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                    PopupMenuItem(value: 'move', child: Text('Move')),
                    // future: color/labels
                  ],
                ),
                */
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _CardAction { edit, delete }

// Edit card dialog
Future<void> _showEditCardDialog(
    BuildContext context, BoardCard card, BoardCardCubit cardCubit) async {
  final titleController = TextEditingController(text: card.title);
  final descController = TextEditingController(text: card.description);

  await showDialog(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      title: Text('Edit Card'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogCtx).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
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
          child: Text('Save'),
        ),
      ],
    ),
  );
}
