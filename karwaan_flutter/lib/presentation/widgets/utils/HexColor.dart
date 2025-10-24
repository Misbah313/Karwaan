import 'package:flutter/material.dart';

// Hex color utility (add this to your utils)
class HexColor extends Color {
  HexColor(super.value);

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
