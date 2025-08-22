import 'package:karwaan_flutter/domain/models/comment/comment.dart';
import 'package:karwaan_flutter/domain/models/comment/comment_with_author.dart';
import 'package:karwaan_flutter/domain/models/comment/create_comment_credentails.dart';
import 'package:karwaan_flutter/domain/models/comment/update_comment_credentails.dart';

abstract class CommentRepo {
  Future<Comment> createComment(CreateCommentCredentails credentails);
  Future<List<CommentWithAuthor>> getCommentsForCard(int cardId);
  Future<Comment> updateComment(UpdateCommentCredentails credentails);
  Future<bool> deleteComment(int commentId);
}
