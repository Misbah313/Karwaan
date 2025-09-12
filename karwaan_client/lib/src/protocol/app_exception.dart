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

abstract class AppException
    implements _i1.SerializableException, _i1.SerializableModel {
  AppException._({
    required this.message,
    String? code,
  }) : code = code ?? 'GENERIC_ERROR';

  factory AppException({
    required String message,
    String? code,
  }) = _AppExceptionImpl;

  factory AppException.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppException(
      message: jsonSerialization['message'] as String,
      code: jsonSerialization['code'] as String,
    );
  }

  String message;

  String code;

  /// Returns a shallow copy of this [AppException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppException copyWith({
    String? message,
    String? code,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AppExceptionImpl extends AppException {
  _AppExceptionImpl({
    required String message,
    String? code,
  }) : super._(
          message: message,
          code: code,
        );

  /// Returns a shallow copy of this [AppException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppException copyWith({
    String? message,
    String? code,
  }) {
    return AppException(
      message: message ?? this.message,
      code: code ?? this.code,
    );
  }
}
