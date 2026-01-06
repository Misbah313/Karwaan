import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_card_cubit.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_navigation_service.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_option_service.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/presentation/widgets/bubble_avatar_group.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/HexColor.dart';

class DeskWorkspaceCard extends StatefulWidget {
  final Workspace workspace;
  final WorkspaceNavigationService navigationService;
  final WorkspaceOptionsService optionsService;

  const DeskWorkspaceCard({
    super.key,
    required this.workspace,
    required this.navigationService,
    required this.optionsService,
  });

  @override
  State<DeskWorkspaceCard> createState() => _DeskWorkspaceCardState();
}

class _DeskWorkspaceCardState extends State<DeskWorkspaceCard> {
  @override
  void initState() {
    super.initState();
    // Load members when card is created
    context.read<WorkspaceCardCubit>().loadMembers();
  }

  void _handleWorkspaceTap() {
    widget.navigationService
        .navigateToWorkspaceBoards(context, widget.workspace);
  }

  void _handleOptionsTap() {
    widget.optionsService.showOptionsDialog(
        context: context,
        workspace: widget.workspace,
        cardCubit: context.read<WorkspaceCardCubit>());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceCardCubit, WorkspaceCardState>(
      listener: (context, state) {
        if (state is WorkspaceCardShowOptions) {
          widget.optionsService.showOptionsDialog(
              context: context,
              workspace: state.workspace,
              cardCubit: context.read<WorkspaceCardCubit>());
        } else if (state is WorkspaceCardError) {
          context.read<BannerManager>().show(state.message);
        }
      },
      child: GestureDetector(
        onTap: _handleWorkspaceTap,
        child: Container(
          constraints: BoxConstraints(minHeight: 200, maxHeight: 300),
          width: MediaQuery.of(context).size.width * 0.25,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              HexColor.fromHex(widget.workspace.backgroundColor)
                  .withValues(alpha: 110),
              HexColor.fromHex(widget.workspace.backgroundColor)
                  .withValues(alpha: 210),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: HexColor.fromHex(widget.workspace.backgroundColor)
                    .withValues(alpha: 0.2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const Spacer(),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListTile(
              title: Text(
                widget.workspace.workspaceName,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              subtitle: Text(
                widget.workspace.workspaceDescription,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
          IconButton(
            onPressed: _handleOptionsTap,
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: [
            HexColor.fromHex(widget.workspace.backgroundColor)
                .withValues(alpha: 210),
            HexColor.fromHex(widget.workspace.backgroundColor)
                .withValues(alpha: 110),
          ]),
        ),
        child: BlocBuilder<WorkspaceCardCubit, WorkspaceCardState>(
          builder: (context, state) {
            return _buildMemberSection(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildMemberSection(BuildContext context, WorkspaceCardState state) {
    if (state is WorkspaceCardLoaded) {
      final avatarUrls = state.members
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
              '${state.members.length} Members',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ],
      );
    } else if (state is WorkspaceCardLoading) {
      return _buildMemberLoading(context);
    } else {
      return _buildMemberInitial(context);
    }
  }

  Widget _buildMemberLoading(BuildContext context) {
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

  Widget _buildMemberInitial(BuildContext context) {
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
}
