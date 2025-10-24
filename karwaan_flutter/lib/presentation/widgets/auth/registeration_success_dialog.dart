import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegistrationSuccessDialog extends StatelessWidget {
  final VoidCallback onContinue;

  const RegistrationSuccessDialog({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return _buildBaseDialog(
      context: context,
      animation: 'asset/ani/registered.json',
      title: 'Welcome Aboard! 🎉',
      description:
          'Your account has been successfully created.\nPlease login with your credentials to continue.',
      buttonText: 'Continue to Login',
      onPressed: onContinue,
    );
  }

  Widget _buildBaseDialog({
    required String animation,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    return Center(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color:
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              animation,
              width: 300,
              height: 200,
              repeat: false,
            ),
            const SizedBox(height: 24),
            Text(title,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: onPressed,
              child: Text(buttonText,
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}
