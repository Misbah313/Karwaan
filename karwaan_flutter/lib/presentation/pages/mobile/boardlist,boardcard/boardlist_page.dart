import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_state.dart';
import 'package:karwaan_flutter/domain/models/boardcard/create_board_card_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist_state.dart';
import 'package:karwaan_flutter/domain/models/boardlist/create_board_list_credentails.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardlist/boardlist_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/boardlist,boardcard/board_card_widget.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';

class BoardlistPage extends StatefulWidget {
  final int boardId;
  final BoardcardRepo boardcardRepo;
  final String boardName;
  const BoardlistPage(
      {super.key,
      required this.boardId,
      required this.boardcardRepo,
      required this.boardName});

  @override
  State<BoardlistPage> createState() => _BoardlistPageState();
}

class _BoardlistPageState extends State<BoardlistPage> {
  final Map<int, BoardCardCubit> _cardCubit = {};

  BoardCardCubit _cardCubitFor(int listId) {
    return _cardCubit.putIfAbsent(
      listId,
      () => BoardCardCubit(widget.boardcardRepo),
    );
  }

  @override
  void dispose() {
    for (final c in _cardCubit.values) {
      c.close();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BoardlistCubit>().listBoardLists(widget.boardId);
    });
  }

  // =============================================== Dialogs ======================================================= //

  // create list dialog
  Future<void> _showCreateListDialog() async {
    final titleController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.grey.shade300,
          title: Text('Create new list',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Textfield(
                text: 'List title',
                obsecureText: false,
                controller: titleController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final raw = titleController.text.trim();
                if (raw.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('List title is required'),
                        backgroundColor: Colors.red),
                  );
                  return;
                }

                final creds = CreateBoardListCredentails(
                  boardListName: raw,
                  boardListId: widget.boardId,
                  createdAt: DateTime.now(),
                );

                // We rely on page-level BlocListener to show success/error and refresh.
                context.read<BoardlistCubit>().createBoardList(creds);
                if (mounted) Navigator.of(dialogCtx).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  // show update list dialog
  Future<void> _showUpdateListDialog(Boardlist list) async {
    final controller = TextEditingController(text: list.boardlistTitle);
    await showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.grey.shade300,
          title: Text('Rename list',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Textfield(
                text: 'New title',
                obsecureText: false,
                controller: controller,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final raw = controller.text.trim();
                if (raw.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Title can\'t be empty'),
                        backgroundColor: Colors.red),
                  );
                  return;
                }
                final creds = BoardlistCredentails(id: list.id, newTitle: raw);
                context.read<BoardlistCubit>().updateBoardList(creds);
                if (mounted) Navigator.of(dialogCtx).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // show confim delete list dialog
  Future<void> _confirmDeleteList(int listId) async {
    await showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.grey.shade300,
          title: const Text('Delete list'),
          content: Text(
            'Are you sure you want to delete this list? This cannot be undone.',
            style: GoogleFonts.alef(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                context.read<BoardlistCubit>().deleteBoardList(listId);
                if (mounted) Navigator.of(dialogCtx).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // show add card dialog
  Future<void> _showAddCardDialog(int listId) async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final cardCubit = _cardCubitFor(listId);

    await showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.grey.shade300,
          title: const Text('Add card'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Card title'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descController,
                decoration: const InputDecoration(hintText: 'Card description'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Card title is required'),
                        backgroundColor: Colors.red),
                  );
                  return;
                }
                final creds = CreateBoardCardCredentails(
                  id: listId,
                  title: title,
                  description: descController.text.trim(),
                  createAt: DateTime.now(),
                );
                cardCubit.createBoardCard(creds);
                if (mounted) Navigator.of(dialogCtx).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // ==================================================================================== UI BOARD LIST  ============================================================================= //

  @override
  Widget build(BuildContext context) {
    return BlocListener<BoardlistCubit, BoardlistState>(
      listener: (context, state) {
        if (state is BoardlistError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: Colors.red,
          ));
        }
        if (state is BoardlistDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Boardlist has been deleted successfully.'),
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
        } else if (state is BoardListCreated) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Boardlist has been created.'),
            backgroundColor: Colors.green,
          ));
          context.read<BoardlistCubit>().listBoardLists(widget.boardId);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade400,
          centerTitle: true,
          title: Text(
            widget.boardName,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: myDeafultBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<BoardlistCubit, BoardlistState>(
            builder: (context, state) {
              // boardlist loading/initial state
              if (state is BoardlistLoading || state is BoardlistInitial) {
                return Center(
                  child: Lottie.asset('asset/ani/load.json'),
                );
              }
              if (state is BoardlistError) {
                return _ErrorView(
                    message: state.error,
                    onRetry: () => context
                        .read<BoardlistCubit>()
                        .listBoardLists(widget.boardId));
              }
              // Boardlist loaded state
              if (state is BoardlistLoaded) {
                return _buildBoardLists(state.boardlist);
              }

              return _ErrorView(
                  message: 'Unknown state, Tap to retry.',
                  onRetry: () => context
                      .read<BoardlistCubit>()
                      .listBoardLists(widget.boardId));
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.grey.shade400,
            onPressed: _showCreateListDialog,
            label: Text(
              'Add list',
              style: GoogleFonts.alef(
                  color: Colors.grey.shade800,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
            icon: Icon(
              Icons.add,
              color: Colors.grey.shade800,
            )),
      ),
    );
  }

// ============================================================ Build Widgets ============================================================ //

// build board lists
  Widget _buildBoardLists(List<Boardlist> lists) {
    if (lists.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(
              'No lists yet!',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _showCreateListDialog,
              label: Text(
                'Create your first list',
                style: GoogleFonts.alef(
                    fontSize: 17,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
              icon: Icon(
                Icons.add,
                color: Colors.grey.shade600,
              ),
            )
          ],
        ),
      );
    }

    return ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        itemBuilder: (context, index) => _buildListColumn(lists[index]),
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemCount: lists.length);
  }

// build list columns ( // ======================== CARDS ======================= //)
  Widget _buildListColumn(Boardlist list) {
    final cardCubit = _cardCubitFor(list.id);

    // Ensure initial fetch after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cardCubit.state is! BoardCardListLoaded) {
        debugPrint('Fetching cards for list ${list.id}');
        cardCubit.getListByBoardCard(list.id);
      }
    });

    // BOARD LIST
    return Container(
      width: 300,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Colors.grey.shade400, Colors.grey.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title + actions
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            title: Text(
              list.boardlistTitle,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                  fontSize: 20),
            ),
            trailing: _ListActions(
              onEdit: () => _showUpdateListDialog(list),
              onDelete: () => _confirmDeleteList(list.id),
            ),
          ),

          // Cards list
          Expanded(
            child: BlocListener<BoardCardCubit, BoardCardState>(
              bloc: cardCubit,
              listener: (context, state) {
                if (state is BoardCardCreated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Card has been created!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  cardCubit.getListByBoardCard(list.id);
                } else if (state is BoardCardUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Card has been updated!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  cardCubit.getListByBoardCard(list.id);
                } else if (state is BoardCardDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Card has been deleted!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  cardCubit.getListByBoardCard(list.id);
                }
              },
              child: BlocBuilder<BoardCardCubit, BoardCardState>(
                bloc: cardCubit,
                builder: (context, state) {
                  if (state is BoardCardLoading || state is BoardCardInitial) {
                    return Center(
                      child: Lottie.asset('asset/ani/load.json'),
                    );
                  }

                  if (state is BoardCardError) {
                    return _ErrorCardsView(
                      message: state.error,
                      onRetry: () => cardCubit.getListByBoardCard(list.id),
                    );
                  }

                  if (state is BoardCardListLoaded) {
                    final cards = state.boardCard;

                    // NO cards
                    if (cards.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Lottie.asset('asset/ani/emptys.json', height: 200),
                            SizedBox(height: 16),
                            Text(
                              'Create your first card to get started!',
                              style: GoogleFonts.alef(
                                  fontSize: 15,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      itemCount: cards.length,
                      itemBuilder: (context, index) => CardWidget(
                        card: cards[index],
                        cardCubit: cardCubit,
                      ),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),

          // Add card button
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showAddCardDialog(list.id),
                label: Text(
                  'Add card',
                  style: GoogleFonts.alef(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w400),
                ),
                icon: Icon(
                  Icons.add,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================== Small UI Helpers ======================================================= //

// list Actions
class _ListActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ListActions({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ListAction>(
      onSelected: (value) {
        switch (value) {
          case _ListAction.edit:
            onEdit();
            break;
          case _ListAction.delete:
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: _ListAction.edit, child: Text('Edit')),
        PopupMenuItem(value: _ListAction.delete, child: Text('Delete')),
      ],
    );
  }
}

enum _ListAction { edit, delete }

// Error view for boardlists
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('asset/ani/error.json', height: 160, repeat: false),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: GoogleFonts.alef(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

// Error for cards view
class _ErrorCardsView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorCardsView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('asset/ani/error.json', height: 120, repeat: false),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: GoogleFonts.alef(fontSize: 14)),
            const SizedBox(height: 12),
            OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
