import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/comment/comment_state.dart';
import 'package:karwaan_flutter/domain/models/comment/comment_with_author.dart';
import 'package:karwaan_flutter/domain/models/comment/create_comment_credentails.dart';
import 'package:karwaan_flutter/domain/models/comment/update_comment_credentails.dart';
import 'package:karwaan_flutter/domain/repository/comment/comment_repo.dart';

class CommentCubit extends Cubit<CommentState> {
  final CommentRepo commentRepo;

  CommentCubit(this.commentRepo) : super(CommentInitial());

  // create comment
  Future<void> createComment(CreateCommentCredentails credentails) async {
    emit(CommentLoading());
    try {
      final created = await commentRepo.createComment(credentails);
      emit(CommentCreated(created));
    } catch (e) {
      emit(CommentError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> createCommentOptimized(
      CreateCommentCredentails credentails) async {
    try {
      final comment = await commentRepo.createComment(credentails);

      if (state is CommentForCardListLoaded) {
        final current = state as CommentForCardListLoaded;
        final updated = List<CommentWithAuthor>.from(current.comments)
          ..add(comment);

        emit(CommentForCardListLoaded(updated));
      } else {
        await getCommentsForCard(credentails.cardId);
      }
    } catch (e) {
      emit(CommentError(ExceptionMapper.toMessage(e)));
    }
  }

  // get comments for card
  Future<void> getCommentsForCard(int cardId) async {
    emit(CommentLoading());
    try {
      final comments = await commentRepo.getCommentsForCard(cardId);
      emit(CommentForCardListLoaded(comments));
    } catch (e) {
      emit(CommentError(ExceptionMapper.toMessage(e)));
    }
  }

  // update comment
  Future<void> udpateComment(UpdateCommentCredentails credentails) async {
    emit(CommentLoading());
    try {
      final updated = await commentRepo.updateComment(credentails);
      emit(CommentUpdated(updated));
    } catch (e) {
      emit(CommentError(ExceptionMapper.toMessage(e)));
    }
  }

  // delete comment
  Future<void> deleteComment(int commentId) async {
    emit(CommentLoading());
    try {
      await commentRepo.deleteComment(commentId);
      emit(CommentDeleted(commentId));
    } catch (e) {
      emit(CommentError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> deleteCommentOptimized(int commentId) async {
    try {
      await commentRepo.deleteComment(commentId);

      if (state is CommentForCardListLoaded) {
        final current = state as CommentForCardListLoaded;
        final updated =
            current.comments.where((c) => c.id != commentId).toList();
        emit(CommentForCardListLoaded(updated));
      }
    } catch (e) {
      emit(CommentError(ExceptionMapper.toMessage(e)));
    }
  }
}
