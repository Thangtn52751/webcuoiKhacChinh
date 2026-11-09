import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'qr_download_stub.dart'
    if (dart.library.js_interop) 'qr_download_web.dart';
import '../section_theme.dart';

class GiftAccount {
  const GiftAccount({
    required this.side,
    required this.owner,
    required this.bankName,
    required this.accountNumber,
  });

  final String side;
  final String owner;
  final String bankName;
  final String accountNumber;
}

class GiftBoxSection extends StatefulWidget {
  const GiftBoxSection({
    super.key,
    required this.scale,
    this.accounts = _demoAccounts,
    this.thankYou =
        'S\u{1EF1} hi\u{1EC7}n di\u{1EC7}n c\u{1EE7}a qu\u{00FD} kh\u{00E1}ch '
        'l\u{00E0} ni\u{1EC1}m vinh h\u{1EA1}nh c\u{1EE7}a gia \u{0111}\u{00EC}nh '
        'ch\u{00FA}ng t\u{00F4}i!',
  });

  final double scale;
  final List<GiftAccount> accounts;
  final String thankYou;

  static const List<GiftAccount> _demoAccounts = [
    GiftAccount(
      side: 'Ch\u{00FA} R\u{1EC3}',
      owner: 'Nguyễn Khắc Chính',
      bankName: 'Viettinbank',
      accountNumber: '105885499481',
    ),
    GiftAccount(
      side: 'C\u{00F4} D\u{00E2}u',
      owner: 'Nguyễn Trang',
      bankName: 'Vietcombank',
      accountNumber: '0731000806651',
    ),
  ];

  @override
  State<GiftBoxSection> createState() => _GiftBoxSectionState();
}

