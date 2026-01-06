import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_dialog_service.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_details.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_state.dart';
import 'package:karwaan_flutter/presentation/widgets/member/member_avatar.dart';
import 'package:karwaan_flutter/presentation/widgets/member/member_role_badget.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/button.dart';

class WorkspaceMemberSection extends StatefulWidget {
  final int workspaceId;
  final WorkspaceMemberCubit memberCubit;
  final MemberDialogService dialogService;
  final MemberService memberService;
  final String currentUserEmail;

  const WorkspaceMemberSection({
    super.key,
    required this.workspaceId,
    required this.memberCubit,
    required this.dialogService,
    required this.memberService,
    required this.currentUserEmail,
  });

  @override
  State<WorkspaceMemberSection> createState() => _WorkspaceMemberSectionState();
}

class _WorkspaceMemberSectionState extends State<WorkspaceMemberSection> {
  bool _showAllMembers = false;
  final int _maxVisibleMembers = 5;
  List<WorkspaceMemberDetail> _lastKnownMembers = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Members'),
          const SizedBox(height: 16),
          _buildMemberList(context),
          const SizedBox(height: 15),
          _buildAddMemberSection(context),
          const SizedBox(height: 15),
          _buildLeaveWorkspace(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildMemberList(BuildContext context) {
    return BlocBuilder<WorkspaceMemberCubit, WorkspaceMemberState>(
      bloc: widget.memberCubit,
      buildWhen: (previous, current) => _shouldRebuild(previous, current),
      builder: (context, state) {
        return _buildMemberListContent(context, state);
      },
    );
  }

  bool _shouldRebuild(
      WorkspaceMemberState previous, WorkspaceMemberState current) {
    if (previous is MemberLoadedState && current is MemberLoadedState) {
      return _hasMembersChanged(previous.members, current.members);
    }
    return current is MemberLoadedState ||
        current is MemberAddedSuccess ||
        current is MemberRemovedSuccess ||
        current is MemberRoleChangedSuccess ||
        current is MemberLoadingState ||
        current is MemberLeavedSuccessfully ||
        current is MemberErrorState;
  }

  bool _hasMembersChanged(List<WorkspaceMemberDetail> oldList,
      List<WorkspaceMemberDetail> newList) {
    if (oldList.length != newList.length) return true;

    for (int i = 0; i < oldList.length; i++) {
      final oldMember = oldList[i];
      final newMember = newList[i];

      if (oldMember.userId != newMember.userId ||
          oldMember.role != newMember.role ||
          oldMember.userName != newMember.userName ||
          oldMember.email != newMember.email) {
        return true;
      }
    }
    return false;
  }

  Widget _buildMemberListContent(
      BuildContext context, WorkspaceMemberState state) {
    if (state is MemberLoadingState ||
        state is MemberAddingState ||
        state is MemberRemovingState ||
        state is MemberRoleChangingState) {
      return _buildLoadingState();
    } else if (state is MemberLoadedState) {
      _lastKnownMembers = state.members;
      return _buildMemberListView(context, state.members);
    } else if (state is MemberAddedSuccess) {
      _lastKnownMembers = state.updatedMembers;
      return _buildMemberListView(context, state.updatedMembers);
    } else if (state is MemberRemovedSuccess) {
      _lastKnownMembers = state.updatedMembers;
      return _buildMemberListView(context, state.updatedMembers);
    } else if (state is MemberRoleChangedSuccess) {
      _lastKnownMembers = state.updatedMembers;
      return _buildMemberListView(context, state.updatedMembers);
    } else if (state is MemberErrorState) {
      return _buildErrorState(context, state.error);
    } else {
      return _buildInitialState(context);
    }
  }

  Widget _buildMemberListView(
      BuildContext context, List<WorkspaceMemberDetail> members) {
    final displayedMembers =
        _showAllMembers ? members : members.take(_maxVisibleMembers).toList();
    final hasMoreMembers = members.length > _maxVisibleMembers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${members.length} ${members.length == 1 ? 'Member' : 'Members'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (hasMoreMembers)
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAllMembers = !_showAllMembers;
                  });
                },
                child: Text(
                  _showAllMembers ? 'Show Less' : 'Show All',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: displayedMembers
              .map((member) => _buildMemberItem(context, member))
              .toList(),
        ),
        if (!_showAllMembers && hasMoreMembers)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '+ ${members.length - _maxVisibleMembers} more members',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  Widget _buildMemberItem(BuildContext context, WorkspaceMemberDetail member) {
    final isCurrentUser =
        widget.memberService.isCurrentUser(member, widget.currentUserEmail);
    final canModify = !isCurrentUser;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          MemberAvatar(member: member, memberService: widget.memberService),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.userName,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isCurrentUser) _buildCurrentUserBadge(context),
                  ],
                ),
                if (member.email != null && member.email!.isNotEmpty)
                  Text(
                    member.email!,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                Text(
                  'Joined ${widget.memberService.formatJoinDate(member.joinedAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          RoleBadge(role: member.role, memberService: widget.memberService),
          if (canModify) ...[
            const SizedBox(width: 8),
            _buildActionMenu(context, member),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentUserBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'You',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context, WorkspaceMemberDetail member) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).iconTheme.color,
        size: 20,
      ),
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
      ),
      onSelected: (value) => _handleActionSelected(value, member),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'change_role',
          child: Row(
            children: [
              Icon(Icons.swap_horiz,
                  size: 18, color: Theme.of(context).iconTheme.color),
              const SizedBox(width: 8),
              Text(
                'Change Role',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'remove',
          child: Row(
            children: [
              Icon(Icons.person_remove,
                  size: 18, color: Colors.red.withValues(alpha: 0.8)),
              const SizedBox(width: 8),
              Text(
                'Remove Member',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleActionSelected(String action, WorkspaceMemberDetail member) {
    switch (action) {
      case 'change_role':
        widget.dialogService.showChangeRoleDialog(
            context, member, widget.memberCubit, widget.workspaceId);
        break;
      case 'remove':
        widget.dialogService.showRemoveDialog(
            context, member, widget.memberCubit, widget.workspaceId);
        break;
    }
  }

  Widget _buildAddMemberSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add Team Member', style: Theme.of(context).textTheme.bodyMedium),
        Text(
          'Invite collaborators to this workspace by email address',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        Button(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.09),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          text: 'Invite Members',
          onTap: () {
            widget.dialogService.showInviteDialog(
                context, widget.memberCubit, widget.workspaceId);
          },
        ),
      ],
    );
  }

  Widget _buildLeaveWorkspace(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Leave Workspace', style: Theme.of(context).textTheme.bodyMedium),
        Text(
          'If you are the last owner of this workspace, make sure to assign another owner before leaving.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        Button(
          text: 'Leave',
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.09),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () {
            widget.dialogService.showLeaveConfirmationDialog(
                context, widget.memberCubit, widget.workspaceId);
          },
        ),
      ],
    );
  }

  // State builders
  Widget _buildLoadingState() => const Center(
        child: SizedBox(
          height: 40,
          child: Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );

  Widget _buildErrorState(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BannerManager>().show(message);
    });

    if (_lastKnownMembers.isNotEmpty) {
      return _buildMemberListView(context, _lastKnownMembers);
    }
    return const SizedBox.shrink();
  }

  Widget _buildInitialState(BuildContext context) => Text(
        'No members found',
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      );
}
