import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// Các viewType đã đăng ký để không đăng ký trùng khi rebuild.
final Set<String> _registered = <String>{};

/// Tạo iframe Google Maps Embed cho [query] (địa chỉ).
///
/// Dùng endpoint nhúng cơ bản (maps.google.com/maps?...&output=embed) —
/// không cần API key, miễn phí cho mục đích hiển thị.
Widget buildEmbeddedMap(String query, {String? embedUrl}) {
  final viewType = 'gmap-${query.hashCode}';

  if (!_registered.contains(viewType)) {
    _registered.add(viewType);
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final iframe =
          web.document.createElement('iframe') as web.HTMLIFrameElement;
      final configuredUrl = Uri.tryParse(embedUrl ?? '');
      final url =
          configuredUrl != null &&
              configuredUrl.hasScheme &&
              (configuredUrl.host == 'www.google.com' ||
                  configuredUrl.host == 'maps.google.com')
          ? configuredUrl
          : Uri.https('www.google.com', '/maps', {
              'q': query,
              'z': '16',
              'output': 'embed',
            });
      iframe.src = url.toString();
      iframe.style
        ..border = '0'
        ..width = '100%'
        ..height = '100%'
        ..display = 'block';
      iframe.setAttribute('loading', 'lazy');
      iframe.setAttribute('referrerpolicy', 'no-referrer-when-downgrade');
      iframe.setAttribute('title', 'Bản đồ địa điểm');
      iframe.setAttribute('allowfullscreen', '');
      return iframe;
    });
  }

  return HtmlElementView(viewType: viewType);
}
