// workspace_content_section.dart
import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/workspace/background_color_selector.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_credentials.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/editable_field_withsave.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/button.dart';

class WorkspaceContentSection extends StatelessWidget {
  final Workspace workspace;
  final WorkspaceCubit workspaceCubit;

  const WorkspaceContentSection({
    super.key,
    required this.workspace,
    required this.workspaceCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Workspace Contents'),
          const SizedBox(height: 10),
          _buildEditableTitle(context),
          const SizedBox(height: 12),
          _buildEditableDescription(context),
          const SizedBox(height: 16),
          _buildBackgroundColorSelector(context),
          const SizedBox(height: 24),
          _buildDeleteButton(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.w200, fontSize: 22),
    );
  }

  Widget _buildEditableTitle(BuildContext context) {
    return EditableFieldWithSave(
      initialValue: workspace.workspaceName,
      label: 'Workspace Name',
      onSave: (newTitle) {
        final credentials = WorkspaceCredential(
          id: workspace.id,
          workspaceName: newTitle,
          workspaceDescription: workspace.workspaceDescription,
          backgroundColor:
              workspace.backgroundColor, // Include background color
        );
        workspaceCubit.updateWorkspaceOptimized(credentials);
      },
    );
  }

  Widget _buildEditableDescription(BuildContext context) {
    return EditableFieldWithSave(
      initialValue: workspace.workspaceDescription,
      label: 'Workspace Description',
      maxLines: 3,
      onSave: (newDescription) {
        final credentials = WorkspaceCredential(
          id: workspace.id,
          workspaceName: workspace.workspaceName,
          workspaceDescription: newDescription,
          backgroundColor:
              workspace.backgroundColor, // Include background color
        );
        workspaceCubit.updateWorkspaceOptimized(credentials);
      },
    );
  }

  Widget _buildBackgroundColorSelector(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Background Color',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            BackgroundColorSelector(
              initialColor: workspace.backgroundColor,
              onColorSelected: (color) {
                final credentials = WorkspaceCredential(
                    id: workspace.id,
                    workspaceName: workspace.workspaceName,
                    workspaceDescription: workspace.workspaceDescription,
                    backgroundColor: color);
                workspaceCubit.updateWorkspaceOptimized(credentials);
              },
            )
          ],
        ),
        _buildPrivacyIndicator(context),
      ],
    );
  }

  Widget _buildPrivacyIndicator(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Workspace privacy',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Container(
          width: MediaQuery.of(context).size.width * 0.08,
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Center(
            child: Text(
              workspace.isPrivate ? 'Private' : 'Public',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Button(
      gradient: LinearGradient(
        colors: [
          Colors.red.withValues(alpha: 0.5),
          Colors.red.shade200.withValues(alpha: 0.09),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      text: 'Delete Workspace',
      onTap: () => _showDeleteWorkspaceDialog(context, workspace.id),
    );
  }

  void _showDeleteWorkspaceDialog(BuildContext context, int workspaceId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        insetPadding: const EdgeInsets.all(30),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                // header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delete Workspace',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Are you sure want to delete this workspace, this cannot be undone!',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),

                // actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.05),
                      ),
                      onPressed: () {
                        workspaceCubit.deleteWorkspaceOptimized(workspaceId);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Delete',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
