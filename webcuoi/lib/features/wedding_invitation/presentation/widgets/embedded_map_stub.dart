import 'package:flutter/material.dart';

/// Fallback cho các nền tảng không phải web: không nhúng iframe được,
/// hiển thị một placeholder nhẹ nhàng.
Widget buildEmbeddedMap(String query, {String? embedUrl}) {
  return const ColoredBox(
    color: Color(0xFFE9E0D2),
    child: Center(
      child: Icon(Icons.map_outlined, color: Color(0xFF8A7868), size: 40),
    ),
  );
}
