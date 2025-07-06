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

abstract class CardLabel implements _i1.SerializableModel {
  CardLabel._({
    this.id,
    required this.card,
    required this.label,
  });

  factory CardLabel({
    int? id,
    required int card,
    required int label,
  }) = _CardLabelImpl;

  factory CardLabel.fromJson(Map<String, dynamic> jsonSerialization) {
    return CardLabel(
      id: jsonSerialization['id'] as int?,
      card: jsonSerialization['card'] as int,
      label: jsonSerialization['label'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int card;

  int label;

  /// Returns a shallow copy of this [CardLabel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CardLabel copyWith({
    int? id,
    int? card,
    int? label,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'card': card,
      'label': label,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CardLabelImpl extends CardLabel {
  _CardLabelImpl({
    int? id,
    required int card,
    required int label,
  }) : super._(
          id: id,
          card: card,
          label: label,
        );

  /// Returns a shallow copy of this [CardLabel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CardLabel copyWith({
    Object? id = _Undefined,
    int? card,
    int? label,
  }) {
    return CardLabel(
      id: id is int? ? id : this.id,
      card: card ?? this.card,
      label: label ?? this.label,
    );
  }
}
