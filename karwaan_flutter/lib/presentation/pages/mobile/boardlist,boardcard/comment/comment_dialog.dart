import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/comment/comment_state.dart';
import 'package:karwaan_flutter/domain/models/comment/create_comment_credentails.dart';
import 'package:karwaan_flutter/domain/models/comment/update_comment_credentails.dart';
import 'package:karwaan_flutter/presentation/cubits/comment/comment_cubit.dart';
import 'package:lottie/lottie.dart';

enum _CommentActions { update, delete }

class CommentDialog extends StatelessWidget {
  final int cardId;
  final CommentCubit commentCubit;
  const CommentDialog(
      {super.key, required this.cardId, required this.commentCubit});

  @override
  Widget build(BuildContext context) {
    commentCubit.getCommentsForCard(cardId);
    return BlocProvider.value(
      value: commentCubit,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Comments',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: BlocListener<CommentCubit, CommentState>(
          listener: (context, state) {
            if (state is CommentCreated) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Comment has been created.'),
                backgroundColor: Colors.green,
              ));
              commentCubit.getCommentsForCard(cardId);
            }
            if (state is CommentUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Comment has been updated.'),
                backgroundColor: Colors.green,
              ));
              commentCubit.getCommentsForCard(cardId);
            }
            if (state is CommentDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Comment has been deleted.'),
                backgroundColor: Colors.green,
              ));
              commentCubit.getCommentsForCard(cardId);
            }
            if (state is CommentError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ));
            }
          },
          child: BlocBuilder<CommentCubit, CommentState>(
            builder: (context, state) {
              if (state is CommentInitial || state is CommentLoading) {
                return Center(
                  child:
                      Lottie.asset('asset/ani/load.json', fit: BoxFit.contain),
                );
              } else if (state is CommentForCardListLoaded) {
                final comments = state.comments;

                if (comments.isEmpty) {
                  return Center(
                    child: Text(
                      'No comments yet!',
                      style: GoogleFonts.alef(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: comments.map((comment) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Colors.blueGrey.shade300,
                                Colors.grey.shade300
                              ])),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Comment text/content
                              Expanded(
                                  child: ListTile(
                                title: Text(
                                  comment.authorName,
                                  style: GoogleFonts.alef(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                subtitle: Text(
                                  comment.content,
                                  style: GoogleFonts.alef(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),

                              // actions in pop up menu item
                              PopupMenuButton<_CommentActions>(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                                icon: Icon(Icons.more_horiz,
                                    size: 20, color: Colors.grey.shade600),
                                onSelected: (action) {
                                  switch (action) {
                                    case _CommentActions.update:
                                      _showUpdateCommentDialog(
                                          context, comment.id, commentCubit);
                                      break;
                                    case _CommentActions.delete:
                                      _showConfirmDeleteCommentDialog(
                                          context, commentCubit, comment.id);
                                      break;
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: _CommentActions.update,
                                      child: Text(
                                        'Update',
                                        style: GoogleFonts.alef(
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500),
                                      )),
                                  PopupMenuItem(
                                      value: _CommentActions.delete,
                                      child: Text(
                                        'Delete',
                                        style: GoogleFonts.alef(
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500),
                                      )),
                                ],
                              )
                            ],
                          ),
                        );
                      }).toList()),
                );
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
                _showCreateCommentDialog(context, commentCubit, cardId);
              },
              child: Text(
                'Add Comment',
                style:
                    GoogleFonts.alef(color: Colors.grey.shade600, fontSize: 16),
              ))
        ],
      ),
    );
  }

  // create comment dialog
  static Future<void> _showCreateCommentDialog(
      BuildContext context, CommentCubit cubit, int cardId) async {
    final contentController = TextEditingController();
    await showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Add Comment',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
            )
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
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
                final credentails = CreateCommentCredentails(
                    cardId: cardId, content: contentController.text.trim());
                Navigator.pop(dialogCtx);
                cubit.createComment(credentails);
              },
              child: Text(
                'Create',
                style:
                    GoogleFonts.alef(color: Colors.grey.shade600, fontSize: 16),
              ))
        ],
      ),
    );
  }

// update comment dialog
  static Future<void> _showUpdateCommentDialog(
      BuildContext context, int commentId, CommentCubit cubit) async {
    final newContentController = TextEditingController();
    await showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: Colors.grey.shade300,
              title: Text(
                'Update Comment',
                style: GoogleFonts.alef(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: newContentController,
                    decoration: InputDecoration(labelText: 'New Content'),
                  )
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
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
                      final credentails = UpdateCommentCredentails(
                          commentId: commentId,
                          newContent: newContentController.text.trim());
                      Navigator.pop(dialogCtx);
                      cubit.udpateComment(credentails);
                    },
                    child: Text(
                      'Update',
                      style: GoogleFonts.alef(
                          color: Colors.grey.shade600, fontSize: 16),
                    ))
              ],
            ));
  }

// delete comment dialog
  static Future<void> _showConfirmDeleteCommentDialog(
      BuildContext context, CommentCubit cubit, int commentId) async {
    await showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: Colors.grey.shade300,
              title: Text(
                'Delete Comment',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Are you sure want to delete this comment?',
                style: GoogleFonts.alef(
                  fontSize: 17,
                  color: Colors.black87,
                ),
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
                      cubit.deleteComment(commentId);
                    },
                    child: Text(
                      'Delete',
                      style: GoogleFonts.alef(color: Colors.red, fontSize: 17),
                    ))
              ],
            ));
  }
}
