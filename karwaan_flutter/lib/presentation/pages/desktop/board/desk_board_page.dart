// DeskBoardPage operates in two explicit modes:
// - BoardPageMode.workspaceScoped: boards limited to a workspace
// - BoardPageMode.global: all boards user is a member of
//
// Mode semantics intentionally mirror previous workspaceId == null behavior.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/board/board_options_service.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/domain/models/board/board_state.dart';
import 'package:karwaan_flutter/domain/models/board/board_wrapper.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_preview_analytics_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_preview_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_context_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/board_page_mode.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/create_desk_board_dialog.dart';

class DeskBoardPage extends StatefulWidget {
  const DeskBoardPage({super.key});
  @override
  State<DeskBoardPage> createState() => _DeskBoardPageState();
}

class _DeskBoardPageState extends State<DeskBoardPage> {
  List<BoardWrapper> _cachedBoards = [];
  int? cachedWorkspaceId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workspace = context.read<WorkspaceContextCubit>().state;
      _fetchForWorkspace(workspace.workspaceId);
    });
  }

  void _fetchForWorkspace(int? workspaceId) {
    final boardCubit = context.read<BoardCubit>();
    setState(() {
      _cachedBoards = [];
      cachedWorkspaceId = null;
    });

    if (workspaceId != null) {
      boardCubit.getBoardsByWorkspace(workspaceId);
    } else {
      boardCubit.getUserBoards();
    }
  }

  void _onWorkspaceChanged(BuildContext context, WorkspaceContextState state) {
    _fetchForWorkspace(state.workspaceId);
    context.read<BoardPreviewCubit>().clear();
  }

  void _onBoardStateChanged(BuildContext context, BoardState state) {
    final banner = context.read<BannerManager>();
    if (state is BoardError) {
      banner.show(state.error, backgroundColor: Colors.red);
      return;
    }
    if (state is CreatedSuccessfully) {
      banner.show('Board "${state.boardName}" created successfully!',
          backgroundColor: Colors.green);
    }
    if (state is BoardUpdated) {
      banner.show('Board updated successfully!', backgroundColor: Colors.green);
      return;
    }
    if (state is DeletedSuccessfully) {
      banner.show('Board deleted successfully!', backgroundColor: Colors.green);
      return;
    }

    final workspaceId = context.read<WorkspaceContextCubit>().state.workspaceId;
    if (state is BoardlistLoaded && workspaceId == null) {
      setState(() {
        cachedWorkspaceId = null;
        _cachedBoards = state.boards.map((b) => BoardWrapper(b)).toList();
      });
    } else if (state is BoardsFromWorkspaceLoaded) {
      final returnedWorkspaceId = state.boards.firstOrNull?.workspaceId;
      if (returnedWorkspaceId == workspaceId) {
        setState(() {
          cachedWorkspaceId = returnedWorkspaceId;
          _cachedBoards = state.boards.map((b) => BoardWrapper(b)).toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<WorkspaceContextCubit, WorkspaceContextState>(
          listener: _onWorkspaceChanged,
        ),
        BlocListener<BoardCubit, BoardState>(listener: _onBoardStateChanged),
        BlocListener<BoardPreviewCubit, int?>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, boardId) {
            final analyticsCubit = context.read<BoardPreviewAnalyticsCubit>();

            if (boardId == null) {
              analyticsCubit.clear();
            } else {
              analyticsCubit.loadForBoard(boardId);
            }
          },
        )
      ],
      child: BlocBuilder<WorkspaceContextCubit, WorkspaceContextState>(
        builder: (context, workspace) {
          final hasSpecificWorkspace = workspace.workspaceId != null;
          final mode = workspace.workspaceId != null
              ? BoardPageMode.workspaceScoped
              : BoardPageMode.global;
          return Column(
            children: [
              _buildHeader(workspace, hasSpecificWorkspace, mode),
              _buildDivider(context),
              Expanded(
                child: BlocBuilder<BoardCubit, BoardState>(
                  buildWhen: (_, current) =>
                      current is BoardLoading ||
                      current is BoardError ||
                      current is BoardlistLoaded ||
                      current is BoardsFromWorkspaceLoaded,
                  builder: (context, state) {
                    // ALWAYS show cached boards if available (even on error)
                    if (_cachedBoards.isNotEmpty) {
                      return _buildBoardsList(_cachedBoards,
                          workspaceId: workspace.workspaceId, mode: mode);
                    }

                    // Only show loading/empty states when NO cached data
                    if (state is BoardLoading) {
                      return _buildLoadingState();
                    }

                    if (state is BoardError) {
                      // Error already shown in banner by listener
                      return _buildEmptyState(workspace.workspaceId, mode);
                    }

                    if (state is BoardsFromWorkspaceLoaded &&
                        workspace.workspaceId ==
                            state.boards.firstOrNull?.workspaceId) {
                      final wrapped =
                          state.boards.map((b) => BoardWrapper(b)).toList();
                      return _buildBoardsList(wrapped,
                          workspaceId: workspace.workspaceId, mode: mode);
                    }

                    if (state is BoardlistLoaded &&
                        workspace.workspaceId == null) {
                      final wrapped =
                          state.boards.map((b) => BoardWrapper(b)).toList();
                      return _buildBoardsList(wrapped, mode: mode);
                    }

                    // Default empty state
                    return _buildEmptyState(workspace.workspaceId, mode);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- UI helpers ---
  Widget _buildHeader(WorkspaceContextState workspaceState,
          bool hasSpecificWorkspace, BoardPageMode mode) =>
      Container(
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.4))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      mode == BoardPageMode.workspaceScoped
                          ? workspaceState.workspaceName!
                          : 'All Boards',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  Text(
                      mode == BoardPageMode.workspaceScoped
                          ? workspaceState.workspaceDescription!
                          : 'Boards you are member/a member to its parent workspace.',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            SizedBox(width: 20),
            _buildCreateBoardButton(mode == BoardPageMode.workspaceScoped
                ? workspaceState.workspaceId
                : null),
          ],
        ),
      );

  Widget _buildCreateBoardButton(int? workspaceId) {
    if (workspaceId == null) return const SizedBox.shrink();
    return ElevatedButton.icon(
      onPressed: () => _showCreateBoardDialog(workspaceId),
      icon: Icon(
        Icons.add,
        size: 18,
        color: Theme.of(context).iconTheme.color,
      ),
      label: Text('New Board', style: Theme.of(context).textTheme.bodySmall),
      style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
          side: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget _buildBoardsList(List<BoardWrapper> boards,
      {int? workspaceId, required BoardPageMode mode}) {
    final selectedBoardId = context.watch<BoardPreviewCubit>().state;
    if (boards.isEmpty) return _buildEmptyState(workspaceId, mode);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: boards.length,
      itemBuilder: (context, i) {
        final board = boards[i];
        final isSelected = board.id == selectedBoardId;
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                  color: isSelected
                      ? Colors.blue.shade500.withValues(alpha: 0.4)
                      : Colors.transparent)),
          elevation: 0,
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.04),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.dashboard,
                  color: Theme.of(context).iconTheme.color),
            ),
            title:
                Text(board.name, style: Theme.of(context).textTheme.bodyMedium),
            subtitle: Text(
              board.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: IconButton(
              icon: Icon(Icons.more_vert,
                  color: Theme.of(context).iconTheme.color),
              onPressed: () => _showBoardOptions(board, workspaceId),
            ),
            onTap: () => _navigateToBoard(board),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() =>
      const Center(child: CircularProgressIndicator());

  Widget _buildEmptyState(int? workspaceId, BoardPageMode mode) => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.dashboard_outlined,
              size: 64, color: Theme.of(context).iconTheme.color),
          const SizedBox(height: 16),
          Text(
              mode == BoardPageMode.workspaceScoped
                  ? 'No boards in this workspace'
                  : 'No boards found',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text(
            mode == BoardPageMode.workspaceScoped
                ? 'Create your first board to get started'
                : 'No boards found. Enter a workspace to create boards.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (mode == BoardPageMode.workspaceScoped)
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.03),
                    side: BorderSide(
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () => _showCreateBoardDialog(workspaceId!),
                child: Text(
                  'Create Board',
                  style: Theme.of(context).textTheme.bodySmall,
                )),
        ]),
      );

  Widget _buildDivider(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Divider(
            thickness: 1,
            color: Theme.of(context).dividerColor.withValues(alpha: .3)),
      );

  // --- Methods ---
  void _showCreateBoardDialog(int workspaceId) {
    final boardCubit = context.read<BoardCubit>();
    final bannerManager = context.read<BannerManager>();
    showDialog(
      context: context,
      builder: (context) => CreateBoardDialog(
          workspaceId: workspaceId,
          boardCubit: boardCubit,
          bannerManager: bannerManager),
    );
  }

  void _showBoardOptions(BoardWrapper board, int? workspaceId) {
    final optionService = BoardOptionsServiceImpl(
      boardCubit: context.read<BoardCubit>(),
      boardMemberCubit: context.read<BoardMemberCubit>(),
      labelCubit: context.read<LabelCubit>(),
      workspaceId: workspaceId!,
    );

    optionService.showOptionsDialog(context: context, board: board);
  }

  void _navigateToBoard(dynamic board) {
    context.read<BannerManager>().show('Double Click To Navigate.',
        backgroundColor: Theme.of(context).colorScheme.primary);
    context.read<BoardPreviewCubit>().selectBoard(board.id);
  }
}
