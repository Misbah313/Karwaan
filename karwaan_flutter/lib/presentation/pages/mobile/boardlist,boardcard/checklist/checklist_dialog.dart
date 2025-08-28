import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/checklist/checklist_state.dart';
import 'package:karwaan_flutter/domain/models/checklist/update_checklist_credentails.dart';
import 'package:karwaan_flutter/domain/models/checklist/create_checklist_credentails.dart';
import 'package:karwaan_flutter/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/checklistItem/checklist_item_cubit.dart';
import 'package:karwaan_flutter/domain/repository/checklistItem/checklist_item_repo.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/boardlist,boardcard/checklistItem/checklist_item_dialog.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';

enum _ChecklistAction { update, delete }

class ChecklistDialog extends StatelessWidget {
  final int cardId;
  final ChecklistCubit checklistCubit;

  const ChecklistDialog({
    super.key,
    required this.cardId,
    required this.checklistCubit,
  });

  @override
  Widget build(BuildContext context) {
    checklistCubit.listChecklist(cardId);

    return BlocProvider.value(
      value: checklistCubit,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Checklists',
          style: Theme.of(context).textTheme.bodyLarge
        ),
        content: BlocListener<ChecklistCubit, ChecklistState>(
          listener: (context, state) {
            if (state is ChecklistCreated) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Checklist has been created.'),
                backgroundColor: Colors.green,
              ));
              checklistCubit.listChecklist(cardId);
            }
            if (state is ChecklistError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ));
              Navigator.pop(context);
            }
            if (state is ChecklistDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Checklist has been deleted successfully.'),
                backgroundColor: Colors.green,
              ));
              checklistCubit.listChecklist(cardId);
            }
            if (state is ChecklistUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Checklist has been updated successfully'),
                backgroundColor: Colors.green,
              ));
              checklistCubit.listChecklist(cardId);
            }
          },
          child: BlocBuilder<ChecklistCubit, ChecklistState>(
            builder: (context, state) {
              if (state is ChecklistInitial || state is ChecklistLoading) {
                return Center(
                    child: Lottie.asset('asset/ani/load.json',
                        fit: BoxFit.contain));
              } else if (state is ChecklistListLoaded) {
                final checklist = state.checklist;

                if (checklist.isEmpty) {
                  return Center(
                    child: Text(
                      'No checklist yet!',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: checklist.map((item) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _showChecklistItemDialog(
                              context, item.id!, item.title);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.onSecondary
                              ])),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              PopupMenuButton<_ChecklistAction>(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(10),
                                icon: Icon(Icons.more_horiz,
                                    size: 20, color: Theme.of(context).iconTheme.color),
                                onSelected: (action) {
                                  switch (action) {
                                    case _ChecklistAction.update:
                                      _showUpdateChecklistDialog(
                                          context, checklistCubit, item.id!);
                                      break;
                                    case _ChecklistAction.delete:
                                      _showConfirmDeleteChecklistDialog(
                                          context, checklistCubit, item.id!);
                                      break;
                                  }
                                },
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                      value: _ChecklistAction.update,
                                      child: Text(
                                        'Update',
                                        style: Theme.of(context).textTheme.bodyMedium
                                      )),
                                  PopupMenuItem(
                                      value: _ChecklistAction.delete,
                                      child: Text(
                                        'Delete',
                                        style: Theme.of(context).textTheme.bodyMedium
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
              return Center(
                child: Text('Something went wrong , please try again!', style: Theme.of(context).textTheme.bodyMedium),
              );
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: Theme.of(context).textTheme.titleSmall
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Theme.of(context).colorScheme.primary),
              onPressed: () {
                _showCreateChecklistDialog(context, cardId, checklistCubit);
              },
              child: Text(
                'Create Checklist',
                style: Theme.of(context).textTheme.bodySmall
              ))
        ],
      ),
    );
  }

  // Helper methods (these can stay in this file since they're specific to checklists)
  static Future<void> _showUpdateChecklistDialog(BuildContext context,
      ChecklistCubit checklistCubit, int checklistId) async {
    final newContentController = TextEditingController();
    await showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Update Checklist',
          style: Theme.of(context).textTheme.bodyLarge
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Textfield(text: 'New Title', obsecureText: false, controller: newContentController)
          ],
        ),
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
                final credentails = UpdateChecklistCredentails(
                    checklistId: checklistId,
                    newTitle: newContentController.text.trim());
                Navigator.pop(dialogCtx);
                checklistCubit.updateChecklist(credentails);
              },
              child: Text(
                'Update',
                style: Theme.of(context).textTheme.bodySmall
              ))
        ],
      ),
    );
  }

  static Future<void> _showConfirmDeleteChecklistDialog(BuildContext context,
      ChecklistCubit checklistCubit, int checklistId) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Delete checklist', style: Theme.of(context).textTheme.bodyLarge,),
        content: Text(
          'Are you sure want to delete this checklist? This cannot be undone!!',
          style: Theme.of(context).textTheme.bodyMedium
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.titleSmall
              )),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Theme.of(context).colorScheme.primary
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              checklistCubit.deleteChecklist(checklistId);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.alef(fontSize: 15, color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  static Future<void> _showCreateChecklistDialog(
      BuildContext context, int cardID, ChecklistCubit checklistCubit) async {
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: checklistCubit,
        child: AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Create Checklist',
            style: Theme.of(context).textTheme.bodyLarge
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Textfield(text: 'Title', obsecureText: false, controller: contentController)
            ],
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.titleSmall
                )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Theme.of(context).colorScheme.primary
              ),
              onPressed: () {
                final credentails = CreateChecklistCredentails(
                    cardId: cardID, title: contentController.text.trim());
                Navigator.pop(dialogContext);
                checklistCubit.createChecklist(credentails);
              },
              child: Text(
                'Create',
                style: Theme.of(context).textTheme.bodySmall
              ),
            )
          ],
        ),
      ),
    );
  }

  static void _showChecklistItemDialog(
      BuildContext context, int checklistId, String checklistTitle) {
    showDialog(
        context: context,
        builder: (context) {
          final cubit = ChecklistItemCubit(context.read<ChecklistItemRepo>());
          cubit.listChecklistItem(checklistId);
          return BlocProvider.value(
            value: cubit,
            child: ChecklistItemDialog(
              checklistTitle: checklistTitle,
              checklistId: checklistId,
            ),
          );
        });
  }
}
