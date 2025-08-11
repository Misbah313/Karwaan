import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_credentails.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_state.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';

class BoardAddMemberDialog extends StatelessWidget {
  final int boardId;
  const BoardAddMemberDialog({super.key, required this.boardId});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
     String? selectedRole = 'member';
    return BlocListener<BoardMemberCubit, BoardMemberState>(
      listener: (context, state) {
        if (state is BoardAddMemberSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Member has been add successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ));
          context.read<BoardMemberCubit>().getBoardMembers(boardId);
        }

        if (state is BoardMemberError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ));
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Add Member',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Textfield(
                  text: 'Member Email',
                  obsecureText: false,
                  controller: emailController),
              middleSizedBox,
              DropdownButtonFormField<String>(
                dropdownColor: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
                value: selectedRole,
                decoration: InputDecoration(
                    labelText: 'Role',
                    labelStyle: GoogleFonts.alef(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade600)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade800))),
                items: ['member', 'admin', 'moderator'].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(
                      role,
                      style: GoogleFonts.alef(
                          fontSize: 18, fontWeight: FontWeight.w200),
                    ),
                  );
                }).toList(),
                onChanged: (value) => selectedRole = value,
              )
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
          BlocBuilder<BoardMemberCubit, BoardMemberState>(
            builder: (context, state) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.grey.shade400),
                onPressed: state is BoardMemberLoading
                    ? null
                    : () async {
                        if (emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Email is required!'),
                                backgroundColor: Colors.red),
                          );
                          return;
                        }

                        if (!emailController.text.contains('@')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Enter a valid email!'),
                                backgroundColor: Colors.red),
                          );
                          return;
                        }

                        final credentials = BoardMemberCredentails(
                          userId: 0, // Will be ignored by backend (using email)
                          boardId: boardId,
                          userName: emailController.text.trim(),
                          userRole: selectedRole ?? 'member',
                        );
                        await context
                            .read<BoardMemberCubit>()
                            .addMemberToBoard(credentials);
                      },
                child: state is BoardMemberLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Add',
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 15),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
