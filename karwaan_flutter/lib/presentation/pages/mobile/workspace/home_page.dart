import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/workspace/create_workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_state.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_state.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/auth/profile_page.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/workspace/workspace_card.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/my_drawer.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int _currentPage = 0;
  bool _isCreatingWorkspace = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // build Workspace section(choose what ot show for the workspace state)
  Widget _buildWorkspaceSection(List<Workspace> worksapces) {
    if (worksapces.isEmpty) {
      return _buildEmtpyWorkspaceAni();
    } else {
      return _buildWorkspaceCarousel(worksapces);
    }
  }

  // build empty workspace
  Widget _buildEmtpyWorkspaceAni() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 20),
          Lottie.asset('asset/ani/emptys.json', height: 250),
          SizedBox(height: 16),
          Text('Create your first workspace to get started!',
              style: Theme.of(context).textTheme.bodyMedium)
        ],
      ),
    );
  }

  // build workspace Containers
  Widget _buildWorkspaceCarousel(List<Workspace> workspaces) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.80,
          child: PageView.builder(
            controller: _pageController,
            itemCount: workspaces.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: WorkspaceCard(workspace: workspaces[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        _buildPageIndicator(_currentPage, workspaces.length),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: Text('Tap on the workspace containers!',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  // page indicator
  Widget _buildPageIndicator(int currentPage, int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = currentPage == index;
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 16 : 8,
          height: 8,
          decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(4)),
        );
      }),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        title: Text(
          'Create new workspace',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        content: Column(
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
                controller: desController)
          ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myDeafultBackgroundColor,
      body: BlocListener<WorkspaceMemberCubit, WorkspaceMemberState>(
        listener: (context, state) {
          // Error state on workspace members
          if (state is MemberErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: BlocBuilder<WorkspaceCubit, WorkspaceState>(
          builder: (context, state) {
            // Loading/Initial state on workspaces
            if (state is WorkspaceLoading || state is WorkspaceInitial) {
              return Center(
                child: Lottie.asset('asset/ani/load.json'),
              );
            }
            // Workspace loaded lists state
            else if (state is WorkspaceListLoaded) {
              final authState = context.watch<AuthCubit>().state;

              String username = '';
              if (authState is AuthAuthenticated) {
                username = authState.user.name;
              }
              return Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                drawer: MyDrawer(),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Builder(
                                    builder: (context) => IconButton(
                                        onPressed: () =>
                                            Scaffold.of(context).openDrawer(),
                                        icon: Icon(
                                          Icons.menu,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        )),
                                  ),
                                ],
                              ),

                              // profile page
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProfilePage(),
                                  ));
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  child: Icon(
                                    Icons.person_2_outlined,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // greetings
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: 'Hello, ',
                                style: Theme.of(context).textTheme.bodyLarge),
                            TextSpan(
                                text: username.isNotEmpty
                                    ? '$username!'
                                    : 'Guest!',
                                style: Theme.of(context).textTheme.displayMedium),
                          ])),
                          Text('A great day to get better.',
                              style: Theme.of(context).textTheme.bodySmall),

                          const SizedBox(height: 15),

                          // divider
                          Divider(
                              thickness: 1,
                              color: Theme.of(context).dividerColor),

                          const SizedBox(height: 20),

                          // workspace header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text('Workspaces',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  subtitle: Text(
                                      'You have ${state.workspaces.length} workspaces',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ),
                              ),
                              GestureDetector(
                                  onTap: _addWorkspaceDialog,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Theme.of(context).colorScheme.surface,
                                          Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                        ]),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.add,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                              size: 18),
                                          SizedBox(width: 4),
                                          Text('Add',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall)
                                        ],
                                      ))),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // workspace section
                          _buildWorkspaceSection(state.workspaces),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            // Workspace error state
            else if (state is WorkspaceError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Optional animation
                      Lottie.asset(
                        'asset/ani/error.json',
                        height: 180,
                        repeat: false,
                      ),
                      const SizedBox(height: 16),

                      Text(
                        "Oops! Something went wrong, but don't worry, you can try again.",
                        style: GoogleFonts.alef(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      Text(
                        state
                            .error, // show the actual error if it's user-friendly
                        style: GoogleFonts.alef(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

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
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Something went wrong for the workspaces. Please login!'),
                  TextButton(
                      onPressed: () => context.read<AuthCubit>().checkAuth(),
                      child: const Text('Retry'))
                ],
              ));
            }
          },
        ),
      ),
    );
  }
}
