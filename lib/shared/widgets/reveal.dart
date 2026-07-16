import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Direction a [Reveal] slides in from.
enum RevealFrom { bottom, left, right, none }

/// Scroll-triggered entrance animation.
///
/// Children start invisible and play a fade + slide (+ optional scale) the
/// first time they enter the viewport. Fires once; re-scrolling does not
/// replay, which keeps long pages calm.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.from = RevealFrom.bottom,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 850),
    this.distance = 48,
    this.scaleFrom,
  });

  final Widget child;
  final RevealFrom from;
  final Duration delay;
  final Duration duration;
  final double distance;
  final double? scaleFrom;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  bool _shown = false;
  final Key _detectorKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _detectorKey,
      onVisibilityChanged: (info) {
        if (!_shown && info.visibleFraction > 0.08 && mounted) {
          setState(() => _shown = true);
        }
      },
      child: !_shown
          ? Opacity(opacity: 0, child: widget.child)
          : _animated(widget.child),
    );
  }

  Widget _animated(Widget child) {
    final offset = switch (widget.from) {
      RevealFrom.bottom => Offset(0, widget.distance),
      RevealFrom.left => Offset(-widget.distance, 0),
      RevealFrom.right => Offset(widget.distance, 0),
      RevealFrom.none => Offset.zero,
    };
    var animated = child
        .animate(delay: widget.delay)
        .fadeIn(duration: widget.duration, curve: Curves.easeOutCubic);
    if (offset != Offset.zero) {
      animated = animated.move(
        begin: offset,
        end: Offset.zero,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
      );
    }
    if (widget.scaleFrom != null) {
      animated = animated.scale(
        begin: Offset(widget.scaleFrom!, widget.scaleFrom!),
        end: const Offset(1, 1),
        duration: widget.duration,
        curve: Curves.easeOutCubic,
      );
    }
    return animated;
  }
}
