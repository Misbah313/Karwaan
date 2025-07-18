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
import 'user.dart' as _i2;

abstract class AuthResponse implements _i1.SerializableModel {
  AuthResponse._({
    required this.user,
    required this.token,
  });

  factory AuthResponse({
    required _i2.User user,
    required String token,
  }) = _AuthResponseImpl;

  factory AuthResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthResponse(
      user: _i2.User.fromJson(
          (jsonSerialization['user'] as Map<String, dynamic>)),
      token: jsonSerialization['token'] as String,
    );
  }

  _i2.User user;

  String token;

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthResponse copyWith({
    _i2.User? user,
    String? token,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AuthResponseImpl extends AuthResponse {
  _AuthResponseImpl({
    required _i2.User user,
    required String token,
  }) : super._(
          user: user,
          token: token,
        );

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthResponse copyWith({
    _i2.User? user,
    String? token,
  }) {
    return AuthResponse(
      user: user ?? this.user.copyWith(),
      token: token ?? this.token,
    );
  }
}
