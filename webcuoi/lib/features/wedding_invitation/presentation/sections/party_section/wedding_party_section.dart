import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../widgets/scroll_visibility.dart';
import 'widgets/party_section_actions.dart';
import 'widgets/wedding_calendar_card.dart';
import 'widgets/wedding_event_information.dart';

class WeddingPartySection extends StatefulWidget {
  const WeddingPartySection({super.key, required this.scale});

  final double scale;

  @override
  State<WeddingPartySection> createState() => _WeddingPartySectionState();
}

class _WeddingPartySectionState extends State<WeddingPartySection> {
  bool _isVisible = false;
  late final _viewportObserver = ScrollViewportObserver(_updateVisibility);
  ScrollPosition? get _scrollPosition => _viewportObserver.position;

  static const _artworkWidth = 900.0;
  static const _artworkHeight = 1077.0;
  static const _cardLeft = 0.2288;
  static const _cardRight = 0.1492;
  static const _cardTop = 65 / _artworkHeight;
  static const _cardBottom = 68 / _artworkHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibility());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewportObserver.attach(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibility());
  }

  @override
  void dispose() {
    _viewportObserver.dispose();
    super.dispose();
  }

  void _updateVisibility() {
    if (!mounted) return;
    final visible = isInScrollViewport(context, _scrollPosition);
    if (visible == _isVisible) return;
    setState(() => _isVisible = visible);
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;
    final screenWidth = MediaQuery.widthOf(context);
    final isCompact = screenWidth < 600;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24 * scale),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : screenWidth;
          return _buildCard(availableWidth, scale, isCompact: isCompact);
        },
      ),
    );
  }

  Widget _buildCard(
    double availableWidth,
    double scale, {
    required bool isCompact,
  }) {
    final cardWidthFraction = 1 - _cardLeft - _cardRight;
    final artworkWidth = math.min(
      _artworkWidth * scale,
      isCompact ? availableWidth * 0.88 / cardWidthFraction : availableWidth,
    );
    final naturalArtworkHeight = artworkWidth * _artworkHeight / _artworkWidth;
    final cardWidth = artworkWidth * cardWidthFraction;
    final cardLeft = (availableWidth - cardWidth) / 2;
    final contentInset = isCompact
        ? (cardWidth * 0.05).clamp(14.0, 20.0)
        : 18 * scale;
    final contentWidth = cardWidth - contentInset * 2;
    final calendarWidth = isCompact
        ? math.min(280.0, contentWidth * 0.94)
        : math.min(360 * scale, contentWidth * 0.8);

    // Content determines the card height on every screen. Keep the calendar
    // and actions in the same flow so spare artwork height cannot separate them.
    return SizedBox(
      width: availableWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (_isVisible)
            Positioned(
              left: cardLeft - artworkWidth * _cardLeft,
              top: 0,
              bottom: 0,
              width: artworkWidth,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/decorations/Group_5.png',
                  fit: BoxFit.fill,
                  excludeFromSemantics: true,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              cardLeft + contentInset,
              naturalArtworkHeight * _cardTop + (isCompact ? 20 : 20 * scale),
              cardLeft + contentInset,
              naturalArtworkHeight * _cardBottom +
                  (isCompact ? 28 : 28 * scale),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                WeddingEventInformation(scale: scale),
                SizedBox(height: isCompact ? 20 : 24 * scale),
                SizedBox(
                  width: calendarWidth,
                  child: WeddingCalendarCard(scale: scale),
                ),
                SizedBox(height: isCompact ? 10 : 12 * scale),
                PartySectionActions(scale: scale),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
