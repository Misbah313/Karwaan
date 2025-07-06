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

abstract class Attachment implements _i1.SerializableModel {
  Attachment._({
    this.id,
    required this.card,
    required this.uploadedBy,
    required this.fileName,
  });

  factory Attachment({
    int? id,
    required int card,
    required int uploadedBy,
    required String fileName,
  }) = _AttachmentImpl;

  factory Attachment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Attachment(
      id: jsonSerialization['id'] as int?,
      card: jsonSerialization['card'] as int,
      uploadedBy: jsonSerialization['uploadedBy'] as int,
      fileName: jsonSerialization['fileName'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int card;

  int uploadedBy;

  String fileName;

  /// Returns a shallow copy of this [Attachment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Attachment copyWith({
    int? id,
    int? card,
    int? uploadedBy,
    String? fileName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'card': card,
      'uploadedBy': uploadedBy,
      'fileName': fileName,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttachmentImpl extends Attachment {
  _AttachmentImpl({
    int? id,
    required int card,
    required int uploadedBy,
    required String fileName,
  }) : super._(
          id: id,
          card: card,
          uploadedBy: uploadedBy,
          fileName: fileName,
        );

  /// Returns a shallow copy of this [Attachment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Attachment copyWith({
    Object? id = _Undefined,
    int? card,
    int? uploadedBy,
    String? fileName,
  }) {
    return Attachment(
      id: id is int? ? id : this.id,
      card: card ?? this.card,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      fileName: fileName ?? this.fileName,
    );
  }
}
