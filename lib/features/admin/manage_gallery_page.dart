import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/content_models.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/net_image.dart';
import 'widgets/admin_widgets.dart';

/// Gallery management: photo grid with add, edit and delete.
class ManageGalleryPage extends ConsumerWidget {
  const ManageGalleryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gallery = ref.watch(galleryProvider);

    return gallery.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 160),
        child: Center(
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.gold)),
      ),
      error: (e, _) => Text('Could not load the gallery: $e'),
      data: (items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminHeader(
            title: 'Gallery',
            subtitle: '${items.length} photographs on the public wall',
            action: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.emeraldDeep,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
              onPressed: () =>
                  showAdminDialog(context, const _GalleryEditor()),
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
              label: const Text('Add photograph'),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final item in items)
                SizedBox(
                  width: 240,
                  child: AdminCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8)),
                          child: AspectRatio(
                              aspectRatio: 3 / 2,
                              child: NetImage(item.image)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 12, 6, 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(item.caption,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(fontSize: 13)),
                                    Text(item.location,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontSize: 11)),
                                  ],
                                ),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: () => showAdminDialog(context,
                                    _GalleryEditor(existing: item)),
                                icon: const Icon(Icons.edit_outlined,
                                    size: 17),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: () async {
                                  if (await confirmDelete(
                                      context, 'this photograph')) {
                                    await ref
                                        .read(galleryRepositoryProvider)
                                        .delete(item.id);
                                    ref.invalidate(galleryProvider);
                                  }
                                },
                                icon: const Icon(Icons.delete_outline,
                                    size: 17, color: AppColors.danger),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GalleryEditor extends ConsumerStatefulWidget {
  const _GalleryEditor({this.existing});

  final GalleryItem? existing;

  @override
  ConsumerState<_GalleryEditor> createState() => _GalleryEditorState();
}

class _GalleryEditorState extends ConsumerState<_GalleryEditor> {
  final _formKey = GlobalKey<FormState>();
  late final g = widget.existing;

  late final _image = TextEditingController(text: g?.image ?? '');
  late final _caption = TextEditingController(text: g?.caption ?? '');
  late final _location = TextEditingController(text: g?.location ?? '');
  late final _category =
      TextEditingController(text: g?.category ?? 'India');
  late final _ratio =
      TextEditingController(text: g == null ? '1.5' : '${g!.aspectRatio}');
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_image, _caption, _location, _category, _ratio]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final item = GalleryItem(
      id: g?.id ?? 'g${DateTime.now().millisecondsSinceEpoch}',
      image: _image.text.trim(),
      caption: _caption.text.trim(),
      location: _location.text.trim(),
      category: _category.text.trim().isEmpty ? 'India' : _category.text.trim(),
      aspectRatio: double.tryParse(_ratio.text) ?? 1.5,
    );
    await ref.read(galleryRepositoryProvider).upsert(item);
    ref.invalidate(galleryProvider);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                    g == null ? 'Add photograph' : 'Edit photograph',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
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
                children: [
                  AdminField(
                      label: 'Image URL',
                      controller: _image,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required'
                          : null),
                  AdminField(label: 'Caption', controller: _caption),
                  Row(children: [
                    Expanded(
                        child: AdminField(
                            label: 'Location', controller: _location)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: AdminField(
                            label: 'Category',
                            controller: _category,
                            hint: 'India, Beaches, Mountains…')),
                    const SizedBox(width: 16),
                    Expanded(
                        child: AdminField(
                            label: 'Aspect ratio (w/h)',
                            controller: _ratio,
                            keyboardType: TextInputType.number)),
                  ]),
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
}
