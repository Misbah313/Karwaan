import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/domain/models/board/board_credentials.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_state.dart';
import 'package:karwaan_flutter/domain/models/board/board_wrapper.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/editable_field_withsave.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/button.dart';

class BoardSettingsSection extends StatelessWidget {
  final BoardWrapper board;
  final BoardCubit boardCubit;
  final BoardMemberCubit memberCubit;
  final String? currentUserEmail;
  final int worksapceId;
  const BoardSettingsSection(
      {super.key,
      required this.board,
      required this.boardCubit,
      required this.memberCubit,
      required this.worksapceId,
      this.currentUserEmail});

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
          _buildSectionTitle(context, 'Board Settings'),
          const SizedBox(height: 10),
          _buildEditableName(context, worksapceId),
          const SizedBox(height: 12),
          _buildEditableDescription(context, worksapceId),
          const SizedBox(height: 24),
          Column(
            children: [
              _buildDeleteButton(context),
              const SizedBox(height: 12),
              _buildLeaveButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.w200, fontSize: 22),
    );
  }

  Widget _buildEditableName(BuildContext context, int workspaceId) {
    return EditableFieldWithSave(
      initialValue: board.name,
      label: 'Board Name',
      onSave: (newName) {
        final credentails = BoardCredentials(
            id: board.id,
            boardName: newName,
            boardDescription: board.description);
        boardCubit.updateBoardOptimized(credentails, workspaceId);
      },
    );
  }

  Widget _buildEditableDescription(BuildContext context, int worksapceId) {
    return EditableFieldWithSave(
      initialValue: board.description,
      label: 'Board Description',
      maxLines: 3,
      onSave: (newDes) {
        final credentails = BoardCredentials(
            id: board.id, boardName: board.name, boardDescription: newDes);
        boardCubit.updateBoardOptimized(credentails, worksapceId);
      },
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Button(
      text: 'Delete Board',
      gradient: LinearGradient(colors: [
        Colors.red.withValues(alpha: 0.5),
        Colors.red.shade200.withValues(alpha: 0.1),
      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      onTap: () => _showDeleteBoardDialog(context, board.id),
    );
  }

  Widget _buildLeaveButton(BuildContext context) {
    return Button(
      text: 'Leave Board',
      gradient: LinearGradient(colors: [
        Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.09),
      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      onTap: () => _showLeaveBoardDialog(context, board.id),
    );
  }

  void _showDeleteBoardDialog(BuildContext context, int boardId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        insetPadding: const EdgeInsets.all(30),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2))),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Delete Board',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text(
                            'Are you sure want to delete this board? This action cannot be undone!',
                            style: Theme.of(context).textTheme.bodySmall)
                      ],
                    ))
                  ],
                ),

                // actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel',
                            style: Theme.of(context).textTheme.titleSmall)),
                    const SizedBox(width: 6),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary),
                        onPressed: () {
                          boardCubit.deleteBoardOptimized(boardId, worksapceId);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Delete',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.red),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLeaveBoardDialog(BuildContext context, int boardId) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: memberCubit,
        child: Dialog(
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          insetPadding: const EdgeInsets.all(30),
          child: BlocListener<BoardMemberCubit, BoardMemberState>(
            listener: (context, state) {
              if (state is BoardMemberLeavedSuccessfully) {
                Navigator.pop(context);
                Navigator.pop(context);
                context.read<BannerManager>().show('Left board successfully');
              }

              if (state is BoardMemberError) {
                Navigator.pop(context);
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
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Leave Board',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center),
                            const SizedBox(height: 8),
                            Text(
                              'Are you sure want to leave this board? You can rejoin if invited again.',
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        ))
                      ],
                    ),

                    // actions
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                ),
                                onPressed: state is BoardMemberLoading
                                    ? null
                                    : () {
                                        context
                                            .read<BoardMemberCubit>()
                                            .leaveBoard(boardId);
                                      },
                                child: state is BoardMemberLoading
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        'Leave',
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
}
