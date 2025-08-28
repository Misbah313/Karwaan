import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/board/board.dart';

class BoardCardBoard extends StatelessWidget {
  final Board board;
  const BoardCardBoard({super.key, required this.board});

  // build header with the menu button
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              // Wrap ListTile content in Column
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(board.boardName,
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: 4),
                Text(board.boardDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          IconButton(
            iconSize: 20,
            padding: EdgeInsets.zero,
              onPressed: () => _showBoardMenu(context),
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).iconTheme.color
              )),
        ],
      ),
    );
  }

  // build footer with the creation date
  Widget _buildFooter(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(12.0),
        child: Container(
          padding: EdgeInsets.all(12),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.onSurface])),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today, size: 16, color: Theme.of(context).iconTheme.color),
              SizedBox(width: 4),
              Text(
                'Created At ${_formatDate(board.createAt)}',
                style: Theme.of(context).textTheme.bodySmall
              ),
            ],
          ),
        ));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // show workspace menu
  void _showBoardMenu(BuildContext context) {
    showBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (bottomSheetContext) {
        return Scaffold();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // navigate to the board list page
      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: 150,
        ),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.onSurface],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.blueGrey.shade100, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }
}
