import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';

class CardDetailSheet extends StatelessWidget {
  final BoardCard card;
  const CardDetailSheet({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            children: [
              Expanded(
                  child: ListTile(
                title: Text(
                  card.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  card.description,
                  style: Theme.of(context).textTheme.bodyMedium
                ),
              )),
              IconButton(
                icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          // Status Toggle
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Completed:'),
              const SizedBox(width: 8),
              Switch(
                value: card.isCompleted,
                onChanged: (value) {
                  // TODO: Add cubit call to update completion status
                  Navigator.pop(context); // Close sheet after update
                },
              ),
            ],
          ),

          // Action Buttons
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // TODO: Save changes via cubit
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
