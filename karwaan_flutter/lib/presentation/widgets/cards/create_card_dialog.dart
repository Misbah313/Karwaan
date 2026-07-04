import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';
import 'package:karwaan_flutter/domain/models/boardcard/create_board_card_credentails.dart';
import 'package:karwaan_flutter/domain/models/label/label.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';

class CreateCardDialog extends StatefulWidget {
  final int boardId;
  final int listId;
  final BoardCardCubit cardCubit;
  final BoardMemberCubit memberCubit;
  final LabelCubit labelCubit;
  final List<BoardMemberDetails> boardMembers;
  const CreateCardDialog(
      {super.key,
      required this.boardId,
      required this.listId,
      required this.cardCubit,
      required this.memberCubit,
      required this.labelCubit,
      required this.boardMembers});

  @override
  State<CreateCardDialog> createState() => _CreateCardDialogState();
}

class _CreateCardDialogState extends State<CreateCardDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  bool _isCreating = false;
  List<int> selectedUserIds = [];
  List<BoardMemberDetails> boardMembers = [];
  List<BoardMemberDetails> filteredMembers = [];
  List<Label> boardLabels = [];
  List<Label> selectedLabels = [];
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    // _loadBoardMembers();
    _loadBoardLabels();
    searchController = TextEditingController();
    boardMembers = widget.boardMembers;
    filteredMembers = widget.boardMembers;
  }

  Future<void> _loadBoardLabels() async {
    final labels = await widget.labelCubit.getLabelsForBoard(widget.boardId);
    setState(() {
      boardLabels = labels;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create a new task',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        size: 24,
                      ))
                ],
              ),
              const SizedBox(height: 15),

              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // task title
                    Text('Task Title',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 2),
                    Textfield(
                        text: 'Enter task title...',
                        obsecureText: false,
                        controller: titleController),
                    const SizedBox(height: 10),

                    // description
                    Text('Description',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 2),
                    Textfield(
                        text: "What's the task for?",
                        obsecureText: false,
                        controller: descController,
                        maxline: 2),

                    const SizedBox(height: 10),

                    // inline assigning members to the card
                    Text('Assign Members',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 2),
                    _buildAssignMemberSection(),

                    const SizedBox(height: 10),

                    // inline adding label to the card
                    Text('Add Label',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 2),
                    _buildAddLabelSection()
                  ],
                ),
              )),

              const SizedBox(height: 15),

              // actions
              Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: Theme.of(context).textTheme.bodySmall,
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.03),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(
                                color: Theme.of(context)
                                    .dividerColor
                                    .withValues(alpha: 0.5))),
                        onPressed: _isCreating
                            ? null
                            : () async {
                                final title = titleController.text.trim();
                                if (title.isEmpty) return;

                                setState(() => _isCreating = true);

                                await widget.cardCubit.createCardOptimized(
                                  CreateBoardCardCredentails(
                                      id: widget.listId,
                                      title: title,
                                      description: descController.text.trim(),
                                      createAt: DateTime.now(),
                                      assignedUserIds: selectedUserIds.isEmpty
                                          ? null
                                          : selectedUserIds,
                                      assignedLabelIds: selectedLabels.isEmpty
                                          ? null
                                          : selectedLabels
                                              .map((l) => l.id!)
                                              .toList()),
                                );

                                setState(() => _isCreating = false);
                                Navigator.pop(context);
                              },
                        child: Text('Create',
                            style: Theme.of(context).textTheme.bodySmall)),
                  ])
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssignMemberSection() {
    final displayList = searchController.text.isEmpty
        ? boardMembers.take(5).toList()
        : filteredMembers;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Textfield(
            text: 'Search Members...',
            obsecureText: false,
            controller: searchController,
            onChanged: (value) {
              setState(() {
                filteredMembers = boardMembers.where((m) {
                  final query = value.toLowerCase();

                  return m.userName.toLowerCase().contains(query) ||
                      (m.userEmail).toLowerCase().contains(query);
                }).toList();
              });
            },
          ),

          const SizedBox(height: 10),

          // 👇 Search results list
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final user = displayList[index];
                final isSelected = selectedUserIds.contains(user.userId);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedUserIds.remove(user.userId);
                      } else {
                        selectedUserIds.add(user.userId);
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: isSelected
                              ? Colors.blue.withValues(alpha: 0.5)
                              : Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        // members avatar
                        if (user.avatarUrl != null)
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.avatarUrl!),
                          )
                        else
                          CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.2),
                            child: Text(
                              user.userName[0],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),

                        const SizedBox(width: 12),

                        // member name
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  user.userName,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Text(
                              user.userEmail,
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        ))

                        //
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // ✅ Selected preview
          Wrap(
            spacing: 8,
            children: selectedUserIds.map((id) {
              final user =
                  boardMembers.firstWhere((element) => element.userId == id);

              return Chip(
                elevation: 0,
                backgroundColor: Colors.white.withValues(alpha: 0.01),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: Theme.of(context).dividerColor),
                label: Text(
                  user.userName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onDeleted: () {
                  setState(() {
                    selectedUserIds.remove(id);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddLabelSection() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // labels
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: boardLabels.length,
              itemBuilder: (context, index) {
                final label = boardLabels[index];
                final isSelected = selectedLabels.contains(label);

                final hex = label.color.replaceFirst('#', '');
                final color = Color(int.parse('FF$hex', radix: 16));

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedLabels.remove(label);
                      } else {
                        selectedLabels.add(label);
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color:
                                isSelected ? Colors.white : Colors.transparent,
                            width: 2)),
                    child: Text(label.title,
                        style: TextStyle(
                            color: _getContrastColor(color),
                            fontWeight: FontWeight.w500)),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // selected preview
          Wrap(
              spacing: 8,
              children: selectedLabels.map((label) {
                final hex = label.color.replaceFirst('#', '');
                final color = Color(int.parse('FF$hex', radix: 16));

                return Chip(
                    backgroundColor: color,
                    label: Text(
                      label.title,
                      style: TextStyle(color: _getContrastColor(color)),
                    ),
                    onDeleted: () {
                      setState(() {
                        selectedLabels.remove(label);
                      });
                    });
              }).toList())
        ],
      ),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
