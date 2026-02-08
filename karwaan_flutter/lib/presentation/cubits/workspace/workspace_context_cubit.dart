import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_preview_cubit.dart';

class WorkspaceContextCubit extends Cubit<WorkspaceContextState> {
  final BoardPreviewCubit previewCubit;
  WorkspaceContextCubit(this.previewCubit) : super(WorkspaceContextState());

  void setCurrentWorkspace(int id, String name, String description) {
    previewCubit.clear();
    emit(WorkspaceContextState(
      workspaceId: id,
      workspaceName: name,
      workspaceDescription: description,
    ));
  }

  void clearCurrentWorkspace() {
    emit(WorkspaceContextState());
  }
}

class WorkspaceContextState {
  final int? workspaceId;
  final String? workspaceName;
  final String? workspaceDescription;

  WorkspaceContextState({
    this.workspaceId,
    this.workspaceName,
    this.workspaceDescription,
  });
}