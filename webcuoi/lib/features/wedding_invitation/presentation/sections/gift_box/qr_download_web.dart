import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

Future<bool> downloadQrAsset(String assetPath, String fileName) async {
  try {
    final data = await rootBundle.load(assetPath);
    final imageBytes = data.buffer.asUint8List();
    final parts = <web.BlobPart>[imageBytes.toJS].toJS;
    final blob = web.Blob(parts, web.BlobPropertyBag(type: 'image/jpeg'));
    final objectUrl = web.URL.createObjectURL(blob);
    final link = web.document.createElement('a') as web.HTMLAnchorElement;
    link.href = objectUrl;
    link.download = fileName;
    link.style.display = 'none';
    web.document.body?.appendChild(link);
    link.click();
    link.remove();
    unawaited(
      Future<void>.delayed(
        const Duration(seconds: 1),
        () => web.URL.revokeObjectURL(objectUrl),
      ),
    );
    return true;
  } catch (_) {
    return false;
  }
}
