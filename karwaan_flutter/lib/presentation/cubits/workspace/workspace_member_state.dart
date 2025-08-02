import 'package:karwaan_flutter/domain/models/workspace/workspace_member_model.dart';

abstract class WorkspaceMemberState {}

class MemberIntialState extends WorkspaceMemberState {}

class MemberLoadingState extends WorkspaceMemberState {}

class MemberLoadedState extends WorkspaceMemberState {
  final WorkspaceMemberModel workspaceMember;

  MemberLoadedState(this.workspaceMember);
}

class AddMemberSuccess extends WorkspaceMemberState {
  final WorkspaceMemberModel member;

  AddMemberSuccess(this.member);
}

class MemberDeletionSuccess extends WorkspaceMemberState {
  final int userId;

  MemberDeletionSuccess(this.userId);
}

class MemberNotLoaded extends WorkspaceMemberState {}

class MemberErrorState extends WorkspaceMemberState {
  final String error;

  MemberErrorState(this.error);
}

class MemberLeavedSuccessfully extends WorkspaceMemberState {
  final int workspaceId;

  MemberLeavedSuccessfully(this.workspaceId);
}
