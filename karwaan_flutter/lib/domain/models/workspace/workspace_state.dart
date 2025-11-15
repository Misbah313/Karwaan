import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';

abstract class WorkspaceState {}

class WorkspaceInitial extends WorkspaceState {}

class WorkspaceLoading extends WorkspaceState {}

class WorkspaceListLoaded extends WorkspaceState {
  final List<Workspace> workspaces;

  WorkspaceListLoaded(this.workspaces);
}

class WorkspaceCreated extends WorkspaceState {
  final String workspaceName;

  WorkspaceCreated(this.workspaceName);
}
class WorkspaceError extends WorkspaceState {
  final String error;
  WorkspaceError(this.error);
}
