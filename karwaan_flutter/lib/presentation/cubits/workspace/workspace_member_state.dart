import 'package:karwaan_flutter/domain/models/workspace/workspace_member_details.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_model.dart';

abstract class WorkspaceMemberState {}

class MemberIntialState extends WorkspaceMemberState {}

class MemberLoadingState extends WorkspaceMemberState {}

class MemberLoadedState extends WorkspaceMemberState {
  final List<WorkspaceMemberDetail> members;
  MemberLoadedState(this.members);
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

class LastOwnerError extends WorkspaceMemberState {
  final String error;
  final bool isLastOwner;
  LastOwnerError(this.error, this.isLastOwner);
}

class MemberRoleChanging extends WorkspaceMemberState {
  final int targetUserId;
   MemberRoleChanging(this.targetUserId);
}

class MemberRoleChanged extends WorkspaceMemberState {
  final int targetUserId;
  final String newRole;
   MemberRoleChanged({
    required this.targetUserId,
    required this.newRole,
  });
}

class MemberRoleChangeError extends MemberErrorState {
  final int targetUserId;
   MemberRoleChangeError(super.error, this.targetUserId);
}
