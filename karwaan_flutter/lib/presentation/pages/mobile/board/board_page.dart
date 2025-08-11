import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/board/board_details.dart';
import 'package:karwaan_flutter/domain/models/board/board_state.dart';
import 'package:karwaan_flutter/domain/models/board/create_board_credentials.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/board/board_details_card.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/my_drawer.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';

class BoardPage extends StatefulWidget {
  final int workspaceId;
  final String workspaceName;
  final String workspaceDec;
  const BoardPage(
      {super.key,
      required this.workspaceId,
      required this.workspaceName,
      required this.workspaceDec});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  bool _isCreatingBoard = false;

  // build board section(choose what to show for the board state)
  Widget _buildBoardSection(List<BoardDetails> boards) {
    if (boards.isEmpty) {
      return _buildEmptyBoardAni();
    } else {
      return _buildBoardCarousel(boards);
    }
  }

  // build empty boards
  Widget _buildEmptyBoardAni() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 20),
          Lottie.asset('asset/ani/emptys.json', height: 250),
          SizedBox(height: 16),
          Text(
            'Create your first board to get started!',
            style: GoogleFonts.alef(
                fontSize: 16,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  // build board containers
  Widget _buildBoardCarousel(List<BoardDetails> boards) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.88,
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 20),
            itemCount: boards.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: BoardDetailsCard(board: boards[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  // add board dialog
  void _addBoardDialog() {
    final nameController = TextEditingController();
    final desController = TextEditingController();

    final cubit = context.read<BoardCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Create new board',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Textfield(
                text: 'Board Name',
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
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Board name is required!'),
                    backgroundColor: Colors.red,
                  ));
                  return;
                }

                setState(() {
                  _isCreatingBoard = true;
                });

                try {
                  final credentilas = CreateBoardCredentials(
                      workspaceId: widget.workspaceId,
                      boardName: nameController.text.trim(),
                      boardDescription: desController.text.trim(),
                      createdAt: DateTime.now());

                  await cubit.createBoard(credentilas);
                  await cubit.getBoardsByWorkspace(widget.workspaceId);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Board successfully created!'),
                    backgroundColor: Colors.green,
                  ));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed: ${e.toString()}')));
                } finally {
                  setState(() {
                    _isCreatingBoard = false;
                  });
                }
              },
              child: _isCreatingBoard
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Create',
                      style: TextStyle(color: Colors.white),
                    ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BoardCubit, BoardState>(
      listener: (context, state) {
        if (state is BoardUpdated) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Board has been updated successfully'),
            backgroundColor: Colors.green,
          ));
          context.read<BoardCubit>().getBoardsByWorkspace(widget.workspaceId);
        } else if (state is DeletedSuccessfully) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Board has been deleted successfully'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ));
          context.read<BoardCubit>().getBoardsByWorkspace(widget.workspaceId);
        }
      },
      child: Scaffold(
          backgroundColor: myDeafultBackgroundColor,
          body: BlocBuilder<BoardCubit, BoardState>(
            builder: (context, state) {
              // Loading, initial state on the boards
              if (state is BoardLoading || state is BoardInitial) {
                return Center(
                  child: Lottie.asset('asset/ani/load.json'),
                );
              }
              // board loaded list state
              else if (state is BoardsFromWorkspaceLoaded) {
                // get the parent workspace name and dispaly it on the appbar
                return Scaffold(
                  backgroundColor: myDeafultBackgroundColor,
                  drawer: MyDrawer(),
                  body: SafeArea(
                      child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // top bar
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
                                          color: Colors.black,
                                        )),
                                  ),
                                ],
                              ),

                              // drawer or something
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade400,
                                child: Icon(
                                  Icons.person_2_outlined,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // greetings
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                // name of the parent board
                                text: '${widget.workspaceName}, ',
                                style: GoogleFonts.alef(
                                    fontSize: 28, fontWeight: FontWeight.bold)),
                            TextSpan(
                                // hard code
                                text: 'Boards!',
                                style: GoogleFonts.alef(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                    color: Colors.grey.shade400)),
                          ])),
                          Text(
                            // parent workspace description
                            '${widget.workspaceDec}.',
                            style: GoogleFonts.alef(
                                color: Colors.grey.shade600, fontSize: 16),
                          ),

                          const SizedBox(height: 15),

                          // divider
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            child: Divider(
                                thickness: 1, color: Colors.grey.shade400),
                          ),

                          const SizedBox(height: 20),

                          // board header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Boards',
                                    style: GoogleFonts.alef(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'You have ${state.boards.length} boards.',
                                    style: GoogleFonts.alef(
                                        fontSize: 16,
                                        color: Colors.grey.shade600),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: _addBoardDialog,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.add,
                                              color: Colors.grey.shade600,
                                              size: 18),
                                          SizedBox(width: 4),
                                          Text(
                                            'Add',
                                            style: GoogleFonts.alef(
                                                color: Colors.grey.shade600,
                                                fontSize: 15),
                                          )
                                        ],
                                      ))),
                            ],
                          ),

                          // board section
                          _buildBoardSection(state.boards)
                        ],
                      ),
                    ),
                  )),
                );
              }
              // board error state
              else if (state is BoardError) {
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
                              context.read<BoardCubit>().getBoardsByWorkspace(widget.workspaceId),
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
                    Text('Something went wrong for the boards. Please Retry!'),
                    TextButton(
                        onPressed: () => context.read<BoardCubit>().getBoardsByWorkspace(widget.workspaceId),
                        child: const Text('Retry'))
                  ],
                ));
              }
            },
          )),
    );
  }
}
