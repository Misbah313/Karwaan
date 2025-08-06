import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_credentials.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_state.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';

class WorkspaceAddMemberDialog extends StatelessWidget {
  final int workspaceId;
  const WorkspaceAddMemberDialog({super.key, required this.workspaceId});

  @override
  Widget build(BuildContext context) {

    final emailController = TextEditingController();
    String? selectedRole = 'member'; // Default role

    return   BlocListener<WorkspaceMemberCubit, WorkspaceMemberState>(
        listener: (context, state) {
          if (state is AddMemberSuccess) {
            Navigator.pop(context); // Close the dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Member added successfully!')),
            );
            // Refresh members list
            context
                .read<WorkspaceMemberCubit>()
                .getWorkspaceMembers(workspaceId);
          }
          if (state is MemberErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: AlertDialog(
          title: const Text('Add Member'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Textfield(
                  text: 'Member Email',
                  obsecureText: false,
                  controller: emailController,
                ),
                middleSizedBox,
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: ['member', 'admin', 'moderator'].map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) => selectedRole = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            BlocBuilder<WorkspaceMemberCubit, WorkspaceMemberState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state is MemberLoadingState
                      ? null
                      : () {
                          if (emailController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Email is required!')),
                            );
                            return;
                          }

                          // In production, you should lookup user ID from email first
                          // For now using 0 as placeholder - implement user lookup
                          final credentials = WorkspaceMemberCredential(
                            userId: 27, // TODO: Replace with actual user lookup
                            workspaceId: workspaceId,
                            userName: emailController.text.trim(),
                            userRole: selectedRole ?? 'member',
                          );
                          context
                              .read<WorkspaceMemberCubit>()
                              .addMemberToWorkspace(credentials);
                        },
                  child: state is MemberLoadingState
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Add'),
                );
              },
            ),
          ],
        ),
      );
  }
}