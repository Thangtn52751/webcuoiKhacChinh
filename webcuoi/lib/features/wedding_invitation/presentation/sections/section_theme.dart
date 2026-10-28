import 'package:flutter/material.dart';

/// Màu sắc và style dùng chung cho các section trong trang nội dung thiệp,
/// đồng bộ với tông "Minimalism Nâu" trong mẫu Figma.
class SectionTheme {
  SectionTheme._();

  /// Nâu đậm cho tiêu đề và chữ chính.
  static const Color ink = Color(0xFF6E5B4F);

  /// Nâu nhạt cho chữ phụ, ngày tháng.
  static const Color inkSoft = Color(0xFF8A7868);

  /// Màu chữ rất nhạt cho ghi chú (âm lịch...).
  static const Color inkMuted = Color(0xFFA79686);

  /// Nền thẻ giấy kem.
  static const Color paperCard = Color(0xFFF3ECE0);

  /// Màu đường kẻ/viền mảnh.
  static const Color hairline = Color(0xFFD8C9B6);

  /// Dòng nhãn nhỏ in hoa, giãn chữ (vd "THÔNG TIN LỄ CƯỚI").
  static TextStyle label(double scale) => TextStyle(
    color: ink,
    fontSize: 15 * scale,
    letterSpacing: 3 * scale,
    fontWeight: FontWeight.w600,
  );

  /// Tiêu đề lớn kiểu serif nghiêng (tên cặp đôi).
  static TextStyle displayName(double scale) => TextStyle(
    color: ink,
    fontSize: 32 * scale,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  /// Nhãn uppercase nhỏ giãn chữ phía trên tên ("THE WEDDING OF").
  static TextStyle overline(double scale) => TextStyle(
    color: inkSoft,
    fontSize: 12 * scale,
    letterSpacing: 4 * scale,
    fontWeight: FontWeight.w500,
  );

  /// Chữ nội dung thường.
  static TextStyle body(double scale) =>
      TextStyle(color: ink, fontSize: 15 * scale, height: 1.5);
}
