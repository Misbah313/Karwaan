import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_state.dart';
import 'package:karwaan_flutter/domain/models/boardcard/create_board_card_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist_state.dart';
import 'package:karwaan_flutter/domain/models/boardlist/create_board_list_credentails.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
import 'package:karwaan_flutter/domain/repository/cardlabel/cardlabel_repo.dart';
import 'package:karwaan_flutter/domain/repository/checklist/checklist_repo.dart';
import 'package:karwaan_flutter/domain/repository/label/label_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardlist/boardlist_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/cardlabel/cardlabel_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/boardlist,boardcard/board_card_widget.dart';
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text('Create new list',
              style: Theme.of(context).textTheme.bodyLarge),
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
              child:
                  Text('Cancel', style: Theme.of(context).textTheme.titleSmall),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Theme.of(context).colorScheme.primary),
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
              child:
                  Text('Create', style: Theme.of(context).textTheme.bodySmall),
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title:
              Text('Rename list', style: Theme.of(context).textTheme.bodyLarge),
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
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Theme.of(context).colorScheme.primary),
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
              child: Text(
                'Update',
                style: Theme.of(context).textTheme.titleSmall,
              ),
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Delete list',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          content: Text(
              'Are you sure you want to delete this list? This cannot be undone.',
              style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.titleSmall,
                )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Theme.of(context).colorScheme.primary),
              onPressed: () {
                context.read<BoardlistCubit>().deleteBoardList(listId);
                if (mounted) Navigator.of(dialogCtx).pop();
              },
              child: Text(
                'Delete',
                style: Theme.of(context).textTheme.bodySmall,
              ),
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text('Add card', style: Theme.of(context).textTheme.bodyLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Textfield(
                  text: 'Card Title',
                  obsecureText: false,
                  controller: titleController),
              const SizedBox(height: 8),
              Textfield(
                  text: 'Card description',
                  obsecureText: false,
                  controller: descController),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.titleSmall,
                )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Theme.of(context).colorScheme.primary),
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
              child: Text(
                'Add',
                style: Theme.of(context).textTheme.bodySmall,
              ),
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
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          iconTheme: Theme.of(context).iconTheme,
          centerTitle: true,
          title: Text(widget.boardName,
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: _showCreateListDialog,
            label:
                Text('Add list', style: Theme.of(context).textTheme.bodyMedium),
            icon: Icon(
              Icons.add,
              color: Theme.of(context).iconTheme.color,
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
            Text('No lists yet!',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _showCreateListDialog,
              label: Text('Create your first list',
                  style: Theme.of(context).textTheme.bodySmall),
              icon: Icon(
                Icons.add,
                color: Theme.of(context).iconTheme.color,
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
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.onSurface
          ],
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
            title: Text(list.boardlistTitle,
                style: Theme.of(context).textTheme.bodyMedium),
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
                            Lottie.asset('asset/ani/emptys.json',
                                height:
                                    MediaQuery.of(context).size.height * 0.2),
                            SizedBox(height: 16),
                            Text('Create your first card to get started!',
                                style: Theme.of(context).textTheme.bodySmall)
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        itemCount: cards.length,
                        itemBuilder: (context, index) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: cardCubit),

                                // cardlabel cubit for the specifc card
                                BlocProvider(
                                    create: (_) => CardlabelCubit(
                                        context.read<CardlabelRepo>())
                                      ..getLabelForCard(cards[index].id)),

                                // label cubit for global label list
                                BlocProvider(
                                    create: (_) =>
                                        LabelCubit(context.read<LabelRepo>())
                                          ..getLabelsForBoard(widget.boardId)),

                                // checklist cubit for the specific card
                                BlocProvider(
                                    create: (_) => ChecklistCubit(
                                        context.read<ChecklistRepo>())
                                      ..listChecklist(cards[index].id))
                              ],
                              child: CardWidget(
                                card: cards[index],
                                cardCubit: cardCubit,
                              ),
                            ));
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
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).dividerColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Theme.of(context).colorScheme.primary),
                onPressed: () => _showAddCardDialog(list.id),
                label: Text('Add card',
                    style: Theme.of(context).textTheme.bodySmall),
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).iconTheme.color,
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
      color: Theme.of(context).scaffoldBackgroundColor,
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
      itemBuilder: (context) => [
        PopupMenuItem(
            value: _ListAction.edit,
            child: Text('Edit', style: Theme.of(context).textTheme.bodyMedium)),
        PopupMenuItem(
            value: _ListAction.delete,
            child:
                Text('Delete', style: Theme.of(context).textTheme.bodyMedium)),
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
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).iconTheme.color,
                ),
                label: Text(
                  'Retry',
                  style: Theme.of(context).textTheme.bodySmall,
                )),
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
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            OutlinedButton.icon(
                onPressed: onRetry,
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).iconTheme.color,
                ),
                label: Text(
                  'Retry',
                  style: Theme.of(context).textTheme.bodySmall,
                )),
          ],
        ),
      ),
    );
  }
}
