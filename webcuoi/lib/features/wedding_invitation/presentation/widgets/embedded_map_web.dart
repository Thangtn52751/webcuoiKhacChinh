import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

Widget buildEmbeddedMap(String query, {String? embedUrl}) =>
    _GoogleMapFrame(query: query, embedUrl: embedUrl);

class _GoogleMapFrame extends StatefulWidget {
  const _GoogleMapFrame({required this.query, this.embedUrl});

  final String query;
  final String? embedUrl;

  @override
  State<_GoogleMapFrame> createState() => _GoogleMapFrameState();
}

class _GoogleMapFrameState extends State<_GoogleMapFrame>
    with WidgetsBindingObserver {
  web.HTMLIFrameElement? _iframe;
  bool _suspended = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final state = WidgetsBinding.instance.lifecycleState;
    _suspended =
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached;
  }

  Uri get _uri {
    final configuredUrl = Uri.tryParse(widget.embedUrl ?? '');
    if (configuredUrl != null &&
        configuredUrl.hasScheme &&
        (configuredUrl.host == 'www.google.com' ||
            configuredUrl.host == 'maps.google.com')) {
      return configuredUrl;
    }
    return Uri.https('www.google.com', '/maps', {
      'q': widget.query,
      'z': '16',
      'output': 'embed',
    });
  }

  @override
  void didUpdateWidget(covariant _GoogleMapFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query ||
        oldWidget.embedUrl != widget.embedUrl) {
      if (!_suspended) _iframe?.src = _uri.toString();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // Hidden apps may not paint another Flutter frame, so stop the embedded
      // document directly instead of relying only on a parent rebuild.
      _suspended = true;
      _iframe?.src = 'about:blank';
    } else if (state == AppLifecycleState.resumed && _suspended) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted ||
            !_suspended ||
            WidgetsBinding.instance.lifecycleState !=
                AppLifecycleState.resumed) {
          return;
        }
        _suspended = false;
        _iframe?.src = _uri.toString();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Stop the embedded document before Flutter releases its platform view.
    // A hidden map must not keep its Google Maps document running offscreen.
    _iframe?.src = 'about:blank';
    _iframe = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HtmlElementView.fromTagName(
    tagName: 'iframe',
    onElementCreated: (element) {
      final iframe = element as web.HTMLIFrameElement;
      _iframe = iframe;
      iframe.src = _suspended ? 'about:blank' : _uri.toString();
      iframe.style
        ..border = '0'
        ..width = '100%'
        ..height = '100%'
        ..display = 'block';
      iframe.setAttribute('loading', 'lazy');
      iframe.setAttribute('referrerpolicy', 'no-referrer-when-downgrade');
      iframe.setAttribute('title', 'Bản đồ địa điểm');
      iframe.setAttribute('allowfullscreen', '');
    },
  );
}
