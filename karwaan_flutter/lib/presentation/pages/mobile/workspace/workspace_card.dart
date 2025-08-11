import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_gate.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/workspace/workspace_menu.dart';

class WorkspaceCard extends StatelessWidget {
  final Workspace workspace;
  const WorkspaceCard({super.key, required this.workspace});

  // build header with the menu button
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: ListTile(
            title: Text(workspace.workspaceName,
                style:
                    GoogleFonts.alef(fontSize: 20, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            subtitle: Text(workspace.workspaceDescription,
                style: GoogleFonts.alef(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                    fontWeight: FontWeight.w200),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          )),
          IconButton(
              onPressed: () => _showWorkspaceMenu(context),
              icon: Icon(
                Icons.more_vert,
                color: Colors.grey.shade600,
              )),
        ],
      ),
    );
  }

  // build footer with the creation date
  Widget _buildFooter(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  colors: [Colors.grey.shade400, Colors.grey.shade200])),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.white),
              SizedBox(width: 4),
              Text(
                'Created At ${_formatDate(workspace.createdAt)}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // show workspace menu
  void _showWorkspaceMenu(BuildContext context) {
    showBottomSheet(
      backgroundColor: Colors.grey.shade200,
      context: context,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<WorkspaceMemberCubit>(),
          child: WorkspaceMenu(workspace: workspace),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider<BoardCubit>(
                      create: (context) =>
                          BoardCubit(context.read<BoardRepo>()),
                      child: BoardGate(
                          boardRepo: context.read<BoardRepo>(),
                          workspaceId: workspace.id,
                          workspaceName: workspace.workspaceName,
                          workspaceDescription: workspace.workspaceDescription),
                    )));
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width * 0.8,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.grey.shade400, Colors.grey.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const Spacer(),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }
}
