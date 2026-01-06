import 'package:karwaan_flutter/domain/models/workspace/workspace_member_details.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';

class GetWorkspaceMembersUseCase {
  final WorkspaceRepo memberRepo;

  GetWorkspaceMembersUseCase({required this.memberRepo});

  Future<List<WorkspaceMemberDetail>> execute(int workspaceId) async {
    return await memberRepo.getWorkspaceMembers(workspaceId);
  }
}