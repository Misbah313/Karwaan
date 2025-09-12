import 'package:flutter/material.dart';
import 'package:karwaan_client/karwaan_client.dart';

class ExceptionMapper {
  static String toMessage(Object exception) {
    if (exception is AppAuthException) {
      return exception.message;
    } else if (exception is AppPermissionException) {
      return exception.message;
    } else if (exception is AppNotFoundException) {
      return 'The request ${exception.resourceType} was not found.';
    } else if (exception is RandomAppException) {
      return exception.message;
    } else if (exception is AppException) {
      return exception.message;
    }

    final errorString = exception.toString();
    if (errorString.contains('SocketException') ||
        errorString.contains('Connection failed')) {
      return 'No internet connection. Please check your network.';
    } else if (errorString.contains('timed out')) {
      return 'The request timed out. Please try again.';
    }

    debugPrint('Unmapped Exception: $exception');
    return 'An unexpected error occurred. Please try again.';
  }
}
