import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../sections/section_theme.dart';
import '../widgets/falling_leaves_layer.dart';
import '../wedding_music.dart';
import 'wedding_invitation_page.dart';

class WeddingCoverPage extends StatefulWidget {
  const WeddingCoverPage({super.key});

  static const _background = Color(0xFFE8D3BC);
  static const _ink = Color(0xFF806D61);

  @override
  State<WeddingCoverPage> createState() => _WeddingCoverPageState();
}

class _WeddingCoverPageState extends State<WeddingCoverPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _openController;
  late final AudioPlayer _musicPlayer;
  bool _musicPlayerTransferred = false;
  bool _isOpening = false;

  @override
  void initState() {
    super.initState();
    _openController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _musicPlayer = AudioPlayer();
    unawaited(
      _musicPlayer.setReleaseMode(ReleaseMode.loop).catchError((Object error) {
        debugPrint('Could not set wedding music loop mode: $error');
      }),
    );
  }

  @override
  void dispose() {
    _openController.dispose();
    if (!_musicPlayerTransferred) {
      unawaited(_musicPlayer.dispose());
    }
    super.dispose();
  }

  Future<void> _openInvitation() async {
    if (_isOpening) return;
    setState(() => _isOpening = true);
    unawaited(
      _musicPlayer
          .play(
            AssetSource(weddingMusicAssetForWidth(MediaQuery.widthOf(context))),
          )
          .catchError((Object error) {
            debugPrint('Could not start wedding music: $error');
          }),
    );
    await _openController.forward();
    if (!mounted) return;

    _musicPlayerTransferred = true;
    final isMobile = MediaQuery.widthOf(context) <= 720;
    Navigator.of(context).pushReplacement<void, void>(
      PageRouteBuilder<void>(
        transitionDuration: Duration(milliseconds: isMobile ? 260 : 700),
        reverseTransitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) =>
            WeddingInvitationPage(musicPlayer: _musicPlayer),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = CurveTween(
            curve: const Interval(0, 0.86, curve: Curves.easeOutCubic),
          ).animate(animation);
          if (isMobile) return FadeTransition(opacity: fade, child: child);

          final entrance = CurveTween(curve: Curves.easeOutCubic)
              .animate(animation);
          final scale = Tween<double>(
            begin: 0.975,
            end: 1,
          ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);

          return FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.025),
                end: Offset.zero,
              ).animate(entrance),
              child: ScaleTransition(scale: scale, child: child),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.widthOf(context) <= 720;

    return Scaffold(
      backgroundColor: WeddingCoverPage._background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (!isMobile)
            const Positioned.fill(
              child: IgnorePointer(child: FallingLeavesLayer(count: 8)),
            ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = math.max(
                  0.0,
                  constraints.maxWidth - 32.0,
                );
                final availableHeight = math.max(
                  0.0,
                  constraints.maxHeight - 32.0,
                );
                final scale = math
                    .min(
                      1.0,
                      math.min(availableWidth / 520.0, availableHeight / 420.0),
                    )
                    .toDouble();

                return AnimatedBuilder(
                  animation: _openController,
                  builder: (context, child) {
                    final progress = Curves.easeInOutCubic.transform(
                      _openController.value,
                    );
                    final coverOpacity =
                        1 -
                        Interval(
                          0.56,
                          1,
                          curve: Curves.easeInCubic,
                        ).transform(_openController.value);

                    return Center(
                      child: Transform.translate(
                        offset: Offset(0, -18 * progress),
                        child: Transform.rotate(
                          angle: -0.012 * progress,
                          child: Transform.scale(
                            scale: 1 + 0.1 * progress,
                            child: Opacity(opacity: coverOpacity, child: child),
                          ),
                        ),
                      ),
                    );
                  },
                  child: _buildCard(
                    scale,
                    isCompact: constraints.maxWidth < 600,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(double scale, {required bool isCompact}) {
    final ink = WeddingCoverPage._ink;
    final cardFont = isCompact
        ? SectionTheme.mobileFontFamily
        : SectionTheme.fontFamily;

    return Container(
      width: 520 * scale,
      height: 420 * scale,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8 * scale),
        boxShadow: [
          BoxShadow(
            color: const Color(0x3D5A473B),
            blurRadius: 20 * scale,
            offset: Offset(0, 8 * scale),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8 * scale),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/decorations/starterCard.png',
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 111 * scale,
              left: 16 * scale,
              right: 16 * scale,
              child: Text(
                'Kh\u{1EAF}c Ch\u{00ED}nh\n&\nNguy\u{1EC5}n Trang',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ink,
                  fontFamily: cardFont,
                  fontSize: 30 * scale,
                  height: 1.12,
                  fontWeight: isCompact ? FontWeight.w500 : FontWeight.w400,
                  letterSpacing: 0.1,
                ),
              ),
            ),
            Positioned(
              top: 225 * scale,
              left: 0,
              right: 0,
              height: 23 * scale,
              child: Center(
                child: Image(
                  image: const AssetImage('assets/icons/ic_split.png'),
                  width: 54 * scale,
                  height: 23 * scale,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 263 * scale,
              left: 12 * scale,
              right: 12 * scale,
              child: Text(
                '13 th\u{00E1}ng 12, 2026',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ink,
                  fontFamily: cardFont,
                  fontSize: 17 * scale,
                  height: 1.3,
                  fontWeight: isCompact ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            Positioned(
              top: 300 * scale,
              left: 0,
              right: 0,
              child: Text(
                'Th\u{00E2}n M\u{1EDD}i',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ink,
                  fontFamily: cardFont,
                  fontSize: 18 * scale,
                  height: 1.3,
                  fontWeight: isCompact ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            Positioned(
              top: 336 * scale,
              left: 0,
              right: 0,
              child: Center(
                child: Semantics(
                  button: true,
                  label: 'M\u{1EDF} thi\u{1EC7}p',
                  child: Material(
                    color: ink,
                    borderRadius: BorderRadius.circular(24 * scale),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24 * scale),
                      onTap: _openInvitation,
                      child: SizedBox(
                        width: 136 * scale,
                        height: 42 * scale,
                        child: Center(
                          child: Text(
                            'M\u{1EDF} thi\u{1EC7}p',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: cardFont,
                              fontSize: 17 * scale,
                              height: 1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
