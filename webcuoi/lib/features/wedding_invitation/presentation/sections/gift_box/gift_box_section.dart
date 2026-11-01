import 'package:flutter/material.dart';

import '../section_theme.dart';

/// Thông tin một tài khoản nhận quà mừng cưới.
class GiftAccount {
  const GiftAccount({
    required this.side,
    required this.owner,
    required this.bankName,
    required this.accountNumber,
  });

  final String side; // 'Nhà Trai' / 'Nhà Gái'
  final String owner;
  final String bankName;
  final String accountNumber;
}

/// Section — HỘP QUÀ MỪNG (theo mẫu Figma):
/// Hộp quà lớn ở giữa, các hộp nhỏ nhiều màu + ngôi sao bay quanh.
/// Nhấn "Nhấn để mở" -> xổ ra thông tin tài khoản mừng cưới.
/// Dòng cuối: lời cảm ơn nghiêng.
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
      side: 'Nh\u{00E0} Trai',
      owner: 'Nguy\u{1EC5}n Kh\u{1EAF}c Ch\u{00ED}nh',
      bankName: 'Vietcombank',
      accountNumber: '0123456789',
    ),
    GiftAccount(
      side: 'Nh\u{00E0} G\u{00E1}i',
      owner: 'Nguy\u{1EC5}n Th\u{1ECB} Trang',
      bankName: 'Techcombank',
      accountNumber: '9876543210',
    ),
  ];

  @override
  State<GiftBoxSection> createState() => _GiftBoxSectionState();
}

class _GiftBoxSectionState extends State<GiftBoxSection> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36 * scale),
      child: Column(
        children: [
          Text('H\u{1ED8}P QU\u{00C0} M\u{1EEA}NG', style: SectionTheme.label(scale)),
          SizedBox(height: 28 * scale),

          // Cụm hộp quà bấm được.
          _GiftCluster(scale: scale, onTap: _toggle, highlighted: _open),

          SizedBox(height: 14 * scale),
          // Nhãn "Nhấn để mở" / "Thu gọn".
          GestureDetector(
            onTap: _toggle,
            child: Text(
              _open ? 'Thu g\u{1ECD}n' : 'Nh\u{1EA5}n \u{0111}\u{1EC3} m\u{1EDF}',
              style: SectionTheme.body(scale).copyWith(
                fontSize: 14 * scale,
                color: SectionTheme.inkSoft,
                letterSpacing: 0.5 * scale,
              ),
            ),
          ),

          // Panel tài khoản xổ ra.
          AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            child: _open
                ? Padding(
                    padding: EdgeInsets.only(top: 22 * scale),
                    child: Column(
                      children: [
                        for (final a in widget.accounts)
                          Padding(
                            padding: EdgeInsets.only(bottom: 14 * scale),
                            child: _AccountCard(account: a, scale: scale),
                          ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          SizedBox(height: 26 * scale),
          // Lời cảm ơn nghiêng.
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
  }

  void _toggle() => setState(() => _open = !_open);
}

/// Cụm hộp quà: hộp lớn ở giữa + các hộp nhỏ và ngôi sao bay quanh.
class _GiftCluster extends StatelessWidget {
  const _GiftCluster({
    required this.scale,
    required this.onTap,
    required this.highlighted,
  });

  final double scale;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final size = 260.0 * scale;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Các hộp nhỏ bay quanh.
          Positioned(
            left: 10 * scale,
            top: 30 * scale,
            child: _MiniGift(scale: scale, size: 46, color: const Color(0xFFEDE3D0)),
          ),
          Positioned(
            right: 16 * scale,
            top: 18 * scale,
            child: _MiniGift(scale: scale, size: 54, color: const Color(0xFF9E3B36)),
          ),
          Positioned(
            left: 0,
            bottom: 36 * scale,
            child: _MiniGift(scale: scale, size: 50, color: const Color(0xFFBE5B43)),
          ),
          Positioned(
            left: 26 * scale,
            top: 96 * scale,
            child: _MiniGift(scale: scale, size: 40, color: const Color(0xFF2F4A6B)),
          ),
          Positioned(
            right: 6 * scale,
            bottom: 70 * scale,
            child: _MiniGift(scale: scale, size: 42, color: const Color(0xFFCBD8E6)),
          ),
          Positioned(
            right: 48 * scale,
            bottom: 34 * scale,
            child: _MiniGift(scale: scale, size: 40, color: const Color(0xFFCBA14E)),
          ),
          // Ngôi sao lấp lánh.
          Positioned(
            left: 60 * scale,
            top: 70 * scale,
            child: _Sparkle(scale: scale, size: 14),
          ),
          Positioned(
            right: 70 * scale,
            top: 100 * scale,
            child: _Sparkle(scale: scale, size: 11),
          ),

          // Hộp quà lớn ở giữa (bấm để mở).
          GestureDetector(
            onTap: onTap,
            child: AnimatedScale(
              scale: highlighted ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 250),
              child: _MainGift(scale: scale),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hộp quà lớn kem với nơ vàng (vẽ bằng code).
class _MainGift extends StatelessWidget {
  const _MainGift({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final w = 150.0 * scale;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: w,
          height: w,
          child: CustomPaint(
            painter: _GiftPainter(
              body: const Color(0xFFF3EAD8),
              lid: const Color(0xFFEDE1C9),
              ribbon: const Color(0xFFCBA14E),
            ),
          ),
        ),
        SizedBox(height: 6 * scale),
        // Bóng đổ oval.
        Container(
          width: w * 0.7,
          height: 10 * scale,
          decoration: BoxDecoration(
            color: const Color(0x1A5A473B),
            borderRadius: BorderRadius.circular(10 * scale),
          ),
        ),
      ],
    );
  }
}

/// Hộp quà nhỏ nhiều màu.
class _MiniGift extends StatelessWidget {
  const _MiniGift({required this.scale, required this.size, required this.color});

  final double scale;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final s = size * scale;
    final ribbon = Color.lerp(color, Colors.white, 0.5)!;
    return SizedBox(
      width: s,
      height: s,
      child: CustomPaint(
        painter: _GiftPainter(
          body: color,
          lid: Color.lerp(color, Colors.black, 0.08)!,
          ribbon: ribbon,
        ),
      ),
    );
  }
}

/// Ngôi sao 4 cánh lấp lánh.
class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.scale, required this.size});

  final double scale;
  final double size;

  @override
  Widget build(BuildContext context) {
    final s = size * scale;
    return SizedBox(
      width: s,
      height: s,
      child: CustomPaint(painter: _SparklePainter(const Color(0xFFBFA87C))),
    );
  }
}

