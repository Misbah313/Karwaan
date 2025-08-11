import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/board/board_page.dart';

class BoardGate extends StatelessWidget {
  final BoardRepo boardRepo;
  final int workspaceId;
  final String workspaceName;
  final String workspaceDescription;
  const BoardGate(
      {super.key,
      required this.boardRepo,
      required this.workspaceId,
      required this.workspaceName,
      required this.workspaceDescription});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              final cubit = context.read<BoardCubit>();
              cubit.getBoardsByWorkspace(workspaceId);
              return cubit;
            },
          ),
          BlocProvider(
            create: (context) => BoardMemberCubit(boardRepo),
          ),
        ],
        child: BoardPage(
            workspaceId: workspaceId,
            workspaceName: workspaceName,
            workspaceDec: workspaceDescription));
  }
}
