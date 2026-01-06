import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_change_role_member_model.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_details.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_state.dart';

class WorkspaceMemberCubit extends Cubit<WorkspaceMemberState> {
  final WorkspaceRepo workspaceRepo;

  WorkspaceMemberCubit(this.workspaceRepo) : super(MemberIntialState());

  // OPTIMIZED: Add member without reloading entire list (for Desktop)
  Future<void> addMemberOptimized(WorkspaceMemberCredential credential) async {
    try {
      // Show loading state with current members
      if (state is MemberLoadedState) {
        final currentState = state as MemberLoadedState;
        emit(MemberAddingState(currentState.members));
      }

       await workspaceRepo.addMemberToWorkspace(credential);

      // If we have current members, update the list optimistically
      if (state is MemberAddingState) {
         state as MemberAddingState;

        // Fetch the complete member details for the new member
        final updatedMembers =
            await workspaceRepo.getWorkspaceMembers(credential.workspaceId);
        emit(MemberAddedSuccess(updatedMembers));
      } else {
        // Fallback: reload all members
        await getWorkspaceMembers(credential.workspaceId);
      }
    } catch (e) {
      emit(MemberErrorState(ExceptionMapper.toMessage(e)));
    }
  }

  // OPTIMIZED: Remove member without reloading entire list (for Desktop)
  Future<void> removeMemberOptimized(
      WorkspaceMemberCredential credential) async {
    try {
      // Show loading state with current members
      if (state is MemberLoadedState) {
        final currentState = state as MemberLoadedState;
        emit(MemberRemovingState(currentState.members, credential.userId));
      }

      await workspaceRepo.removeMemberFromWorkspace(credential);

      // If we have current members, remove the member optimistically
      if (state is MemberRemovingState) {
        final currentState = state as MemberRemovingState;
        final updatedMembers = currentState.currentMembers
            .where((member) => member.userId != credential.userId)
            .toList();
        emit(MemberRemovedSuccess(updatedMembers));
      } else {
        // Fallback: reload all members
        await getWorkspaceMembers(credential.workspaceId);
      }
    } catch (e) {
      emit(MemberErrorState(ExceptionMapper.toMessage(e)));
    }
  }

  // OPTIMIZED: Change role without reloading entire list (for Desktop)
  Future<void> changeRoleOptimized(
      WorkspaceChangeRoleMemberModel update) async {
    try {
      // Show loading state with current members
      if (state is MemberLoadedState) {
        final currentState = state as MemberLoadedState;
        emit(
            MemberRoleChangingState(currentState.members, update.targetUserId));
      }

      await workspaceRepo.changeMemberRole(update);

      // If we have current members, update the role optimistically
      if (state is MemberRoleChangingState) {
        final currentState = state as MemberRoleChangingState;
        final updatedMembers = currentState.currentMembers.map((member) {
          if (member.userId == update.targetUserId) {
            // Create updated member with new role
            return WorkspaceMemberDetail(
              userId: member.userId,
              userName: member.userName,
              email: member.email,
              role: update.newRole,
              joinedAt: member.joinedAt,
              avatarUrl: member.avatarUrl,
            );
          }
          return member;
        }).toList();
        emit(MemberRoleChangedSuccess(updatedMembers));
      } else {
        // Fallback: reload all members
        await getWorkspaceMembers(update.workspaceId);
      }
    } catch (e) {
      emit(MemberErrorState(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> addMemberToWorkspace(
      WorkspaceMemberCredential workspaceMemberCredential) async {
    emit(MemberLoadingState());
    try {
      final member =
          await workspaceRepo.addMemberToWorkspace(workspaceMemberCredential);
      emit(AddMemberSuccess(member));
    } catch (e) {
      emit(MemberErrorState(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> removeMemberFromWorkspace(
      WorkspaceMemberCredential workspaceMemberCredential) async {
    emit(MemberLoadingState());
    try {
      await workspaceRepo.removeMemberFromWorkspace(workspaceMemberCredential);
      emit(MemberDeletionSuccess(workspaceMemberCredential.userId));
    } catch (e) {
      emit(MemberErrorState(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> leaveWorkspace(int workspaceId) async {
    emit(MemberLoadingState());
    try {
      await workspaceRepo.leaveWorkspace(workspaceId);
      emit(MemberLeavedSuccessfully(workspaceId));
    } catch (e) {
      if (e.toString().contains('last owner')) {
        emit(LastOwnerError(ExceptionMapper.toMessage(e)));
      } else {
        emit(MemberErrorState(ExceptionMapper.toMessage(e)));
      }
    }
  }

  Future<void> getWorkspaceMembers(int workspaceId) async {
    emit(MemberLoadingState());
    try {
      final members = await workspaceRepo.getWorkspaceMembers(workspaceId);
      emit(MemberLoadedState(members));
    } catch (e) {
      emit(MemberErrorState(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> changeMemberRole(WorkspaceChangeRoleMemberModel update) async {
    emit(MemberRoleChanging(update.targetUserId)); // Use mobile-specific state
    try {
      await workspaceRepo.changeMemberRole(update);
      emit(MemberRoleChanged(
          targetUserId: update.targetUserId, newRole: update.newRole));
      // Reload members to get updated data
      await getWorkspaceMembers(update.workspaceId);
    } catch (e) {
      emit(MemberErrorState(ExceptionMapper.toMessage(e)));
    }
  }
}
