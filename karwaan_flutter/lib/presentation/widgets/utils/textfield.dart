import 'package:flutter/material.dart';

class Textfield extends StatefulWidget {
  final String text;
  final bool obsecureText;
  final TextEditingController controller;
  final int maxline;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmit;
  const Textfield({
    super.key,
    required this.text,
    required this.obsecureText,
    required this.controller,
    this.maxline = 1,
    this.onChanged,
    this.onSubmit
  });

  @override
  State<Textfield> createState() => _TextfieldState();
}

class _TextfieldState extends State<Textfield> {
  @override
  Widget build(BuildContext context) {
    return  TextField(
      onSubmitted: widget.onSubmit,
      onChanged: widget.onChanged,
        controller: widget.controller,
        obscureText: widget.obsecureText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16),
        cursorColor: Theme.of(context).dividerColor.withValues(alpha: 0.7),
        maxLines: widget.maxline,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            gapPadding: 1,
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary,
          hintText: widget.text,
          hintStyle: Theme.of(context).textTheme.bodyMedium,
        ),
      );
  }
}
