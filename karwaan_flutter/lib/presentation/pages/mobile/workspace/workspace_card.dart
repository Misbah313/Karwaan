import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/workspace/workspace_menu.dart';

class WorkspaceCard extends StatelessWidget {
  final Workspace workspace;
  const WorkspaceCard({super.key, required this.workspace});

  // build header with the menu button
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Text(workspace.workspaceName,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          IconButton(
              onPressed: () => _showWorkspaceMenu(context),
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  // build description section
  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(workspace.workspaceDescription,
          style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 15),
          maxLines: 2,
          overflow: TextOverflow.ellipsis),
    );
  }

  // build footer with the creation date
  Widget _builFooter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 16, color: Colors.white),
          SizedBox(width: 4),
          Text(
            'Created ${_formatDate(workspace.createdAt)}',
            style: TextStyle(color: Colors.white, fontSize: 12),
          )
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // show workspace menu
  void _showWorkspaceMenu(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (context) => WorkspaceMenu(workspace: workspace),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showWorkspaceMenu(context),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width * 0.8,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue.shade200, Colors.blue.shade400]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            _buildDescription(),
            const Spacer(),
            _builFooter(),
          ],
        ),
      ),
    );
  }
}
