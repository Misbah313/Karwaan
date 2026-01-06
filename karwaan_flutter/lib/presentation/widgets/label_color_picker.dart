import 'package:flutter/material.dart';

class LabelColorPicker extends StatelessWidget {
  final List<Color> colors;
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;
  final double circleSize;
  final double selectedBorderWidth;
  final Color selectedBorderColor;
  const LabelColorPicker(
      {super.key,
      required this.colors,
      required this.selectedColor,
      required this.onColorSelected,
      this.circleSize = 40,
      this.selectedBorderWidth = 3,
      this.selectedBorderColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: colors.map((color) {
          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                    color: selectedColor == color
                        ? selectedBorderColor
                        : Colors.transparent,
                    width: selectedBorderWidth),
                boxShadow: selectedColor == color
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ]
                    : null,
              ),
            ),
          );
        }).toList());
  }
}
