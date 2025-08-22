/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class CommentWithAuthor implements _i1.SerializableModel {
  CommentWithAuthor._({
    required this.id,
    required this.card,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  factory CommentWithAuthor({
    required int id,
    required int card,
    required int authorId,
    required String authorName,
    required String content,
    required DateTime createdAt,
  }) = _CommentWithAuthorImpl;

  factory CommentWithAuthor.fromJson(Map<String, dynamic> jsonSerialization) {
    return CommentWithAuthor(
      id: jsonSerialization['id'] as int,
      card: jsonSerialization['card'] as int,
      authorId: jsonSerialization['authorId'] as int,
      authorName: jsonSerialization['authorName'] as String,
      content: jsonSerialization['content'] as String,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  int id;

  int card;

  int authorId;

  String authorName;

  String content;

  DateTime createdAt;

  /// Returns a shallow copy of this [CommentWithAuthor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CommentWithAuthor copyWith({
    int? id,
    int? card,
    int? authorId,
    String? authorName,
    String? content,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card': card,
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CommentWithAuthorImpl extends CommentWithAuthor {
  _CommentWithAuthorImpl({
    required int id,
    required int card,
    required int authorId,
    required String authorName,
    required String content,
    required DateTime createdAt,
  }) : super._(
          id: id,
          card: card,
          authorId: authorId,
          authorName: authorName,
          content: content,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [CommentWithAuthor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CommentWithAuthor copyWith({
    int? id,
    int? card,
    int? authorId,
    String? authorName,
    String? content,
    DateTime? createdAt,
  }) {
    return CommentWithAuthor(
      id: id ?? this.id,
      card: card ?? this.card,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
