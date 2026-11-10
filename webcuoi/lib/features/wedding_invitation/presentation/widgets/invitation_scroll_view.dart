import 'package:flutter/material.dart';

import 'scroll_visibility.dart';

/// Keeps the continuous paper background while painting only visible sections.
/// All section states stay mounted, so scrolling never discards an unsent form.
class InvitationScrollView extends StatefulWidget {
  const InvitationScrollView({
    super.key,
    required this.viewportWidth,
    required this.canvasWidth,
    required this.backgroundAsset,
    required this.children,
    this.controller,
  });

  final double viewportWidth;
  final double canvasWidth;
  final String backgroundAsset;
  final List<Widget> children;
  final ScrollController? controller;

  @override
  State<InvitationScrollView> createState() => _InvitationScrollViewState();
}

class _InvitationScrollViewState extends State<InvitationScrollView> {
  final _metrics = _ViewportMetrics();
  bool _metricsPending = false;

  @override
  void dispose() {
    _metrics.dispose();
    super.dispose();
  }

  bool _onMetrics(ScrollMetricsNotification notification) {
    if (notification.depth != 0 || _metricsPending) return false;
    _metricsPending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _metricsPending = false;
      _metrics.changed();
    });
    WidgetsBinding.instance.ensureVisualUpdate();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: _onMetrics,
      child: ScrollViewportMetrics(
        metrics: _metrics,
        child: CustomScrollView(
          controller: widget.controller,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: (widget.viewportWidth - widget.canvasWidth) / 2,
              ),
              sliver: DecoratedSliver(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.backgroundAsset),
                    fit: widget.canvasWidth <= 720
                        ? BoxFit.cover
                        : BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
                sliver: SliverMainAxisGroup(
                  slivers: [
                    for (final child in widget.children)
                      SliverToBoxAdapter(child: child),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewportMetrics extends ChangeNotifier {
  void changed() => notifyListeners();
}
