import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Counts from zero to [value] the first time it scrolls into view.
class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    required this.style,
    this.suffix = '',
    this.prefix = '',
    this.duration = const Duration(milliseconds: 1800),
    this.formatter,
  });

  final int value;
  final TextStyle? style;
  final String suffix;
  final String prefix;
  final Duration duration;
  final String Function(int)? formatter;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo);
  final Key _detectorKey = UniqueKey();
  bool _started = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _detectorKey,
      onVisibilityChanged: (info) {
        if (!_started && info.visibleFraction > 0.4 && mounted) {
          _started = true;
          _controller.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final current = (_animation.value * widget.value).round();
          final text = widget.formatter?.call(current) ?? '$current';
          return Text(
            '${widget.prefix}$text${widget.suffix}',
            style: widget.style,
          );
        },
      ),
    );
  }
}
