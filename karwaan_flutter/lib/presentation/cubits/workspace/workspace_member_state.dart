import 'package:karwaan_flutter/domain/models/workspace/workspace_member_details.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_model.dart';

abstract class WorkspaceMemberState {
  const WorkspaceMemberState();
}

class MemberIntialState extends WorkspaceMemberState {}

class MemberLoadingState extends WorkspaceMemberState {}

class MemberLoadedState extends WorkspaceMemberState {
  final List<WorkspaceMemberDetail> members;
  const MemberLoadedState(this.members);
}

class MemberErrorState extends WorkspaceMemberState {
  final String error;
  const MemberErrorState(this.error);
}

// Mobile-specific states 
class MemberRoleChanging extends WorkspaceMemberState {
  final int targetUserId;
  const MemberRoleChanging(this.targetUserId);
}

class LastOwnerError extends WorkspaceMemberState {
  final String error;
  const LastOwnerError(this.error);
}

// Optimized update states
class MemberAddingState extends WorkspaceMemberState {
  final List<WorkspaceMemberDetail> currentMembers;
  const MemberAddingState(this.currentMembers);
}

class MemberRemovingState extends WorkspaceMemberState {
  final List<WorkspaceMemberDetail> currentMembers;
  final int userId;
  const MemberRemovingState(this.currentMembers, this.userId);
}

class MemberRoleChangingState extends WorkspaceMemberState {
  final List<WorkspaceMemberDetail> currentMembers;
  final int targetUserId;
  const MemberRoleChangingState(this.currentMembers, this.targetUserId);
}

// Success states for optimized updates
class MemberAddedSuccess extends WorkspaceMemberState {
  final List<WorkspaceMemberDetail> updatedMembers;
  const MemberAddedSuccess(this.updatedMembers);
}

class MemberRemovedSuccess extends WorkspaceMemberState {
  final List<WorkspaceMemberDetail> updatedMembers;
  const MemberRemovedSuccess(this.updatedMembers);
}

class MemberRoleChangedSuccess extends WorkspaceMemberState {
  final List<WorkspaceMemberDetail> updatedMembers;
  const MemberRoleChangedSuccess(this.updatedMembers);
}

class AddMemberSuccess extends WorkspaceMemberState {
  final WorkspaceMemberModel member;
  const AddMemberSuccess(this.member);
}

class MemberDeletionSuccess extends WorkspaceMemberState {
  final int userId;
  const MemberDeletionSuccess(this.userId);
}

class MemberLeavedSuccessfully extends WorkspaceMemberState {
  final int workspaceId;
  const MemberLeavedSuccessfully(this.workspaceId);
}

class MemberRoleChanged extends WorkspaceMemberState {
  final int targetUserId;
  final String newRole;
  const MemberRoleChanged({required this.targetUserId, required this.newRole});
}
