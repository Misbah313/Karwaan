import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_gate.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_state.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/workspace/workspace_menu.dart';
import 'package:karwaan_flutter/presentation/widgets/bubble_avatar_group.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/HexColor.dart';

class DeskWorkspaceCard extends StatefulWidget {
  final Workspace workspace;
  const DeskWorkspaceCard({super.key, required this.workspace});

  @override
  State<DeskWorkspaceCard> createState() => _DeskWorkspaceCardState();
}

class _DeskWorkspaceCardState extends State<DeskWorkspaceCard> {
  // Remove the BlocConsumer from _footer and create separate cubit
  late final WorkspaceMemberCubit _memberCubit;

  @override
  void initState() {
    super.initState();
    _memberCubit = WorkspaceMemberCubit(context.read<WorkspaceRepo>());
    _fetchWorkspaceMembers();
  }

  @override
  void dispose() {
    _memberCubit.close();
    super.dispose();
  }

  void _fetchWorkspaceMembers() {
    _memberCubit.getWorkspaceMembers(widget.workspace.id);
  }

  // header
  Widget _header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListTile(
              title: Text(widget.workspace.workspaceName,
                  style: Theme.of(context).textTheme.displayLarge),
              subtitle: Text(widget.workspace.workspaceDescription,
                  style: Theme.of(context).textTheme.displaySmall),
            ),
          ),
          IconButton(
              onPressed: () => _showWorkspaceMenu(context),
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).iconTheme.color,
              ))
        ],
      ),
    );
  }

  // SIMPLIFIED Footer without BlocConsumer
  Widget _footer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: [
            HexColor.fromHex(widget.workspace.backgroundColor).withValues(alpha: 210),
            HexColor.fromHex(widget.workspace.backgroundColor).withValues(alpha: 70),
          ]),
        ),
        child: BlocBuilder<WorkspaceMemberCubit, WorkspaceMemberState>(
          bloc: _memberCubit, // Use the local cubit instance
          builder: (context, state) {
            if (state is MemberLoadedState) {
              final members = state.members;
              final avatarUrls = members
                  .where((member) =>
                      member.avatarUrl != null && member.avatarUrl!.isNotEmpty)
                  .map((member) => member.avatarUrl!)
                  .toList();

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 120),
                    child: BubbleAvatarGroup(
                      imageURL: avatarUrls,
                      maxDisplay: 3,
                      avatarSize: 30,
                      overlapAmount: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      '${members.length} Members',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ],
              );
            } else if (state is MemberLoadingState) {
              return _memberLoadingState(context);
            } else {
              return _memberInitialState(context);
            }
          },
        ),
      ),
    );
  }

  // Rest of your code remains the same...
  Widget _memberLoadingState(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 28,
          child: Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        SizedBox(width: 12),
        Text(
          'Loading...',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ],
    );
  }

  Widget _memberInitialState(BuildContext context) {
    return Row(
      children: [
        BubbleAvatarGroup(
          imageURL: [],
          maxDisplay: 4,
          avatarSize: 28,
          overlapAmount: 18,
        ),
        SizedBox(width: 12),
        Text(
          'Members',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ],
    );
  }

  // Remove the listener from showWorkspaceMenu since we're using local cubit
  void _showWorkspaceMenu(BuildContext context) {
    showBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primary,
      context: context,
      builder: (bottomSheetContext) {
        return WorkspaceMenu(workspace: widget.workspace);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<BoardCubit>(
              create: (context) => BoardCubit(context.read<BoardRepo>()),
              child: BoardGate(
                boardRepo: context.read<BoardRepo>(),
                workspaceId: widget.workspace.id,
                workspaceName: widget.workspace.workspaceName,
                workspaceDescription: widget.workspace.workspaceDescription,
              ),
            ),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(minHeight: 200, maxHeight: 300),
        width: MediaQuery.of(context).size.width * 0.25,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            HexColor.fromHex(widget.workspace.backgroundColor)
                .withValues(alpha: 70),
            HexColor.fromHex(widget.workspace.backgroundColor)
                .withValues(alpha: 210),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: HexColor.fromHex(widget.workspace.backgroundColor)
                    .withValues(alpha: 0.2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            const Spacer(),
            _footer(context),
          ],
        ),
      ),
    );
  }
}
