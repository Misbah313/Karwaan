import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:karwaan_client/karwaan_client.dart';
import 'package:karwaan_flutter/core/error/app_error.dart';

class ErrorUtils {
  static final _pattern = RegExp(
      r'^\[(?<code>[A-Z_]+)\]\s*(?<text>.*?)(?:\s*::\s*(?<json>\{.*\}))?$');

  static AppError handleError(dynamic error) {
    debugPrint('Raw error: $error  type: ${error.runtimeType}');

    if (error is AppError) return error; // allow throwing AppError locally
    if (error is String) return AppError(error);

    if (error is ServerpodClientException) {
      final raw = error.message;
      return _parseServerMessage(raw);
    }

    if (error is Exception) {
      // Some local Exceptions (e.g., token missing)
      return _parseServerMessage(error.toString());
    }

    return AppError('Something went wrong. Please try again.');
  }

  static AppError _parseServerMessage(String raw) {
    final m = _pattern.firstMatch(raw);
    if (m == null) {
      return AppError(raw); // fallback: show the text as-is
    }

    final code = m.namedGroup('code');
    final text = m.namedGroup('text')?.trim() ?? raw;

    Map<String, dynamic>? details;
    final jsonStr = m.namedGroup('json');
    if (jsonStr != null) {
      try {
        details = jsonDecode(jsonStr) as Map<String, dynamic>;
      } catch (_) {}
    }

    // Optionally map codes to nicer messages (keep it minimal & clean)
    switch (code) {
      case 'AUTH_ERROR':
        return AppError('Please login again.', code: code, details: details);
      case 'PERMISSION_DENIED':
        return AppError('You don\'t have permission to perform this action.',
            code: code, details: details);
      case 'NOT_FOUND':
        return AppError('Resource not found.', code: code, details: details);
      case 'VALIDATION_ERROR':
        // Prefer backend message so you see which field failed (and use details in the UI)
        return AppError(text.isEmpty ? 'Invalid input.' : text,
            code: code, details: details);
      default:
        return AppError(text.isEmpty ? 'Unexpected error.' : text,
            code: code, details: details);
    }
  }

  // unified UI helper
  static void showError(BuildContext context, dynamic error) {
    final appError = handleError(error);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(appError.message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ));
  }
}
