import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import 'reveal.dart';

/// Editorial section opener: a gold rule + letter-spaced eyebrow, then a
/// large light headline, optionally with a supporting paragraph.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.body,
    this.onDark = false,
    this.center = false,
  });

  final String eyebrow;
  final String title;
  final String? body;
  final bool onDark;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final titleColor = onDark ? AppColors.onDark : AppColors.inkStrong;
    final bodyColor = onDark ? AppColors.onDarkSoft : AppColors.inkSoft;
    final cross =
        center ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: cross,
      children: [
        Reveal(
          from: RevealFrom.bottom,
          distance: 24,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 1, color: AppColors.gold),
              const SizedBox(width: 14),
              Text(
                eyebrow.toUpperCase(),
                style: theme.labelMedium?.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (center) ...[
                const SizedBox(width: 14),
                Container(width: 40, height: 1, color: AppColors.gold),
              ],
            ],
          ),
        ),
        const SizedBox(height: 22),
        Reveal(
          delay: const Duration(milliseconds: 120),
          child: Text(
            title,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: (context.isMobile ? theme.headlineLarge : theme.displaySmall)
                ?.copyWith(color: titleColor),
          ),
        ),
        if (body != null) ...[
          const SizedBox(height: 20),
          Reveal(
            delay: const Duration(milliseconds: 240),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Text(
                body!,
                textAlign: center ? TextAlign.center : TextAlign.start,
                style: theme.bodyLarge?.copyWith(color: bodyColor),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
