import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/animated_counter.dart';
import '../../../shared/widgets/net_image.dart';
import '../../../shared/widgets/reveal.dart';
import '../../../shared/widgets/section_header.dart';

/// The company story: an animated milestone timeline beside a photographic
/// collage, closed by the statistics band.
class StorySection extends StatelessWidget {
  const StorySection({super.key});

  static const _milestones = [
    (year: '2010', title: 'A desk in Fort Kochi',
        text: 'Two friends, one telephone, and a conviction that Indian travel deserved better manners.'),
    (year: '2014', title: 'The first thousand',
        text: 'A thousand travellers sent home happy; our houseboat and plantation partnerships take shape.'),
    (year: '2018', title: 'Across the water',
        text: 'International journeys open — Dubai, Bali, the Maldives — with the same handmade standard.'),
    (year: '2022', title: 'The concierge era',
        text: 'A 24/7 travel desk and destination hosts in twelve countries. No traveller is ever alone.'),
    (year: '2026', title: 'Journeys as art',
        text: 'Forty-two countries, one promise unchanged: every itinerary composed like a film.'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    return Container(
      color: AppColors.ivory,
      padding: EdgeInsets.symmetric(vertical: context.fluid(80, 140)),
      child: SectionFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              eyebrow: 'Our story',
              title: 'Sixteen years of\ncomposing journeys',
              body:
                  'Aurevia began with a simple refusal: to sell travel the way it was being sold. '
                  'Since 2010 we have built each journey by hand — the right room, the right table, '
                  'the right hour of light.',
            ),
            SizedBox(height: context.fluid(48, 80)),
            if (isMobile)
              Column(
                children: [
                  const _Timeline(milestones: _milestones),
                  const SizedBox(height: 56),
                  _Collage(height: 420),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(flex: 5, child: _Timeline(milestones: _milestones)),
                  const SizedBox(width: 80),
                  Expanded(flex: 6, child: _Collage(height: 640)),
                ],
              ),
            SizedBox(height: context.fluid(72, 120)),
            const _StatsBand(),
          ],
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.milestones});

  final List<({String year, String title, String text})> milestones;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      children: [
        for (final (i, m) in milestones.indexed)
          Reveal(
            delay: Duration(milliseconds: 100 * i),
            from: RevealFrom.left,
            distance: 36,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == milestones.length - 1
                              ? AppColors.gold
                              : AppColors.ivory,
                          border: Border.all(color: AppColors.gold, width: 2),
                        ),
                      ),
                      if (i != milestones.length - 1)
                        Expanded(
                          child: Container(
                            width: 1,
                            color: AppColors.gold.withValues(alpha: 0.35),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 26),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: i == milestones.length - 1 ? 0 : 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.year,
                            style: theme.labelMedium?.copyWith(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text(m.title, style: theme.headlineSmall),
                          const SizedBox(height: 8),
                          Text(m.text, style: theme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _Collage extends StatelessWidget {
  const _Collage({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: height * 0.22,
            bottom: height * 0.3,
            child: Reveal(
              scaleFrom: 0.94,
              from: RevealFrom.none,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const NetImage(
                    'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=1200&q=75'),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            width: height * 0.52,
            height: height * 0.55,
            child: Reveal(
              delay: const Duration(milliseconds: 200),
              scaleFrom: 0.94,
              from: RevealFrom.none,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.ivory, width: 8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowDeep,
                      blurRadius: 44,
                      offset: const Offset(0, 22),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: const NetImage(
                      'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=800&q=75'),
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            bottom: height * 0.08,
            child: Reveal(
              delay: const Duration(milliseconds: 350),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.midnight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EST. 2010',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.goldBright, letterSpacing: 3),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fort Kochi · Worldwide',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: AppColors.onDark),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsBand extends StatelessWidget {
  const _StatsBand();

  @override
  Widget build(BuildContext context) {
    final stats = [
      (value: AppConstants.yearsExperience, suffix: '+', label: 'Years of craft'),
      (value: AppConstants.happyTravellers, suffix: '+', label: 'Happy travellers'),
      (value: AppConstants.countriesCovered, suffix: '', label: 'Countries covered'),
      (value: AppConstants.tourPackages, suffix: '+', label: 'Tour packages'),
      (value: AppConstants.satisfactionPercent, suffix: '%', label: 'Satisfaction'),
    ];
    final theme = Theme.of(context).textTheme;

    return Reveal(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: context.fluid(36, 56), horizontal: context.fluid(20, 56)),
        decoration: BoxDecoration(
          color: AppColors.midnight,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          runSpacing: 36,
          spacing: 24,
          children: [
            for (final s in stats)
              SizedBox(
                width: context.isMobile ? 140 : 190,
                child: Column(
                  children: [
                    AnimatedCounter(
                      value: s.value,
                      suffix: s.suffix,
                      formatter: (v) => v >= 1000
                          ? '${(v / 1000).toStringAsFixed(0)}K'
                          : '$v',
                      style: theme.displaySmall?.copyWith(
                        color: AppColors.goldBright,
                        fontWeight: FontWeight.w200,
                        fontSize: context.fluid(34, 52),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.label.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: theme.labelSmall?.copyWith(
                        color: AppColors.onDarkSoft,
                        letterSpacing: 2,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
