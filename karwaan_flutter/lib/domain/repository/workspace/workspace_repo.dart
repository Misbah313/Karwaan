import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_credentials.dart';

abstract class WorkspaceRepo {

   Future<Workspace> createWorkspace(WorkspaceCredential workspaceCredential);
   Future<List<Workspace>> getUserWorkspace();
   Future<bool> updateWorkspace(int workspaceId);
   Future<void> deleteWorkspace(int workspaceId);
   Future<bool> addMemberToWorkspace(WorkspaceMemberCredential workspaceMemberCredential);
   Future<void> removeMemberFromWorkspace(WorkspaceMemberCredential workspaceMemberCredential);
   Future<void> leaveWorkspace(int workspaceId);
}