class _GiftBoxSectionState extends State<GiftBoxSection>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _idleController;
  AnimationController? _hoverController;
  bool _hasEntered = false;
  bool _isVisible = false;
  ScrollPosition? _scrollPosition;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    );
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
    _entranceController.dispose();
    _idleController.dispose();
    _hoverController?.dispose();
    super.dispose();
  }

  AnimationController get _hoverAnimationController =>
      _hoverController ??= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1100),
      );

  void _startGiftHover() => _hoverAnimationController.repeat();

  void _stopGiftHover() => _hoverAnimationController.reset();

  void _updateVisibility() {
    if (!mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final top = renderObject.localToGlobal(Offset.zero).dy;
    final bottom = top + renderObject.size.height;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    _isVisible = bottom > 0 && top < viewportHeight;

    if (!_isVisible) {
      if (_idleController.isAnimating) _idleController.stop();
      return;
    }

    if (!_hasEntered) {
      _hasEntered = true;
      _entranceController.forward().whenComplete(_startIdleIfVisible);
    } else if (_entranceController.isCompleted &&
        !_idleController.isAnimating) {
      _idleController.repeat();
    }
  }

  void _startIdleIfVisible() {
    if (mounted && _isVisible && !_idleController.isAnimating) {
      _idleController.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32 * scale),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          final compositionWidth = math
              .min(390 * scale, availableWidth * 0.9)
              .toDouble();
          final compactMotion = availableWidth < 600;
          final compositionHeight = 230 * scale;
          final artworkWidth = math
              .min(170 * scale, compositionWidth * 0.46)
              .toDouble();
          final sectionFade = CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0, 0.84, curve: Curves.easeInOut),
          );

          return FadeTransition(
            opacity: sectionFade,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'H\u{1ED8}P QU\u{00C0} M\u{1EEA}NG',
                  textAlign: TextAlign.center,
                  style: SectionTheme.label(scale),
                ),
                SizedBox(height: 8 * scale),
                Center(
                  child: _giftArtwork(
                    width: compositionWidth,
                    height: compositionHeight,
                    giftWidth: artworkWidth,
                    scale: scale,
                    compactMotion: compactMotion,
                  ),
                ),
                SizedBox(height: 4 * scale),
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _entranceController,
                    curve: const Interval(0.25, 0.9, curve: Curves.easeInOut),
                  ),
                  child: GestureDetector(
                    onTap: _toggle,
                    child: Padding(
                      padding: EdgeInsets.all(6 * scale),
                      child: Text(
                        'Nh\u{1EA5}n \u{0111}\u{1EC3} m\u{1EDF}',
                        style: SectionTheme.body(scale).copyWith(
                          fontSize: 14 * scale,
                          color: SectionTheme.inkSoft,
                          letterSpacing: 0.4 * scale,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22 * scale),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                  child: Text(
                    widget.thankYou,
                    textAlign: TextAlign.center,
                    style: SectionTheme.body(scale).copyWith(
                      fontStyle: FontStyle.italic,
                      fontSize: 14 * scale,
                      color: SectionTheme.inkSoft,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _giftArtwork({
    required double width,
    required double height,
    required double giftWidth,
    required double scale,
    required bool compactMotion,
  }) {
    final entrance = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.08, 0.88, curve: Curves.easeInOut),
    );

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _giftDecoration(
            'assets/images/decorations/present1.png',
            size: 43 * scale,
            left: width * 0.20,
            top: height * 0.08,
            phase: 0.3,
            entranceStart: 0.1,
            compactMotion: compactMotion,
          ),
          _giftDecoration(
            'assets/images/decorations/present2.png',
            size: 43 * scale,
            right: width * 0.20,
            top: height * 0.08,
            phase: 2.1,
            entranceStart: 0.18,
            compactMotion: compactMotion,
          ),
          _giftDecoration(
            'assets/images/decorations/present3.png',
            size: 34 * scale,
            left: width * 0.18,
            top: height * 0.48,
            phase: 4.0,
            entranceStart: 0.26,
            compactMotion: compactMotion,
          ),
          _giftDecoration(
            'assets/images/decorations/present4.png',
            size: 34 * scale,
            right: width * 0.18,
            top: height * 0.48,
            phase: 1.4,
            entranceStart: 0.34,
            compactMotion: compactMotion,
          ),
          _giftDecoration(
            'assets/images/decorations/present5.png',
            size: 42 * scale,
            left: width * 0.20,
            bottom: height * 0.17,
            phase: 3.1,
            entranceStart: 0.42,
            compactMotion: compactMotion,
          ),
          AnimatedBuilder(
            animation: _idleController,
            child: RepaintBoundary(
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1).animate(entrance),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(entrance),
                  child: GestureDetector(
                    onTap: _toggle,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => _startGiftHover(),
                      onExit: (_) => _stopGiftHover(),
                      child: Image.asset(
                        'assets/images/decorations/big_Present.png',
                        width: giftWidth,
                        fit: BoxFit.contain,
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            builder: (context, child) {
              final float =
                  math.sin(_idleController.value * math.pi * 2) * 5 * scale;
              return Transform.translate(
                offset: Offset(0, float),
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _giftDecoration(
    String asset, {
    required double size,
    required double phase,
    required double entranceStart,
    required bool compactMotion,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    final entrance = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(
        entranceStart,
        math.min(entranceStart + 0.48, 1),
        curve: Curves.easeInOut,
      ),
    );
    Widget decoration = FadeTransition(
      opacity: entrance,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1).animate(entrance),
        child: RepaintBoundary(
          child: Image.asset(
            asset,
            width: size,
            height: size,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
        ),
      ),
    );

    if (!compactMotion) {
      final hoverOpacity = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1,
            end: 0,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 34,
        ),
        TweenSequenceItem(tween: ConstantTween<double>(0), weight: 20),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0,
            end: 1,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 18,
        ),
        TweenSequenceItem(tween: ConstantTween<double>(1), weight: 28),
      ]).animate(_hoverAnimationController);
      final hoverTravel = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0,
            end: 1,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 34,
        ),
        TweenSequenceItem(tween: ConstantTween<double>(1), weight: 12),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1,
            end: 0,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 8,
        ),
        TweenSequenceItem(tween: ConstantTween<double>(0), weight: 46),
      ]).animate(_hoverAnimationController);

      decoration = AnimatedBuilder(
        animation: _hoverAnimationController,
        child: decoration,
        builder: (context, child) => Opacity(
          opacity: hoverOpacity.value,
          child: Transform.translate(
            offset: Offset(0, -34 * widget.scale * hoverTravel.value),
            child: child,
          ),
        ),
      );

      decoration = AnimatedBuilder(
        animation: _idleController,
        child: decoration,
        builder: (context, child) {
          final angle =
              math.sin(_idleController.value * math.pi * 2 + phase) * 0.02;
          final float =
              math.sin(_idleController.value * math.pi * 2 + phase) *
              2 *
              widget.scale;
          return Transform.translate(
            offset: Offset(0, float),
            child: Transform.rotate(angle: angle, child: child),
          );
        },
      );
    }

    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: decoration,
    );
  }

  void _toggle() {
    showDialog<void>(
      context: context,
      barrierColor: const Color(0xB3000000),
      builder: (dialogContext) => _GiftQrDialog(accounts: widget.accounts),
    );
  }
}

