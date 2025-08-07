import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_change_role_member_model.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_details.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_state.dart';

class WorkspaceMembersDialog extends StatelessWidget {
  const WorkspaceMembersDialog({
    super.key,
    required this.workspaceId,
  });

  final int workspaceId;

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkspaceMemberCubit, WorkspaceMemberState>(
      listener: (context, state) {
        if (state is MemberDeletionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Member removed successfully'), backgroundColor: Colors.green),
          );
        }
        if (state is MemberRoleChanged) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Role changed to ${state.newRole}'), backgroundColor: Colors.green,),
          );
        }
        if (state is MemberErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is MemberLoadedState) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade300,
            title: const Text('Members'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.members.length,
                itemBuilder: (context, index) {
                  final member = state.members[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        title: Text(member.userName),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                member.role,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'Joined At: ${_formatDate(member.joinedAt)}',
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        trailing: member.role != 'owner'
                            ? _buildMemberActions(context, member)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildMemberActions(
      BuildContext context, WorkspaceMemberDetail member) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'delete') {
          _confirmRemove(context, member);
        } else if (value == 'change_role') {
          _showRoleChangeDialog(context, member);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 8),
              Text('Remove Member'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'change_role',
          child: Row(
            children: [
              Icon(Icons.swap_vert, color: Colors.blue),
              SizedBox(width: 8),
              Text('Change Role'),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmRemove(
      BuildContext context, WorkspaceMemberDetail member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Remove ${member.userName} from workspace?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      context.read<WorkspaceMemberCubit>().removeMemberFromWorkspace(
            WorkspaceMemberCredential(
              userId: member.userId,
              workspaceId: workspaceId,
              userName: member.userName,
              userRole: member.role,
            ),
          );
    }
  }

  void _showRoleChangeDialog(
      BuildContext context, WorkspaceMemberDetail member) {
    // 1. Use a controller to manage the dropdown value
    final roleController = ValueNotifier<String>(member.role);
    final cubit = context.read<WorkspaceMemberCubit>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: AlertDialog(
          title: Text('Change ${member.userName}\'s Role'),
          content: ValueListenableBuilder<String>(
            valueListenable: roleController,
            builder: (context, currentRole, _) {
              return DropdownButtonFormField<String>(
                value: currentRole,
                items: const [
                  DropdownMenuItem(value: 'owner', child: Text('Owner')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'member', child: Text('Member')),
                ],
                onChanged: (value) {
                  roleController.value = value!; // Update the controller
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            BlocBuilder<WorkspaceMemberCubit, WorkspaceMemberState>(
              builder: (context, state) {
                final isLoading = state is MemberRoleChanging &&
                    state.targetUserId == member.userId;
                return ValueListenableBuilder<String>(
                  valueListenable: roleController,
                  builder: (context, selectedRole, _) {
                    return TextButton(
                      onPressed: isLoading || selectedRole == member.role
                          ? null
                          : () {
                              cubit.changeMemberRole(
                                WorkspaceChangeRoleMemberModel(
                                  targetUserId: member.userId,
                                  workspaceId: workspaceId,
                                  newRole: selectedRole,
                                ),
                              );
                              Navigator.pop(context);
                            },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Change'),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
