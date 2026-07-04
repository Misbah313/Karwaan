import 'package:flutter/material.dart';

enum _ListAction { edit, delete } 

class ListActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ListActions({super.key, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ListAction>(
      iconColor: Theme.of(context).iconTheme.color,
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      onSelected: (value) {
        switch (value) {
          case _ListAction.edit:
            onEdit();
            break;
          case _ListAction.delete:
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _ListAction.edit,
          child: Text('Edit', style: Theme.of(context).textTheme.bodyMedium),
        ),
        PopupMenuItem(
          value: _ListAction.delete,
          child: Text('Delete', style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
