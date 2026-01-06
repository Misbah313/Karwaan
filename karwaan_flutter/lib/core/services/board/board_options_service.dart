import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/board/board_wrapper.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/board_options_dialog.dart';

abstract class BoardOptionsService {
  void showOptionsDialog({
    required BuildContext context,
    required BoardWrapper board,
  }); 
}

class BoardOptionsServiceImpl implements BoardOptionsService {
  final BoardCubit boardCubit;
  final BoardMemberCubit boardMemberCubit;
  final LabelCubit labelCubit;
  final int workspaceId;

  BoardOptionsServiceImpl({
    required this.boardCubit,
    required this.boardMemberCubit,
    required this.labelCubit,
    required this.workspaceId
  });

@override
  void showOptionsDialog({
    required BuildContext context,
    required BoardWrapper board,
  }) {
    showDialog(context: context, builder: (context) => BoardOptionsDialog(
      board: board,
      boardCubit: boardCubit,
      boardMemberCubit: boardMemberCubit,
      labelCubit: labelCubit,
      workspaceId: workspaceId,
    ));
  }
}