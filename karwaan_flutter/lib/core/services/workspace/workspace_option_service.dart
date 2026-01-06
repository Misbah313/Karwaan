import 'package:flutter/material.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_card_cubit.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/workspace/workspace_options_dialog.dart';

abstract class WorkspaceOptionsService {
  void showOptionsDialog({
    required BuildContext context,
    required Workspace workspace,
    required WorkspaceCardCubit cardCubit
  });
}

class WorkspaceOptionsServiceImpl implements WorkspaceOptionsService {
  final WorkspaceCubit workspaceCubit;
  final WorkspaceMemberCubit workspaceMemberCubit;

  WorkspaceOptionsServiceImpl(
      {required this.workspaceCubit, required this.workspaceMemberCubit});
  @override
  void showOptionsDialog({
    required BuildContext context,
    required Workspace workspace,
    required WorkspaceCardCubit cardCubit
  }) {
    showDialog(
      context: context,
      builder: (context) => WorkspaceOptionsDialog(
        workspace: workspace,
        workspaceCubit: workspaceCubit,
        memberCubit: workspaceMemberCubit,
        cardCubit: cardCubit
      ),
    );
  }
}
