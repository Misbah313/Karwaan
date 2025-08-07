import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/workspace/create_workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_state.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_state.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/workspace/workspace_card.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  final lowBlue = Colors.blue.shade300;
  final heightBlue = Colors.amber.shade400;
  int _currentPage = 0;
  bool _isCreatingWorkspace = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // build workspace crarousel
  Widget _buildWorkspaceCarousel(List<Workspace> workspaces) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.85,
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
    );
  }

  // page indicator
  Widget _buildPageIndicator(int currentPage, int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 12 : 8,
          height: 8,
          decoration: BoxDecoration(
              color: currentPage == index ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(4)),
        );
      }),
    );
  }

  // add worksapce
  void _addWorkspaceDialog() {
    final nameController = TextEditingController();
    final desController = TextEditingController();

    final cubit = context.read<WorkspaceCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade200,
        title: Text('Create new workspace'),
        content: Column(
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
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Workspace name is required!')));
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Failed to create worksapce: ${e.toString()}')));
                } finally {
                  setState(() {
                    _isCreatingWorkspace = false;
                  });
                }
              },
              child: _isCreatingWorkspace
                  ? CircularProgressIndicator()
                  : Text('Create'))
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
          if (state is MemberErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: BlocBuilder<WorkspaceCubit, WorkspaceState>(
          builder: (context, state) {
            if (state is WorkspaceLoading || state is WorkspaceInitial) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is WorkspaceListLoaded) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // heading
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.amber.shade400,
                                  child: Icon(
                                    Icons.person_2_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),

                            // drawer or something
                          ],
                        ),

                        const SizedBox(height: 25),

                        // greetings
                        ListTile(
                          title: Row(
                            children: [
                              Text(
                                'Hello, ',
                                style: TextStyle(
                                  color: Colors.amber.shade600,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              Text(
                                'Mike!',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            'A great day to get better.',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        // divider
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Divider(
                              thickness: 1, color: Colors.grey.shade400),
                        ),

                        const SizedBox(height: 20),

                        // workspace header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    'Workspaces',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'You have ${state.workspaces.length} workspace',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: Colors.grey.shade500),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: _addWorkspaceDialog,
                                      child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Colors.blue.shade400,
                                              Colors.grey.shade300
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.add,
                                                  color: Colors.white),
                                              Text(
                                                'Add',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ))),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // workspace carousel
                        SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              children: [
                                _buildWorkspaceCarousel(state.workspaces),
                                const SizedBox(height: 10),
                                _buildPageIndicator(
                                    _currentPage, state.workspaces.length)
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is WorkspaceNotLoaded) {
              return Center(
                child: Lottie.asset('asset/ani/empty.json',
                    width: 200, height: 200),
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
