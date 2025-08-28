import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_state.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_state.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/workspace/workspace_add_member_dialog.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/workspace/workspace_member_dialog.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';

class WorkspaceMenu extends StatelessWidget {
  final Workspace workspace;
  const WorkspaceMenu({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            leading:  Icon(Icons.people, color: Theme.of(context).iconTheme.color,),
            title:  Text('View Members', style: Theme.of(context).textTheme.bodyMedium,),
            onTap: () {
              Navigator.pop(context);
              final cubit = context.read<WorkspaceMemberCubit>();
              cubit.getWorkspaceMembers(workspace.id);
              _showMemberDialog(context, cubit);
            }),
        ListTile(
          leading:  Icon(Icons.exit_to_app, color: Theme.of(context).iconTheme.color),
          title:  Text('Leave Workspace',  style: Theme.of(context).textTheme.bodyMedium),
          onTap: () {
            Navigator.pop(context);
            _showLeaveConfirmationDialog(context, workspace.id);
          },
        ),
        ListTile(
          leading:  Icon(Icons.add_circle_outline_outlined, color: Theme.of(context).iconTheme.color),
          title:  Text('Add member',  style: Theme.of(context).textTheme.bodyMedium),
          onTap: () {
            Navigator.pop(context);
            final cubit = context.read<WorkspaceMemberCubit>();
            cubit.getWorkspaceMembers(workspace.id);
            _showAddMemberDialog(context, workspace.id, cubit);
          },
        ),
        ListTile(
          leading:  Icon(Icons.delete_outline_rounded, color: Theme.of(context).iconTheme.color),
          title:  Text('Delete Workspace',  style: Theme.of(context).textTheme.bodyMedium),
          onTap: () {
            Navigator.pop(context);
            _showDeleteWorkspaceDialog(context, workspace.id);
          },
        ),
        ListTile(
          leading:  Icon(Icons.update, color: Theme.of(context).iconTheme.color),
          title:  Text('Update Worksace',  style: Theme.of(context).textTheme.bodyMedium),
          onTap: () {
            Navigator.pop(context);
            _showUpdateWorkspaceDialog(context, workspace.id);
          },
        ),
      ],
    );
  }

  void _showMemberDialog(BuildContext context, WorkspaceMemberCubit cubit) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: WorkspaceMembersDialog(
          workspaceId: workspace.id,
        ),
      ),
    ).then((_) {
      cubit.getWorkspaceMembers(workspace.id);
    });
  }

  void _showAddMemberDialog(
      BuildContext context, int workspaceId, WorkspaceMemberCubit cubit) {
    showDialog(
        context: context,
        builder: (context) => BlocProvider.value(
              value: cubit,
              child: WorkspaceAddMemberDialog(workspaceId: workspaceId),
            ));
  }

  void _showLeaveConfirmationDialog(BuildContext context, int workspaceId) {
    final cubit = context.read<WorkspaceMemberCubit>();

    showDialog(
        context: context,
        builder: (context) => BlocProvider.value(
              value: cubit,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  'Leave Workspace?',
                  style: Theme.of(context).textTheme.bodyLarge
                ),
                content: Text(
                  'Are you sure you want to leave this workspace?',
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child:  Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.titleSmall
                    ),
                  ),
                  BlocConsumer<WorkspaceMemberCubit, WorkspaceMemberState>(
                    listener: (context, state) {
                      if (state is MemberLeavedSuccessfully) {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(
                            context); // Close workspace menu if still open
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Left workspace successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                      if (state is LastOwnerError) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Theme.of(context).colorScheme.primary),
                        onPressed: state is MemberLoadingState
                            ? null
                            : () {
                                context
                                    .read<WorkspaceMemberCubit>()
                                    .leaveWorkspace(workspaceId);
                              },
                        child: state is MemberLoadingState
                            ? const CircularProgressIndicator()
                            :  Text(
                                'Leave',
                                style: TextStyle(color: Colors.red),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ));
  }

  void _showDeleteWorkspaceDialog(BuildContext context, int workspaceId) {
    final cubit = context.read<WorkspaceCubit>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Delete Workspace?',
            style: Theme.of(context).textTheme.bodyLarge
          ),
          content: Text(
            'Are you sure want to delete this workspace?',
            style: Theme.of(context).textTheme.bodyMedium
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.titleSmall
                )),
            BlocConsumer<WorkspaceCubit, WorkspaceState>(
              listener: (context, state) {
                if (state is WorkspaceListLoaded) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Workspace deleted successfully.'),
                    backgroundColor: Colors.green,
                  ));
                }
                if (state is WorkspaceError) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    onPressed: state is WorkspaceLoading
                        ? null
                        : () {
                            context
                                .read<WorkspaceCubit>()
                                .deleteWorkspace(workspaceId);
                          },
                    child: state is WorkspaceLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ));
              },
            )
          ],
        ),
      ),
    );
  }

  void _showUpdateWorkspaceDialog(BuildContext context, int workspaceId) {
    final cubit = context.read<WorkspaceCubit>();
    final newNameController = TextEditingController();
    final newDecController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => BlocProvider.value(
              value: cubit,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text('Update workspace!', style: Theme.of(context).textTheme.bodyLarge),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Textfield(
                        text: 'New Name',
                        obsecureText: false,
                        controller: newNameController),
                    const SizedBox(height: 20),
                    Textfield(
                        text: 'New Descritpion',
                        obsecureText: false,
                        controller: newDecController),
                  ],
                ),
                 actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: Theme.of(context).textTheme.titleSmall)),
                  BlocConsumer<WorkspaceCubit, WorkspaceState>(
                    listener: (context, state) {
                      if (state is WorkspaceListLoaded) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Workspace successfully updated.'),
                          backgroundColor: Colors.green,
                        ));
                      }

                      if (state is WorkspaceError) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          backgroundColor: Theme.of(context).colorScheme.primary
                        ),
                          onPressed: state is WorkspaceLoading
                              ? null
                              : () {
                                  if (newNameController.text.isEmpty) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Workspace name cannot be empty!!'),
                                      backgroundColor: Colors.red,
                                    ));
                                    return;
                                  }
                                  final credentials = WorkspaceCredential(
                                      id: workspaceId,
                                      workspaceName:
                                          newNameController.text.trim(),
                                      workspaceDescription:
                                          newDecController.text.trim());
                                  context
                                      .read<WorkspaceCubit>()
                                      .updateWorkspace(credentials);
                                },
                          child: state is WorkspaceLoading
                              ? const CircularProgressIndicator()
                              :  Text('Update', style: Theme.of(context).textTheme.bodySmall));
                    },
                  )
                ],
              ),
            ));
  }
}
