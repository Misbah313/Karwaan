import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                    style: GoogleFonts.alef(
                        fontSize: 18, // Slightly smaller
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: 4),
                Text(board.boardDescription,
                    style: GoogleFonts.alef(
                        color: Colors.grey.shade600,
                        fontSize: 14, // Slightly smaller
                        fontWeight: FontWeight.w200),
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
                color: Colors.grey.shade600,
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
                  colors: [Colors.grey.shade400, Colors.grey.shade200])),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.white),
              SizedBox(width: 4),
              Text(
                'Created At ${_formatDate(board.createAt)}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
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
      backgroundColor: Colors.grey.shade200,
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
              colors: [Colors.grey.shade400, Colors.grey.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 6)],
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
