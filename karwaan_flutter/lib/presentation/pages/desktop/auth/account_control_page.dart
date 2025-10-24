import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AccountControlPage extends StatefulWidget {
  const AccountControlPage({super.key});

  @override
  State<AccountControlPage> createState() => _AccountControlPageState();
}

class _AccountControlPageState extends State<AccountControlPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Center(
            child:
                Lottie.asset('asset/ani/development.json', fit: BoxFit.cover),
          )
        ],
      ),
    );
  }
}
