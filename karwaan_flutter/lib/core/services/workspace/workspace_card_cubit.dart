import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member_use_case.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_details.dart';

class WorkspaceCardCubit extends Cubit<WorkspaceCardState> {
  final GetWorkspaceMembersUseCase getMembersUseCase;
  final Workspace workspace;

  WorkspaceCardCubit({
    required this.getMembersUseCase,
    required this.workspace,
  }) : super(WorkspaceCardInitial());

  void loadMembers() async {
    emit(WorkspaceCardLoading());
    
    try {
      final members = await getMembersUseCase.execute(workspace.id);
      emit(WorkspaceCardLoaded(members));
    } catch (e) {
      emit(WorkspaceCardError(e.toString()));
    }
  }


  void showOptions() {
    emit(WorkspaceCardShowOptions(workspace));
  }
}

abstract class WorkspaceCardState {}

class WorkspaceCardInitial extends WorkspaceCardState {}

class WorkspaceCardLoading extends WorkspaceCardState {}

class WorkspaceCardLoaded extends WorkspaceCardState {
  final List<WorkspaceMemberDetail> members;
  WorkspaceCardLoaded(this.members);
}

class WorkspaceCardError extends WorkspaceCardState {
  final String message;
  WorkspaceCardError(this.message);
}

class WorkspaceCardShowOptions extends WorkspaceCardState {
  final Workspace workspace;
  WorkspaceCardShowOptions(this.workspace);
}