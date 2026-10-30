import 'package:flutter/material.dart';

import '../section_theme.dart';

/// Section 3 — ALBUM ẢNH (coverflow theo Figma):
/// Ảnh giữa to, đứng thẳng, bo góc lớn (không viền polaroid). Hai bên là các
/// lớp ảnh nhỏ dần, mờ dần và CHỒNG LỚP lên nhau (ảnh gần tâm đè lên ảnh xa).
/// Nút ‹ › tròn nâu đặc hai bên, chỉ số "n/tổng" phía dưới.
class PhotoGallerySection extends StatefulWidget {
  const PhotoGallerySection({
    super.key,
    required this.scale,
    this.imagePaths = _defaultImages,
  });

  final double scale;
  final List<String> imagePaths;

  static const List<String> _defaultImages = [
    'assets/images/couple/couple.jpg',
    'assets/images/couple/couple2.jpg',
    'assets/images/couple/couple3.jpg',
    'assets/images/couple/couple4.jpg',
    'assets/images/couple/couple5.jpg',
    'assets/images/couple/couple6.jpg',
    'assets/images/couple/couple7.jpg',
    'assets/images/couple/couple8.jpg',
    'assets/images/couple/couple9.jpg',
    'assets/images/couple/couple10.jpg',
    'assets/images/couple/couple11.jpg',
    'assets/images/couple/couple12.jpg',
  ];

  @override
  State<PhotoGallerySection> createState() => _PhotoGallerySectionState();
}

class _PhotoGallerySectionState extends State<PhotoGallerySection>
    with SingleTickerProviderStateMixin {
  /// Số lớp ảnh mỗi bên (ngoài ảnh giữa) -> tổng hiển thị = 2*side + 1 = 5.
  static const _sideCount = 2;

  late final AnimationController _animation;
  int _current = 0;
  // Vị trí "ảo" mượt dùng để nội suy khi chuyển ảnh.
  double _displayIndex = 0;
  double _animFrom = 0;
  double _animTo = 0;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..addListener(_onTick);
  }

  void _onTick() {
    setState(() {
      final t = Curves.easeOutCubic.transform(_animation.value);
      _displayIndex = _animFrom + (_animTo - _animFrom) * t;
      // Khi trượt xong, chuẩn hóa vị trí ảo về [0, count) để lần sau tính đúng.
      if (_animation.isCompleted) {
        final count = widget.imagePaths.length;
        _displayIndex = (_displayIndex % count + count) % count;
      }
    });
  }

  @override
  void dispose() {
    _animation.removeListener(_onTick);
    _animation.dispose();
    super.dispose();
  }

  /// Chuyển ảnh theo hướng (+1 phải, -1 trái), xoay vòng ở hai đầu.
  /// Nội suy vị trí ảo đi đúng một bước để animation luôn trượt theo hướng bấm,
  /// kể cả khi nhảy từ ảnh cuối về ảnh đầu (và ngược lại).
  void _step(int direction) {
    final count = widget.imagePaths.length;
    if (count <= 1) return;
    _animFrom = _displayIndex;
    _animTo = _displayIndex + direction; // có thể là -1 hoặc = count
    _current = ((_current + direction) % count + count) % count;
    _animation.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;
    final count = widget.imagePaths.length;
    final centerW = 300.0 * scale;
    final centerH = 400.0 * scale;
    final carouselHeight = centerH + 24 * scale;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36 * scale),
      child: Column(
        children: [
          Text('ALBUM \u{1EA2}NH', style: SectionTheme.label(scale)),
          SizedBox(height: 28 * scale),

          SizedBox(
            height: carouselHeight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                return Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    ..._buildLayers(scale, centerW, centerH, maxWidth, count),
                    Positioned(
                      left: 8 * scale,
                      child: _NavButton(
                        scale: scale,
                        icon: Icons.chevron_left_rounded,
                        onTap: () => _step(-1),
                      ),
                    ),
                    Positioned(
                      right: 8 * scale,
                      child: _NavButton(
                        scale: scale,
                        icon: Icons.chevron_right_rounded,
                        onTap: () => _step(1),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: 20 * scale),
          Text(
            '${_current + 1} / $count',
            style: SectionTheme.body(scale).copyWith(
              fontSize: 14 * scale,
              color: SectionTheme.inkSoft,
              letterSpacing: 1 * scale,
            ),
          ),
        ],
      ),
    );
  }

  /// Dựng các lớp ảnh, vẽ từ xa tâm -> gần tâm để ảnh gần nằm TRÊN (chồng lớp).
  List<Widget> _buildLayers(
    double scale,
    double centerW,
    double centerH,
    double maxWidth,
    int count,
  ) {
    // Bước lệch ngang giữa các lớp (ảnh gần tâm cách tâm bao xa).
    final step = centerW * 0.52;
    final layers = <_Layer>[];

    // Tâm ảo liên tục (đã chuẩn hóa về [0,count)). Lấy ảnh nguyên gần tâm nhất
    // và phần lẻ để trượt mượt khi đang animate.
    final base = _displayIndex.round();
    final frac = _displayIndex - base;

    // Duyệt quanh tâm, index bao vòng (wrap-around) để luôn đủ các lớp hai bên,
    // kể cả khi ở ảnh đầu hoặc ảnh cuối. (An toàn khi count > 2*_sideCount+1.)
    for (var offset = -_sideCount; offset <= _sideCount; offset++) {
      final index = ((base + offset) % count + count) % count;

      // Vị trí tương đối tới tâm, có nội suy mượt bằng phần lẻ.
      final rel = offset - frac;
      final dist = rel.abs();
      final clamped = dist.clamp(0.0, _sideCount.toDouble());

      // Càng xa tâm càng nhỏ, mờ và lệch ngang nhiều hơn.
      final itemScale = 1 - 0.16 * clamped;
      final opacity = (1 - 0.30 * clamped).clamp(0.0, 1.0);
      final dx = rel * step;

      layers.add(_Layer(
        index: index,
        dx: dx,
        scale: itemScale,
        opacity: opacity,
        dist: dist,
      ));
    }

    // Sắp xếp: xa tâm trước (dưới), gần tâm sau (trên).
    layers.sort((a, b) => b.dist.compareTo(a.dist));

    return [
      for (final l in layers)
        Transform.translate(
          offset: Offset(l.dx, 0),
          child: Transform.scale(
            scale: l.scale,
            child: Opacity(
              opacity: l.opacity,
              child: GestureDetector(
                onTap: () {
                  // Bấm ảnh giữa -> phóng to (lightbox).
                  // Bấm ảnh hai bên -> trượt tới ảnh đó.
                  if (l.dist < 0.5) {
                    _openLightbox(l.index);
                  } else {
                    _step(l.dx < 0 ? -1 : 1);
                  }
                },
                child: _GalleryImage(
                  imagePath: widget.imagePaths[l.index],
                  width: centerW,
                  height: centerH,
                  scale: scale,
                  // Ảnh không phải trung tâm thì làm tối nhẹ cho lùi ra sau.
                  dim: l.dist > 0.5,
                ),
              ),
            ),
          ),
        ),
    ];
  }

  /// Mở overlay phóng to ảnh, cho phép vuốt chuyển và pinch-zoom.
  Future<void> _openLightbox(int startIndex) async {
    final result = await Navigator.of(context).push<int>(
      PageRouteBuilder<int>(
        opaque: false,
        barrierColor: Colors.black87,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            _GalleryLightbox(
              imagePaths: widget.imagePaths,
              initialIndex: startIndex,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
    // Đồng bộ carousel về ảnh cuối cùng người dùng xem trong lightbox.
    if (result != null && mounted && result != _current) {
      setState(() {
        _current = result;
        _displayIndex = result.toDouble();
      });
    }
  }
}

class _Layer {
  _Layer({
    required this.index,
    required this.dx,
    required this.scale,
    required this.opacity,
    required this.dist,
  });

  final int index;
  final double dx;
  final double scale;
  final double opacity;
  final double dist;
}

/// Ảnh bo góc lớn với bóng đổ (không viền polaroid, đứng thẳng).
class _GalleryImage extends StatelessWidget {
  const _GalleryImage({
    required this.imagePath,
    required this.width,
    required this.height,
    required this.scale,
    required this.dim,
  });

  final String imagePath;
  final double width;
  final double height;
  final double scale;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16 * scale),
        boxShadow: [
          BoxShadow(
            color: const Color(0x335A473B),
            blurRadius: 24 * scale,
            offset: Offset(0, 12 * scale),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16 * scale),
        child: ColorFiltered(
          colorFilter: dim
              ? ColorFilter.mode(
                  Colors.white.withValues(alpha: 0.35),
                  BlendMode.srcOver,
                )
              : const ColorFilter.mode(
                  Colors.transparent,
                  BlendMode.srcOver,
                ),
          child: Image.asset(
            imagePath,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

/// Nút tròn nâu đặc điều hướng carousel.
class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.scale,
    required this.icon,
    required this.onTap,
  });

  final double scale;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = 44.0 * scale;
    return Material(
      color: SectionTheme.ink,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: Colors.white, size: 26 * scale),
        ),
      ),
    );
  }
}

