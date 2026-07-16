import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/content_models.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/net_image.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/reveal.dart';

/// Masonry photo wall with category filters, hover captions and a lightbox.
class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({super.key});

  @override
  ConsumerState<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  String _category = 'All';

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      sections: [
        (context, offset) => PageHeader(
              eyebrow: 'Field notes',
              title: 'Proof, in\nphotographs',
              subtitle:
                  'Unstaged and unfiltered — moments our travellers and hosts '
                  'caught along the way.',
              image:
                  'https://images.unsplash.com/photo-1503220317375-aaad61436b1b?auto=format&fit=crop&w=2000&q=75',
              scrollOffset: offset,
            ),
        (context, _) => _GalleryBody(
              category: _category,
              onCategory: (c) => setState(() => _category = c),
            ),
      ],
    );
  }
}

class _GalleryBody extends ConsumerWidget {
  const _GalleryBody({required this.category, required this.onCategory});

  final String category;
  final ValueChanged<String> onCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gallery = ref.watch(galleryProvider);

    return Container(
      color: AppColors.ivory,
      padding: EdgeInsets.symmetric(vertical: context.fluid(48, 80)),
      child: SectionFrame(
        child: gallery.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 120),
            child: Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.gold)),
          ),
          error: (e, _) => Text('Could not load the gallery: $e'),
          data: (items) {
            final categories = <String>[
              'All',
              ...{for (final g in items) g.category},
            ];
            final visible = category == 'All'
                ? items
                : items.where((g) => g.category == category).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Reveal(
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 10,
                    children: [
                      for (final c in categories)
                        _GalleryTab(
                          label: c,
                          selected: c == category,
                          onTap: () => onCategory(c),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: context.fluid(28, 48)),
                _Masonry(
                  key: ValueKey(category),
                  items: visible,
                  onTap: (index) => showDialog(
                    context: context,
                    barrierColor: Colors.black.withValues(alpha: 0.93),
                    builder: (_) => _GalleryLightbox(
                        items: visible, initialIndex: index),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GalleryTab extends StatefulWidget {
  const _GalleryTab(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_GalleryTab> createState() => _GalleryTabState();
}

class _GalleryTabState extends State<_GalleryTab> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _hovered;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: active ? AppColors.inkStrong : AppColors.inkSoft,
                    letterSpacing: 2,
                    fontWeight:
                        widget.selected ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 2,
              width: widget.selected ? 26 : 0,
              color: AppColors.gold,
            ),
          ],
        ),
      ),
    );
  }
}

/// Column-packed masonry: items flow into the currently-shortest column,
/// preserving photographic aspect ratios.
class _Masonry extends StatelessWidget {
  const _Masonry({super.key, required this.items, required this.onTap});

  final List<GalleryItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final columnCount = constraints.maxWidth > 1100
          ? 4
          : constraints.maxWidth > 760
              ? 3
              : constraints.maxWidth > 480
                  ? 2
                  : 1;
      const gap = 18.0;
      final columnWidth =
          (constraints.maxWidth - gap * (columnCount - 1)) / columnCount;

      final columns = List.generate(columnCount, (_) => <(int, GalleryItem)>[]);
      final heights = List.filled(columnCount, 0.0);
      for (final (i, item) in items.indexed) {
        var target = 0;
        for (var c = 1; c < columnCount; c++) {
          if (heights[c] < heights[target]) target = c;
        }
        columns[target].add((i, item));
        heights[target] += columnWidth / item.aspectRatio + gap;
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (c, column) in columns.indexed) ...[
            if (c > 0) const SizedBox(width: gap),
            Expanded(
              child: Column(
                children: [
                  for (final (index, item) in column)
                    Padding(
                      padding: const EdgeInsets.only(bottom: gap),
                      child: Reveal(
                        delay: Duration(milliseconds: 70 * (index % 6)),
                        child: _GalleryTile(
                          item: item,
                          onTap: () => onTap(index),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      );
    });
  }
}

class _GalleryTile extends StatefulWidget {
  const _GalleryTile({required this.item, required this.onTap});

  final GalleryItem item;
  final VoidCallback onTap;

  @override
  State<_GalleryTile> createState() => _GalleryTileState();
}

class _GalleryTileState extends State<_GalleryTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: AspectRatio(
            aspectRatio: widget.item.aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  scale: _hovered ? 1.06 : 1,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  child: NetImage(widget.item.image),
                ),
                AnimatedOpacity(
                  opacity: _hovered ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                        gradient: AppColors.cardOverlay),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.caption,
                            style: theme.titleSmall
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.item.location.toUpperCase(),
                            style: theme.labelSmall?.copyWith(
                                color: AppColors.goldBright,
                                fontSize: 10,
                                letterSpacing: 1.8),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GalleryLightbox extends StatefulWidget {
  const _GalleryLightbox({required this.items, required this.initialIndex});

  final List<GalleryItem> items;
  final int initialIndex;

  @override
  State<_GalleryLightbox> createState() => _GalleryLightboxState();
}

class _GalleryLightboxState extends State<_GalleryLightbox> {
  late final PageController _controller =
      PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final item = widget.items[_index];
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.items.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, i) => InteractiveViewer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 60, 40, 110),
                child: NetImage(widget.items[i].image, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
        Positioned(
          top: 24,
          right: 24,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
          ),
        ),
        Positioned(
          bottom: 34,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(item.caption,
                  style: theme.titleMedium?.copyWith(color: Colors.white)),
              const SizedBox(height: 4),
              Text(
                '${item.location}   ·   ${_index + 1} / ${widget.items.length}',
                style: theme.bodySmall?.copyWith(color: Colors.white60),
              ),
            ],
          ),
        ),
        if (_index > 0)
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: () => _controller.previousPage(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic),
                icon: const Icon(Icons.chevron_left,
                    color: Colors.white, size: 36),
              ),
            ),
          ),
        if (_index < widget.items.length - 1)
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: () => _controller.nextPage(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic),
                icon: const Icon(Icons.chevron_right,
                    color: Colors.white, size: 36),
              ),
            ),
          ),
      ],
    );
  }
}
