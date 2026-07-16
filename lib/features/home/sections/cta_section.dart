import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/net_image.dart';
import '../../../shared/widgets/reveal.dart';

/// Closing invitation band before the footer.
class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return SizedBox(
      height: context.fluid(480, 560),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const NetImage(
              'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=2000&q=75'),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.midnightDeep.withValues(alpha: 0.72),
            ),
          ),
          SectionFrame(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Reveal(
                  child: Text(
                    'YOUR NEXT CHAPTER',
                    style: theme.labelMedium?.copyWith(
                      color: AppColors.goldBright,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Reveal(
                  delay: const Duration(milliseconds: 120),
                  child: Text(
                    'Tell us where the story goes.',
                    textAlign: TextAlign.center,
                    style: theme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontSize: context.fluid(34, 62),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Reveal(
                  delay: const Duration(milliseconds: 240),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Text(
                      'A thirty-minute conversation with a travel designer is free, '
                      'unhurried, and usually the beginning of something extraordinary.',
                      textAlign: TextAlign.center,
                      style: theme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8)),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Reveal(
                  delay: const Duration(milliseconds: 360),
                  child: Wrap(
                    spacing: 18,
                    runSpacing: 14,
                    alignment: WrapAlignment.center,
                    children: [
                      AureviaButton(
                        label: 'Start an enquiry',
                        onPressed: () => context.go('/contact'),
                      ),
                      AureviaButton(
                        label: 'Browse the gallery',
                        style: AureviaButtonStyle.ghostLight,
                        icon: null,
                        onPressed: () => context.go('/gallery'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
