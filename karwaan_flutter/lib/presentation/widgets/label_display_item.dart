import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/label/label.dart';

class LabelDisplayItem extends StatelessWidget {
  final Label label;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Color? labelColor;
  const LabelDisplayItem(
      {super.key,
      required this.label,
      required this.onEdit,
      required this.onDelete,
      this.labelColor});

  @override
  Widget build(BuildContext context) {
    final hex = label.color.replaceFirst('#', '');
    final color = labelColor ?? Color(int.parse('FF$hex', radix: 16));
    final contrastColor = _getContrastColor(color);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // label chip
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2))
                ]),
            child: Text(
              label.title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: contrastColor, fontWeight: FontWeight.w500),
            ),
          )),

          // actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit,
                      size: 20, color: Theme.of(context).iconTheme.color),
                  tooltip: 'Edit Label'),
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.red,
                ),
                tooltip: 'Delete Label',
              )
            ],
          )
        ],
      ),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
