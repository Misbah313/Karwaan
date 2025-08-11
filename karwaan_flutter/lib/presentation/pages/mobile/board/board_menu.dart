import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/board/board_credentials.dart';
import 'package:karwaan_flutter/domain/models/board/board_details.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_state.dart';
import 'package:karwaan_flutter/domain/models/board/board_state.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/board/board_add_member_dialog.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/board/board_member_dialog.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';

class BoardMenu extends StatelessWidget {
  final BoardDetails board;
  const BoardMenu({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text('Update board'),
          leading: Icon(Icons.update),
          onTap: () {
            Navigator.pop(context);
            _showUpdateWorkspaceDialog(context, board.id);
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_outline, color: Colors.red),
          title: const Text('Delete board'),
          onTap: () {
            Navigator.pop(context);
            _showDeleteWorkspaceDialog(context, board.id);
          },
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: const Text('View member'),
          onTap: () {
            Navigator.pop(context);
            final cubit = context.read<BoardMemberCubit>();
            cubit.getBoardMembers(board.id);
            _showMemberDialog(context, cubit);
          },
        ),
        ListTile(
          leading: Icon(Icons.person_add_alt_1_rounded),
          title: const Text('Add member'),
          onTap: () {
            Navigator.pop(context);
            final cubit = context.read<BoardMemberCubit>();
            cubit.getBoardMembers(board.id);
            _showAddMemberDialog(context, board.id, cubit);
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app_sharp),
          title: const Text('Leave board'),
          onTap: () {
            Navigator.pop(context);
            _showLeaveConfirmationDialog(context, board.id);
          },
        ),
      ],
    );
  }

  void _showUpdateWorkspaceDialog(BuildContext context, int boardId) {
    final cubit = context.read<BoardCubit>();
    final newNameController = TextEditingController();
    final newDecController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => BlocProvider.value(
            value: cubit,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: Colors.grey.shade300,
              title: Text(
                'Update Board!',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Textfield(
                      text: 'New Name',
                      obsecureText: false,
                      controller: newNameController),
                  const SizedBox(height: 20),
                  Textfield(
                      text: 'New Descritpion',
                      obsecureText: false,
                      controller: newDecController),
                ],
              ),
              actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    )),
                BlocConsumer<BoardCubit, BoardState>(
                  listener: (context, state) {
                    if (state is BoardError) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.grey.shade300),
                        onPressed: state is BoardLoading
                            ? null
                            : () {
                                if (newNameController.text.isEmpty) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text('Boards name cannot be empty!!'),
                                    backgroundColor: Colors.red,
                                  ));
                                  return;
                                }
                                final credentials = BoardCredentials(
                                    id: boardId,
                                    boardName: newNameController.text.trim(),
                                    boardDescription:
                                        newDecController.text.trim());
                                context
                                    .read<BoardCubit>()
                                    .updateBoard(credentials);
                              },
                        child: state is BoardLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                'Update',
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w400),
                              ));
                  },
                )
              ],
            )));
  }

  void _showDeleteWorkspaceDialog(BuildContext context, int boardId) {
    final cubit = context.read<BoardCubit>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.grey.shade300,
          title: Text(
            'Delete Board?',
            style: GoogleFonts.poppins(
                color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure want to delete this board?',
            style: GoogleFonts.alef(color: Colors.grey.shade600, fontSize: 16),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                )),
            BlocConsumer<BoardCubit, BoardState>(
              listener: (context, state) {
                if (state is BoardsFromWorkspaceLoaded) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Board deleted successfully.'),
                    backgroundColor: Colors.green,
                  ));
                }
                if (state is BoardError) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.grey.shade300),
                    onPressed: state is BoardLoading
                        ? null
                        : () {
                            context.read<BoardCubit>().deleteBoard(boardId);
                          },
                    child: state is BoardLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ));
              },
            )
          ],
        ),
      ),
    );
  }

  void _showAddMemberDialog(
      BuildContext context, int boardId, BoardMemberCubit cubit) {
    showDialog(
        context: context,
        builder: (context) => BlocProvider.value(
              value: cubit,
              child: BoardAddMemberDialog(boardId: boardId),
            ));
  }

  void _showMemberDialog(BuildContext context, BoardMemberCubit cubit) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: BoardMemberDialog(boardId: board.id),
      ),
    ).then((_) {
      cubit.getBoardMembers(board.id);
    });
  }

  void _showLeaveConfirmationDialog(BuildContext context, int boardId) {
    final cubit = context.read<BoardMemberCubit>();

    showDialog(
        context: context,
        builder: (context) => BlocProvider.value(
              value: cubit,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.grey.shade300,
                title: Text(
                  'Leave board?',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Are you sure you want to leave this board?',
                  style: GoogleFonts.alef(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  BlocConsumer<BoardMemberCubit, BoardMemberState>(
                    listener: (context, state) {
                      if (state is BoardMemberLeavedSuccessfully) {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(
                            context); // Close workspace menu if still open
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Left board successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                      if (state is BoardLastOwner) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.grey.shade300),
                        onPressed: state is BoardMemberLoading
                            ? null
                            : () {
                                context
                                    .read<BoardMemberCubit>()
                                    .leaveBoard(boardId);
                              },
                        child: state is BoardMemberLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Leave',
                                style: TextStyle(color: Colors.red),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ));
  }
}
