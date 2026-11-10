import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A stable scope: metric changes notify callbacks, not widget dependencies.
class ScrollViewportMetrics extends InheritedWidget {
  const ScrollViewportMetrics({
    super.key,
    required this.metrics,
    required super.child,
  });

  final Listenable metrics;

  static Listenable? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ScrollViewportMetrics>()
      ?.metrics;

  @override
  bool updateShouldNotify(ScrollViewportMetrics oldWidget) =>
      oldWidget.metrics != metrics;
}

/// Refreshes visibility for both user scrolling and viewport/content resizing.
class ScrollViewportObserver {
  ScrollViewportObserver(this.onChange);

  final VoidCallback onChange;
  ScrollPosition? _position;
  Listenable? _metrics;

  ScrollPosition? get position => _position;

  void attach(BuildContext context) {
    final nextPosition = Scrollable.maybeOf(context)?.position;
    final nextMetrics = ScrollViewportMetrics.of(context);
    if (!identical(_position, nextPosition)) {
      _position?.removeListener(onChange);
      _position = nextPosition;
      _position?.addListener(onChange);
    }
    if (!identical(_metrics, nextMetrics)) {
      _metrics?.removeListener(onChange);
      _metrics = nextMetrics;
      _metrics?.addListener(onChange);
    }
  }

  void dispose() {
    _position?.removeListener(onChange);
    _metrics?.removeListener(onChange);
  }
}

/// Uses document offsets, since offscreen sliver paint offsets can be clamped
/// to the viewport edge and are not reliable for visibility detection.
bool isInScrollViewport(BuildContext context, ScrollPosition? position) {
  final renderObject = context.findRenderObject();
  if (renderObject is! RenderBox || !renderObject.hasSize) return false;

  final viewport = RenderAbstractViewport.maybeOf(renderObject);
  if (position != null && position.hasContentDimensions && viewport != null) {
    final start = viewport.getOffsetToReveal(renderObject, 0).offset;
    final end = start + renderObject.size.height;
    return end > position.pixels &&
        start < position.pixels + position.viewportDimension;
  }

  final top = renderObject.localToGlobal(Offset.zero).dy;
  return top + renderObject.size.height > 0 &&
      top < MediaQuery.heightOf(context);
}
