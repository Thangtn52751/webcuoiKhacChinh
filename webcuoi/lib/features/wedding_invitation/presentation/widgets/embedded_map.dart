import 'package:flutter/material.dart';

import 'embedded_map_stub.dart'
    if (dart.library.js_interop) 'embedded_map_web.dart';

/// Bản đồ Google Maps nhúng (iframe) dùng cho Flutter Web.
///
/// Trên web: hiển thị iframe Google Maps Embed theo [query] (miễn phí,
/// không cần API key). Trên nền tảng khác: hiển thị placeholder.
class EmbeddedMap extends StatelessWidget {
  const EmbeddedMap({
    super.key,
    required this.query,
    this.embedUrl,
    this.height = 180,
    this.borderRadius = 12,
  });

  /// Chuỗi tìm kiếm địa điểm (địa chỉ) sẽ truyền vào Google Maps.
  final String query;
  final String? embedUrl;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: buildEmbeddedMap(query, embedUrl: embedUrl),
      ),
    );
  }
}
