import 'package:flutter/material.dart';

class SideBarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const SideBarItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.selected,
      required this.onTap});

  @override
  State<SideBarItem> createState() => _SideBarItemState();
}

class _SideBarItemState extends State<SideBarItem> {
  bool hoverd = false;
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selected;
    return MouseRegion(
      onEnter: (_) => setState(() => hoverd = true),
      onExit: (_) => setState(() => hoverd = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue.withValues(alpha: 0.12)
                  : hoverd
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: isSelected
                    ? Colors.blue
                    : Theme.of(context).iconTheme.color?.withValues(alpha: 0.9),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(widget.label,
                  style: isSelected
                      ? Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.blue.withValues(alpha: 0.9))
                      : Theme.of(context).textTheme.bodySmall)
            ],
          ),
        ),
      ),
    );
  }
}
