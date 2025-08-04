import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/workspace/workspace_member_dialog.dart';

class WorkspaceMenu extends StatelessWidget {
  final Workspace workspace;
  const WorkspaceMenu({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.people),
          title: Text('View Members'),
          onTap: () {
            Navigator.pop(context);
             context.read<WorkspaceMemberCubit>().getWorkspaceMembers(workspace.id);
            _showMemberDialog(context);
          },
        ),
        ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Leave Workspace'),
            onTap: () {
              Navigator.pop(context);
              context.read<WorkspaceMemberCubit>().leaveWorkspace(workspace.id);
            })
      ],
    );
  }
}

void _showMemberDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const WorkspaceMembersDialog(),
  );
}
