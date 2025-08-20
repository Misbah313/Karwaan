import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/checklistItem/checklist_item_state.dart';
import 'package:karwaan_flutter/domain/models/checklistItem/create_checklist_item_credentails.dart';
import 'package:karwaan_flutter/domain/models/checklistItem/update_checklist_item_credentails.dart';
import 'package:karwaan_flutter/presentation/cubits/checklistItem/checklist_item_cubit.dart';
import 'package:lottie/lottie.dart';

class ChecklistItemDialog extends StatelessWidget {
  final String checklistTitle;
  final int checklistId;
  const ChecklistItemDialog(
      {super.key, required this.checklistTitle, required this.checklistId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChecklistItemCubit>();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.grey.shade300,
      title: Text(
        checklistTitle,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      content: BlocConsumer<ChecklistItemCubit, ChecklistItemState>(
        listener: (context, state) {
          if (state is ChecklistItemUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Item has been updated successfully.'),
              backgroundColor: Colors.green,
            ));
            cubit.listChecklistItem(checklistId);
          }
          if (state is ChecklistItemCreated) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Item has been created successfully.'),
              backgroundColor: Colors.green,
            ));
            cubit.listChecklistItem(checklistId);
          }
          if (state is ChecklistItemDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Item has been deleted successfully.'),
              backgroundColor: Colors.green,
            ));
            cubit.listChecklistItem(checklistId);
          }
          if (state is ChecklistItemError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ));
          }
          if (state is ChecklistItemToggled) {
            cubit.listChecklistItem(checklistId);
          }
        },
        builder: (context, state) {
          if (state is ChecklistItemLoading) {
            return SizedBox(
              height: 100,
              child: Center(
                  child: Lottie.asset('asset/ani/load.json', height: 100)),
            );
          }

          if (state is ChecklistItemListLoaded) {
            final checklistItems = state.checklistItems;

            if (checklistItems.isEmpty) {
              return SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    'No Checklist Item yet!',
                    style: GoogleFonts.alef(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: checklistItems.map((item) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.blueGrey.shade300,
                          Colors.grey.shade300
                        ]),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 3)
                        ]),
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.green,
                          checkColor: Colors.grey.shade300,
                          side: BorderSide(color: Colors.grey.shade400),
                          value: item.isDone,
                          onChanged: (value) {
                            cubit.toggleChecklistItem(item.id!);
                            cubit.listChecklistItem(checklistId);
                          },
                        ),
                        Expanded(
                          child: Text(
                            item.content,
                            style: GoogleFonts.alef(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                              decoration: item.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                          onSelected: (value) {
                            if (value == 'Update') {
                              // open update dialog
                              _showUpdateChecklistItemDialog(
                                  context, item.id!, checklistId, cubit);
                            } else if (value == 'Delete') {
                              // open delete confirmation dialog
                              _showConfirmDeleteItemDialog(
                                  context, item.id!, cubit);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'Update',
                              child: Text('Update'),
                            ),
                            PopupMenuItem(
                              value: 'Delete',
                              child: Text('Delete'),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }

          if (state is ChecklistItemError) {
            return SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'Error: ${state.error}',
                  style: GoogleFonts.alef(
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.w600),
                ),
              ),
            );
          }

          // Fallback
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.grey[350]),
          onPressed: () {
            // show create checklist item dialog
            _showCreateChecklistItemDialog(context, cubit, checklistId);
          },
          child: Text(
            'Create Item',
            style: GoogleFonts.alef(color: Colors.grey.shade600),
          ),
        )
      ],
    );
  }
}

// show create item dialog
Future<void> _showCreateChecklistItemDialog(
  BuildContext context,
  ChecklistItemCubit cubit,
  int checklistId,
) async {
  final contentController = TextEditingController();

  await showDialog(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.grey.shade300,
      title: Text(
        'Create new Item',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: contentController,
            decoration: InputDecoration(labelText: 'Title'),
          )
        ],
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            )),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.grey[350],
          ),
          onPressed: () {
            final credentails = CreateChecklistItemCredentails(
                checklistId: checklistId,
                content: contentController.text.trim());
            Navigator.pop(dialogCtx);
            cubit.createChecklistItem(credentails);
          },
          child: Text(
            'Create',
            style: GoogleFonts.alef(color: Colors.grey.shade700, fontSize: 16),
          ),
        )
      ],
    ),
  );
}

// show update checklist Item dialog
Future<void> _showUpdateChecklistItemDialog(BuildContext context,
    int checklistItemId, int checklistId, ChecklistItemCubit cubit) async {
  final newContentController = TextEditingController();

  await showDialog(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.grey.shade300,
      title: Text(
        'Update Item Title',
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: newContentController,
            decoration: InputDecoration(labelText: 'New Title'),
          )
        ],
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            )),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.grey[350]),
            onPressed: () {
              final credentails = UpdateChecklistItemCredentails(
                  checklistItemId: checklistItemId,
                  checklistId: checklistId,
                  newContent: newContentController.text.trim());
              Navigator.pop(dialogCtx);
              cubit.updateChecklistItem(credentails);
            },
            child: Text(
              'Update',
              style:
                  GoogleFonts.alef(fontSize: 16, color: Colors.grey.shade600),
            ))
      ],
    ),
  );
}

// show confirm delete checklist item dialog
Future<void> _showConfirmDeleteItemDialog(
    BuildContext context, int checklistItemId, ChecklistItemCubit cubit) async {
  await showDialog(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.grey.shade300,
      title: Text(
        'Delete Item',
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      content: Text(
        'Are you sure want to delete this item? This cannot be undone!',
        style: GoogleFonts.alef(fontSize: 16, color: Colors.black87),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            )),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.grey[350]),
            onPressed: () {
              Navigator.pop(dialogCtx);
              cubit.deleteChecklistItem(checklistItemId);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.alef(fontSize: 16, color: Colors.red),
            ))
      ],
    ),
  );
}
