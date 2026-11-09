import 'dart:math' as math;

import 'package:flutter/material.dart';

class FallingLeavesLayer extends StatefulWidget {
  const FallingLeavesLayer({super.key, this.count = 8});

  final int count;

  @override
  State<FallingLeavesLayer> createState() => _FallingLeavesLayerState();
}

class _FallingLeavesLayerState extends State<FallingLeavesLayer>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _animation;
  late final List<_LeafParticle> _leaves;
  bool _isAppResumed = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    if (lifecycleState != null) {
      _isAppResumed = lifecycleState == AppLifecycleState.resumed;
    }
    final random = math.Random();
    _leaves = List.generate(widget.count, (_) => _LeafParticle.random(random));
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 36),
    );
    if (_isAppResumed) _animation.repeat();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final isResumed = state == AppLifecycleState.resumed;
    if (isResumed == _isAppResumed) return;
    _isAppResumed = isResumed;
    if (isResumed) {
      _animation.repeat();
    } else {
      _animation.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            for (final leaf in _leaves)
              _AnimatedLeaf(
                animation: _animation,
                leaf: leaf,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedLeaf extends StatelessWidget {
  const _AnimatedLeaf({
    required this.animation,
    required this.leaf,
    required this.width,
    required this.height,
  });

  final Animation<double> animation;
  final _LeafParticle leaf;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: SizedBox(
        width: leaf.size,
        height: leaf.size,
        child: RepaintBoundary(
          child: Opacity(
            opacity: leaf.opacity,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(leaf.tint, BlendMode.srcIn),
              child: Image.asset(
                leaf.assetPath,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.low,
                excludeFromSemantics: true,
              ),
            ),
          ),
        ),
      ),
      builder: (context, child) {
        final progress = animation.value;
        final y =
            (leaf.startY * height + progress * height * leaf.fallCycles) %
            height;
        final swayPhase = progress * leaf.swayCycles * math.pi * 2 + leaf.phase;
        final x = leaf.x * width + math.sin(swayPhase) * leaf.sway;
        final flutter = math.sin(swayPhase) * 0.28;

        return Positioned(
          left: x - leaf.size / 2,
          top: y - leaf.size / 2,
          width: leaf.size,
          height: leaf.size,
          child: Transform.rotate(angle: leaf.angle + flutter, child: child),
        );
      },
    );
  }
}

class _LeafParticle {
  const _LeafParticle({
    required this.x,
    required this.startY,
    required this.size,
    required this.sway,
    required this.phase,
    required this.fallCycles,
    required this.swayCycles,
    required this.angle,
    required this.opacity,
    required this.assetPath,
    required this.tint,
  });

  factory _LeafParticle.random(math.Random random) {
    final tints = [
      const Color(0xFFC5A47F),
      const Color(0xFFD0B38F),
      const Color(0xFFB9956F),
    ];
    return _LeafParticle(
      x: random.nextDouble(),
      startY: random.nextDouble(),
      size: 10 + random.nextDouble() * 8,
      sway: 5 + random.nextDouble() * 18,
      phase: random.nextDouble() * math.pi * 2,
      fallCycles: 1 + random.nextInt(2),
      swayCycles: 1 + random.nextInt(3),
      angle: random.nextDouble() * math.pi * 2,
      opacity: 0.3 + random.nextDouble() * 0.15,
      assetPath: random.nextBool()
          ? 'assets/images/backgrounds/leaf_fall1.png'
          : 'assets/images/backgrounds/leaf_fall2.png',
      tint: tints[random.nextInt(tints.length)],
    );
  }

  final double x;
  final double startY;
  final double size;
  final double sway;
  final double phase;
  final int fallCycles;
  final int swayCycles;
  final double angle;
  final double opacity;
  final String assetPath;
  final Color tint;
}
