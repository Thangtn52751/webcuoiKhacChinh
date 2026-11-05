import 'package:flutter/material.dart';

class SectionTheme {
  SectionTheme._();
  static const String fontFamily = 'CormorantGaramond';
  static const Color ink = Color(0xFF6E5B4F);
  static const Color inkSoft = Color(0xFF8A7868);
  static const Color inkMuted = Color(0xFFA79686);
  static const Color paperCard = Color(0xFFF3ECE0);
  static const Color hairline = Color(0xFFD8C9B6);

  static TextStyle label(double scale) => TextStyle(
    color: inkSoft,
    fontFamily: fontFamily,
    fontSize: 15 * scale,
    letterSpacing: 3 * scale,
    fontWeight: FontWeight.w600,
  );

  static TextStyle displayName(double scale) => TextStyle(
    color: inkSoft,
    fontFamily: fontFamily,
    fontSize: 32 * scale,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static TextStyle overline(double scale) => TextStyle(
    color: inkSoft,
    fontFamily: fontFamily,
    fontSize: 12 * scale,
    letterSpacing: 4 * scale,
    fontWeight: FontWeight.w500,
  );

  static TextStyle body(double scale) => TextStyle(
    color: inkSoft,
    fontFamily: fontFamily,
    fontSize: 15 * scale,
    height: 1.5,
  );
}
