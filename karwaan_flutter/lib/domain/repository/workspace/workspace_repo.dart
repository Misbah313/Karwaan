import 'package:karwaan_flutter/domain/models/workspace/create_workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_change_role_member_model.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_details.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_model.dart';

abstract class WorkspaceRepo {

   Future<Workspace> createWorkspace(CreateWorkspaceCredentials createworkspaceCredential);
   Future<List<Workspace>> getUserWorkspace();
   Future<Workspace> updateWorkspace(WorkspaceCredential workspaceCredential);
   Future<void> deleteWorkspace(int workspaceId);
   Future<WorkspaceMemberModel> addMemberToWorkspace(WorkspaceMemberCredential workspaceMemberCredential);
   Future<void> removeMemberFromWorkspace(WorkspaceMemberCredential workspaceMemberCredential);
   Future<List<WorkspaceMemberDetail>> getWorkspaceMembers(int workspaceId);
   Future<void> leaveWorkspace(int workspaceId);
   Future<WorkspaceMemberModel> changeMemberRole(WorkspaceChangeRoleMemberModel credential);
}