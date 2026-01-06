import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspaceContextCubit extends Cubit<WorkspaceContextState> {
  WorkspaceContextCubit() : super(WorkspaceContextState());

  void setCurrentWorkspace(int id, String name, String description) {
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