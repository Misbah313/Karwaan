import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/board/board_member_dialog_service.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/domain/models/board/board_wrapper.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/pinn_board_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board_list/desk_boardlist.dart';

class DeskBoardlistHeader extends StatefulWidget {
  final BoardWrapper board;
  final BoardMemberDialogService dialogService;
  final BoardMemberCubit memberCubit;
  final LabelCubit labelCubit;
  final Function(RightPanelMode) onPanelChanged;
  final RightPanelMode currentPanelMode;
  const DeskBoardlistHeader(
      {super.key,
      required this.board,
      required this.dialogService,
      required this.memberCubit,
      required this.labelCubit,
      required this.onPanelChanged,
      required this.currentPanelMode});

  @override
  State<DeskBoardlistHeader> createState() => _DeskBoardlistHeaderState();
}

class _DeskBoardlistHeaderState extends State<DeskBoardlistHeader> {
  bool _isPinned = false;
  String? currentUserEmail;

  @override
  void initState() {
    _getCurrentUserEmail();
    widget.labelCubit.getLabelsForBoard(widget.board.id);
    widget.memberCubit.getBoardMembers(widget.board.id);
    _checkPinStatus();
    super.initState();
  }

  Future<void> _checkPinStatus() async {
    final isPinned =
        await context.read<PinnedBoardCubit>().isBoardPinned(widget.board.id);
    setState(() {
      _isPinned = isPinned;
    });
  }

  void _togglePin() async {
    final cubit = context.read<PinnedBoardCubit>();

    setState(() {
      _isPinned = !_isPinned;
    });

    try {
      if (_isPinned) {
        await cubit.pinBoard(widget.board.id);
        context.read<BannerManager>().show(
              'Board pinned to favorites',
              backgroundColor: Colors.green,
            );
      } else {
        await cubit.unpinBoard(widget.board.id);
        context.read<BannerManager>().show(
              'Board unpinned',
              backgroundColor: Colors.orange,
            );
      }
    } catch (e) {
      // Revert UI on error
      setState(() {
        _isPinned = !_isPinned;
      });
      context.read<BannerManager>().show(
            'Failed to update pin status',
            backgroundColor: Colors.red,
          );
    }
  }

  void _getCurrentUserEmail() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      setState(() {
        currentUserEmail = authState.user.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          // LEFT SIDE - Board name
          Text(
            widget.board.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          Spacer(),

          // RIGHT SIDE - All actions
          Row(
            children: [
              const SizedBox(width: 4),

              // chat
              IconButton(
                style: IconButton.styleFrom(
                    backgroundColor:
                        widget.currentPanelMode == RightPanelMode.chat
                            ? Colors.blue.withValues(alpha: 0.12)
                            : Theme.of(context).scaffoldBackgroundColor),
                onPressed: () => widget.onPanelChanged(RightPanelMode.chat),
                icon: Icon(Icons.message_outlined),
                tooltip: 'Chat',
                color: widget.currentPanelMode == RightPanelMode.chat
                    ? Colors.blue
                    : null,
              ),

              const SizedBox(width: 4),

              // Members
              IconButton(
                style: IconButton.styleFrom(
                    backgroundColor:
                        widget.currentPanelMode == RightPanelMode.members
                            ? Colors.blue.withValues(alpha: 0.12)
                            : Theme.of(context).scaffoldBackgroundColor),
                onPressed: () => widget.onPanelChanged(RightPanelMode.members),
                icon: Icon(Icons.group),
                tooltip: 'Show Members',
                color: widget.currentPanelMode == RightPanelMode.members
                    ? Colors.blue
                    : null,
              ),

              const SizedBox(width: 4),

              // Labels
              IconButton(
                style: IconButton.styleFrom(
                    backgroundColor:
                        widget.currentPanelMode == RightPanelMode.labels
                            ? Colors.blue.withValues(alpha: 0.12)
                            : Theme.of(context).scaffoldBackgroundColor),
                onPressed: () => widget.onPanelChanged(RightPanelMode.labels),
                icon: Icon(Icons.label_outline_sharp),
                tooltip: 'Show Labels',
                color: widget.currentPanelMode == RightPanelMode.labels
                    ? Colors.blue
                    : null,
              ),

              const SizedBox(width: 4),

              // Filter button
              IconButton(
                style: IconButton.styleFrom(
                    backgroundColor:
                        widget.currentPanelMode == RightPanelMode.filter
                            ? Colors.blue.withValues(alpha: 0.12)
                            : Theme.of(context).scaffoldBackgroundColor),
                onPressed: () => widget.onPanelChanged(RightPanelMode.filter),
                icon: Icon(Icons.filter_list),
                tooltip: 'Filter',
                color: widget.currentPanelMode == RightPanelMode.filter
                    ? Colors.blue
                    : null,
              ),

              const SizedBox(width: 4),

              // Pin button
              IconButton(
                onPressed: _togglePin,
                icon: Icon(
                  _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: _isPinned ? Colors.blue : null,
                ),
                tooltip: _isPinned ? 'Unpin Board' : 'Pin Board',
              ),

              const SizedBox(width: 8),

              // Share button (disabled)
              TextButton(
                onPressed: null, // Disabled
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).dividerColor.withAlpha(100),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: Theme.of(context).disabledColor,
                ),
                child: Text(
                  'Share Board',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
