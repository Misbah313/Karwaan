import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
import 'package:karwaan_flutter/domain/repository/boardlist/boardlist_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardlist/boardlist_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/boardlist,boardcard/boardlist_page.dart';

class BoardlistGate extends StatelessWidget {
  final BoardlistRepo boardlistRepo;
  final BoardcardRepo boardcardRepo;
  final int boardId;
  final String boardName;
  const BoardlistGate(
      {super.key,
      required this.boardlistRepo,
      required this.boardId,
      required this.boardcardRepo,
      required this.boardName});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<BoardlistCubit>(
        create: (context) =>
            BoardlistCubit(boardlistRepo)..listBoardLists(boardId),
      ),
      BlocProvider<BoardCardCubit>(
        create: (context) => BoardCardCubit(boardcardRepo),
      )
    ], child: BoardlistPage(boardId: boardId, boardcardRepo: boardcardRepo, boardName: boardName,));
  }
}
