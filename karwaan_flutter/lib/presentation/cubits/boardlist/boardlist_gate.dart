import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/repository/boardlist/boardlist_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/boardlist/boardlist_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/boardlist/boardlist_page.dart';

class BoardlistGate extends StatelessWidget {
  final BoardlistRepo boardlistRepo;
  final int boardId;
  const BoardlistGate({super.key, required this.boardlistRepo, required this.boardId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => BoardlistCubit(boardlistRepo),
    child: BoardlistPage(boardId: boardId,),);
  }
}