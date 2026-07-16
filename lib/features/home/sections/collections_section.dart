import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/tour_package.dart';
import '../../../shared/widgets/net_image.dart';
import '../../../shared/widgets/reveal.dart';
import '../../../shared/widgets/section_header.dart';

/// The nine curated collections as an interactive index — hovering a row
/// swaps the backdrop photograph, magazine-masthead style.
class CollectionsSection extends StatefulWidget {
  const CollectionsSection({super.key});

  @override
  State<CollectionsSection> createState() => _CollectionsSectionState();
}

class _CollectionsSectionState extends State<CollectionsSection> {
  int _active = 0;

  static const _images = {
    PackageCategory.luxury:
        'https://images.unsplash.com/photo-1573843981267-be1999ff37cd?auto=format&fit=crop&w=1600&q=75',
    PackageCategory.adventure:
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=1600&q=75',
    PackageCategory.family:
        'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?auto=format&fit=crop&w=1600&q=75',
    PackageCategory.honeymoon:
        'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?auto=format&fit=crop&w=1600&q=75',
    PackageCategory.weekend:
        'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?auto=format&fit=crop&w=1600&q=75',
    PackageCategory.international:
        'https://images.unsplash.com/photo-1530122037265-a5f1f91d3b99?auto=format&fit=crop&w=1600&q=75',
    PackageCategory.budget:
        'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=1600&q=75',
    PackageCategory.premium:
        'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=1600&q=75',
    PackageCategory.vip:
        'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=1600&q=75',
  };

  @override
  Widget build(BuildContext context) {
    final categories = PackageCategory.values;
    final theme = Theme.of(context).textTheme;

    return Container(
      color: AppColors.midnightDeep,
      child: Stack(
        children: [
          // Cross-fading backdrop follows the hovered collection.
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 700),
              switchInCurve: Curves.easeOut,
              child: Opacity(
                key: ValueKey(_active),
                opacity: 0.22,
                child: NetImage(_images[categories[_active]]!),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.midnightDeep.withValues(alpha: 0.9),
                    AppColors.midnightDeep.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.fluid(80, 130)),
            child: SectionFrame(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    eyebrow: 'The collections',
                    title: 'Nine ways\nto go',
                    onDark: true,
                  ),
                  SizedBox(height: context.fluid(36, 56)),
                  for (final (i, category) in categories.indexed)
                    Reveal(
                      delay: Duration(milliseconds: 50 * i),
                      distance: 30,
                      child: _CollectionRow(
                        index: i,
                        category: category,
                        active: _active == i,
                        onHover: () => setState(() => _active = i),
                        onTap: () =>
                            context.go('/collections?category=${category.name}'),
                        theme: theme,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionRow extends StatelessWidget {
  const _CollectionRow({
    required this.index,
    required this.category,
    required this.active,
    required this.onHover,
    required this.onTap,
    required this.theme,
  });

  final int index;
  final PackageCategory category;
  final bool active;
  final VoidCallback onHover;
  final VoidCallback onTap;
  final TextTheme theme;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 52,
                child: Text(
                  (index + 1).toString().padLeft(2, '0'),
                  style: theme.labelMedium?.copyWith(
                    color: active ? AppColors.gold : AppColors.onDarkSoft,
                  ),
                ),
              ),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                style: theme.headlineLarge!.copyWith(
                  color: active ? Colors.white : AppColors.onDarkSoft,
                  fontSize: context.fluid(26, 44),
                  fontWeight: active ? FontWeight.w300 : FontWeight.w200,
                ),
                child: Text(category.label),
              ),
              const Spacer(),
              if (context.isDesktop)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: active ? 1 : 0,
                  child: Row(
                    children: [
                      Text(
                        category.subtitle,
                        style: theme.bodySmall
                            ?.copyWith(color: AppColors.onDarkSoft),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.arrow_forward,
                          color: AppColors.gold, size: 18),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
