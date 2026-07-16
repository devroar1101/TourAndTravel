import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Visual style of an [AureviaButton].
enum AureviaButtonStyle { gold, ghostLight, ghostDark, emerald }

/// The site's signature button: squared, letter-spaced, with an arrow that
/// glides on hover.
class AureviaButton extends StatefulWidget {
  const AureviaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AureviaButtonStyle.gold,
    this.icon = Icons.arrow_forward,
    this.expand = false,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AureviaButtonStyle style;
  final IconData? icon;
  final bool expand;
  final bool busy;

  @override
  State<AureviaButton> createState() => _AureviaButtonState();
}

class _AureviaButtonState extends State<AureviaButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, border) = switch (widget.style) {
      AureviaButtonStyle.gold => (
          _hovered ? AppColors.goldBright : AppColors.gold,
          AppColors.midnightDeep,
          Colors.transparent,
        ),
      AureviaButtonStyle.emerald => (
          _hovered ? AppColors.emerald : AppColors.emeraldDeep,
          AppColors.onDark,
          Colors.transparent,
        ),
      AureviaButtonStyle.ghostLight => (
          _hovered ? Colors.white.withValues(alpha: 0.12) : Colors.transparent,
          Colors.white,
          Colors.white.withValues(alpha: 0.55),
        ),
      AureviaButtonStyle.ghostDark => (
          _hovered
              ? AppColors.midnight.withValues(alpha: 0.06)
              : Colors.transparent,
          AppColors.midnight,
          AppColors.midnight.withValues(alpha: 0.4),
        ),
    };

    final label = Text(
      widget.label.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: foreground,
            fontSize: 13,
            letterSpacing: 2.2,
            fontWeight: FontWeight.w600,
          ),
    );

    return MouseRegion(
      cursor: widget.onPressed == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.busy ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
          decoration: BoxDecoration(
            color: background,
            border: Border.all(color: border, width: 1.2),
          ),
          child: Row(
            mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.busy) ...[
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foreground,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              label,
              if (widget.icon != null && !widget.busy) ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  margin: EdgeInsets.only(left: _hovered ? 16 : 10),
                  child: Icon(widget.icon, size: 16, color: foreground),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
