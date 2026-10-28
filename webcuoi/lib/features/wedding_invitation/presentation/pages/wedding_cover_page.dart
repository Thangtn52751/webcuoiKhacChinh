import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../widgets/falling_leaves_layer.dart';
import 'wedding_invitation_page.dart';

/// Trang bìa thiệp cưới dựng theo mẫu Figma "dau trang":
/// - Nền be ấm, thẻ thiệp kem bo góc nằm giữa.
/// - Hai nhành hoa khô đối xứng tràn ra hai mép thẻ.
/// - Con dấu tròn nâu với trái tim trắng phía trên tên.
/// - Tên cặp đôi 3 dòng, dấu fleuron, ngày cưới, "Thân Mời" và nút "Mở thiệp".
class WeddingCoverPage extends StatefulWidget {
  const WeddingCoverPage({super.key});

  /// Màu nền be/nude ấm của toàn trang (lấy từ Figma).
  static const _background = Color(0xFFE2CDB8);

  /// Màu nền thẻ thiệp (kem).
  static const _cardColor = Color(0xFFFBF6EE);

  /// Màu nâu chủ đạo cho chữ, con dấu và nút.
  static const _ink = Color(0xFF6E5B4F);

  /// Màu nâu nhạt hơn cho dòng ngày tháng.
  static const _inkSoft = Color(0xFF8A7868);

  // Kích thước thiết kế gốc của thẻ thiệp (theo Figma).
  static const _cardWidth = 520.0;
  static const _cardHeight = 430.0;

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
      duration: const Duration(milliseconds: 1400),
    );
    _musicPlayer = AudioPlayer();
    unawaited(
      _musicPlayer.setReleaseMode(ReleaseMode.loop).catchError((Object error) {
        debugPrint('Could not set wedding music loop: $error');
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
      _musicPlayer.play(AssetSource('audio/music.mp3')).catchError((
        Object error,
      ) {
        debugPrint('Could not start wedding music: $error');
      }),
    );
    await _openController.forward();
    if (!mounted) return;

    _musicPlayerTransferred = true;
    Navigator.of(context).pushReplacement<void, void>(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            WeddingInvitationPage(musicPlayer: _musicPlayer),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(opacity: fade, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeddingCoverPage._background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(
            child: IgnorePointer(child: FallingLeavesLayer()),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Chừa lề để hoa khô tràn hai bên vẫn nằm trong màn hình.
                final availableWidth = math.max(0.0, constraints.maxWidth - 80);
                final availableHeight = math.max(
                  0.0,
                  constraints.maxHeight - 48,
                );
                final scale = math
                    .min(
                      1.0,
                      math.min(
                        availableWidth / WeddingCoverPage._cardWidth,
                        availableHeight / WeddingCoverPage._cardHeight,
                      ),
                    )
                    .toDouble();

                return AnimatedBuilder(
                  animation: _openController,
                  builder: (context, child) {
                    final value = _openController.value;
                    // Giai đoạn 1 (0 -> 0.5): thiệp "nhú lên" nhẹ nhàng.
                    final rise = Curves.easeOutBack.transform(
                      Interval(
                        0.0,
                        0.5,
                        curve: Curves.easeOutCubic,
                      ).transform(value),
                    );
                    // Giai đoạn 2 (0.45 -> 1): thiệp phóng to và mờ dần khi mở.
                    final open = Interval(
                      0.45,
                      1.0,
                      curve: Curves.easeInCubic,
                    ).transform(value);
                    final coverOpacity = (1 - open).clamp(0.0, 1.0);

                    return Center(
                      child: Transform.translate(
                        offset: Offset(0, -24 * rise - 90 * open),
                        child: Transform.rotate(
                          angle: -0.04 * rise - 0.02 * open,
                          child: Transform.scale(
                            scale: 1 - 0.05 * rise + 0.45 * open,
                            child: Opacity(opacity: coverOpacity, child: child),
                          ),
                        ),
                      ),
                    );
                  },
                  child: _buildCover(scale),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Dựng toàn bộ cụm bìa: thẻ thiệp + hoa khô hai bên (tràn mép) + con dấu.
  Widget _buildCover(double scale) {
    final cardWidth = WeddingCoverPage._cardWidth * scale;
    final cardHeight = WeddingCoverPage._cardHeight * scale;
    final flowerHeight = 300.0 * scale;
    final flowerWidth = 120.0 * scale;
    // Chừa không gian hai bên để hoa khô tràn ra ngoài mép thẻ.
    final sideGutter = flowerWidth * 0.55;

    return SizedBox(
      width: cardWidth + sideGutter * 2,
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Thẻ thiệp nền kem.
          _buildCard(cardWidth, cardHeight, scale),

          // Nhành hoa khô bên trái (lật ngang).
          Positioned(
            left: 0,
            top: cardHeight * 0.16,
            child: Transform.flip(
              flipX: true,
              child: Image.asset(
                'assets/images/decorations/dried_flower.png',
                width: flowerWidth,
                height: flowerHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Nhành hoa khô bên phải.
          Positioned(
            right: 0,
            top: cardHeight * 0.12,
            child: Image.asset(
              'assets/images/decorations/dried_flower.png',
              width: flowerWidth,
              height: flowerHeight,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  /// Thẻ thiệp kem chứa con dấu, tên, ngày và nút.
  Widget _buildCard(double cardWidth, double cardHeight, double scale) {
    final ink = WeddingCoverPage._ink;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: WeddingCoverPage._cardColor,
        borderRadius: BorderRadius.circular(18 * scale),
        boxShadow: [
          BoxShadow(
            color: const Color(0x2E5A473B),
            blurRadius: 30 * scale,
            offset: Offset(0, 12 * scale),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Con dấu tròn nâu với trái tim trắng.
          Image.asset(
            'assets/images/decorations/heart_badge.png',
            width: 64 * scale,
            height: 64 * scale,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 18 * scale),

          // Tên cặp đôi 3 dòng.
          Text(
            'Kh\u{1EAF}c Ch\u{00ED}nh\n&\nTh\u{1ECB} Trang',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ink,
              fontSize: 30 * scale,
              height: 1.22,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 12 * scale),

          // Dấu phân cách fleuron —❦—.
          Image.asset(
            'assets/images/decorations/divider_fleuron.png',
            width: 50 * scale,
            height: 17 * scale,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 16 * scale),

          // Ngày cưới.
          Text(
            '13 th\u{00E1}ng 12, 2026',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: WeddingCoverPage._inkSoft,
              fontSize: 17 * scale,
              height: 1.2,
            ),
          ),
          SizedBox(height: 14 * scale),

          // Lời mời.
          Text(
            'Th\u{00E2}n M\u{1EDD}i',
            textAlign: TextAlign.center,
            style: TextStyle(color: ink, fontSize: 18 * scale, height: 1.2),
          ),
          SizedBox(height: 18 * scale),

          // Nút mở thiệp (pill bo tròn).
          Semantics(
            button: true,
            label: 'M\u{1EDF} thi\u{1EC7}p',
            child: Material(
              color: ink,
              borderRadius: BorderRadius.circular(24 * scale),
              child: InkWell(
                borderRadius: BorderRadius.circular(24 * scale),
                onTap: _openInvitation,
                child: SizedBox(
                  width: 140 * scale,
                  height: 44 * scale,
                  child: Center(
                    child: Text(
                      'M\u{1EDF} thi\u{1EC7}p',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17 * scale,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
