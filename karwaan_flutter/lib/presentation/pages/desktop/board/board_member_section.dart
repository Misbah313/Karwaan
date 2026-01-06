import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/board/board_member_dialog_service.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_state.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/board_member_avatar.dart';
import 'package:karwaan_flutter/presentation/widgets/member/member_role_badget.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/button.dart';

class BoardMemberSection extends StatefulWidget {
  final int boardId;
  final BoardMemberCubit memberCubit;
  final BoardMemberDialogService dialogService;
  final MemberService memberService;
  final String currentUserEmail;
  const BoardMemberSection(
      {super.key,
      required this.boardId,
      required this.memberCubit,
      required this.dialogService,
      required this.memberService,
      required this.currentUserEmail});

  @override
  State<BoardMemberSection> createState() => _BoardMemberSectionState();
}

class _BoardMemberSectionState extends State<BoardMemberSection> {
  bool _showAllMembers = false;
  final int _maxVisibleMembers = 5;
  List<BoardMemberDetails> _lastKnownMembers = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Board Members'),
          const SizedBox(height: 10),
          _buildMemberList(context),
          const SizedBox(height: 16),
          _buildAddMemberSection(context)
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.bodyLarge);
  }

  Widget _buildMemberList(BuildContext context) {
    return BlocBuilder<BoardMemberCubit, BoardMemberState>(
      bloc: widget.memberCubit,
      buildWhen: (previous, current) => _shouldRebuild(previous, current),
      builder: (context, state) {
        return _buildMemberListContent(context, state);
      },
    );
  }

  bool _shouldRebuild(BoardMemberState previous, BoardMemberState current) {
    if (previous is BoardMemberLoaded && current is BoardMemberLoaded) {
      return _hasMembersChanged(previous.members, current.members);
    }
    return current is BoardMemberLoaded ||
        current is BoardMemberAddedSuccessfully || 
        current is BoardMemberRemovedSuccessfully || 
        current is BoardMemberRoleChangedSuccessfully || 
        current is BoardAddMemberSuccess ||
        current is BoardDeleteMemberSuccess ||
        current is BoardMemberRoleChanged ||
        current is BoardMemberLoading ||
        current is BoardMemberAdding ||
        current is BoardMemberRemoving ||
        current is BoardMemberRoleChanging || 
        current is BoardMemberError;
  }

  bool _hasMembersChanged(
      List<BoardMemberDetails> oldList, List<BoardMemberDetails> newList) {
    if (oldList.length != newList.length) return true;

    for (int i = 0; i < oldList.length; i++) {
      final oldMember = oldList[i];
      final newMember = newList[i];

      if (oldMember.userId != newMember.userId ||
          oldMember.userRole != newMember.userRole ||
          oldMember.userName != newMember.userName ||
          oldMember.userEmail != newMember.userEmail) {
        return true;
      }
    }
    return false;
  }

  Widget _buildMemberListContent(
    BuildContext context,
    BoardMemberState state,
  ) {
    if (state is BoardMemberLoading || state is BoardMemberRoleChanging) {
      return _buildLoadingState();
    } else if (state is BoardMemberLoaded) {
      _lastKnownMembers = state.members;
      return _buildMemberListView(context, state.members);
    } else if (state is BoardMemberAddedSuccessfully) {
      _lastKnownMembers = state.updatedMembers;
      return _buildMemberListView(context, state.updatedMembers);
    } else if (state is BoardMemberRemovedSuccessfully) {
      _lastKnownMembers = state.updatedMembers;
      return _buildMemberListView(context, state.updatedMembers);
    } else if (state is BoardMemberRoleChangedSuccessfully) {
      _lastKnownMembers = state.updatedMembers;
      return _buildMemberListView(context, state.updatedMembers);
    } else if (state is BoardAddMemberSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.memberCubit.getBoardMembers(widget.boardId);
      });
      return _buildLoadingState();
    } else if (state is BoardDeleteMemberSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.memberCubit.getBoardMembers(widget.boardId);
      });
      return _buildLoadingState();
    } else if (state is BoardMemberRoleChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.memberCubit.getBoardMembers(widget.boardId);
      });
      return _buildLoadingState();
    } else if (state is BoardMemberError) {
      return _buildErrorState(context, state.error);
    } else {
      return _buildInitialState(context);
    }
  }

  Widget _buildMemberListView(
    BuildContext context,
    List<BoardMemberDetails> members,
  ) {
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
                style: Theme.of(context).textTheme.bodyMedium),
            if (hasMoreMembers)
              TextButton(
                  onPressed: () {
                    setState(() {
                      _showAllMembers = !_showAllMembers;
                    });
                  },
                  child: Text(_showAllMembers ? 'Show Less' : 'Show All',
                      style: Theme.of(context).textTheme.bodyMedium))
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
          )
      ],
    );
  }

  Widget _buildMemberItem(BuildContext context, BoardMemberDetails member) {
    final isCurrentUser = member.userEmail == widget.currentUserEmail;
    final canModify = !isCurrentUser;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
      child: Row(
        children: [
          BoardMemberAvatar(
              member: member, memberService: widget.memberService),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(member.userName,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis),
                  if (isCurrentUser) _buildCurrentUserBadge(context)
                ],
              ),
              Text(
                  'Joined ${widget.memberService.formatJoinDate(member.joinedAt)}',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          )),
          RoleBadge(role: member.userRole, memberService: widget.memberService),
          if (canModify) ...[
            const SizedBox(width: 8),
            _buildActionMenu(context, member)
          ]
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
        child: Text('You', style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context, BoardMemberDetails member) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert,
          color: Theme.of(context).iconTheme.color, size: 20),
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
      onSelected: (value) => _handleActionSelected(value, member),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
            value: 'change_role',
            child: Row(
              children: [
                Icon(Icons.swap_horiz,
                    size: 18, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 8),
                Text('Change Role',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            )),
        PopupMenuItem(
            value: 'remove',
            child: Row(
              children: [
                Icon(Icons.person_remove,
                    size: 18, color: Colors.red.withValues(alpha: 0.8)),
                const SizedBox(width: 8),
                Text(
                  'Remove Member',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.red),
                )
              ],
            ))
      ],
    );
  }

  void _handleActionSelected(String action, BoardMemberDetails member) {
    switch (action) {
      case 'change_role':
        widget.dialogService.showChangeRoleDialog(
            context, member, widget.memberCubit, widget.boardId);
        break;
      case 'remove':
        widget.dialogService.showRemoveDialog(
            context, member, widget.memberCubit, widget.boardId);
        break;
    }
  }

  Widget _buildAddMemberSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add Board Member', style: Theme.of(context).textTheme.bodyMedium),
        Text('Invite collaborators to this board by email address',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 10),
        Button(
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.09)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          text: 'Invite Members',
          onTap: () {
            widget.dialogService
                .showInviteDialog(context, widget.memberCubit, widget.boardId);
          },
        )
      ],
    );
  }

  Widget _buildLoadingState() => const Center(
        child: SizedBox(
            height: 40,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
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

  Widget _buildInitialState(BuildContext context) => Text('No members found',
      style: Theme.of(context).textTheme.bodySmall,
      textAlign: TextAlign.center);
}
