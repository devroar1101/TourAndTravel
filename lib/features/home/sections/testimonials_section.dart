import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/content_models.dart';
import '../../../providers/providers.dart';
import '../../../shared/widgets/net_image.dart';
import '../../../shared/widgets/rating_stars.dart';
import '../../../shared/widgets/section_header.dart';

/// Auto-advancing testimonial theatre with portrait, quote and progress dots.
class TestimonialsSection extends ConsumerStatefulWidget {
  const TestimonialsSection({super.key});

  @override
  ConsumerState<TestimonialsSection> createState() =>
      _TestimonialsSectionState();
}

class _TestimonialsSectionState extends ConsumerState<TestimonialsSection> {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      final items = ref.read(testimonialsProvider).value;
      if (items == null || items.isEmpty || !mounted) return;
      setState(() => _index = (_index + 1) % items.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testimonials = ref.watch(testimonialsProvider);

    return Container(
      color: AppColors.ivory,
      padding: EdgeInsets.symmetric(vertical: context.fluid(80, 140)),
      child: SectionFrame(
        maxWidth: 1000,
        child: Column(
          children: [
            const SectionHeader(
              eyebrow: 'Word of mouth',
              title: 'Travellers, verbatim',
              center: true,
            ),
            SizedBox(height: context.fluid(40, 64)),
            testimonials.when(
              loading: () => const SizedBox(height: 320),
              error: (e, _) => Text('Could not load testimonials: $e'),
              data: (items) {
                if (items.isEmpty) return const SizedBox.shrink();
                final t = items[_index % items.length];
                return Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 650),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween(
                            begin: const Offset(0, 0.08),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: _TestimonialCard(
                          key: ValueKey(t.id), testimonial: t),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final (i, _) in items.indexed)
                          GestureDetector(
                            onTap: () => setState(() => _index = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              width: i == _index % items.length ? 28 : 8,
                              height: 4,
                              decoration: BoxDecoration(
                                color: i == _index % items.length
                                    ? AppColors.gold
                                    : AppColors.midnight
                                        .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({super.key, required this.testimonial});

  final Testimonial testimonial;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          '“',
          style: theme.displayLarge?.copyWith(
            color: AppColors.gold,
            height: 0.6,
            fontSize: 110,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          testimonial.quote,
          textAlign: TextAlign.center,
          style: theme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w300,
            height: 1.5,
            fontSize: context.fluid(19, 27),
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: SizedBox(
                width: 52,
                height: 52,
                child: NetImage(testimonial.avatar),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(testimonial.name, style: theme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  '${testimonial.origin} · ${testimonial.tripName}',
                  style: theme.bodySmall,
                ),
              ],
            ),
            const SizedBox(width: 18),
            RatingStars(testimonial.rating),
          ],
        ),
      ],
    );
  }
}