class _GiftQrDialog extends StatelessWidget {
  const _GiftQrDialog({required this.accounts});

  final List<GiftAccount> accounts;

  @override
  Widget build(BuildContext context) {
    const groomQr = 'assets/images/gallery/qr_hus.jpeg';
    const brideQr = 'assets/images/gallery/qr_Wife.jpeg';
    final dialogWidth = math
        .min(560.0, MediaQuery.sizeOf(context).width - 24)
        .toDouble();
    final uiScale = (dialogWidth / 520).clamp(0.72, 1.0).toDouble();
    final groom = accounts.isNotEmpty
        ? accounts[0]
        : GiftBoxSection._demoAccounts[0];
    final bride = accounts.length > 1
        ? accounts[1]
        : GiftBoxSection._demoAccounts[1];
    final qrSize = math
        .min(148 * uiScale, (dialogWidth - 64 * uiScale) / 2 - 14 * uiScale)
        .toDouble();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16 * uiScale),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              fontFamily: SectionTheme.fontFamilyFor(context),
              fontWeight: SectionTheme.isCompact(context)
                  ? FontWeight.w500
                  : FontWeight.w400,
              color: SectionTheme.inkSoft,
            ),
            child: Container(
              width: dialogWidth,
              color: const Color(0xFFFFF8F4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 62 * uiScale,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Positioned.fill(
                          child: ColoredBox(color: Color(0xFF806D62)),
                        ),
                        Text(
                          'HỘP QUÀ MỪNG',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: SectionTheme.fontFamilyFor(context),
                            fontSize: 18 * uiScale,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3 * uiScale,
                          ),
                        ),
                        Positioned(
                          top: 4 * uiScale,
                          right: 6 * uiScale,
                          child: IconButton(
                            tooltip: 'Đóng',
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.white.withValues(alpha: 0.9),
                              size: 20 * uiScale,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      18 * uiScale,
                      18 * uiScale,
                      18 * uiScale,
                      20 * uiScale,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _QrGiftCard(
                            account: groom,
                            imageAsset: groomQr,
                            fileName: 'qr-chu-re.jpeg',
                            size: qrSize,
                            scale: uiScale,
                          ),
                        ),
                        SizedBox(width: 12 * uiScale),
                        Expanded(
                          child: _QrGiftCard(
                            account: bride,
                            imageAsset: brideQr,
                            fileName: 'qr-co-dau.jpeg',
                            size: qrSize,
                            scale: uiScale,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QrGiftCard extends StatelessWidget {
  const _QrGiftCard({
    required this.account,
    required this.imageAsset,
    required this.fileName,
    required this.size,
    required this.scale,
  });

  final GiftAccount account;
  final String imageAsset;
  final String fileName;
  final double size;
  final double scale;

  Future<void> _saveQr(BuildContext context) async {
    final saved = await downloadQrAsset(imageAsset, fileName);
    if (!saved && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể lưu ảnh QR trên thiết bị này.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ink = SectionTheme.inkSoft;
    final imageSize = math.min(size, 150 * scale).toDouble();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 32 * scale,
          child: Center(
            child: Text(
              '${account.side} - ${account.owner}',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ink,
                fontSize: 11 * scale,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(7 * scale),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12 * scale),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1C46352B),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6 * scale),
            child: Image.asset(
              imageAsset,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
          ),
        ),
        SizedBox(height: 8 * scale),
        Text(
          account.bankName,
          textAlign: TextAlign.center,
          style: TextStyle(color: SectionTheme.inkSoft, fontSize: 9.5 * scale),
        ),
        SizedBox(height: 2 * scale),
        Text(
          account.accountNumber,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: SectionTheme.inkSoft,
            fontSize: 10 * scale,
            letterSpacing: 0.4 * scale,
          ),
        ),
        SizedBox(height: 3 * scale),
        Text(
          account.owner,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: ink,
            fontSize: 10 * scale,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 7 * scale),
        SizedBox(
          height: 28 * scale,
          child: TextButton.icon(
            onPressed: () => _saveQr(context),
            style: TextButton.styleFrom(
              foregroundColor: ink,
              backgroundColor: const Color(0xFFF0E8E2),
              padding: EdgeInsets.symmetric(horizontal: 10 * scale),
              shape: const StadiumBorder(),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            icon: Icon(Icons.download_rounded, size: 12 * scale),
            label: Text('Lưu QR', style: TextStyle(fontSize: 9.5 * scale)),
          ),
        ),
      ],
    );
  }
}
