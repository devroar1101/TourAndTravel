import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/content_models.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/net_image.dart';
import '../../shared/widgets/rating_stars.dart';
import 'widgets/admin_widgets.dart';

/// Testimonial management: full CRUD.
class ManageTestimonialsPage extends ConsumerWidget {
  const ManageTestimonialsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testimonials = ref.watch(testimonialsProvider);

    return testimonials.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 160),
        child: Center(
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.gold)),
      ),
      error: (e, _) => Text('Could not load testimonials: $e'),
      data: (items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminHeader(
            title: 'Testimonials',
            subtitle: '${items.length} voices on the public site',
            action: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.emeraldDeep,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
              onPressed: () =>
                  showAdminDialog(context, const _TestimonialEditor()),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New testimonial'),
            ),
          ),
          const SizedBox(height: 24),
          for (final t in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AdminCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: SizedBox(
                          width: 46, height: 46, child: NetImage(t.avatar)),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(t.name,
                                style:
                                    Theme.of(context).textTheme.titleSmall),
                            const SizedBox(width: 12),
                            RatingStars(t.rating, size: 13),
                          ]),
                          Text('${t.origin} · ${t.tripName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 12)),
                          const SizedBox(height: 8),
                          Text('“${t.quote}”',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: () => showAdminDialog(
                          context, _TestimonialEditor(existing: t)),
                      icon: const Icon(Icons.edit_outlined, size: 19),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: () async {
                        if (await confirmDelete(
                            context, 'the testimonial from ${t.name}')) {
                          await ref
                              .read(testimonialRepositoryProvider)
                              .delete(t.id);
                          ref.invalidate(testimonialsProvider);
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
}

class _TestimonialEditor extends ConsumerStatefulWidget {
  const _TestimonialEditor({this.existing});

  final Testimonial? existing;

  @override
  ConsumerState<_TestimonialEditor> createState() =>
      _TestimonialEditorState();
}

class _TestimonialEditorState extends ConsumerState<_TestimonialEditor> {
  final _formKey = GlobalKey<FormState>();
  late final t = widget.existing;

  late final _name = TextEditingController(text: t?.name ?? '');
  late final _origin = TextEditingController(text: t?.origin ?? '');
  late final _avatar = TextEditingController(text: t?.avatar ?? '');
  late final _quote = TextEditingController(text: t?.quote ?? '');
  late final _trip = TextEditingController(text: t?.tripName ?? '');
  late double _rating = t?.rating ?? 5;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _origin, _avatar, _quote, _trip]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final item = Testimonial(
      id: t?.id ?? 't${DateTime.now().millisecondsSinceEpoch}',
      name: _name.text.trim(),
      origin: _origin.text.trim(),
      avatar: _avatar.text.trim(),
      rating: _rating,
      quote: _quote.text.trim(),
      tripName: _trip.text.trim(),
    );
    await ref.read(testimonialRepositoryProvider).upsert(item);
    ref.invalidate(testimonialsProvider);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                    t == null ? 'New testimonial' : 'Edit testimonial',
                    style: theme.headlineSmall),
              ),
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close)),
            ],
          ),
        ),
        const Divider(),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            label: 'Origin',
                            controller: _origin,
                            hint: 'City, Country')),
                  ]),
                  AdminField(label: 'Avatar URL', controller: _avatar),
                  AdminField(
                      label: 'Quote',
                      controller: _quote,
                      maxLines: 3,
                      validator: _required),
                  AdminField(label: 'Trip name', controller: _trip),
                  Text('RATING — ${_rating.toStringAsFixed(1)}',
                      style: theme.labelSmall?.copyWith(
                          fontSize: 10,
                          letterSpacing: 1.8,
                          color: AppColors.inkSoft)),
                  Slider(
                    value: _rating,
                    min: 1,
                    max: 5,
                    divisions: 8,
                    activeColor: AppColors.gold,
                    onChanged: (v) => setState(() => _rating = v),
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
                  child: const Text('Cancel')),
              const SizedBox(width: 12),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.emeraldDeep,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 18)),
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Saving…' : 'Save'),
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
