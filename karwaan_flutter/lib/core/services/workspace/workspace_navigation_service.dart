import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_gate.dart';

abstract class WorkspaceNavigationService {
  void navigateToWorkspaceBoards(BuildContext context, Workspace workspace);
}

class WorkspaceNavigationServiceImpl implements WorkspaceNavigationService {
  final BoardRepo boardRepo;

  WorkspaceNavigationServiceImpl({required this.boardRepo});
  @override
  void navigateToWorkspaceBoards(BuildContext context, Workspace workspace) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<BoardCubit>(
          create: (context) => BoardCubit(boardRepo),
          child: BoardGate(
            boardRepo: boardRepo,
            workspaceId: workspace.id,
            workspaceName: workspace.workspaceName,
            workspaceDescription: workspace.workspaceDescription,
          ),
        ),
      ),
    );
  }
}