/// Vẽ hộp quà: thân + nắp + nơ (dải dọc/ngang + hai cánh nơ).
class _GiftPainter extends CustomPainter {
  _GiftPainter({required this.body, required this.lid, required this.ribbon});

  final Color body;
  final Color lid;
  final Color ribbon;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()..isAntiAlias = true;

    final lidHeight = h * 0.22;
    final bodyTop = lidHeight;

    // Thân hộp.
    paint.color = body;
    final bodyRect = Rect.fromLTWH(w * 0.08, bodyTop, w * 0.84, h - bodyTop);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(w * 0.03)),
      paint,
    );

    // Nắp hộp.
    paint.color = lid;
    final lidRect = Rect.fromLTWH(0, bodyTop - lidHeight * 0.5, w, lidHeight);
    canvas.drawRRect(
      RRect.fromRectAndRadius(lidRect, Radius.circular(w * 0.03)),
      paint,
    );

    // Dải nơ dọc.
    paint.color = ribbon;
    canvas.drawRect(Rect.fromLTWH(w * 0.44, bodyTop - lidHeight * 0.5, w * 0.12, h - bodyTop + lidHeight * 0.5), paint);

    // Hai cánh nơ.
    final bowY = bodyTop - lidHeight * 0.5;
    final bowPath = Path()
      ..moveTo(w * 0.5, bowY)
      ..quadraticBezierTo(w * 0.2, bowY - h * 0.18, w * 0.32, bowY)
      ..quadraticBezierTo(w * 0.2, bowY + h * 0.02, w * 0.5, bowY)
      ..moveTo(w * 0.5, bowY)
      ..quadraticBezierTo(w * 0.8, bowY - h * 0.18, w * 0.68, bowY)
      ..quadraticBezierTo(w * 0.8, bowY + h * 0.02, w * 0.5, bowY);
    canvas.drawPath(bowPath, paint);

    // Nút nơ giữa.
    paint.color = Color.lerp(ribbon, Colors.black, 0.12)!;
    canvas.drawCircle(Offset(w * 0.5, bowY), w * 0.05, paint);
  }

  @override
  bool shouldRepaint(covariant _GiftPainter oldDelegate) =>
      body != oldDelegate.body ||
      lid != oldDelegate.lid ||
      ribbon != oldDelegate.ribbon;
}

/// Vẽ ngôi sao 4 cánh (hình kim cương thon).
class _SparklePainter extends CustomPainter {
  _SparklePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true;
    final path = Path()
      ..moveTo(w * 0.5, 0)
      ..quadraticBezierTo(w * 0.55, h * 0.45, w, h * 0.5)
      ..quadraticBezierTo(w * 0.55, h * 0.55, w * 0.5, h)
      ..quadraticBezierTo(w * 0.45, h * 0.55, 0, h * 0.5)
      ..quadraticBezierTo(w * 0.45, h * 0.45, w * 0.5, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) =>
      color != oldDelegate.color;
}

/// Thẻ thông tin một tài khoản mừng cưới.
class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.account, required this.scale});

  final GiftAccount account;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320 * scale,
      padding: EdgeInsets.symmetric(horizontal: 20 * scale, vertical: 16 * scale),
      decoration: BoxDecoration(
        color: SectionTheme.paperCard,
        borderRadius: BorderRadius.circular(10 * scale),
        border: Border.all(color: SectionTheme.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            account.side,
            style: SectionTheme.body(scale).copyWith(
              fontSize: 12 * scale,
              letterSpacing: 1 * scale,
              color: SectionTheme.inkSoft,
            ),
          ),
          SizedBox(height: 6 * scale),
          Text(
            account.owner,
            style: SectionTheme.body(scale)
                .copyWith(fontSize: 16 * scale, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4 * scale),
          Text(account.bankName, style: SectionTheme.body(scale).copyWith(fontSize: 13 * scale)),
          SizedBox(height: 4 * scale),
          Text(
            account.accountNumber,
            style: SectionTheme.body(scale).copyWith(
              fontSize: 17 * scale,
              letterSpacing: 2 * scale,
              fontWeight: FontWeight.w600,
              color: SectionTheme.ink,
            ),
          ),
        ],
      ),
    );
  }
}
