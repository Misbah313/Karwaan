import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorCardsView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorCardsView(
      {super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('asset/ani/error.json', height: 120, repeat: false),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).iconTheme.color,
              ),
              label: Text(
                'Retry',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
