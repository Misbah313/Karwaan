class TokenExpiredExceptions implements Exception {
  final String message;
  TokenExpiredExceptions([this.message = 'Token expired or invalid']);

  @override
  String toString() => 'TokenExpiredException: $message';
}
