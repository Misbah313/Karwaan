import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';

class WorkspacePage extends StatelessWidget {
  final WorkspaceRepo workspaceRepo;
  final Widget child;
  const WorkspacePage(
      {super.key, required this.workspaceRepo, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => WorkspaceCubit(workspaceRepo)..getUserWorkspace(),
      ),
      BlocProvider(
        create: (context) => WorkspaceMemberCubit(workspaceRepo),
      )
    ], child: child);
  }
}
