import 'package:flutter/material.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';

abstract class LogoutDialogService {
  void showLogoutDialog(BuildContext context);
}

class LogoutDialogServiceImpl implements LogoutDialogService {
  final AuthCubit authCubit;

  LogoutDialogServiceImpl({required this.authCubit});

  @override
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildLogoutDialog(context),
    );
  }

  Widget _buildLogoutDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.all(30),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDialogContent(context),
              _buildDialogActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Logout',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          'Are you sure want to logout from this account?',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildDialogActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.03),
          ),
          onPressed: () {
            Navigator.pop(context);
            authCubit.logout();
          },
          child: Text(
            'Logout',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
