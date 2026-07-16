import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/destination.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/destination_card.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/reveal.dart';

/// The full destination index with tag filtering.
class DestinationsPage extends ConsumerStatefulWidget {
  const DestinationsPage({super.key});

  @override
  ConsumerState<DestinationsPage> createState() => _DestinationsPageState();
}

class _DestinationsPageState extends ConsumerState<DestinationsPage> {
  String _filter = 'All';

  static const _filters = [
    'All',
    'India',
    'International',
    'Honeymoon',
    'Adventure',
    'Family',
    'Luxury',
    'Nature',
  ];

  List<Destination> _apply(List<Destination> all) {
    return switch (_filter) {
      'All' => all,
      'India' => all.where((d) => !d.isInternational).toList(),
      'International' => all.where((d) => d.isInternational).toList(),
      _ => all.where((d) => d.tags.contains(_filter)).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      sections: [
        (context, offset) => PageHeader(
              eyebrow: 'The atlas',
              title: 'Fifteen destinations,\nzero compromises',
              subtitle:
                  'Every place on this list earned it — scouted in person, partnered '
                  'carefully, and composed into journeys we would take ourselves.',
              image:
                  'https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=2000&q=75',
              scrollOffset: offset,
            ),
        (context, _) => _Body(
              filter: _filter,
              filters: _filters,
              onFilter: (f) => setState(() => _filter = f),
              apply: _apply,
            ),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.filter,
    required this.filters,
    required this.onFilter,
    required this.apply,
  });

  final String filter;
  final List<String> filters;
  final ValueChanged<String> onFilter;
  final List<Destination> Function(List<Destination>) apply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinations = ref.watch(destinationsProvider);
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
                  for (final f in filters)
                    _FilterChip(
                      label: f,
                      selected: f == filter,
                      onTap: () => onFilter(f),
                    ),
                ],
              ),
            ),
            SizedBox(height: context.fluid(32, 52)),
            destinations.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 120),
                child: Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.gold)),
              ),
              error: (e, _) => Text('Could not load destinations: $e'),
              data: (all) {
                final list = apply(all);
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth > 1080
                        ? 3
                        : constraints.maxWidth > 680
                            ? 2
                            : 1;
                    const gap = 28.0;
                    final width =
                        (constraints.maxWidth - gap * (columns - 1)) / columns;
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Wrap(
                        key: ValueKey(filter),
                        spacing: gap,
                        runSpacing: gap,
                        children: [
                          for (final (i, d) in list.indexed)
                            SizedBox(
                              width: width,
                              child: Reveal(
                                delay:
                                    Duration(milliseconds: 60 * (i % columns)),
                                child: DestinationCard(destination: d),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
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
            color: selected
                ? AppColors.midnight
                : _hovered
                    ? AppColors.midnight.withValues(alpha: 0.06)
                    : Colors.transparent,
            border: Border.all(
              color: selected
                  ? AppColors.midnight
                  : AppColors.midnight.withValues(alpha: 0.25),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            widget.label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: selected ? Colors.white : AppColors.ink,
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
