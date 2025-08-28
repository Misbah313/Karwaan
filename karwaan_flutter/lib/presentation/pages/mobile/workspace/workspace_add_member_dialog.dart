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

    return BlocListener<WorkspaceMemberCubit, WorkspaceMemberState>(
      listener: (context, state) {
        if (state is AddMemberSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Member added successfully!'),
              backgroundColor: Colors.green.shade200,
            ),
          );
          context.read<WorkspaceMemberCubit>().getWorkspaceMembers(workspaceId);
        }
        if (state is MemberErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Add Member',
          style: Theme.of(context).textTheme.bodyLarge
        ),
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
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
                value: selectedRole,
                decoration: InputDecoration(
                  labelText: 'Role',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Theme.of(context).dividerColor)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Theme.of(context).dividerColor)
                  )    
                ),
                items: ['member', 'admin', 'moderator'].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(
                      role,
                      style: Theme.of(context).textTheme.bodySmall
                    ),
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
            child:  Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleSmall
            ),
          ),
          BlocBuilder<WorkspaceMemberCubit, WorkspaceMemberState>(
            builder: (context, state) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor),
                onPressed: state is MemberLoadingState
                    ? null
                    : () async {
                        if (emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Email is required!'),
                                backgroundColor: Colors.red),
                          );
                          return;
                        }

                        if (!emailController.text.contains('@')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Enter a valid email!'),
                                backgroundColor: Colors.red),
                          );
                          return;
                        }

                        final credentials = WorkspaceMemberCredential(
                          userId: 0, // Will be ignored by backend (using email)
                          workspaceId: workspaceId,
                          userName: emailController.text.trim(),
                          userRole: selectedRole ?? 'member',
                        );
                        await context
                            .read<WorkspaceMemberCubit>()
                            .addMemberToWorkspace(credentials);
                      },
                child: state is MemberLoadingState
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Add',
                        style: Theme.of(context).textTheme.bodySmall
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
