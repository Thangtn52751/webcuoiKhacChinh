import 'dart:math' as math;

import 'package:flutter/material.dart';

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
  ScrollPosition? _scrollPosition;

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
    final nextPosition = Scrollable.maybeOf(context)?.position;
    if (identical(nextPosition, _scrollPosition)) return;
    _scrollPosition?.removeListener(_updateVisibility);
    _scrollPosition = nextPosition;
    _scrollPosition?.addListener(_updateVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibility());
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_updateVisibility);
    super.dispose();
  }

  void _updateVisibility() {
    if (!mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final top = renderObject.localToGlobal(Offset.zero).dy;
    final bottom = top + renderObject.size.height;
    final visible = bottom > 0 && top < MediaQuery.sizeOf(context).height;
    if (visible == _isVisible) return;
    setState(() => _isVisible = visible);
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 600;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24 * scale),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : screenWidth;
          if (isCompact) {
            return _buildMobileCard(availableWidth, scale);
          }
          final cardWidthFraction = 1 - _cardLeft - _cardRight;
          final artworkWidth = math
              .min(_artworkWidth * scale, availableWidth)
              .toDouble();
          final artworkHeight = artworkWidth * _artworkHeight / _artworkWidth;
          final horizontalInset = 18 * scale;
          final cardWidth = artworkWidth * cardWidthFraction;
          final cardLeft = (availableWidth - cardWidth) / 2;
          final artworkLeft = cardLeft - artworkWidth * _cardLeft;
          final contentWidth = cardWidth - horizontalInset * 2;
          final calendarWidth = math
              .min(contentWidth * 0.45, contentWidth)
              .toDouble();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: availableWidth,
                height: artworkHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (_isVisible)
                      Positioned(
                        left: artworkLeft,
                        top: 0,
                        width: artworkWidth,
                        height: artworkHeight,
                        child: IgnorePointer(
                          child: Image.asset(
                            'assets/images/decorations/Group_5.png',
                            fit: BoxFit.fill,
                            excludeFromSemantics: true,
                          ),
                        ),
                      ),
                    Positioned(
                      left: cardLeft + horizontalInset,
                      right:
                          availableWidth -
                          cardLeft -
                          cardWidth +
                          horizontalInset,
                      top: artworkHeight * _cardTop + 20 * scale,
                      bottom: artworkHeight * _cardBottom + 18 * scale,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WeddingEventInformation(scale: scale),
                          SizedBox(
                            width: calendarWidth,
                            child: WeddingCalendarCard(scale: scale),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18 * scale),
              PartySectionActions(scale: scale),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMobileCard(double availableWidth, double scale) {
    final cardWidthFraction = 1 - _cardLeft - _cardRight;
    final artworkWidth = math.min(
      _artworkWidth * scale,
      availableWidth * 0.88 / cardWidthFraction,
    );
    final naturalArtworkHeight = artworkWidth * _artworkHeight / _artworkWidth;
    final cardWidth = artworkWidth * cardWidthFraction;
    final cardLeft = (availableWidth - cardWidth) / 2;
    final contentInset = (cardWidth * 0.05).clamp(14.0, 20.0);
    final contentWidth = cardWidth - contentInset * 2;

    // Let text, calendar and actions determine the mobile card height. The
    // artwork remains behind the content instead of distributing spare height
    // between the event information and calendar.
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
              naturalArtworkHeight * _cardTop + 20,
              cardLeft + contentInset,
              naturalArtworkHeight * _cardBottom + 28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                WeddingEventInformation(scale: scale),
                const SizedBox(height: 20),
                SizedBox(
                  width: math.min(280.0, contentWidth * 0.94),
                  child: WeddingCalendarCard(scale: scale),
                ),
                const SizedBox(height: 10),
                PartySectionActions(scale: scale),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
