import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/attachment/attachment_state.dart';
import 'package:karwaan_flutter/domain/models/attachment/upload_attachment_credentails.dart';
import 'package:karwaan_flutter/presentation/cubits/attachment/attachment_cubit.dart';
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
        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Attachments',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
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
                        style: GoogleFonts.alef(
                            color: Colors.grey.shade600,
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center),
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
                          Colors.blueGrey.shade300,
                          Colors.grey.shade300
                        ]),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // attachment file name
                          Expanded(
                              child: Text(
                            attachment.fileName,
                            style: GoogleFonts.alef(
                                color: Colors.grey.shade600, fontSize: 15),
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
                child: Text('Something went wrong, please try again!'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.grey),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.grey[350]),
              onPressed: () {
                // show upload attachment dialog
                _showUploadAttachmentDialog(context, attachmentCubit, cardId);
              },
              child: Text(
                'Upload Attachment',
                style:
                    GoogleFonts.alef(color: Colors.grey.shade600, fontSize: 16),
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
        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Upload new Attachment',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fileNameController,
              decoration: InputDecoration(labelText: 'File Name'),
            )
          ],
        ),
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
                final credentails = UploadAttachmentCredentails(
                    cardId: cardId, fileName: fileNameController.text.trim());
                Navigator.pop(dialogCtx);
                cubit.uploadAttachment(credentails);
              },
              child: Text(
                'Upload',
                style:
                    GoogleFonts.alef(color: Colors.grey.shade600, fontSize: 16),
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
              backgroundColor: Colors.grey.shade300,
              title: Text(
                'Delete Attachment',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Are you sure want to delete this attachment?',
                style: GoogleFonts.alef(fontSize: 17, color: Colors.black87),
              ),
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
