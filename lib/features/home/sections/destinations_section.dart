import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../providers/providers.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/destination_card.dart';
import '../../../shared/widgets/reveal.dart';
import '../../../shared/widgets/section_header.dart';

/// Featured destinations in a staggered editorial grid.
class DestinationsSection extends ConsumerWidget {
  const DestinationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(featuredDestinationsProvider);

    return Container(
      color: AppColors.mist,
      padding: EdgeInsets.symmetric(vertical: context.fluid(80, 140)),
      child: SectionFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Expanded(
                  child: SectionHeader(
                    eyebrow: 'Signature destinations',
                    title: 'Places that ask\nto be remembered',
                  ),
                ),
                if (context.isDesktop)
                  Reveal(
                    from: RevealFrom.right,
                    child: AureviaButton(
                      label: 'View all fifteen',
                      style: AureviaButtonStyle.ghostDark,
                      onPressed: () => context.go('/destinations'),
                    ),
                  ),
              ],
            ),
            SizedBox(height: context.fluid(40, 64)),
            featured.when(
              loading: () => const _CardGridPlaceholder(),
              error: (e, _) => Text('Could not load destinations: $e'),
              data: (list) {
                final items = list.take(6).toList();
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth > 1080
                        ? 3
                        : constraints.maxWidth > 680
                            ? 2
                            : 1;
                    const gap = 28.0;
                    final width = (constraints.maxWidth - gap * (columns - 1)) /
                        columns;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap + 8,
                      children: [
                        for (final (i, d) in items.indexed)
                          SizedBox(
                            width: width,
                            child: Reveal(
                              delay: Duration(milliseconds: 90 * (i % columns)),
                              child: Padding(
                                // Stagger middle column downward for rhythm.
                                padding: EdgeInsets.only(
                                    top: columns == 3 && i % 3 == 1 ? 40 : 0),
                                child: DestinationCard(destination: d),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
            if (!context.isDesktop) ...[
              const SizedBox(height: 40),
              Center(
                child: AureviaButton(
                  label: 'View all fifteen',
                  style: AureviaButtonStyle.ghostDark,
                  onPressed: () => context.go('/destinations'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CardGridPlaceholder extends StatelessWidget {
  const _CardGridPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.gold,
        ),
      ),
    );
  }
}
