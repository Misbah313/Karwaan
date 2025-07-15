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

abstract class CheckListItem implements _i1.SerializableModel {
  CheckListItem._({
    this.id,
    required this.checklist,
    required this.content,
    required this.isDone,
    required this.createdBy,
  });

  factory CheckListItem({
    int? id,
    required int checklist,
    required String content,
    required bool isDone,
    required int createdBy,
  }) = _CheckListItemImpl;

  factory CheckListItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return CheckListItem(
      id: jsonSerialization['id'] as int?,
      checklist: jsonSerialization['checklist'] as int,
      content: jsonSerialization['content'] as String,
      isDone: jsonSerialization['isDone'] as bool,
      createdBy: jsonSerialization['createdBy'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int checklist;

  String content;

  bool isDone;

  int createdBy;

  /// Returns a shallow copy of this [CheckListItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CheckListItem copyWith({
    int? id,
    int? checklist,
    String? content,
    bool? isDone,
    int? createdBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'checklist': checklist,
      'content': content,
      'isDone': isDone,
      'createdBy': createdBy,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CheckListItemImpl extends CheckListItem {
  _CheckListItemImpl({
    int? id,
    required int checklist,
    required String content,
    required bool isDone,
    required int createdBy,
  }) : super._(
          id: id,
          checklist: checklist,
          content: content,
          isDone: isDone,
          createdBy: createdBy,
        );

  /// Returns a shallow copy of this [CheckListItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CheckListItem copyWith({
    Object? id = _Undefined,
    int? checklist,
    String? content,
    bool? isDone,
    int? createdBy,
  }) {
    return CheckListItem(
      id: id is int? ? id : this.id,
      checklist: checklist ?? this.checklist,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
