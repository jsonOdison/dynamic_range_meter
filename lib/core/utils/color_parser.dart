import 'package:flutter/material.dart';

class ColorParser {
  /// Parses a hex color string (e.g., "#FF0000" or "FF0000") to a [Color].
  /// Supports optional alpha channel (e.g., "#80FF0000" for 50% opacity).
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.startsWith('#')) hexString = hexString.substring(1);
    if (hexString.length == 6) buffer.write('ff'); // Default alpha to 100%
    buffer.write(hexString);
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
