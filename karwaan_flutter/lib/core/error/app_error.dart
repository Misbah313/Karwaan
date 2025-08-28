class AppError {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  AppError(this.message, {this.code, this.details});

  @override
  String toString() => code == null ? message : '[$code] $message';
}
