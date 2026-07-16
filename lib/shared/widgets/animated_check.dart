import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Drawn success mark: an emerald circle sweeps closed, then the tick
/// strokes itself in. Used by the enquiry form's confirmation state.
class AnimatedCheck extends StatefulWidget {
  const AnimatedCheck({super.key, this.size = 96});

  final double size;

  @override
  State<AnimatedCheck> createState() => _AnimatedCheckState();
}

class _AnimatedCheckState extends State<AnimatedCheck>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        size: Size.square(widget.size),
        painter: _CheckPainter(_controller.value),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  _CheckPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 4;

    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..color = AppColors.emerald;

    // Circle sweep occupies the first 55% of the timeline.
    final circleT = (progress / 0.55).clamp(0.0, 1.0);
    final sweep = Curves.easeOutCubic.transform(circleT) * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      circlePaint,
    );

    // Tick strokes in over the remainder.
    final tickT =
        Curves.easeOutCubic.transform(((progress - 0.5) / 0.5).clamp(0.0, 1.0));
    if (tickT <= 0) return;

    final p1 = Offset(size.width * 0.30, size.height * 0.52);
    final p2 = Offset(size.width * 0.45, size.height * 0.66);
    final p3 = Offset(size.width * 0.71, size.height * 0.36);
    final path = Path()..moveTo(p1.dx, p1.dy);

    const firstLeg = 0.42;
    if (tickT <= firstLeg) {
      final t = tickT / firstLeg;
      path.lineTo(_lerp(p1.dx, p2.dx, t), _lerp(p1.dy, p2.dy, t));
    } else {
      path.lineTo(p2.dx, p2.dy);
      final t = (tickT - firstLeg) / (1 - firstLeg);
      path.lineTo(_lerp(p2.dx, p3.dx, t), _lerp(p2.dy, p3.dy, t));
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = AppColors.emerald,
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
