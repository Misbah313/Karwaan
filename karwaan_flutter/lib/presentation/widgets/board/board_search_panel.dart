import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/board/board.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';

class BoardSearchPanel extends StatelessWidget {
  final String query;
  final List<Board> boards;
  final List<BoardCard> cards;
  final VoidCallback onClose;

  const BoardSearchPanel({
    super.key,
    required this.query,
    required this.boards,
    required this.cards,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final hasBoards = boards.isNotEmpty;
    final hasCards = cards.isNotEmpty;
    final hasResults = hasBoards || hasCards;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.05),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // Results
          Expanded(
            child: !hasResults
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 32, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'No results found',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Try different keywords',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.all(12),
                    children: [
                      if (hasBoards) ...[
                        _buildSectionHeader('Boards', boards.length, context),
                        ...boards.map((board) => _buildBoardItem(board, context)),
                        SizedBox(height: 12),
                      ],
                      if (hasCards) ...[
                        _buildSectionHeader('Tasks', cards.length, context),
                        ...cards.map((card) => _buildCardItem(card, context)),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardItem(Board board, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withAlpha(10)
          : Colors.black.withAlpha(5),
      elevation: 0,
      margin: EdgeInsets.only(bottom: 6),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        leading: Icon(Icons.dashboard, size: 16),
        title: Text(
          board.boardName,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: board.boardDescription.isNotEmpty
            ? Text(
                board.boardDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Icon(Icons.chevron_right, size: 16),
        onTap: () {
          // Navigate to board
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening board: ${board.boardName}'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardItem(BoardCard card, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withAlpha(10)
          : Colors.black.withAlpha(5),
      elevation: 0,
      margin: EdgeInsets.only(bottom: 6),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        leading: Icon(
          Icons.task_outlined,
          size: 16,
        ),
        title: Text(
          card.title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: card.isCompleted 
                ? Colors.green.withAlpha(20)
                : Colors.orange.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            card.isCompleted ? 'Done' : 'Pending',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 9,
              color: card.isCompleted ? Colors.green : Colors.orange,
            ),
          ),
        ),
        onTap: () {
          // Navigate to card
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening task: ${card.title}'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}