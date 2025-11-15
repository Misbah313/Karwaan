import 'package:flutter/material.dart';

class UserAllboardsPage extends StatefulWidget {
  const UserAllboardsPage({super.key});

  @override
  State<UserAllboardsPage> createState() => _UserAllboardsPageState();
}

class _UserAllboardsPageState extends State<UserAllboardsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          Center(child: Text('All your boards', style: Theme.of(context).textTheme.bodyMedium,),)
        ],
      ),
    );
  }
}