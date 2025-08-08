import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
            SnackBar(
                content: Text('Member removed successfully'),
                backgroundColor: Colors.green),
          );
        }
        if (state is MemberRoleChanged) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Role changed to ${state.newRole}'),
              backgroundColor: Colors.green,
            ),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: Colors.grey.shade300,
            title: Text(
              'Members',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
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
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            Colors.grey.shade400,
                            Colors.grey.shade200
                          ])),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        title: Text(
                          member.userName,
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                member.role,
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w300),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'Joined At: ${_formatDate(member.joinedAt)}',
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w300),
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
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // Member actions dialog
  Widget _buildMemberActions(
      BuildContext context, WorkspaceMemberDetail member) {
    return PopupMenuButton<String>(
      color: Colors.grey.shade300,
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'delete') {
          _confirmRemove(context, member);
        } else if (value == 'change_role') {
          _showRoleChangeDialog(context, member);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Remove Member',
                style:
                    GoogleFonts.alef(fontSize: 16, color: Colors.grey.shade800),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'change_role',
          child: Row(
            children: [
              Icon(Icons.change_circle_outlined, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Change Role',
                style:
                    GoogleFonts.alef(fontSize: 16, color: Colors.grey.shade800),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // confirm remove dialog
  void _confirmRemove(
      BuildContext context, WorkspaceMemberDetail member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Remove Member',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Remove ${member.userName} from workspace?',
          style: GoogleFonts.alef(fontSize: 16, color: Colors.grey.shade800),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
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

  // Change role dialog
  void _showRoleChangeDialog(
      BuildContext context, WorkspaceMemberDetail member) {
    final roleController = ValueNotifier<String>(member.role.toLowerCase());
    final cubit = context.read<WorkspaceMemberCubit>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.grey.shade300,
          title: Text(
            'Change ${member.userName}\'s Role',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: ValueListenableBuilder<String>(
            valueListenable: roleController,
            builder: (context, currentRole, _) {
              return DropdownButtonFormField<String>(
                dropdownColor: Colors.grey.shade300,
                 decoration: InputDecoration(
                  labelText: 'New Role',
                  labelStyle: GoogleFonts.alef(color: Colors.grey.shade600),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade600)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade800)
                  )    
                ),
                value: currentRole,
                items: [
                  DropdownMenuItem(
                      value: 'owner',
                      child: Text(
                        'Owner',
                        style: GoogleFonts.alef(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w300,
                            fontSize: 17),
                      )),
                  DropdownMenuItem(
                      value: 'admin',
                      child: Text(
                        'Admin',
                        style: GoogleFonts.alef(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w300,
                            fontSize: 17),
                      )),
                  DropdownMenuItem(
                      value: 'member',
                      child: Text(
                        'Member',
                        style: GoogleFonts.alef(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w300,
                            fontSize: 17),
                      )),
                ],
                onChanged: (value) {
                  if (value != null) {
                    roleController.value = value;
                  }
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            ),
            BlocBuilder<WorkspaceMemberCubit, WorkspaceMemberState>(
              builder: (context, state) {
                final isLoading = state is MemberRoleChanging &&
                    state.targetUserId == member.userId;
                return ValueListenableBuilder<String>(
                  valueListenable: roleController,
                  builder: (context, selectedRole, _) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.grey.shade500),
                      onPressed:
                          isLoading || selectedRole == member.role.toLowerCase()
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
                          : Text(
                              'Change',
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.bold),
                            ),
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
