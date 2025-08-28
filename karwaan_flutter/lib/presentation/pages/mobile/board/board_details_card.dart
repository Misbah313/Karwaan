import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/board/board_details.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
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
                    Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            subtitle: Text(board.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          )),
          IconButton(
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
        padding: EdgeInsets.all(15.0),
        child: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.onSurface])),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Theme.of(context).iconTheme.color),
              SizedBox(width: 4),
              Text(
                'Created At ${_formatDate(board.createdAt)}',
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
                        boardcardRepo: context.read<BoardcardRepo>(),
                        boardName: board.name,

                      ),
                    )));
      },
      child: Container(
        constraints: BoxConstraints(minHeight: 150),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8),
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
          children: [_buildHeader(context), _buildFooter(context)],
        ),
      ),
    );
  }
}
