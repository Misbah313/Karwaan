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

abstract class AppNotFoundException
    implements _i1.SerializableException, _i1.SerializableModel {
  AppNotFoundException._({required this.resourceType});

  factory AppNotFoundException({required String resourceType}) =
      _AppNotFoundExceptionImpl;

  factory AppNotFoundException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return AppNotFoundException(
        resourceType: jsonSerialization['resourceType'] as String);
  }

  String resourceType;

  /// Returns a shallow copy of this [AppNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppNotFoundException copyWith({String? resourceType});
  @override
  Map<String, dynamic> toJson() {
    return {'resourceType': resourceType};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AppNotFoundExceptionImpl extends AppNotFoundException {
  _AppNotFoundExceptionImpl({required String resourceType})
      : super._(resourceType: resourceType);

  /// Returns a shallow copy of this [AppNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppNotFoundException copyWith({String? resourceType}) {
    return AppNotFoundException(
        resourceType: resourceType ?? this.resourceType);
  }
}
