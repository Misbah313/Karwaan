import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';

abstract class WorkspaceState {}

class WorkspaceInitial extends WorkspaceState {}

class WorkspaceLoading extends WorkspaceState {}

class WorkspaceLoaded extends WorkspaceState {
  final Workspace workspace;
  WorkspaceLoaded(this.workspace);
}

class SuccessAction extends WorkspaceState {
  final String workspaceName;
  final String workspaceDec;

  SuccessAction(this.workspaceName, this.workspaceDec);
}

class DeletedSuccessfully extends WorkspaceState {
  final int workspaceId;

  DeletedSuccessfully(this.workspaceId);
}

class WorkspaceNotLoaded extends WorkspaceState {}

class WorkspaceError extends WorkspaceState {
  final String error;
  WorkspaceError(this.error);
}
