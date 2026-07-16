import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/destination.dart';
import 'buttons.dart';
import 'hover_lift.dart';
import 'net_image.dart';
import 'rating_stars.dart';

/// Editorial destination card: full-bleed photography, image zoom on hover,
/// and a meta band that reveals the booking action.
class DestinationCard extends StatefulWidget {
  const DestinationCard({super.key, required this.destination, this.height = 460});

  final Destination destination;
  final double height;

  @override
  State<DestinationCard> createState() => _DestinationCardState();
}

class _DestinationCardState extends State<DestinationCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.destination;
    final theme = Theme.of(context).textTheme;
    return HoverLift(
      lift: 6,
      scale: 1.0,
      onHoverChanged: (v) => setState(() => _hovered = v),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.go('/destinations/${d.slug}'),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: widget.height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedScale(
                    scale: _hovered ? 1.07 : 1.0,
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    child: NetImage(d.cardImage),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(gradient: AppColors.cardOverlay),
                  ),
                  Positioned(
                    top: 18,
                    left: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      color: Colors.black.withValues(alpha: 0.35),
                      child: Text(
                        d.country.toUpperCase(),
                        style: theme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          letterSpacing: 2.4,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 18,
                    child: Row(
                      children: [
                        RatingStars(d.rating, size: 13),
                        const SizedBox(width: 6),
                        Text(
                          d.rating.toStringAsFixed(1),
                          style: theme.labelSmall
                              ?.copyWith(color: Colors.white, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 22,
                    right: 22,
                    bottom: 22,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.name,
                          style: theme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          d.tagline,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.78)),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _Meta(
                                icon: Icons.schedule,
                                text: Formatters.duration(d.days, d.nights)),
                            const SizedBox(width: 18),
                            _Meta(icon: Icons.wb_sunny_outlined, text: d.bestSeason),
                          ],
                        ),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 350),
                          sizeCurve: Curves.easeOutCubic,
                          crossFadeState: _hovered
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: 'FROM  ',
                                  style: theme.labelSmall?.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.6),
                                      fontSize: 10),
                                ),
                                TextSpan(
                                  text: Formatters.price(d.priceFrom),
                                  style: theme.titleLarge?.copyWith(
                                      color: AppColors.goldBright,
                                      fontWeight: FontWeight.w500),
                                ),
                              ]),
                            ),
                          ),
                          secondChild: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    Formatters.price(d.priceFrom),
                                    style: theme.titleLarge?.copyWith(
                                        color: AppColors.goldBright,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                AureviaButton(
                                  label: 'Book now',
                                  onPressed: () =>
                                      context.go('/destinations/${d.slug}'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.7)),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 10.5,
              letterSpacing: 0.8),
        ),
      ],
    );
  }
}
