import 'package:flutter/material.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/HexColor.dart';

class BackgroundColorSelector extends StatefulWidget {
  final String initialColor;
  final ValueChanged<String> onColorSelected;
  const BackgroundColorSelector(
      {super.key, required this.initialColor, required this.onColorSelected});

  @override
  State<BackgroundColorSelector> createState() =>
      _BackgroundColorSelectorState();
}

class _BackgroundColorSelectorState extends State<BackgroundColorSelector> {
  late String selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      '#3B82F6',
      '#8B5CF6',
      '#10B981',
      '#F59E0B',
      '#EF4444',
      '#6B7280'
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () {
            setState(() => selectedColor = color);
            widget.onColorSelected(color); // update backend
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: HexColor.fromHex(color),
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    selectedColor == color ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
