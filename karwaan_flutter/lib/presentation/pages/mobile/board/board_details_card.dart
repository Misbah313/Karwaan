import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/board/board_details.dart';
import 'package:karwaan_flutter/domain/repository/boardlist/boardlist_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/boardlist/boardlist_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardlist/boardlist_gate.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/board/board_menu.dart';

class BoardDetailsCard extends StatelessWidget {
  final BoardDetails board;
  const BoardDetailsCard({super.key, required this.board});

  // build header with the menu button
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: ListTile(
            title: Text(board.name,
                style:
                    GoogleFonts.alef(fontSize: 20, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            subtitle: Text(board.description,
                style: GoogleFonts.alef(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                    fontWeight: FontWeight.w200),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          )),
          IconButton(
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
        padding: EdgeInsets.all(15.0),
        child: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  colors: [Colors.grey.shade400, Colors.grey.shade200])),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.white),
              SizedBox(width: 4),
              Text(
                'Created At ${_formatDate(board.createdAt)}',
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
        return BoardMenu(
          board: board,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // navigate to the board list page
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider<BoardlistCubit>(
                      create: (context) =>
                          BoardlistCubit(context.read<BoardlistRepo>()),
                      child: BoardlistGate(
                        boardlistRepo: context.read<BoardlistRepo>(),
                        boardId: board.id,
                      ),
                    )));
      },
      child: Container(
        constraints: BoxConstraints(minHeight: 150),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8),
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
          children: [_buildHeader(context), _buildFooter(context)],
        ),
      ),
    );
  }
}
