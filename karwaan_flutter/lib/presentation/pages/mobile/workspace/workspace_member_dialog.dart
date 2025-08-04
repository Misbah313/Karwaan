import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_state.dart';

// workspace_members_dialog.dart
class WorkspaceMembersDialog extends StatelessWidget {
  const WorkspaceMembersDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceMemberCubit, WorkspaceMemberState>(
      builder: (context, state) {
        if (state is MemberLoadedState) {
          return AlertDialog(
            title: const Text('Workspace Members'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    state.members.length, 
                itemBuilder: (context, index) => ListTile(
                  title: Text(state.members[index].userName),
                  subtitle: Text(state.members[index].role),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('Close'))
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
