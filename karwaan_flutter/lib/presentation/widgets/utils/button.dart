import 'package:flutter/material.dart';

// In your button.dart file
class Button extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Widget? child;
  final bool isLoading;

  const Button({
    super.key,
    required this.text,
    this.onTap,
    this.child,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        decoration: BoxDecoration(
          gradient:  LinearGradient(
            colors: [Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.onSurface],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : child ??
                  Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
        ),
      ),
    );
  }
}
