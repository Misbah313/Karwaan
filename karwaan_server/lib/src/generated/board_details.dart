/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class BoardDetails
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  BoardDetails._({
    required this.id,
    required this.name,
    this.description,
    required this.members,
  });

  factory BoardDetails({
    required int id,
    required String name,
    String? description,
    required List<String> members,
  }) = _BoardDetailsImpl;

  factory BoardDetails.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardDetails(
      id: jsonSerialization['id'] as int,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      members: (jsonSerialization['members'] as List)
          .map((e) => e as String)
          .toList(),
    );
  }

  int id;

  String name;

  String? description;

  List<String> members;

  /// Returns a shallow copy of this [BoardDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardDetails copyWith({
    int? id,
    String? name,
    String? description,
    List<String>? members,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      'members': members.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      'members': members.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardDetailsImpl extends BoardDetails {
  _BoardDetailsImpl({
    required int id,
    required String name,
    String? description,
    required List<String> members,
  }) : super._(
          id: id,
          name: name,
          description: description,
          members: members,
        );

  /// Returns a shallow copy of this [BoardDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardDetails copyWith({
    int? id,
    String? name,
    Object? description = _Undefined,
    List<String>? members,
  }) {
    return BoardDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      members: members ?? this.members.map((e0) => e0).toList(),
    );
  }
}
