import 'package:flutter/material.dart';

class BoardChat extends StatefulWidget {
  const BoardChat({super.key});

  @override
  State<BoardChat> createState() => _BoardChatState();
}

class _BoardChatState extends State<BoardChat> {

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.05),
        ),
        child: Center(
          child: Text(
            'Coming Soon..',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ));
  }
}
