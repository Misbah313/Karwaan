import 'package:karwaan_flutter/domain/models/comment/comment.dart';
import 'package:karwaan_flutter/domain/models/comment/comment_with_author.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentForCardListLoaded extends CommentState {
  final List<CommentWithAuthor> comments;

  CommentForCardListLoaded(this.comments);
}

class CommentCreated extends CommentState {
  final Comment comment;

  CommentCreated(this.comment);
}

class CommentUpdated extends CommentState {
  final Comment comment;

  CommentUpdated(this.comment);
}

class CommentDeleted extends CommentState {
  final int commentId;

  CommentDeleted(this.commentId);
}

class CommentError extends CommentState {
  final String error;

  CommentError(this.error);
}
