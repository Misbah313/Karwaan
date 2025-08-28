import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_change_role_model.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_credentails.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_state.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';

class BoardMemberDialog extends StatelessWidget {
  const BoardMemberDialog({super.key, required this.boardId});

  final int boardId;

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoardMemberCubit, BoardMemberState>(
      listener: (context, state) {
        if (state is BoardDeleteMemberSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Member removed successfully'),
                backgroundColor: Colors.green),
          );
        }
        if (state is BoardMemberRoleChanged) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Role changed to ${state.newRole}'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state is BoardMemberError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is BoardMemberLoaded) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              'Members',
              style: Theme.of(context).textTheme.bodyLarge
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
                            Theme.of(context).colorScheme.surface,
                            Theme.of(context).colorScheme.onSurface
                          ])),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        title: Text(
                          member.userName,
                          style: Theme.of(context).textTheme.bodyMedium
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                member.userRole,
                                style: Theme.of(context).textTheme.bodySmall
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'Joined At: ${_formatDate(member.joinedAt)}',
                                style: Theme.of(context).textTheme.bodySmall
                              ),
                            ),
                          ],
                        ),
                        trailing: member.userRole != 'owner'
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
                  style: Theme.of(context).textTheme.titleSmall
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
  Widget _buildMemberActions(BuildContext context, BoardMemberDetails member) {
    return PopupMenuButton<String>(
      color: Theme.of(context).scaffoldBackgroundColor,
      icon:  Icon(Icons.more_vert, color: Theme.of(context).iconTheme.color,),
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
                    Theme.of(context).textTheme.bodyMedium
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
                    Theme.of(context).textTheme.bodyMedium
              ),
            ],
          ),
        ),
      ],
    );
  }

  // confirm remove dialog
  void _confirmRemove(BuildContext context, BoardMemberDetails member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Remove Member',
          style: Theme.of(context).textTheme.bodyLarge
        ),
        content: Text(
          'Remove ${member.userName} from board?',
          style: Theme.of(context).textTheme.bodyMedium
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:  Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleSmall
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              backgroundColor: Theme.of(context).colorScheme.primary
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      context.read<BoardMemberCubit>().removeMemberFromBoard(
            BoardMemberCredentails(
              userId: member.userId,
              boardId: boardId,
              userName: member.userName,
              userRole: member.userRole,
            ),
          );
    }
  }

  // Change role dialog
  void _showRoleChangeDialog(
      BuildContext context, BoardMemberDetails member) {
    final roleController = ValueNotifier<String>(member.userRole.toLowerCase());
    final cubit = context.read<BoardMemberCubit>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Change ${member.userName}\'s Role',
            style: Theme.of(context).textTheme.bodyLarge
          ),
          content: ValueListenableBuilder<String>(
            valueListenable: roleController,
            builder: (context, currentRole, _) {
              return DropdownButtonFormField<String>(
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                decoration: InputDecoration(
                    labelText: 'New Role',
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Theme.of(context).dividerColor))),
                value: currentRole,
                items: [
                  DropdownMenuItem(
                      value: 'owner',
                      child: Text(
                        'Owner',
                        style: Theme.of(context).textTheme.bodyMedium
                      )),
                  DropdownMenuItem(
                      value: 'admin',
                      child: Text(
                        'Admin',
                        style: Theme.of(context).textTheme.bodyMedium
                      )),
                  DropdownMenuItem(
                      value: 'member',
                      child: Text(
                        'Member',
                        style: Theme.of(context).textTheme.bodyMedium
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
                  style: Theme.of(context).textTheme.titleSmall),
            ),
            BlocBuilder<BoardMemberCubit,  BoardMemberState>(
              builder: (context, state) {
                final isLoading = state is BoardMemberRoleChanging &&
                    state.targetUserId == member.userId;
                return ValueListenableBuilder<String>(
                  valueListenable: roleController,
                  builder: (context, selectedRole, _) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Theme.of(context).colorScheme.primary),
                      onPressed:
                          isLoading || selectedRole == member.userRole.toLowerCase()
                              ? null
                              : () {
                                  cubit.changeBoardMemberRole(
                                    BoardMemberChangeRoleModel(
                                      targetUserId: member.userId,
                                      boardId: boardId,
                                      newRole: selectedRole,
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              'Change',
                              style: Theme.of(context).textTheme.bodySmall
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
