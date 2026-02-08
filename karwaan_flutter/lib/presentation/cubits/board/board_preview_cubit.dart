/*
    This is the preview of which board the user is looking at on the boards page...
*/


import 'package:flutter_bloc/flutter_bloc.dart';

class BoardPreviewCubit extends Cubit<int?> {
  BoardPreviewCubit() : super(null);

  void selectBoard(int boardId) => emit(boardId);
  void clear() => emit(null);
}
