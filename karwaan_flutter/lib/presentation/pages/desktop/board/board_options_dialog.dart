import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/board/board_member_dialog_service.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/domain/models/board/board_state.dart';
import 'package:karwaan_flutter/domain/models/board/board_wrapper.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/board_label_section.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/board_member_section.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/board_settings_section.dart';

class BoardOptionsDialog extends StatefulWidget {
  final BoardWrapper board;
  final BoardCubit boardCubit;
  final BoardMemberCubit boardMemberCubit;
  final LabelCubit labelCubit;
  final int workspaceId;
  const BoardOptionsDialog(
      {super.key,
      required this.board,
      required this.boardCubit,
      required this.boardMemberCubit,
      required this.workspaceId,
      required this.labelCubit});

  @override
  State<BoardOptionsDialog> createState() => _BoardOptionsDialogState();
}

class _BoardOptionsDialogState extends State<BoardOptionsDialog> {
  String? _currentUserEmail;

  @override
  void initState() {
    super.initState();
    _getCurrentUserEmail();
    widget.boardMemberCubit.getBoardMembers(widget.board.id);
    widget.labelCubit.getLabelsForBoard(widget.board.id);
  }

  @override
  void dispose() {
    // refresh borad list when something changed...
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
        value: widget.boardMemberCubit,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.55,
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.board.name,
                        style: Theme.of(context).textTheme.bodyLarge),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 20))
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                    child: BlocListener<BoardCubit, BoardState>(
                  bloc: widget.boardCubit,
                  listener: (context, state) {
                    if (state is BoardError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.read<BannerManager>().show(state.error);
                      });
                    }
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // board setting sections
                        BoardSettingsSection(
                            board: widget.board,
                            boardCubit: widget.boardCubit,
                            memberCubit: widget.boardMemberCubit,
                            worksapceId: widget.workspaceId),

                        const SizedBox(height: 10),

                        // board member section
                        if (_currentUserEmail != null)
                          BoardMemberSection(
                              boardId: widget.board.id,
                              memberCubit: widget.boardMemberCubit,
                              dialogService: BoardMemberDialogServiceImpl(),
                              memberService: MemberService(),
                              currentUserEmail: _currentUserEmail!),

                        const SizedBox(height: 10),

                        // board label
                        BoardLabelSection(
                            boardId: widget.board.id,
                            labelCubit: widget.labelCubit)
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
