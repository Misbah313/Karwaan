import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/checklistItem/checklist_item_state.dart';
import 'package:karwaan_flutter/domain/models/checklistItem/create_checklist_item_credentails.dart';
import 'package:karwaan_flutter/domain/models/checklistItem/update_checklist_item_credentails.dart';
import 'package:karwaan_flutter/presentation/cubits/checklistItem/checklist_item_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        checklistTitle,
        style: Theme.of(context).textTheme.bodyLarge
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
                    style: Theme.of(context).textTheme.bodyMedium,
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
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.onSecondary
                        ]),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.blueGrey.shade100, blurRadius: 3)
                        ]),
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.green,
                          checkColor: Colors.grey.shade300,
                          side: BorderSide(color: Theme.of(context).dividerColor),
                          value: item.isDone,
                          onChanged: (value) {
                            cubit.toggleChecklistItem(item.id!);
                            cubit.listChecklistItem(checklistId);
                          },
                        ),
                        Expanded(
                          child: Text(
                            item.content,
                            style: Theme.of(context).textTheme.bodySmall
                          ),
                        ),
                        PopupMenuButton<String>(
                          color: Theme.of(context).scaffoldBackgroundColor,
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
                          itemBuilder: (_) =>  [
                            PopupMenuItem(
                              value: 'Update',
                              child: Text('Update', style: Theme.of(context).textTheme.bodyMedium),
                            ),
                            PopupMenuItem(
                              value: 'Delete',
                              child: Text('Delete', style: Theme.of(context).textTheme.bodyMedium,),
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
                  style: Theme.of(context).textTheme.bodyMedium
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
            style: Theme.of(context).textTheme.titleSmall
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Theme.of(context).colorScheme.primary),
          onPressed: () {
            // show create checklist item dialog
            _showCreateChecklistItemDialog(context, cubit, checklistId);
          },
          child: Text(
            'Create Item',
            style: Theme.of(context).textTheme.bodySmall
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        'Create new Item',
        style: Theme.of(context).textTheme.bodyLarge
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Textfield(text: 'Title', obsecureText: false, controller: contentController),
        ],
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleSmall
            )),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Theme.of(context).colorScheme.primary
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
            style: Theme.of(context).textTheme.bodySmall
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        'Update Item Title',
        style: Theme.of(context).textTheme.bodyLarge
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Textfield(text: 'New Title', obsecureText: false, controller: newContentController),
        ],
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleSmall
            )),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Theme.of(context).colorScheme.primary),
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
              style: Theme.of(context).textTheme.bodySmall
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        'Delete Item',
        style: Theme.of(context).textTheme.bodyLarge
      ),
      content: Text(
        'Are you sure want to delete this item? This cannot be undone!',
        style: Theme.of(context).textTheme.bodyMedium
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleSmall
            )),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Theme.of(context).colorScheme.primary),
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
