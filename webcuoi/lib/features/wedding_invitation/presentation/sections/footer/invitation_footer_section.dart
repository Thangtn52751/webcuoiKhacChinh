import 'package:flutter/material.dart';

import '../../widgets/scroll_visibility.dart';

/// Displays the complete closing artwork without loading it above the fold.
class InvitationFooterSection extends StatefulWidget {
  const InvitationFooterSection({super.key});

  @override
  State<InvitationFooterSection> createState() =>
      _InvitationFooterSectionState();
}

class _InvitationFooterSectionState extends State<InvitationFooterSection> {
  late final _viewportObserver = ScrollViewportObserver(_loadWhenVisible);
  bool _loadArtwork = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadArtwork) return;
    _viewportObserver.attach(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadWhenVisible());
  }

  void _loadWhenVisible() {
    if (!mounted || _loadArtwork) return;
    if (!isInScrollViewport(context, _viewportObserver.position)) return;
    _viewportObserver.dispose();
    setState(() => _loadArtwork = true);
  }

  @override
  void dispose() {
    _viewportObserver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= 720;
        return AspectRatio(
          aspectRatio: isMobile ? 390 / 688 : 1440 / 960,
          child: _loadArtwork
              ? RepaintBoundary(
                  child: Image.asset(
                    isMobile
                        ? 'assets/images/decorations/footerMobile_PC.webp'
                        : 'assets/images/decorations/footerPC_BG.webp',
                    fit: BoxFit.contain,
                    semanticLabel:
                        'Cảm ơn bạn đã đến và chung vui trong ngày hạnh phúc '
                        'của chúng mình.',
                  ),
                )
              : const SizedBox.expand(),
        );
      },
    );
  }
}
