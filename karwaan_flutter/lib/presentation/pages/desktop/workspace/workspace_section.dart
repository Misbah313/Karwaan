import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/workspace/app_naviagation_service.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_card_cubit.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member_use_case.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_navigation_service.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_option_service.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/workspace/create_workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_state.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/workspace/desk_workspace_card.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/HexColor.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';

class WorkspaceSection extends StatefulWidget {
  const WorkspaceSection({super.key});

  @override
  State<WorkspaceSection> createState() => _WorkspaceSectionState();
}

class _WorkspaceSectionState extends State<WorkspaceSection> {
  bool _isCreatingWorkspace = false;
  List<Workspace> _lastKnownWorkspaces = [];
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
                  style: Theme.of(context).textTheme.bodyMedium),
              GestureDetector(
                  onTap: _createWorkspaceDialog,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.07),
                        border:
                            Border.all(color: Theme.of(context).dividerColor),
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
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.03),
                      border: Border.all(
                          color: Theme.of(context)
                              .dividerColor
                              .withValues(alpha: 0.5)),
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
                    )))
          ],
        ),
        const SizedBox(height: 10),
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
                return BlocProvider(
                  create: (context) => WorkspaceCardCubit(
                    getMembersUseCase: GetWorkspaceMembersUseCase(
                      memberRepo: context.read<WorkspaceRepo>(),
                    ),
                    workspace: worksapces[index],
                  ),
                  child: DeskWorkspaceCard(
                    workspace: worksapces[index],
                    navigationService: WorkspaceNavigationServiceImpl(
                        boardRepo: context.read<BoardRepo>(),
                        appNavigationService:
                            context.read<AppNavigationService>()),
                    optionsService: WorkspaceOptionsServiceImpl(
                      workspaceCubit: context.read<WorkspaceCubit>(),
                      workspaceMemberCubit:
                          context.read<WorkspaceMemberCubit>(),
                    ),
                  ),
                );
              },
            ))
      ],
    );
  }

  void _buildWorkspaceErrorState(String error) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BannerManager>().show(error);
    });
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
                                    if (nameController.text.isEmpty ||
                                        desController.text.isEmpty) {
                                      context.read<BannerManager>().show(
                                          'Workspace name & description is required!');
                                      return;
                                    }
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
                                    } catch (e) {
                                      final mapper =
                                          ExceptionMapper.toMessage(e);
                                      context
                                          .read<BannerManager>()
                                          .show(mapper);
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
                Text(name, style: Theme.of(context).textTheme.bodySmall),
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceCubit, WorkspaceState>(
      listener: (context, state) {
        if (state is WorkspaceError) {
          _buildWorkspaceErrorState(state.error);
        } else if (state is WorkspaceCreated) {
          Navigator.pop(context);
          context.read<BannerManager>().show(
              'Workpace ${state.workspaceName} created successfully.',
              backgroundColor: Colors.green);
        }
      },
      child: BlocBuilder<WorkspaceCubit, WorkspaceState>(
        buildWhen: (previous, current) {
          return current is WorkspaceLoading || current is WorkspaceListLoaded;
        },
        builder: (context, state) {
          if (state is WorkspaceLoading) {
            return Lottie.asset('asset/ani/load.json');
          } else if (state is WorkspaceListLoaded) {
            _lastKnownWorkspaces = state.workspaces;
            return _buildWorkspaceSection(_lastKnownWorkspaces);
          } else {
            return _buildWorkspaceSection(_lastKnownWorkspaces);
          }
        },
      ),
    );
  }
}
