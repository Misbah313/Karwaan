import 'package:karwaan_flutter/domain/models/workspace/workspace_member_model.dart';

abstract class WorkspaceMemberState {}

class MemberIntialState extends WorkspaceMemberState {}

class MemberLoadingState extends WorkspaceMemberState {}

class MemberLoadedState extends WorkspaceMemberState {
  final WorkspaceMemberModel workspaceMember;

  MemberLoadedState(this.workspaceMember);
}

class MemberSuccessState extends WorkspaceMemberState {
  final int userAddedId;
  final int workspaceId;

  MemberSuccessState(this.userAddedId, this.workspaceId);
}

class MemberDeletionSuccess extends WorkspaceMemberState {
  final int userId;

  MemberDeletionSuccess(this.userId);
}

class MemberNotLoaded extends WorkspaceMemberState {}

class MemberErroState extends WorkspaceMemberState {
  final String error;

  MemberErroState(this.error);
}

class MemberLeavedSuccessfully extends WorkspaceMemberState {
  final int workspaceId;

  MemberLeavedSuccessfully(this.workspaceId);
}
