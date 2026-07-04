import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/board/board_wrapper.dart';

class BoardListItem extends StatelessWidget {
  final BoardWrapper board;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final VoidCallback onOptions;

  const BoardListItem({
    super.key,
    required this.board,
    required this.isSelected,
    required this.onTap,
    required this.onDoubleTap,
    required this.onOptions,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        dragStartBehavior: DragStartBehavior.start,
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected
                  ? Colors.blue.shade500.withValues(alpha: 0.4)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          elevation: 0,
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.04),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.dashboard,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            title:
                Text(board.name, style: Theme.of(context).textTheme.bodyMedium),
            subtitle: Text(
              board.description,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.more_vert,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: onOptions,
              tooltip: 'Board options',
            ),
          ),
        ),
      ),
    );
  }
}
