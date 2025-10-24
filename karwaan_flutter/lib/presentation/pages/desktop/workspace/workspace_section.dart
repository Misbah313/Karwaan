import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/workspace/create_workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_state.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/workspace/desk_workspace_card.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/HexColor.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';

class WorkspaceSection extends StatefulWidget {
  const WorkspaceSection({super.key});

  @override
  State<WorkspaceSection> createState() => _WorkspaceSectionState();
}

class _WorkspaceSectionState extends State<WorkspaceSection> {
  bool _isCreatingWorkspace = false;
  Widget _buildWorkspaceSection(List<Workspace> worksapces) {
    if (worksapces.isEmpty) {
      return _buildEmtpyWorkspaceAni(worksapces);
    } else {
      return _buildWorkspaceCarousel(worksapces);
    }
  }

  Widget _buildEmtpyWorkspaceAni(List<Workspace> worksapces) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Workspaces ${worksapces.length}",
                  style: Theme.of(context).textTheme.bodySmall),
              GestureDetector(
                  onTap: _addWorkspaceDialog,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Theme.of(context).colorScheme.surface,
                          Theme.of(context).colorScheme.onSurface
                        ]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add,
                              color: Theme.of(context).iconTheme.color,
                              size: 18),
                          SizedBox(width: 10),
                          Text('Add',
                              style: Theme.of(context).textTheme.bodySmall)
                        ],
                      ))),
            ],
          ),
          Lottie.asset(
            'asset/ani/emptys.json',
            height: 180,
            repeat: false,
          ),
          const SizedBox(height: 20),
          Text("You've got no workspace, Lets create one!!",
              style: Theme.of(context).textTheme.bodyMedium)
        ],
      ),
    );
  }

  Widget _buildWorkspaceCarousel(List<Workspace> worksapces) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Workspaces ${worksapces.length}",
                style: Theme.of(context).textTheme.bodyMedium),
            GestureDetector(
                onTap: _createWorkspaceDialog,
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context).colorScheme.onSurface
                      ]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add,
                            color: Theme.of(context).iconTheme.color, size: 18),
                        SizedBox(width: 10),
                        Text('Add',
                            style: Theme.of(context).textTheme.bodySmall)
                      ],
                    ))),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 1.2),
              itemCount: worksapces.length,
              itemBuilder: (context, index) {
                return DeskWorkspaceCard(workspace: worksapces[index]);
              },
            ))
      ],
    );
  }

  Widget _buildWorkspaceErrorState(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Theme.of(context).colorScheme.primary)),
        content: Text(
          error,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: Theme.of(context).textTheme.bodySmall,
              )),
        ],
      ),
    );
    return Center(
      child: Text('Failed'),
    );
  }

  // worksapce create
  void _createWorkspaceDialog() {
    final nameController = TextEditingController();
    final desController = TextEditingController();
    final cubit = context.read<WorkspaceCubit>();

    showDialog(
      context: context,
      builder: (context) {
        // Local state for the dialog
        String selectColor = '#6B7280';
        bool isPrivate = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              insetPadding: EdgeInsets.all(40),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context)
                          .colorScheme
                          .surface
                          .withValues(alpha: 0.9),
                      Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Create New Workspace',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close, size: 24),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // workspace name
                              Text(
                                'Workspace Name',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Textfield(
                                  text: 'Enter workspace name...',
                                  obsecureText: false,
                                  controller: nameController),
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: Colors.white.withValues(alpha: 0.1),
                              //     borderRadius: BorderRadius.circular(12),
                              //     border: Border.all(
                              //       color: Colors.white.withValues(alpha: 0.2),
                              //     ),
                              //   ),
                              //   child:

                              //   // TextField(
                              //   //   controller: nameController,
                              //   //   style: Theme.of(context).textTheme.bodyMedium,
                              //   //   decoration: InputDecoration(
                              //   //     hintText: 'Enter workspace name...',
                              //   //     border: InputBorder.none,
                              //   //     contentPadding: EdgeInsets.all(16),
                              //   //   ),
                              //   // ),
                              // ),

                              const SizedBox(height: 24),

                              // description
                              Text(
                                'Description',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Textfield(
                                  text: "What's the workspace for?...",
                                  obsecureText: false,
                                  controller: desController,
                                  maxline: 3),
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: Colors.white.withValues(alpha: 0.1),
                              //     borderRadius: BorderRadius.circular(12),
                              //     border: Border.all(
                              //       color: Colors.white.withValues(alpha: 0.2),
                              //     ),
                              //   ),
                              //   child: TextField(
                              //     controller: desController,
                              //     maxLines: 3,
                              //     style: Theme.of(context).textTheme.bodyMedium,
                              //     decoration: InputDecoration(
                              //       hintText: "What's the workspace for?...",
                              //       border: InputBorder.none,
                              //       contentPadding: EdgeInsets.all(16),
                              //     ),
                              //   ),
                              // ),

                              const SizedBox(height: 32),

                              // background color
                              Text(
                                'Workspace Color',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              _buildColorPalette(selectColor, (color) {
                                setDialogState(() => selectColor = color);
                              }),

                              const SizedBox(height: 32),

                              // privacy settings
                              Text(
                                'Privacy',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              _buildPirvacyOptions(isPrivate, (issPrivate) {
                                setDialogState(() => isPrivate = issPrivate);
                              }),

                              const SizedBox(height: 32),

                              // preview
                              Text(
                                'Preview',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              _buildWorkspacePreview(
                                nameController.text.isEmpty
                                    ? 'Workspace Name'
                                    : nameController.text,
                                selectColor,
                                isPrivate,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                            ),
                            child: Text('Cancel',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _isCreatingWorkspace
                                ? null
                                : () async {
                                    if (nameController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text('Workspace name is required!'),
                                        backgroundColor: Colors.red,
                                      ));
                                      return;
                                    }

                                    // Use parent setState for the loading state
                                    setState(() {
                                      _isCreatingWorkspace = true;
                                    });

                                    try {
                                      final credentials =
                                          CreateWorkspaceCredentials(
                                        workspaceName:
                                            nameController.text.trim(),
                                        workspaceDescription:
                                            desController.text.trim(),
                                        createdAt: DateTime.now(),
                                        backgroundColor: selectColor,
                                        isPrivate: isPrivate,
                                      );

                                      await cubit.createWorkspace(credentials);
                                      await cubit.getUserWorkspace();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            '🎉 Workspace created successfully!'),
                                        backgroundColor: Colors.green,
                                      ));
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed: ${e.toString()}')),
                                      );
                                    } finally {
                                      setState(() {
                                        _isCreatingWorkspace = false;
                                      });
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                      color: Theme.of(context).dividerColor)),
                            ),
                            child: _isCreatingWorkspace
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : Text('Create Workspace',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // color palette
  Widget _buildColorPalette(String selectedColor, Function(String) onSelected) {
    final colors = [
      '#3B82F6', // blue
      '#8B5CF6', // purple
      '#10B981', // green
      '#F59E0B', // orange
      '#EF4444', // red
      '#6B7280', // gray
    ];

    return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: colors.map((color) {
          return GestureDetector(
            onTap: () => onSelected(color),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: HexColor.fromHex(color),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: selectedColor == color
                          ? Colors.white
                          : Colors.transparent,
                      width: 3),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4))
                  ]),
            ),
          );
        }).toList());
  }

  // privacty options
  Widget _buildPirvacyOptions(bool isPrivate, Function(bool) onSelected) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2))),
      child: Column(
        children: [
          // team option
          ListTile(
            leading: Icon(Icons.group, color: Colors.blue),
            title: Text('Team Workspace',
                style: Theme.of(context).textTheme.bodyMedium),
            subtitle: Text(
              'Open - can add members later',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Radio<bool>(
                value: false,
                groupValue: isPrivate,
                activeColor: Colors.green,
                onChanged: (value) => onSelected(value ?? false)),
            onTap: () => onSelected(false),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.1)),

          // personal options
          ListTile(
            leading: Icon(Icons.person, color: Colors.green),
            title: Text(
              'Personal Workspace',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Text(
              'Closed - just for you, no members',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Radio<bool>(
                value: true,
                groupValue: isPrivate,
                activeColor: Colors.green,
                onChanged: (value) => onSelected(value ?? true)),
            onTap: () => onSelected(true),
          )
        ],
      ),
    );
  }

  // Workspace preview
  Widget _buildWorkspacePreview(String name, String color, bool isPrivate) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HexColor.fromHex(color).withValues(alpha: 0.3),
            HexColor.fromHex(color).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: HexColor.fromHex(color),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodySmall
                ),
                SizedBox(height: 4),
                Text(
                  isPrivate ? 'Personal workspace' : 'Team workspace',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isPrivate ? Icons.lock : Icons.group,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }

  // add worksapce dialog
  void _addWorkspaceDialog() {
    final nameController = TextEditingController();
    final desController = TextEditingController();
    final cubit = context.read<WorkspaceCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment(0, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Create new workspace',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Textfield(
                  text: 'Workspace Name',
                  obsecureText: false,
                  controller: nameController),
              middleSizedBox,
              Textfield(
                  text: 'Description',
                  obsecureText: false,
                  controller: desController,
                  maxline: 4)
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: Theme.of(context).textTheme.titleSmall)),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Workspace name is required!'),
                    backgroundColor: Colors.red,
                  ));
                  return;
                }

                setState(() {
                  _isCreatingWorkspace = true;
                });

                try {
                  final credentilas = CreateWorkspaceCredentials(
                      workspaceName: nameController.text.trim(),
                      workspaceDescription: desController.text.trim(),
                      createdAt: DateTime.now());

                  await cubit.createWorkspace(credentilas);
                  await cubit.getUserWorkspace();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Workspace successfully created!'),
                    backgroundColor: Colors.green,
                  ));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed: ${e.toString()}')));
                } finally {
                  setState(() {
                    _isCreatingWorkspace = false;
                  });
                }
              },
              child: _isCreatingWorkspace
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('Create',
                      style: Theme.of(context).textTheme.bodySmall))
        ],
      ),
    );
  }

  // unExpected state
  Widget _unExpectedState() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          title: Text(
            'Unexpected behaviour',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Text(
                "Something went worng. Please check your network or retry again.",
                style: Theme.of(context).textTheme.bodySmall),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          actions: [
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<WorkspaceCubit>().getUserWorkspace(),
              icon: Icon(Icons.refresh, size: 18),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ]),
    );
    return Center(
      child: Text('Failed'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      builder: (context, state) {
        if (state is WorkspaceLoading) {
          return Lottie.asset('asset/ani/load.json');
        } else if (state is WorkspaceListLoaded) {
          return _buildWorkspaceSection(state.workspaces);
        } else if (state is WorkspaceError) {
          return _buildWorkspaceErrorState(state.error);
        } else {
          return _unExpectedState();
        }
      },
    );
  }
}
