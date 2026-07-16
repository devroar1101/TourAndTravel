import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import 'net_image.dart';

/// Dark photographic header used by inner pages, with scroll parallax and a
/// title-card entrance.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.image,
    this.subtitle,
    this.height,
    this.scrollOffset,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final String image;
  final double? height;
  final ValueNotifier<double>? scrollOffset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final headerHeight = height ?? context.fluid(420, 560);

    Widget backdrop = NetImage(image);
    final offset = scrollOffset;
    if (offset != null) {
      backdrop = ValueListenableBuilder<double>(
        valueListenable: offset,
        builder: (context, value, child) => Transform.translate(
          offset: Offset(0, value * 0.3),
          child: child,
        ),
        child: backdrop,
      );
    }

    return SizedBox(
      height: headerHeight,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            backdrop,
            const DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.heroOverlay),
            ),
            SectionFrame(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 44, height: 1, color: AppColors.gold),
                      const SizedBox(width: 14),
                      Text(
                        eyebrow.toUpperCase(),
                        style: theme.labelMedium?.copyWith(
                          color: AppColors.goldBright,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 700.ms)
                      .moveX(begin: -24, curve: Curves.easeOutCubic),
                  const SizedBox(height: 18),
                  ClipRect(
                    child: Text(
                      title,
                      style: theme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontSize: context.fluid(38, 64),
                      ),
                    )
                        .animate(delay: 350.ms)
                        .moveY(
                            begin: 90,
                            end: 0,
                            duration: 900.ms,
                            curve: Curves.easeOutCubic)
                        .fadeIn(duration: 500.ms),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 14),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Text(
                        subtitle!,
                        style: theme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.82)),
                      ),
                    )
                        .animate(delay: 600.ms)
                        .fadeIn(duration: 800.ms)
                        .moveY(begin: 20, curve: Curves.easeOutCubic),
                  ],
                  SizedBox(height: context.fluid(40, 64)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
