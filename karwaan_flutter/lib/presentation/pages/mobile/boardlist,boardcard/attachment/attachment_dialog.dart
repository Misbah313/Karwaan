import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/attachment/attachment_state.dart';
import 'package:karwaan_flutter/domain/models/attachment/upload_attachment_credentails.dart';
import 'package:karwaan_flutter/presentation/cubits/attachment/attachment_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';

class AttachmentDialog extends StatelessWidget {
  final int cardId;
  final AttachmentCubit attachmentCubit;
  const AttachmentDialog(
      {super.key, required this.cardId, required this.attachmentCubit});

  @override
  Widget build(BuildContext context) {
    attachmentCubit.listAttachment(cardId);
    return BlocProvider.value(
      value: attachmentCubit,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Attachments',
          style: Theme.of(context).textTheme.bodyLarge
        ),
        content: BlocListener<AttachmentCubit, AttachmentState>(
          listener: (context, state) {
            if (state is AttachmentUploaded) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Attachment has been uploaded.'),
                backgroundColor: Colors.green,
              ));
              attachmentCubit.listAttachment(cardId);
            }
            if (state is AttachmentDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Attachment has been deleted.'),
                backgroundColor: Colors.green,
              ));
              attachmentCubit.listAttachment(cardId);
            }
            if (state is AttachmentError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ));
            }
          },
          child: BlocBuilder<AttachmentCubit, AttachmentState>(
            builder: (context, state) {
              if (state is AttachmentInitial || state is AttachmentLoading) {
                return Center(
                  child:
                      Lottie.asset('asset/ani/load.json', fit: BoxFit.contain),
                );
              } else if (state is AttachmentListLoaded) {
                final attachments = state.attachments;

                if (attachments.isEmpty) {
                  return Center(
                    child: Text('No attachments yet!',
                        style: Theme.of(context).textTheme.bodyMedium)
                  );
                }

                return SingleChildScrollView(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: attachments.map((attachment) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Theme.of(context).colorScheme.secondary, 
                          Theme.of(context).colorScheme.onSecondary
                        ]),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // attachment file name
                          Expanded(
                              child: Text(
                            attachment.fileName,
                            style: Theme.of(context).textTheme.bodyMedium
                          )),

                          // delete icon button
                          IconButton(
                              onPressed: () {
                                _showConfirmDeleteAttachmentDialog(
                                    context, attachmentCubit, attachment.id!);
                              },
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                              ))
                        ],
                      ),
                    );
                  }).toList(),
                ));
              }
              return Center(
                child: Text('Something went wrong, please try again!', style: Theme.of(context).textTheme.bodyMedium),
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
                // show upload attachment dialog
                _showUploadAttachmentDialog(context, attachmentCubit, cardId);
              },
              child: Text(
                'Upload Attachment',
                style: Theme.of(context).textTheme.bodySmall
              ))
        ],
      ),
    );
  }

  // upload attachment dialog
  static Future<void> _showUploadAttachmentDialog(
      BuildContext context, AttachmentCubit cubit, int cardId) async {
    final fileNameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Upload new Attachment',
          style: Theme.of(context).textTheme.bodyLarge
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Textfield(text: 'File Name', obsecureText: false, controller: fileNameController)
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
                final credentails = UploadAttachmentCredentails(
                    cardId: cardId, fileName: fileNameController.text.trim());
                Navigator.pop(dialogCtx);
                cubit.uploadAttachment(credentails);
              },
              child: Text(
                'Upload',
                style: Theme.of(context).textTheme.bodySmall
              ))
        ],
      ),
    );
  }

  // show delete attachment confirmation dilaog
  static Future<void> _showConfirmDeleteAttachmentDialog(
      BuildContext context, AttachmentCubit cubit, int attachmentId) async {
    await showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                'Delete Attachment',
                style: Theme.of(context).textTheme.bodyLarge
              ),
              content: Text(
                'Are you sure want to delete this attachment?',
                style: Theme.of(context).textTheme.bodyMedium
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
                      Navigator.pop(dialogCtx);
                      cubit.deleteAttachment(attachmentId);
                    },
                    child: Text(
                      'Delete',
                      style: GoogleFonts.alef(fontSize: 15, color: Colors.red),
                    ))
              ],
            ));
  }
}
