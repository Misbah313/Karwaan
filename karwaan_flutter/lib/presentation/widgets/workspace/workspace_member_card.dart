import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_dialog_service.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_details.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_state.dart';
import 'package:karwaan_flutter/presentation/widgets/member/member_avatar.dart';
import 'package:karwaan_flutter/presentation/widgets/workspace/member_chat_dialog.dart';
import 'package:karwaan_flutter/presentation/widgets/workspace/member_profile_dialog.dart';

class WorkspaceMemberCard extends StatefulWidget {
  final int workspaceId;
  final MemberService memberService;
  final MemberDialogService memberDialogService;
  final String currentUserEmail;
  const WorkspaceMemberCard(
      {super.key,
      required this.workspaceId,
      required this.memberService,
      required this.currentUserEmail,
      required this.memberDialogService});

  @override
  State<WorkspaceMemberCard> createState() => _WorkspaceMemberCardState();
}

class _WorkspaceMemberCardState extends State<WorkspaceMemberCard> {
  bool _showAllMembers = false;
  final int _maxvisibleMembers = 5;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withAlpha(13)
                : Colors.black.withAlpha(5),
            border: Border.all(
                color: Theme.of(context).dividerColor.withAlpha(102)),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<WorkspaceMemberCubit, WorkspaceMemberState>(
            builder: (context, state) {
              if (state is MemberLoadingState) {
                return _buildMembersLoading();
              }

              if (state is MemberAddedSuccess) {
                return _buildMembersListView(context, state.updatedMembers);
              }

              if (state is MemberErrorState) {
                return _buildMembersError(context, state.error);
              }

              if (state is MemberLoadedState) {
                return _buildMembersListView(context, state.members);
              }

              return _buildMembersEmpty(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMembersListView(
      BuildContext context, List<WorkspaceMemberDetail> members) {
    // filter out the current user
    final filteredMembers = members
        .where((member) =>
            member.userName.toLowerCase() !=
            widget.currentUserEmail.toLowerCase())
        .toList();

    // Check if there are no other members
    if (filteredMembers.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Workspace Members',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 20),
          Icon(
            Icons.group_outlined,
            size: 48,
            color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 5),
          Text(
            'You are the only member in this workspace',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 1),
          Text(
            'Add others to collaborate!',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () => widget.memberDialogService.showInviteDialog(context,
                context.read<WorkspaceMemberCubit>(), widget.workspaceId),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Add Members',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          )
        ],
      );
    }

    final displayedMembers = _showAllMembers
        ? filteredMembers
        : filteredMembers.take(_maxvisibleMembers).toList();
    final hasMoreMembers = filteredMembers.length > _maxvisibleMembers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${filteredMembers.length} ${filteredMembers.length == 1 ? 'Member' : 'Members'}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
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
                    style: Theme.of(context).textTheme.bodySmall,
                  ))
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
              '+${members.length - _maxvisibleMembers} more members',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
      ],
    );
  }

  Widget _buildMemberItem(BuildContext context, WorkspaceMemberDetail member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white.withAlpha(13),
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: Theme.of(context).dividerColor.withAlpha(51))),
      child: Row(
        children: [
          // avatar
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
                  ],
                ),
                Text(
                  'Joined ${widget.memberService.formatJoinDate(member.joinedAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          _buildMemberActionsMenu(context, member)
        ],
      ),
    );
  }

  Widget _buildMemberActionsMenu(
      BuildContext context, WorkspaceMemberDetail member) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).iconTheme.color,
        size: 20,
      ),
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withAlpha(102),
        ),
      ),
      onSelected: (value) => _handleActionSelected(context, value, member),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 18,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 8),
              Text(
                'View Profile',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'chat',
          child: Row(
            children: [
              Icon(
                Icons.chat_outlined,
                size: 18,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 8),
              Text(
                'Start Chat',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleActionSelected(
      BuildContext context, String action, WorkspaceMemberDetail member) {
    switch (action) {
      case 'profile':
        _showMemberProfileDialog(context, member);
        break;
      case 'chat':
        _showChatDialog(member);
        break;
    }
  }

  void _showMemberProfileDialog(
      BuildContext context, WorkspaceMemberDetail member) {
    showDialog(
        context: context,
        builder: (context) => MemberProfileDialog(member: member));
  }

  void _showChatDialog(WorkspaceMemberDetail member) {
    showDialog(
        context: context,
        builder: (context) => MemberChatDialog(member: member));
  }

  Widget _buildMembersLoading() {
    return Column(
      children: [
        Text(
          'Workspace Members',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  Widget _buildMembersError(BuildContext context, String error) {
    return Column(
      children: [
        Text(
          'Workspace Members',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'Failed to load members',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.red,
              ),
        ),
      ],
    );
  }

  Widget _buildMembersEmpty(BuildContext context) {
    return Column(
      children: [
        Text(
          'Workspace Members',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'No members found in this workspace',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
