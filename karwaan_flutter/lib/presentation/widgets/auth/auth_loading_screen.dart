import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthLoadingScreen extends StatelessWidget {
  const AuthLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('asset/ani/dataSecure.json', width: 300, height: 300),
            const SizedBox(height: 20),
            Text('Securing your session...', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}