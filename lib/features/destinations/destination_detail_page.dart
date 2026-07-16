import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/destination.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/destination_card.dart';
import '../../shared/widgets/enquiry_form.dart';
import '../../shared/widgets/map_embed.dart';
import '../../shared/widgets/net_image.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/rating_stars.dart';
import '../../shared/widgets/reveal.dart';
import '../../shared/widgets/section_header.dart';

/// Everything about one destination: film, gallery, itinerary, hotels,
/// map, reviews, related journeys and a pre-addressed enquiry form.
class DestinationDetailPage extends ConsumerWidget {
  const DestinationDetailPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destination = ref.watch(destinationBySlugProvider(slug));

    return destination.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.ivory,
        body: Center(
            child:
                CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold)),
      ),
      error: (e, _) => _NotFound(message: 'Something went wrong: $e'),
      data: (d) {
        if (d == null) {
          return const _NotFound(
              message: 'This destination has drifted off the map.');
        }
        return PageScaffold(
          sections: [
            (context, offset) => _DetailHero(d: d, scrollOffset: offset),
            (context, _) => _OverviewSection(d: d),
            (context, _) => _FilmAndGallery(d: d),
            (context, _) => _ItinerarySection(d: d),
            (context, _) => _InclusionsSection(d: d),
            (context, _) => _HotelsSection(d: d),
            (context, _) => _AttractionsAndMap(d: d),
            (context, _) => _ReviewsSection(d: d),
            (context, _) => _RelatedSection(current: d),
            (context, _) => _EnquirySection(d: d),
          ],
        );
      },
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightDeep,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Off the map',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(color: Colors.white)),
            const SizedBox(height: 12),
            Text(message,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.onDarkSoft)),
            const SizedBox(height: 28),
            AureviaButton(
              label: 'All destinations',
              onPressed: () => context.go('/destinations'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero
// ---------------------------------------------------------------------------

class _DetailHero extends StatelessWidget {
  const _DetailHero({required this.d, required this.scrollOffset});

  final Destination d;
  final ValueNotifier<double> scrollOffset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return SizedBox(
      height: context.screenHeight * 0.88,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ValueListenableBuilder<double>(
              valueListenable: scrollOffset,
              builder: (context, value, child) => Transform.translate(
                offset: Offset(0, value * 0.3),
                child: child,
              ),
              child: NetImage(d.heroImage),
            ),
            const DecoratedBox(
                decoration: BoxDecoration(gradient: AppColors.heroOverlay)),
            SectionFrame(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${d.country.toUpperCase()}  ·  ${d.bestSeason.toUpperCase()}',
                    style: theme.labelMedium?.copyWith(
                        color: AppColors.goldBright,
                        fontWeight: FontWeight.w500),
                  ).animate(delay: 200.ms).fadeIn(duration: 700.ms).moveX(
                      begin: -24, curve: Curves.easeOutCubic),
                  const SizedBox(height: 14),
                  ClipRect(
                    child: Text(
                      d.name,
                      style: theme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontSize: context.fluid(52, 100),
                      ),
                    )
                        .animate(delay: 320.ms)
                        .moveY(
                            begin: 120,
                            end: 0,
                            duration: 950.ms,
                            curve: Curves.easeOutCubic)
                        .fadeIn(duration: 500.ms),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    d.tagline,
                    style: theme.headlineSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w300,
                    ),
                  ).animate(delay: 620.ms).fadeIn(duration: 800.ms).moveY(
                      begin: 20, curve: Curves.easeOutCubic),
                  SizedBox(height: context.fluid(28, 40)),
                  Wrap(
                    spacing: 14,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _HeroChip(
                          icon: Icons.schedule,
                          text: Formatters.duration(d.days, d.nights)),
                      _HeroChip(
                        icon: Icons.star_rounded,
                        text:
                            '${d.rating.toStringAsFixed(1)} · ${Formatters.compactCount(d.reviewCount)} reviews',
                      ),
                      _HeroChip(
                          icon: Icons.payments_outlined,
                          text: 'From ${Formatters.price(d.priceFrom)}'),
                      AureviaButton(
                        label: 'Book this journey',
                        onPressed: () =>
                            context.go('/contact?destination=${d.name}'),
                      ),
                    ],
                  ).animate(delay: 800.ms).fadeIn(duration: 800.ms).moveY(
                      begin: 24, curve: Curves.easeOutCubic),
                  SizedBox(height: context.fluid(36, 60)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.goldBright),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white, fontSize: 11.5, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Overview & highlights
// ---------------------------------------------------------------------------

class _OverviewSection extends StatelessWidget {
  const _OverviewSection({required this.d});

  final Destination d;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final overview = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(eyebrow: 'The journey', title: 'Why ${d.name}'),
        const SizedBox(height: 28),
        Reveal(
          delay: const Duration(milliseconds: 200),
          child: Text(d.overview, style: theme.bodyLarge),
        ),
      ],
    );

    final highlights = Reveal(
      from: RevealFrom.right,
      delay: const Duration(milliseconds: 250),
      child: Container(
        padding: const EdgeInsets.all(34),
        decoration: BoxDecoration(
          color: AppColors.midnight,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HIGHLIGHTS',
              style: theme.labelSmall?.copyWith(
                  color: AppColors.goldBright, letterSpacing: 2.6),
            ),
            const SizedBox(height: 22),
            for (final h in d.highlights)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Icon(Icons.auto_awesome,
                          size: 14, color: AppColors.gold),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        h,
                        style: theme.bodyMedium
                            ?.copyWith(color: AppColors.onDark, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    return Container(
      color: AppColors.ivory,
      padding: EdgeInsets.symmetric(vertical: context.fluid(64, 110)),
      child: SectionFrame(
        child: context.isMobile
            ? Column(children: [overview, const SizedBox(height: 40), highlights])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: overview),
                  const SizedBox(width: 72),
                  Expanded(flex: 5, child: highlights),
                ],
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Film + gallery
// ---------------------------------------------------------------------------

class _FilmAndGallery extends StatelessWidget {
  const _FilmAndGallery({required this.d});

  final Destination d;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mist,
      padding: EdgeInsets.symmetric(vertical: context.fluid(64, 110)),
      child: SectionFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
                eyebrow: 'Sights & sound',
                title: '${d.name}, in motion'),
            const SizedBox(height: 44),
            Reveal(
              scaleFrom: 0.96,
              from: RevealFrom.none,
              child: _InlineFilm(videoUrl: d.videoUrl, poster: d.heroImage),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: context.fluid(180, 260),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: d.gallery.length,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (context, i) => Reveal(
                  from: RevealFrom.right,
                  delay: Duration(milliseconds: 70 * i),
                  child: _GalleryThumb(
                    url: d.gallery[i],
                    onTap: () => _openLightbox(context, d.gallery, i),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openLightbox(BuildContext context, List<String> images, int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (_) => _Lightbox(images: images, initialIndex: index),
    );
  }
}

class _GalleryThumb extends StatefulWidget {
  const _GalleryThumb({required this.url, required this.onTap});

  final String url;
  final VoidCallback onTap;

  @override
  State<_GalleryThumb> createState() => _GalleryThumbState();
}

class _GalleryThumbState extends State<_GalleryThumb> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: AnimatedScale(
              scale: _hovered ? 1.06 : 1,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              child: NetImage(widget.url),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shared lightbox used by detail galleries and the gallery page.
class _Lightbox extends StatefulWidget {
  const _Lightbox({required this.images, required this.initialIndex});

  final List<String> images;
  final int initialIndex;

  @override
  State<_Lightbox> createState() => _LightboxState();
}

class _LightboxState extends State<_Lightbox> {
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
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.images.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, i) => InteractiveViewer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: NetImage(widget.images[i], fit: BoxFit.contain),
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
          bottom: 28,
          left: 0,
          right: 0,
          child: Text(
            '${_index + 1} / ${widget.images.length}',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Colors.white70),
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
        if (_index < widget.images.length - 1)
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

/// Click-to-play destination film with poster fallback.
class _InlineFilm extends StatefulWidget {
  const _InlineFilm({required this.videoUrl, required this.poster});

  final String videoUrl;
  final String poster;

  @override
  State<_InlineFilm> createState() => _InlineFilmState();
}

class _InlineFilmState extends State<_InlineFilm> {
  VideoPlayerController? _controller;
  bool _ready = false;
  bool _playing = false;

  Future<void> _toggle() async {
    var controller = _controller;
    if (controller == null) {
      controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      _controller = controller;
      try {
        await controller.initialize();
        await controller.setLooping(true);
        await controller.setVolume(0);
        if (mounted) setState(() => _ready = true);
      } catch (_) {
        return;
      }
    }
    if (_playing) {
      await controller.pause();
    } else {
      await controller.play();
    }
    if (mounted) setState(() => _playing = !_playing);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: AspectRatio(
        aspectRatio: context.isMobile ? 16 / 10 : 21 / 9,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _toggle,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_ready && controller != null)
                  FittedBox(
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: controller.value.size.width,
                      height: controller.value.size.height,
                      child: VideoPlayer(controller),
                    ),
                  )
                else
                  NetImage(widget.poster),
                AnimatedOpacity(
                  opacity: _playing ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: Center(
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.14),
                          border: Border.all(color: Colors.white70),
                        ),
                        child: const Icon(Icons.play_arrow_rounded,
                            color: Colors.white, size: 44),
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

// ---------------------------------------------------------------------------
// Itinerary
// ---------------------------------------------------------------------------

class _ItinerarySection extends StatefulWidget {
  const _ItinerarySection({required this.d});

  final Destination d;

  @override
  State<_ItinerarySection> createState() => _ItinerarySectionState();
}

class _ItinerarySectionState extends State<_ItinerarySection> {
  int _open = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      color: AppColors.ivory,
      padding: EdgeInsets.symmetric(vertical: context.fluid(64, 110)),
      child: SectionFrame(
        maxWidth: 980,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
                eyebrow: 'Day by day', title: 'The itinerary'),
            const SizedBox(height: 44),
            for (final (i, day) in widget.d.itinerary.indexed)
              Reveal(
                delay: Duration(milliseconds: 60 * i),
                distance: 30,
                child: _ItineraryTile(
                  day: day,
                  open: _open == i,
                  onTap: () => setState(() => _open = _open == i ? -1 : i),
                  theme: theme,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ItineraryTile extends StatelessWidget {
  const _ItineraryTile({
    required this.day,
    required this.open,
    required this.onTap,
    required this.theme,
  });

  final ItineraryDay day;
  final bool open;
  final VoidCallback onTap;
  final TextTheme theme;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
          decoration: BoxDecoration(
            color: open ? AppColors.cloud : Colors.transparent,
            border: Border.all(
              color: open
                  ? AppColors.gold.withValues(alpha: 0.5)
                  : AppColors.midnight.withValues(alpha: 0.14),
            ),
            borderRadius: BorderRadius.circular(6),
            boxShadow: open
                ? [
                    BoxShadow(
                        color: AppColors.shadowSoft,
                        blurRadius: 30,
                        offset: const Offset(0, 12)),
                  ]
                : const [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'DAY ${day.day.toString().padLeft(2, '0')}',
                    style: theme.labelMedium?.copyWith(
                      color: open ? AppColors.gold : AppColors.inkSoft,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(child: Text(day.title, style: theme.titleLarge)),
                  AnimatedRotation(
                    turns: open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.inkSoft),
                  ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 350),
                sizeCurve: Curves.easeOutCubic,
                crossFadeState: open
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(day.description, style: theme.bodyMedium),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Included / excluded
// ---------------------------------------------------------------------------

class _InclusionsSection extends StatelessWidget {
  const _InclusionsSection({required this.d});

  final Destination d;

  @override
  Widget build(BuildContext context) {
    final included = _InclusionCard(
      title: 'What\'s included',
      icon: Icons.check_circle_outline,
      color: AppColors.emerald,
      items: d.included,
    );
    final excluded = _InclusionCard(
      title: 'What\'s not',
      icon: Icons.remove_circle_outline,
      color: AppColors.inkSoft,
      items: d.excluded,
    );

    return Container(
      color: AppColors.mist,
      padding: EdgeInsets.symmetric(vertical: context.fluid(64, 110)),
      child: SectionFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
                eyebrow: 'The fine print, unfined',
                title: 'Priced with honesty'),
            const SizedBox(height: 44),
            context.isMobile
                ? Column(children: [
                    included,
                    const SizedBox(height: 24),
                    excluded
                  ])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Reveal(child: included)),
                      const SizedBox(width: 28),
                      Expanded(
                          child: Reveal(
                              delay: const Duration(milliseconds: 150),
                              child: excluded)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _InclusionCard extends StatelessWidget {
  const _InclusionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: AppColors.cloud,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.headlineSmall),
          const SizedBox(height: 22),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Icon(icon, size: 17, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item, style: theme.bodyMedium)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hotels
// ---------------------------------------------------------------------------

class _HotelsSection extends StatelessWidget {
  const _HotelsSection({required this.d});

  final Destination d;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      color: AppColors.ivory,
      padding: EdgeInsets.symmetric(vertical: context.fluid(64, 110)),
      child: SectionFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
                eyebrow: 'Where you\'ll sleep', title: 'Stays worth the trip'),
            const SizedBox(height: 44),
            LayoutBuilder(builder: (context, constraints) {
              final columns = constraints.maxWidth > 900
                  ? 3
                  : constraints.maxWidth > 600
                      ? 2
                      : 1;
              const gap = 24.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final (i, hotel) in d.hotels.indexed)
                    SizedBox(
                      width: width,
                      child: Reveal(
                        delay: Duration(milliseconds: 100 * i),
                        child: _HotelCard(hotel: hotel, theme: theme),
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  const _HotelCard({required this.hotel, required this.theme});

  final Hotel hotel;
  final TextTheme theme;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        color: AppColors.cloud,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(aspectRatio: 16 / 10, child: NetImage(hotel.image)),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingStars(hotel.stars.toDouble(), size: 14),
                  const SizedBox(height: 10),
                  Text(hotel.name, style: theme.titleMedium),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined,
                          size: 14, color: AppColors.inkSoft),
                      const SizedBox(width: 5),
                      Text(hotel.location, style: theme.bodySmall),
                    ],
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

// ---------------------------------------------------------------------------
// Attractions + map
// ---------------------------------------------------------------------------

class _AttractionsAndMap extends StatelessWidget {
  const _AttractionsAndMap({required this.d});

  final Destination d;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    final attractions = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
            eyebrow: 'Worth the detour',
            title: 'Around ${d.name}'),
        const SizedBox(height: 36),
        for (final (i, a) in d.attractions.indexed)
          Reveal(
            delay: Duration(milliseconds: 90 * i),
            from: RevealFrom.left,
            distance: 30,
            child: Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cloud,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: AppColors.midnight.withValues(alpha: 0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(a.name, style: theme.titleMedium)),
                      Text(
                        a.distance.toUpperCase(),
                        style: theme.labelSmall?.copyWith(
                            color: AppColors.gold,
                            fontSize: 10,
                            letterSpacing: 1.4),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(a.description, style: theme.bodyMedium),
                ],
              ),
            ),
          ),
      ],
    );

    final map = Reveal(
      from: RevealFrom.right,
      child: SizedBox(
        height: 440,
        child: MapEmbed(latitude: d.latitude, longitude: d.longitude, zoom: 9),
      ),
    );

    return Container(
      color: AppColors.mist,
      padding: EdgeInsets.symmetric(vertical: context.fluid(64, 110)),
      child: SectionFrame(
        child: context.isMobile
            ? Column(children: [attractions, const SizedBox(height: 36), map])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: attractions),
                  const SizedBox(width: 56),
                  Expanded(flex: 6, child: map),
                ],
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reviews
// ---------------------------------------------------------------------------

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({required this.d});

  final Destination d;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      color: AppColors.ivory,
      padding: EdgeInsets.symmetric(vertical: context.fluid(64, 110)),
      child: SectionFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              eyebrow: 'From the road',
              title: 'Travellers on ${d.name}',
              body:
                  'Rated ${d.rating.toStringAsFixed(1)} across ${Formatters.compactCount(d.reviewCount)} verified journeys.',
            ),
            const SizedBox(height: 44),
            LayoutBuilder(builder: (context, constraints) {
              final columns = constraints.maxWidth > 960
                  ? 3
                  : constraints.maxWidth > 620
                      ? 2
                      : 1;
              const gap = 24.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final (i, review) in d.reviews.indexed)
                    SizedBox(
                      width: width,
                      child: Reveal(
                        delay: Duration(milliseconds: 100 * i),
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: AppColors.cloud,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color:
                                    AppColors.midnight.withValues(alpha: 0.08)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RatingStars(review.rating),
                              const SizedBox(height: 16),
                              Text('“${review.comment}”',
                                  style: theme.bodyMedium
                                      ?.copyWith(fontStyle: FontStyle.italic)),
                              const SizedBox(height: 18),
                              Text(review.author, style: theme.titleSmall),
                              const SizedBox(height: 2),
                              Text(
                                '${review.origin} · ${review.monthYear}',
                                style: theme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Related + enquiry
// ---------------------------------------------------------------------------

class _RelatedSection extends ConsumerWidget {
  const _RelatedSection({required this.current});

  final Destination current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(destinationsProvider).value ?? [];
    final related = all
        .where((d) =>
            d.id != current.id &&
            (d.country == current.country ||
                d.tags.any(current.tags.contains)))
        .take(3)
        .toList();
    if (related.isEmpty) return const SizedBox.shrink();

    return Container(
      color: AppColors.mist,
      padding: EdgeInsets.symmetric(vertical: context.fluid(64, 110)),
      child: SectionFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
                eyebrow: 'Keep wandering', title: 'You may also love'),
            const SizedBox(height: 44),
            LayoutBuilder(builder: (context, constraints) {
              final columns = constraints.maxWidth > 1080
                  ? 3
                  : constraints.maxWidth > 680
                      ? 2
                      : 1;
              const gap = 28.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final (i, d) in related.indexed)
                    SizedBox(
                      width: width,
                      child: Reveal(
                        delay: Duration(milliseconds: 100 * i),
                        child: DestinationCard(destination: d, height: 420),
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _EnquirySection extends StatelessWidget {
  const _EnquirySection({required this.d});

  final Destination d;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.midnightDeep,
      padding: EdgeInsets.symmetric(vertical: context.fluid(64, 110)),
      child: SectionFrame(
        maxWidth: 920,
        child: Column(
          children: [
            SectionHeader(
              eyebrow: 'Make it yours',
              title: 'Enquire about ${d.name}',
              onDark: true,
              center: true,
            ),
            const SizedBox(height: 44),
            Reveal(child: EnquiryForm(prefillDestination: d.name)),
          ],
        ),
      ),
    );
  }
}
