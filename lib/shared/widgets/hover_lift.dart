import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Desktop hover treatment: a gentle lift, scale and deepened shadow.
/// On touch devices it simply renders the child.
class HoverLift extends StatefulWidget {
  const HoverLift({
    super.key,
    required this.child,
    this.lift = 8,
    this.scale = 1.02,
    this.shadow = true,
    this.borderRadius,
    this.onHoverChanged,
  });

  final Widget child;
  final double lift;
  final double scale;
  final bool shadow;
  final BorderRadius? borderRadius;
  final ValueChanged<bool>? onHoverChanged;

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        widget.onHoverChanged?.call(true);
      },
      onExit: (_) {
        setState(() => _hovered = false);
        widget.onHoverChanged?.call(false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translateByDouble(0, _hovered ? -widget.lift : 0, 0, 1)
          ..scaleByDouble(_hovered ? widget.scale : 1,
              _hovered ? widget.scale : 1, 1, 1),
        transformAlignment: Alignment.center,
        decoration: widget.shadow
            ? BoxDecoration(
                borderRadius: widget.borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: _hovered ? AppColors.shadowDeep : AppColors.shadowSoft,
                    blurRadius: _hovered ? 40 : 20,
                    offset: Offset(0, _hovered ? 24 : 10),
                  ),
                ],
              )
            : null,
        child: widget.child,
      ),
    );
  }
}
