import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/client/serverpod_client_service.dart';
import 'package:karwaan_flutter/domain/models/comment/comment.dart';
import 'package:karwaan_flutter/domain/models/comment/comment_with_author.dart';
import 'package:karwaan_flutter/domain/models/comment/create_comment_credentails.dart';
import 'package:karwaan_flutter/domain/models/comment/update_comment_credentails.dart';
import 'package:karwaan_flutter/domain/repository/comment/comment_repo.dart';

class CommentRemoteRepo extends CommentRepo {
  final ServerpodClientService _clientService;

  CommentRemoteRepo(this._clientService);

  @override
  Future<CommentWithAuthor> createComment(
      CreateCommentCredentails credentails) async {
    try {
      final created = await _clientService.createComment(
          credentails.cardId, credentails.content);
      if (created.id == null) {
        throw Exception('Server returned null id!');
      }
      return CommentWithAuthor(
          id: created.id,
          cardId: created.card,
          authorId: created.authorId,
          authorName: created.authorName,
          content: created.content,
          createdAt: created.createdAt);
    } catch (e) {
      debugPrint('Failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<CommentWithAuthor>> getCommentsForCard(int cardId) async {
    try {
      final comments = await _clientService.getCommentsForCard(cardId);
      return comments
          .map((e) => CommentWithAuthor(
              id: e.id,
              cardId: e.card,
              authorId: e.authorId,
              authorName: e.authorName,
              content: e.content,
              createdAt: e.createdAt))
          .toList();
    } catch (e) {
      debugPrint('Failed from remote repo " ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<Comment> updateComment(UpdateCommentCredentails credentails) async {
    try {
      final update = await _clientService.updateComment(
          credentails.commentId, credentails.newContent);
      return Comment(
          id: update.id, content: update.content, author: update.author);
    } catch (e) {
      debugPrint('Failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<bool> deleteComment(int commentId) async {
    try {
      return await _clientService.deleteComment(commentId);
    } catch (e) {
      debugPrint('Failed from remote repo: ${e.toString()}');
      rethrow;
    }
  }
}
