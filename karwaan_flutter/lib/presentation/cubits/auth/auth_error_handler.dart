// utils/auth_error_handler.dart
import 'package:flutter/material.dart';

class AuthErrorHandler {
  static String getFriendlyErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('invalid credentials') ||
        errorStr.contains('wrong password')) {
      return 'The password you entered is incorrect. Please try again or reset your password.';
    } else if (errorStr.contains('user not found') ||
        errorStr.contains('email not found')) {
      return 'No account found with this email. Please sign up or check your email address.';
    } else if (errorStr.contains('network error') ||
        errorStr.contains('connection failed')) {
      return 'Network connection failed. Please check your internet and try again.';
    } else if (errorStr.contains('email already in use')) {
      return 'This email is already registered. Please log in or use a different email.';
    } else if (errorStr.contains('weak password')) {
      return 'Your password is too weak. Please use at least 6 characters with a mix of letters and numbers.';
    } else if (errorStr.contains('invalid email')) {
      return 'Please enter a valid email address (e.g., user@example.com).';
    } else {
      return 'Something went wrong. Please try again later.';
    }
  }

  static void showErrorDialog(BuildContext context, dynamic error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(getFriendlyErrorMessage(error)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(getFriendlyErrorMessage(error)),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
