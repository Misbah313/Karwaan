import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/board/board.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';

class BoardSearchOverlay extends StatelessWidget {
  final String query;
  final List<Board> boards;
  final List<BoardCard> cards;

  const BoardSearchOverlay({
    super.key,
    required this.query,
    required this.boards,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    final hasBoards = boards.isNotEmpty;
    final hasCards = cards.isNotEmpty;
    final hasResults = hasBoards || hasCards;

    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.onSurface
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withValues(alpha: 0.2))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Search: "$query"',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: !hasResults
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('No results found',
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 4),
                        Text('Try searching with different keywords',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      if (hasBoards) ...[
                        _buildSectionHeader('Boards', boards.length, context),
                        ...boards
                            .map((board) => _buildBoardItem(board, context)),
                        SizedBox(height: 16),
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
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(count.toString(),
                style: Theme.of(context).textTheme.titleSmall),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardItem(Board board, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.black.withValues(alpha: 0.03),
      elevation: 0,
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.dashboard,
            color: Theme.of(context).iconTheme.color, size: 20),
        title: Text(board.boardName,
            style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Text(
          board.boardDescription,
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        onTap: () {
          Navigator.pop(context);
          // naviagate to that speicfic board page(laterrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              content: Text(
                'Found board: ${board.boardName}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardItem(BoardCard card, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.black.withValues(alpha: 0.03),
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          Icons.task_outlined,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        title: Text(
          card.title,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(card.isCompleted ? '✅ Completed' : '⏳ Pending',
            style: Theme.of(context).textTheme.bodySmall),
        onTap: () {
          Navigator.pop(context);
          // navigate to that card speicific card or its parent board page(laterrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              content: Text(
                'Found task: ${card.title}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}
