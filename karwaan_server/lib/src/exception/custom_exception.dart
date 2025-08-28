import 'dart:convert';

class AppException implements Exception {
  final String message;
  final String code;
  final Map<String, dynamic>? details;

  AppException(
    this.message, {
    this.code = 'APP_ERROR',
    this.details,
  });

  @override
  String toString() {
    // Format: [CODE] message :: { ...json... }
    final detailsPart = (details == null) ? '' : ' :: ${jsonEncode(details)}';
    return '[$code] $message$detailsPart';
  }
}

class PermissionDeniedException extends AppException {
  PermissionDeniedException(super.message) : super(code: 'PERMISSION_DENIED');
}

class ValidationException extends AppException {
  ValidationException(super.message, {super.details})
      : super(code: 'VALIDATION_ERROR');
}

class NotFoundException extends AppException {
  NotFoundException(super.message) : super(code: 'NOT_FOUND');
}

class AuthException extends AppException {
  AuthException(super.message) : super(code: 'AUTH_ERROR');
}
