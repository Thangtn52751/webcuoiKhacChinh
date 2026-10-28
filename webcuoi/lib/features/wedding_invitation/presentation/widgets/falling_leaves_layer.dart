import 'dart:math' as math;

import 'package:flutter/material.dart';

class FallingLeavesLayer extends StatefulWidget {
  const FallingLeavesLayer({super.key, this.count = 8});

  final int count;

  @override
  State<FallingLeavesLayer> createState() => _FallingLeavesLayerState();
}

class _FallingLeavesLayerState extends State<FallingLeavesLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation;
  late final List<_LeafParticle> _leaves;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _leaves = List.generate(widget.count, (_) => _LeafParticle.random(random));
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 36),
    )..repeat();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  for (final leaf in _leaves)
                    _buildLeaf(
                      leaf,
                      constraints.maxWidth,
                      constraints.maxHeight,
                      _animation.value,
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLeaf(
    _LeafParticle leaf,
    double width,
    double height,
    double progress,
  ) {
    final y =
        (leaf.startY * height + progress * height * leaf.fallCycles) % height;
    final swayPhase = progress * leaf.swayCycles * math.pi * 2 + leaf.phase;
    final x = leaf.x * width + math.sin(swayPhase) * leaf.sway;
    final flutter = math.sin(swayPhase) * 0.28;

    return Positioned(
      left: x - leaf.size / 2,
      top: y - leaf.size / 2,
      width: leaf.size,
      height: leaf.size,
      child: Transform.rotate(
        angle: leaf.angle + flutter,
        child: Opacity(
          opacity: leaf.opacity,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(leaf.tint, BlendMode.srcIn),
            child: Image.asset(
              leaf.assetPath,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
      ),
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
