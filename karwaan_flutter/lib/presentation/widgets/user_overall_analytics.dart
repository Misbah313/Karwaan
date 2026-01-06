import 'package:flutter/material.dart';

class UserOverallAnalytics extends StatefulWidget {
  const UserOverallAnalytics({super.key});

  @override
  State<UserOverallAnalytics> createState() => _UserOverallAnalyticsState();
}

class _UserOverallAnalyticsState extends State<UserOverallAnalytics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          Center(child: Text('All your analytics', style: Theme.of(context).textTheme.bodyMedium,),)
        ],
      ),
    );
  }
}