import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/workspace/app_naviagation_service.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';
// import 'package:karwaan_flutter/presentation/cubits/board/board_cubit.dart';
// import 'package:karwaan_flutter/presentation/cubits/board/board_gate.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_context_cubit.dart';

abstract class WorkspaceNavigationService {
  void navigateToWorkspaceBoards(BuildContext context, Workspace workspace);
}

class WorkspaceNavigationServiceImpl implements WorkspaceNavigationService {
  final BoardRepo boardRepo;
  final AppNavigationService appNavigationService;

  WorkspaceNavigationServiceImpl(
      {required this.boardRepo, required this.appNavigationService});
  @override
  void navigateToWorkspaceBoards(BuildContext context, Workspace workspace) {
    context.read<WorkspaceContextCubit>().setCurrentWorkspace(
        workspace.id, workspace.workspaceName, workspace.workspaceDescription);
    appNavigationService.navigateToPage(1, "Boards");
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => BlocProvider<BoardCubit>(
    //       create: (context) => BoardCubit(boardRepo),
    //       child: BoardGate(
    //         boardRepo: boardRepo,
    //         workspaceId: workspace.id,
    //         workspaceName: workspace.workspaceName,
    //         workspaceDescription: workspace.workspaceDescription,
    //       ),
    //     ),
    //   ),
    // );
  }
}
