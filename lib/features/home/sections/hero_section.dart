import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/net_image.dart';
import '../../../shared/widgets/video_background.dart';

/// Full-screen cinematic opener: background film, staggered headline,
/// floating destination vignettes that answer the cursor, and a scroll cue.
class HeroSection extends StatefulWidget {
  const HeroSection({super.key, required this.scrollOffset});

  final ValueNotifier<double> scrollOffset;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  Offset _mouse = Offset.zero; // normalised -1..1 from screen centre

  @override
  Widget build(BuildContext context) {
    final height = context.screenHeight;
    final theme = Theme.of(context).textTheme;
    final isDesktop = context.isDesktop;

    return MouseRegion(
      onHover: (event) {
        final size = MediaQuery.sizeOf(context);
        setState(() {
          _mouse = Offset(
            (event.position.dx / size.width) * 2 - 1,
            (event.position.dy / size.height) * 2 - 1,
          );
        });
      },
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Film layer with slow scroll parallax.
            ValueListenableBuilder<double>(
              valueListenable: widget.scrollOffset,
              builder: (context, offset, child) => Transform.translate(
                offset: Offset(0, offset * 0.35),
                child: child,
              ),
              child: const VideoBackground(
                videoUrl:
                    'https://videos.pexels.com/video-files/2169880/2169880-uhd_3840_2160_30fps.mp4',
                posterUrl:
                    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=2000&q=80',
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.heroOverlay),
            ),

            // Copy block.
            Positioned.fill(
              child: SectionFrame(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.fluid(60, 40)),
                    Row(
                      children: [
                        Container(width: 56, height: 1, color: AppColors.gold),
                        const SizedBox(width: 16),
                        Text(
                          'LUXURY TRAVEL, COMPOSED',
                          style: theme.labelMedium?.copyWith(
                            color: AppColors.goldBright,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                        .animate(delay: 300.ms)
                        .fadeIn(duration: 800.ms)
                        .moveX(begin: -30, curve: Curves.easeOutCubic),
                    const SizedBox(height: 30),
                    _HeadlineLine('Some journeys', theme, context, delay: 500),
                    _HeadlineLine('are works', theme, context, delay: 650),
                    _HeadlineLine('of art.', theme, context,
                        delay: 800, gold: true),
                    const SizedBox(height: 30),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Text(
                        'Aurevia designs private, cinematic journeys across '
                        'India and the world — built by hand, run without '
                        'friction, remembered forever.',
                        style: theme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                    )
                        .animate(delay: 1050.ms)
                        .fadeIn(duration: 900.ms)
                        .moveY(begin: 24, curve: Curves.easeOutCubic),
                    const SizedBox(height: 42),
                    Wrap(
                      spacing: 18,
                      runSpacing: 14,
                      children: [
                        AureviaButton(
                          label: 'Explore destinations',
                          onPressed: () => context.go('/destinations'),
                        ),
                        AureviaButton(
                          label: 'Plan a journey',
                          style: AureviaButtonStyle.ghostLight,
                          icon: null,
                          onPressed: () => context.go('/contact'),
                        ),
                      ],
                    )
                        .animate(delay: 1250.ms)
                        .fadeIn(duration: 900.ms)
                        .moveY(begin: 24, curve: Curves.easeOutCubic),
                  ],
                ),
              ),
            ),

            // Floating vignettes (desktop only).
            if (isDesktop) ...[
              _FloatingCard(
                mouse: _mouse,
                parallax: 26,
                right: context.fluid(40, 150),
                top: height * 0.22,
                image:
                    'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?auto=format&fit=crop&w=600&q=70',
                title: 'Maldives',
                subtitle: 'From ₹89,000',
                delay: 1500,
                floatPeriod: 3600,
              ),
              _FloatingCard(
                mouse: _mouse,
                parallax: 42,
                right: context.fluid(140, 320),
                top: height * 0.48,
                image:
                    'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=600&q=70',
                title: 'Bali',
                subtitle: 'From ₹64,500',
                delay: 1700,
                floatPeriod: 4300,
              ),
              _FloatingCard(
                mouse: _mouse,
                parallax: 16,
                right: context.fluid(30, 120),
                top: height * 0.66,
                image:
                    'https://images.unsplash.com/photo-1530122037265-a5f1f91d3b99?auto=format&fit=crop&w=600&q=70',
                title: 'Switzerland',
                subtitle: 'From ₹1,45,000',
                delay: 1900,
                floatPeriod: 5100,
              ),
            ],

            // Scroll cue.
            Positioned(
              bottom: 34,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'SCROLL',
                    style: theme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.65),
                      letterSpacing: 4,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(width: 1, height: 42, color: Colors.white38)
                      .animate(onPlay: (c) => c.repeat())
                      .scaleY(
                        begin: 0,
                        end: 1,
                        alignment: Alignment.topCenter,
                        duration: 1400.ms,
                        curve: Curves.easeInOutCubic,
                      )
                      .then()
                      .scaleY(
                        begin: 1,
                        end: 0,
                        alignment: Alignment.bottomCenter,
                        duration: 1400.ms,
                        curve: Curves.easeInOutCubic,
                      ),
                ],
              ).animate(delay: 2000.ms).fadeIn(duration: 800.ms),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeadlineLine extends StatelessWidget {
  const _HeadlineLine(this.text, this.theme, this.outerContext,
      {required this.delay, this.gold = false});

  final String text;
  final TextTheme theme;
  final BuildContext outerContext;
  final int delay;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final style =
        (outerContext.isMobile ? theme.displaySmall : theme.displayLarge)
            ?.copyWith(
      color: gold ? AppColors.goldBright : Colors.white,
      fontSize: outerContext.fluid(44, 96),
    );
    // Clip each line so it rises into view like a title card.
    return ClipRect(
      child: Text(text, style: style)
          .animate(delay: Duration(milliseconds: delay))
          .moveY(
            begin: 110,
            end: 0,
            duration: 1000.ms,
            curve: Curves.easeOutCubic,
          )
          .fadeIn(duration: 600.ms),
    );
  }
}

class _FloatingCard extends StatelessWidget {
  const _FloatingCard({
    required this.mouse,
    required this.parallax,
    required this.right,
    required this.top,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.delay,
    required this.floatPeriod,
  });

  final Offset mouse;
  final double parallax;
  final double right;
  final double top;
  final String image;
  final String title;
  final String subtitle;
  final int delay;
  final int floatPeriod;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right,
      top: top,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
            -mouse.dx * parallax, -mouse.dy * parallax, 0),
        child: Container(
          width: 210,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                    width: 54, height: 54, child: NetImage(image)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.goldBright,
                        fontSize: 11,
                        letterSpacing: 0.6),
                  ),
                ],
              ),
            ],
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(
              begin: -7,
              end: 7,
              duration: Duration(milliseconds: floatPeriod),
              curve: Curves.easeInOut,
            ),
      )
          .animate(delay: Duration(milliseconds: delay))
          .fadeIn(duration: 900.ms)
          .moveX(begin: 60, curve: Curves.easeOutCubic),
    );
  }
}
