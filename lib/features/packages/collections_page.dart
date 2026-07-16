import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/tour_package.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/hover_lift.dart';
import '../../shared/widgets/net_image.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/rating_stars.dart';
import '../../shared/widgets/reveal.dart';

/// The tour package index, filterable by the nine collections.
class CollectionsPage extends ConsumerStatefulWidget {
  const CollectionsPage({super.key, this.initialCategory});

  final String? initialCategory;

  @override
  ConsumerState<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends ConsumerState<CollectionsPage> {
  PackageCategory? _category;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialCategory;
    if (initial != null && initial.isNotEmpty) {
      _category = PackageCategory.fromName(initial);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      sections: [
        (context, offset) => PageHeader(
              eyebrow: 'The collections',
              title: 'Journeys, curated\nby temperament',
              subtitle:
                  'Nine collections, one standard. Choose the mood; we\'ve already '
                  'composed the rest.',
              image:
                  'https://images.unsplash.com/photo-1530789253388-582c481c54b0?auto=format&fit=crop&w=2000&q=75',
              scrollOffset: offset,
            ),
        (context, _) => _PackagesBody(
              category: _category,
              onCategory: (c) => setState(() => _category = c),
            ),
      ],
    );
  }
}

class _PackagesBody extends ConsumerWidget {
  const _PackagesBody({required this.category, required this.onCategory});

  final PackageCategory? category;
  final ValueChanged<PackageCategory?> onCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packages = ref.watch(packagesProvider);

    return Container(
      color: AppColors.ivory,
      padding: EdgeInsets.symmetric(vertical: context.fluid(48, 80)),
      child: SectionFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Reveal(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _CategoryChip(
                    label: 'All',
                    selected: category == null,
                    onTap: () => onCategory(null),
                  ),
                  for (final c in PackageCategory.values)
                    _CategoryChip(
                      label: c.label,
                      selected: category == c,
                      onTap: () => onCategory(c),
                    ),
                ],
              ),
            ),
            SizedBox(height: context.fluid(32, 52)),
            packages.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 120),
                child: Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.gold)),
              ),
              error: (e, _) => Text('Could not load packages: $e'),
              data: (all) {
                final list = category == null
                    ? all
                    : all.where((p) => p.category == category).toList();
                if (list.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Center(
                      child: Text(
                        'New journeys for this collection are being composed — '
                        'speak to a designer for a bespoke one.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final (i, p) in list.indexed)
                      Reveal(
                        delay: Duration(milliseconds: 60 * (i % 3)),
                        child: _PackageRow(pkg: p, flip: i.isOdd),
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

class _CategoryChip extends StatefulWidget {
  const _CategoryChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppColors.emeraldDeep
                : _hovered
                    ? AppColors.emeraldDeep.withValues(alpha: 0.07)
                    : Colors.transparent,
            border: Border.all(
              color: widget.selected
                  ? AppColors.emeraldDeep
                  : AppColors.midnight.withValues(alpha: 0.25),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            widget.label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: widget.selected ? Colors.white : AppColors.ink,
                  fontSize: 11,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}

/// Alternating editorial rows: photograph one side, narrative the other.
class _PackageRow extends StatelessWidget {
  const _PackageRow({required this.pkg, required this.flip});

  final TourPackage pkg;
  final bool flip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    final image = HoverLift(
      lift: 4,
      borderRadius: BorderRadius.circular(6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: AspectRatio(
          aspectRatio: 16 / 11,
          child: NetImage(pkg.image),
        ),
      ),
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.emeraldDeep.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                pkg.category.label.toUpperCase(),
                style: theme.labelSmall?.copyWith(
                    color: AppColors.emeraldDeep,
                    fontSize: 10,
                    letterSpacing: 2),
              ),
            ),
            if (pkg.featured) ...[
              const SizedBox(width: 10),
              const Icon(Icons.workspace_premium_outlined,
                  size: 18, color: AppColors.gold),
            ],
            const Spacer(),
            RatingStars(pkg.rating, size: 14),
          ],
        ),
        const SizedBox(height: 18),
        Text(pkg.name,
            style: theme.headlineMedium?.copyWith(fontWeight: FontWeight.w300)),
        const SizedBox(height: 12),
        Text(pkg.description, style: theme.bodyMedium),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final stop in pkg.route)
              Text(
                pkg.route.last == stop ? stop : '$stop  →',
                style: theme.bodySmall?.copyWith(
                    color: AppColors.inkSoft, fontWeight: FontWeight.w400),
              ),
          ],
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FROM',
                    style: theme.labelSmall?.copyWith(
                        fontSize: 9.5,
                        letterSpacing: 2,
                        color: AppColors.inkSoft)),
                Text(
                  Formatters.price(pkg.price),
                  style: theme.headlineSmall?.copyWith(
                      color: AppColors.emeraldDeep,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(width: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DURATION',
                    style: theme.labelSmall?.copyWith(
                        fontSize: 9.5,
                        letterSpacing: 2,
                        color: AppColors.inkSoft)),
                Text(Formatters.duration(pkg.days, pkg.nights),
                    style: theme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w400)),
              ],
            ),
            const Spacer(),
            AureviaButton(
              label: 'Enquire',
              style: AureviaButtonStyle.emerald,
              onPressed: () => context.go('/contact?destination=${pkg.name}'),
            ),
          ],
        ),
      ],
    );

    if (context.isMobile) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 56),
        child:
            Column(children: [image, const SizedBox(height: 24), content]),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 88),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: flip
            ? [
                Expanded(flex: 6, child: content),
                const SizedBox(width: 64),
                Expanded(flex: 5, child: image),
              ]
            : [
                Expanded(flex: 5, child: image),
                const SizedBox(width: 64),
                Expanded(flex: 6, child: content),
              ],
      ),
    );
  }
}
