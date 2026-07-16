import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/destination.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/net_image.dart';
import 'widgets/admin_widgets.dart';

/// Destination management: list, create, edit (media, pricing, SEO,
/// featured flag) and soft delete.
class ManageDestinationsPage extends ConsumerWidget {
  const ManageDestinationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinations = ref.watch(destinationsProvider);

    return destinations.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 160),
        child: Center(
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.gold)),
      ),
      error: (e, _) => Text('Could not load destinations: $e'),
      data: (list) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminHeader(
            title: 'Destinations',
            subtitle:
                '${list.length} live · ${list.where((d) => d.featured).length} featured on the home page',
            action: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.emeraldDeep,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
              onPressed: () => _openEditor(context, ref, null),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New destination'),
            ),
          ),
          const SizedBox(height: 24),
          for (final d in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AdminCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                          width: 92, height: 62, child: NetImage(d.cardImage)),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(d.name,
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              const SizedBox(width: 8),
                              if (d.featured)
                                const Icon(Icons.star_rounded,
                                    size: 16, color: AppColors.gold),
                            ],
                          ),
                          Text('${d.country} · /destinations/${d.slug}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 12)),
                        ],
                      ),
                    ),
                    if (MediaQuery.sizeOf(context).width > 900) ...[
                      Expanded(
                        child: Text(Formatters.price(d.priceFrom),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Expanded(
                        child: Text(Formatters.duration(d.days, d.nights),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Expanded(
                        child: Text(d.bestSeason,
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ],
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: () => _openEditor(context, ref, d),
                      icon: const Icon(Icons.edit_outlined, size: 19),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: () async {
                        if (await confirmDelete(context, d.name)) {
                          await ref
                              .read(destinationRepositoryProvider)
                              .delete(d.id);
                          ref.invalidate(destinationsProvider);
                        }
                      },
                      icon: const Icon(Icons.delete_outline,
                          size: 19, color: AppColors.danger),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openEditor(BuildContext context, WidgetRef ref, Destination? existing) {
    showAdminDialog(context, _DestinationEditor(existing: existing));
  }
}

class _DestinationEditor extends ConsumerStatefulWidget {
  const _DestinationEditor({this.existing});

  final Destination? existing;

  @override
  ConsumerState<_DestinationEditor> createState() =>
      _DestinationEditorState();
}

class _DestinationEditorState extends ConsumerState<_DestinationEditor> {
  final _formKey = GlobalKey<FormState>();
  late final d = widget.existing;

  late final _name = TextEditingController(text: d?.name ?? '');
  late final _country = TextEditingController(text: d?.country ?? 'India');
  late final _tagline = TextEditingController(text: d?.tagline ?? '');
  late final _overview = TextEditingController(text: d?.overview ?? '');
  late final _price =
      TextEditingController(text: d == null ? '' : '${d!.priceFrom}');
  late final _days = TextEditingController(text: d == null ? '5' : '${d!.days}');
  late final _nights =
      TextEditingController(text: d == null ? '4' : '${d!.nights}');
  late final _season = TextEditingController(text: d?.bestSeason ?? '');
  late final _heroImage = TextEditingController(text: d?.heroImage ?? '');
  late final _cardImage = TextEditingController(text: d?.cardImage ?? '');
  late final _gallery =
      TextEditingController(text: d?.gallery.join('\n') ?? '');
  late final _video = TextEditingController(text: d?.videoUrl ?? '');
  late final _seoTitle = TextEditingController(text: d?.seoTitle ?? '');
  late final _seoDescription =
      TextEditingController(text: d?.seoDescription ?? '');
  late bool _featured = d?.featured ?? false;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [
      _name, _country, _tagline, _overview, _price, _days, _nights, _season,
      _heroImage, _cardImage, _gallery, _video, _seoTitle, _seoDescription,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final gallery = _gallery.text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final Destination result;
    final existing = d;
    if (existing != null) {
      result = existing.copyWith(
        name: _name.text.trim(),
        tagline: _tagline.text.trim(),
        overview: _overview.text.trim(),
        heroImage: _heroImage.text.trim(),
        cardImage: _cardImage.text.trim(),
        gallery: gallery,
        videoUrl: _video.text.trim(),
        priceFrom: int.tryParse(_price.text) ?? existing.priceFrom,
        days: int.tryParse(_days.text) ?? existing.days,
        nights: int.tryParse(_nights.text) ?? existing.nights,
        bestSeason: _season.text.trim(),
        featured: _featured,
        seoTitle: _seoTitle.text.trim(),
        seoDescription: _seoDescription.text.trim(),
      );
    } else {
      final name = _name.text.trim();
      result = Destination(
        id: 'd${DateTime.now().millisecondsSinceEpoch}',
        slug: name
            .toLowerCase()
            .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
            .replaceAll(RegExp(r'^-|-$'), ''),
        name: name,
        country: _country.text.trim(),
        tagline: _tagline.text.trim(),
        overview: _overview.text.trim(),
        heroImage: _heroImage.text.trim(),
        cardImage: _cardImage.text.trim().isEmpty
            ? _heroImage.text.trim()
            : _cardImage.text.trim(),
        gallery: gallery,
        videoUrl: _video.text.trim(),
        priceFrom: int.tryParse(_price.text) ?? 0,
        days: int.tryParse(_days.text) ?? 0,
        nights: int.tryParse(_nights.text) ?? 0,
        bestSeason: _season.text.trim(),
        rating: 0,
        reviewCount: 0,
        featured: _featured,
        tags: const [],
        highlights: const [],
        itinerary: const [],
        included: const [],
        excluded: const [],
        hotels: const [],
        attractions: const [],
        reviews: const [],
        latitude: 0,
        longitude: 0,
        seoTitle: _seoTitle.text.trim(),
        seoDescription: _seoDescription.text.trim(),
      );
    }

    await ref.read(destinationRepositoryProvider).upsert(result);
    ref.invalidate(destinationsProvider);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  d == null ? 'New destination' : 'Edit ${d!.name}',
                  style: theme.headlineSmall,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(children: [
                    Expanded(
                        child: AdminField(
                            label: 'Name',
                            controller: _name,
                            validator: _required)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: AdminField(
                            label: 'Country',
                            controller: _country,
                            validator: _required)),
                  ]),
                  AdminField(label: 'Tagline', controller: _tagline),
                  AdminField(
                      label: 'Overview', controller: _overview, maxLines: 4),
                  Row(children: [
                    Expanded(
                        child: AdminField(
                            label: 'Price from (₹)',
                            controller: _price,
                            keyboardType: TextInputType.number,
                            validator: _required)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: AdminField(
                            label: 'Days',
                            controller: _days,
                            keyboardType: TextInputType.number)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: AdminField(
                            label: 'Nights',
                            controller: _nights,
                            keyboardType: TextInputType.number)),
                  ]),
                  AdminField(
                      label: 'Best season',
                      controller: _season,
                      hint: 'e.g. October – March'),
                  AdminField(
                      label: 'Hero image URL',
                      controller: _heroImage,
                      validator: _required),
                  AdminField(label: 'Card image URL', controller: _cardImage),
                  AdminField(
                      label: 'Gallery image URLs (one per line)',
                      controller: _gallery,
                      maxLines: 5),
                  AdminField(label: 'Video URL (mp4)', controller: _video),
                  AdminField(label: 'SEO title', controller: _seoTitle),
                  AdminField(
                      label: 'SEO description',
                      controller: _seoDescription,
                      maxLines: 2),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _featured,
                    activeThumbColor: AppColors.gold,
                    title: Text('Featured on home page',
                        style: theme.bodyMedium),
                    onChanged: (v) => setState(() => _featured = v),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.emeraldDeep,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 18)),
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Saving…' : 'Save destination'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;
}
