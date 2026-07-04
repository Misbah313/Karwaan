import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_change_role_model.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_credentails.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_state.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/member/member_role_badget.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';

abstract class BoardMemberDialogService {
  void showChangeRoleDialog(
    BuildContext context,
    BoardMemberDetails member,
    BoardMemberCubit memberCubit,
    int boardId,
  );

  void showRemoveDialog(
    BuildContext context,
    BoardMemberDetails member,
    BoardMemberCubit memberCubit,
    int boardId,
  );

  void showInviteDialog(
    BuildContext context,
    BoardMemberCubit memberCubit,
    int boardId,
  );
}

class BoardMemberDialogServiceImpl implements BoardMemberDialogService {
  @override
  void showChangeRoleDialog(
    BuildContext context,
    BoardMemberDetails member,
    BoardMemberCubit memberCubit,
    int boardId,
  ) {
    String? selectedRole = member.userRole;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.35,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Change Role for ${member.userName}',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              Text('Current role: ${member.userRole}',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
                value: selectedRole,
                decoration: InputDecoration(
                  labelText: 'New Role',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                items: ['owner', 'admin', 'member'].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Row(
                      children: [
                        RoleBadge(role: role, memberService: MemberService()),
                        const SizedBox(width: 8),
                        Text(
                          MemberService().capitalize(role),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => selectedRole = value,
              ),
             
                ],
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedRole != null &&
                          selectedRole != member.userRole) {
                        final update = BoardMemberChangeRoleModel(
                          targetUserId: member.userId,
                          boardId: boardId,
                          newRole: selectedRole!,
                        );
                        memberCubit.changeRoleOptimized(update);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )

                    ),
                    child: Text(
                      'Update Role',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void showRemoveDialog(
    BuildContext context,
    BoardMemberDetails member,
    BoardMemberCubit memberCubit,
    int boardId,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        insetPadding: const EdgeInsets.all(30),
        child: BlocProvider.value(
          value: memberCubit,
          child: BlocListener<BoardMemberCubit, BoardMemberState>(
            listener: (context, state) {
              if (state is BoardDeleteMemberSuccess) {
                Navigator.pop(context);
                context.read<BannerManager>().show('Member removed');
              }
              if (state is BoardMemberError) {
                Navigator.pop(context);
                context.read<BannerManager>().show(state.error);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Remove ${member.userName}',
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        Text(
                            'Are you sure want to remove this member from the board?',
                            style: Theme.of(context).textTheme.bodySmall)
                      ],
                    ),

                    // actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel',
                                style: Theme.of(context).textTheme.titleSmall)),
                        const SizedBox(width: 6),
                        BlocBuilder<BoardMemberCubit, BoardMemberState>(
                          builder: (context, state) {
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                ),
                                onPressed: state is BoardMemberLoading
                                    ? null
                                    : () {
                                        final credentails =
                                            BoardMemberCredentails(
                                                userId: member.userId,
                                                boardId: boardId,
                                                userName: member.userName,
                                                userRole: member.userRole);
                                        context
                                            .read<BoardMemberCubit>()
                                            .removeMemberOptimized(credentails);
                                        Navigator.pop(context);
                                      },
                                child: state is BoardMemberLoading
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        'Remove',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.red),
                                      ));
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void showInviteDialog(
    BuildContext context,
    BoardMemberCubit memberCubit,
    int boardId,
  ) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        insetPadding: const EdgeInsets.all(30),
        child: BlocProvider.value(
          value: memberCubit,
          child: BlocListener<BoardMemberCubit, BoardMemberState>(
            listener: (context, state) {
              if (state is BoardAddMemberSuccess) {
                Navigator.pop(context);
                context.read<BannerManager>().show('Member added successfully');
              }
              if (state is BoardMemberError) {
                context.read<BannerManager>().show(state.error);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Add Member to Board',
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        Text(
                            'Enter the email address of the person you want to add',
                            style: Theme.of(context).textTheme.bodySmall)
                      ],
                    ),

                    // email input
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email Address',
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 8),
                        Textfield(
                            text: 'user@gmail.com',
                            obsecureText: false,
                            controller: emailController)
                      ],
                    ),

                    // actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel',
                                style: Theme.of(context).textTheme.titleSmall)),
                        const SizedBox(width: 6),
                        BlocBuilder<BoardMemberCubit, BoardMemberState>(
                          builder: (context, state) {
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary),
                                onPressed: state is BoardMemberLoading
                                    ? null
                                    : () {
                                        if (emailController.text.isEmpty) {
                                          context.read<BannerManager>().show(
                                              'Please enter an email address');
                                          return;
                                        }
                                        final credentails =
                                            BoardMemberCredentails(
                                                userId: 0,
                                                boardId: boardId,
                                                userName:
                                                    emailController.text.trim(),
                                                userRole: 'member');
                                        context
                                            .read<BoardMemberCubit>()
                                            .addMemberOptimized(credentails);
                                        Navigator.pop(context);
                                      },
                                child: state is BoardMemberLoading
                                    ? const CircularProgressIndicator()
                                    : Text('Add Member',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall));
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
