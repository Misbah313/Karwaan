import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AccountDeletedDialog extends StatelessWidget {
  final VoidCallback onCreateNewAccount;
  final VoidCallback onClose;

  const AccountDeletedDialog({
    super.key,
    required this.onCreateNewAccount,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
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
            Lottie.asset('asset/ani/deleted.json',
                width: 120, height: 120, repeat: false),
            const SizedBox(height: 24),
            Text('Account Deleted',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(
              'Your account has been successfully deleted.\nWe\'re sorry to see you go.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: onCreateNewAccount,
                  child: Text('Create New Account',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: onClose,
                  child: Text('Close',
                      style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
