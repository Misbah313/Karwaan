import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_state.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_state.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/workspace/workspace_card.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final lowBlue = Colors.blue.shade300;
  final heightBlue = Colors.amber.shade400;
  int _currentPage = 0;

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
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentPage == index ? Colors.blue : Colors.grey.shade400),
        );
      }),
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
                              Text(
                                'My workspaces',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.add, color: Colors.amber.shade500),
                                  Text('Add'),
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
                            _buildPageIndicator(_currentPage, state.workspaces.length)
                          ],
                        )),

                        const SizedBox(height: 10),

                        // swipe
                        Text(
                          'SWIPE CARDS',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 15),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Something went wrong for the workspaces. Please login!'),
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