/// Overlay xem ảnh phóng to toàn màn hình.
/// - Vuốt ngang hoặc bấm nút ‹ › để chuyển ảnh (xoay vòng).
/// - Pinch-zoom / kéo để phóng to từng ảnh (InteractiveViewer).
/// - Bấm nền tối hoặc nút X để đóng; trả về index ảnh đang xem.
class _GalleryLightbox extends StatefulWidget {
  const _GalleryLightbox({required this.imagePaths, required this.initialIndex});

  final List<String> imagePaths;
  final int initialIndex;

  @override
  State<_GalleryLightbox> createState() => _GalleryLightboxState();
}

class _GalleryLightboxState extends State<_GalleryLightbox> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() => Navigator.of(context).pop(_index);

  void _step(int direction) {
    final count = widget.imagePaths.length;
    final target = ((_index + direction) % count + count) % count;
    _controller.animateToPage(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.imagePaths.length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Bấm nền tối để đóng.
          Positioned.fill(
            child: GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.opaque,
            ),
          ),

          // Trình xem ảnh vuốt ngang + pinch-zoom.
          PageView.builder(
            controller: _controller,
            itemCount: count,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              return Center(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Image.asset(
                      widget.imagePaths[i],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),

          // Nút chuyển trái.
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: _LightboxButton(
                icon: Icons.chevron_left_rounded,
                onTap: () => _step(-1),
              ),
            ),
          ),
          // Nút chuyển phải.
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _LightboxButton(
                icon: Icons.chevron_right_rounded,
                onTap: () => _step(1),
              ),
            ),
          ),

          // Nút đóng.
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: _LightboxButton(
                icon: Icons.close_rounded,
                onTap: _close,
              ),
            ),
          ),

          // Chỉ số ảnh.
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Text(
                '${_index + 1} / $count',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Nút tròn bán trong suốt dùng trong lightbox.
class _LightboxButton extends StatelessWidget {
  const _LightboxButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white24,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
