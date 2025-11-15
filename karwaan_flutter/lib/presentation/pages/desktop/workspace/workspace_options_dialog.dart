import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_card_cubit.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_dialog_service.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_state.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/workspace/workspace_content_section.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/workspace/workspace_member_content.dart';

class WorkspaceOptionsDialog extends StatefulWidget {
  final Workspace workspace;
  final WorkspaceCubit workspaceCubit;
  final WorkspaceMemberCubit memberCubit;
  final WorkspaceCardCubit cardCubit;

  const WorkspaceOptionsDialog(
      {super.key,
      required this.workspace,
      required this.workspaceCubit,
      required this.memberCubit,
      required this.cardCubit});

  @override
  State<WorkspaceOptionsDialog> createState() => _WorkspaceOptionsDialogState();
}

class _WorkspaceOptionsDialogState extends State<WorkspaceOptionsDialog> {
  String? _currentUserEmail;

  @override
  void initState() {
    super.initState();
    _getCurrentUserEmail();
    if (!widget.workspace.isPrivate) {
      widget.memberCubit.getWorkspaceMembers(widget.workspace.id);
    }
  }

  @override
  void dispose() {
    widget.cardCubit.loadMembers();
    super.dispose();
  }

  void _getCurrentUserEmail() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      setState(() {
        _currentUserEmail = authState.user.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      insetPadding: const EdgeInsets.all(30),
      child: BlocProvider.value(
        value: widget.memberCubit,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.55,
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.workspace.workspaceName,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: BlocListener<WorkspaceCubit, WorkspaceState>(
                    bloc: widget.workspaceCubit,
                    listener: (context, state) {
                      if (state is WorkspaceError) {
                        // Show error message
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.read<BannerManager>().show(state.error);
                        });
                      }
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Workspace Section
                          WorkspaceContentSection(
                            workspace: widget.workspace,
                            workspaceCubit: widget.workspaceCubit,
                          ),

                          const SizedBox(height: 10),

                          // Add WorkspaceMemberSection later
                          if (!widget.workspace.isPrivate &&
                              _currentUserEmail != null)
                            WorkspaceMemberSection(
                              workspaceId: widget.workspace.id,
                              memberCubit: widget.memberCubit,
                              dialogService: MemberDialogServiceImpl(
                                memberService: MemberService(),
                              ),
                              memberService: MemberService(),
                              currentUserEmail: _currentUserEmail!,
                            )
                          else if (!widget.workspace.isPrivate)
                            const Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
