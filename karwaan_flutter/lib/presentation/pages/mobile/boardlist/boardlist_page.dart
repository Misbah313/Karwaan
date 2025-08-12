import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist_state.dart';
import 'package:karwaan_flutter/domain/models/boardlist/create_board_list_credentails.dart';
import 'package:karwaan_flutter/presentation/cubits/boardlist/boardlist_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';

class BoardlistPage extends StatefulWidget {
  final int boardId;
  const BoardlistPage({super.key, required this.boardId});

  @override
  State<BoardlistPage> createState() => _BoardlistPageState();
}

class _BoardlistPageState extends State<BoardlistPage> {
  bool _isCreatingBoardList = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BoardlistCubit>().listBoardLists(widget.boardId);
    });
  }

  // update boardlist
  void _showUpdateWorkspaceDialog(Boardlist list) {
    final cubit = context.read<BoardlistCubit>();
    final newTitleController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => BlocProvider.value(
              value: cubit,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.grey.shade300,
                title: Text(
                  'Update boardlist!',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Textfield(
                        text: 'New Title',
                        obsecureText: false,
                        controller: newTitleController),
                  ],
                ),
                actionsPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      )),
                  BlocConsumer<BoardlistCubit, BoardlistState>(
                    listener: (context, state) {
                      if (state is BoardlistLoaded) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Boardlist successfully updated.'),
                          backgroundColor: Colors.green,
                        ));
                      }

                      if (state is BoardlistError) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.grey.shade300),
                          onPressed: state is BoardlistLoading
                              ? null
                              : () {
                                  if (newTitleController.text.isEmpty) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Boardlist name cannot be empty!!'),
                                      backgroundColor: Colors.red,
                                    ));
                                    return;
                                  }
                                  final credentials = BoardlistCredentails(
                                      id: list.id,
                                      newTitle: newTitleController.text.trim());
                                  context
                                      .read<BoardlistCubit>()
                                      .updateBoardList(credentials);
                                },
                          child: state is BoardlistLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  'Update',
                                  style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.w400),
                                ));
                    },
                  )
                ],
              ),
            ));
  }

  // delete boardlist
  void _showdeleteBoardListDialog(int listId) {
    final cubit = context.read<BoardlistCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Deleting boardlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure want to delete this boardlist?',
          style: GoogleFonts.alef(
              fontSize: 17,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w300),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                cubit.deleteBoardList(listId);
              },
              child: Text('Delete'))
        ],
      ),
    );
  }

  void _showCreateListDialog() {
    final titleController = TextEditingController();

    final cubit = context.read<BoardlistCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Create new boardlist',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Textfield(
                text: 'Boardlist Title',
                obsecureText: false,
                controller: titleController),
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
                if (titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Boardlist title is required!'),
                    backgroundColor: Colors.red,
                  ));
                  return;
                }

                setState(() {
                  _isCreatingBoardList = true;
                });

                try {
                  final credentilas = CreateBoardListCredentails(
                      boardListName: titleController.text.trim(),
                      boardListId: widget.boardId,
                      createdAt: DateTime.now());

                  await cubit.createBoardList(credentilas);
                  await cubit.listBoardLists(widget.boardId);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('list successfully created!'),
                    backgroundColor: Colors.green,
                  ));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed: ${e.toString()}')));
                } finally {
                  setState(() {
                    _isCreatingBoardList = false;
                  });
                }
              },
              child: _isCreatingBoardList
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
    return BlocListener<BoardlistCubit, BoardlistState>(
      listener: (context, state) {
        if (state is BoardlistDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Boardlist has been deleted successfully'),
            backgroundColor: Colors.green,
          ));
          context.read<BoardlistCubit>().listBoardLists(widget.boardId);
        } else if (state is BoardlistUpdated) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Boardlist has been updated.'),
            backgroundColor: Colors.green,
          ));
          context.read<BoardlistCubit>().listBoardLists(widget.boardId);
        }
      },
      child: Scaffold(
        backgroundColor: myDeafultBackgroundColor,
        // app bar 50%
        body: BlocBuilder<BoardlistCubit, BoardlistState>(
          builder: (context, state) {
            // boardlist loading/initial state
            if (state is BoardlistLoading || state is BoardlistInitial) {
              return Center(
                child: Lottie.asset('asset/ani/load.json'),
              );
            }
            // Boardlist loaded state 
            else if (state is BoardlistLoaded) {
              return _buildBoardLists(state.boardlist);
            }
            // Error state 
            else if (state is BoardlistError) {
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
                        "Oops! ${state.error}",
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
                        onPressed: () => context
                            .read<BoardlistCubit>()
                            .listBoardLists(widget.boardId),
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
            }
            // else 
            else {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Something went wrong for the boardlists. Please Retry!'),
                  TextButton(
                      onPressed: () => context
                          .read<BoardlistCubit>()
                          .listBoardLists(widget.boardId),
                      child: const Text('Retry'))
                ],
              ));
            }
          },
        ),
      ),
    );
  }

// build board lists
  Widget _buildBoardLists(List<Boardlist> lists) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: lists.length + 1,
      itemBuilder: (context, index) {
        if (index == lists.length) {
          return _buildAddListButton();
        }
        return _buildListColumn(lists[index]);
      },
    );
  }

// build list columns
  Widget _buildListColumn(Boardlist list) {
    return Container(
      width: 300,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade200])
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header with title + actions
          ListTile(
            title: Text(list.boardlistTitle),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('Edit'),
                  onTap: () => _showUpdateWorkspaceDialog(list),
                ),
                PopupMenuItem(
                  child: Text('Delete'),
                  onTap: () => _showdeleteBoardListDialog(list.id),
                )
              ],
            ),
          ),

          // cards list (placeholder)
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) => Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text('Card $index'),
              ),
            ),
          )),

          // add card button
          TextButton.icon(
            onPressed: () {},
            label: Text('Add Card'),
            icon: Icon(Icons.add),
          )
        ],
      ),
    );
  }

// build add list button
  Widget _buildAddListButton() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextButton.icon(
        onPressed: _showCreateListDialog,
        label: Text('Add List'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
