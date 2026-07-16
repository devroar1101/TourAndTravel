import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/tour_package.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/net_image.dart';
import 'widgets/admin_widgets.dart';

/// Tour package management: full CRUD across the nine collections.
class ManagePackagesPage extends ConsumerWidget {
  const ManagePackagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packages = ref.watch(packagesProvider);

    return packages.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 160),
        child: Center(
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.gold)),
      ),
      error: (e, _) => Text('Could not load packages: $e'),
      data: (list) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminHeader(
            title: 'Packages',
            subtitle: '${list.length} across ${PackageCategory.values.length} collections',
            action: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.emeraldDeep,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
              onPressed: () =>
                  showAdminDialog(context, const _PackageEditor()),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New package'),
            ),
          ),
          const SizedBox(height: 24),
          for (final p in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AdminCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                          width: 92, height: 62, child: NetImage(p.image)),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Flexible(
                              child: Text(p.name,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                            ),
                            const SizedBox(width: 8),
                            if (p.featured)
                              const Icon(Icons.star_rounded,
                                  size: 16, color: AppColors.gold),
                          ]),
                          Text(p.route.join(' → '),
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 12)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: StatusPill(
                          label: p.category.label,
                          color: AppColors.emeraldDeep),
                    ),
                    if (MediaQuery.sizeOf(context).width > 900) ...[
                      Expanded(
                        child: Text(Formatters.price(p.price),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Expanded(
                        child: Text(Formatters.duration(p.days, p.nights),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ],
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: () => showAdminDialog(
                          context, _PackageEditor(existing: p)),
                      icon: const Icon(Icons.edit_outlined, size: 19),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: () async {
                        if (await confirmDelete(context, p.name)) {
                          await ref
                              .read(packageRepositoryProvider)
                              .delete(p.id);
                          ref.invalidate(packagesProvider);
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

class _PackageEditor extends ConsumerStatefulWidget {
  const _PackageEditor({this.existing});

  final TourPackage? existing;

  @override
  ConsumerState<_PackageEditor> createState() => _PackageEditorState();
}

class _PackageEditorState extends ConsumerState<_PackageEditor> {
  final _formKey = GlobalKey<FormState>();
  late final p = widget.existing;

  late final _name = TextEditingController(text: p?.name ?? '');
  late final _description = TextEditingController(text: p?.description ?? '');
  late final _image = TextEditingController(text: p?.image ?? '');
  late final _price =
      TextEditingController(text: p == null ? '' : '${p!.price}');
  late final _days = TextEditingController(text: p == null ? '5' : '${p!.days}');
  late final _nights =
      TextEditingController(text: p == null ? '4' : '${p!.nights}');
  late final _route = TextEditingController(text: p?.route.join(', ') ?? '');
  late final _highlights =
      TextEditingController(text: p?.highlights.join('\n') ?? '');
  late PackageCategory _category = p?.category ?? PackageCategory.luxury;
  late bool _featured = p?.featured ?? false;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [
      _name, _description, _image, _price, _days, _nights, _route, _highlights,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final route = _route.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final highlights = _highlights.text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final existing = p;
    final TourPackage result;
    if (existing != null) {
      result = TourPackage(
        id: existing.id,
        slug: existing.slug,
        name: _name.text.trim(),
        category: _category,
        description: _description.text.trim(),
        image: _image.text.trim(),
        price: int.tryParse(_price.text) ?? existing.price,
        days: int.tryParse(_days.text) ?? existing.days,
        nights: int.tryParse(_nights.text) ?? existing.nights,
        route: route,
        highlights: highlights,
        featured: _featured,
        rating: existing.rating,
      );
    } else {
      final name = _name.text.trim();
      result = TourPackage(
        id: 'p${DateTime.now().millisecondsSinceEpoch}',
        slug: name
            .toLowerCase()
            .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
            .replaceAll(RegExp(r'^-|-$'), ''),
        name: name,
        category: _category,
        description: _description.text.trim(),
        image: _image.text.trim(),
        price: int.tryParse(_price.text) ?? 0,
        days: int.tryParse(_days.text) ?? 0,
        nights: int.tryParse(_nights.text) ?? 0,
        route: route,
        highlights: highlights,
        featured: _featured,
        rating: 0,
      );
    }

    await ref.read(packageRepositoryProvider).upsert(result);
    ref.invalidate(packagesProvider);
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
                child: Text(p == null ? 'New package' : 'Edit ${p!.name}',
                    style: theme.headlineSmall),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminField(
                      label: 'Name', controller: _name, validator: _required),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('COLLECTION',
                            style: theme.labelSmall?.copyWith(
                                fontSize: 10,
                                letterSpacing: 1.8,
                                color: AppColors.inkSoft)),
                        const SizedBox(height: 7),
                        DropdownButtonFormField<PackageCategory>(
                          initialValue: _category,
                          items: [
                            for (final c in PackageCategory.values)
                              DropdownMenuItem(
                                  value: c, child: Text(c.label)),
                          ],
                          onChanged: (v) =>
                              setState(() => _category = v ?? _category),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AdminField(
                      label: 'Description',
                      controller: _description,
                      maxLines: 3),
                  AdminField(
                      label: 'Image URL',
                      controller: _image,
                      validator: _required),
                  Row(children: [
                    Expanded(
                        child: AdminField(
                            label: 'Price (₹)',
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
                      label: 'Route (comma separated)',
                      controller: _route,
                      hint: 'Kochi, Munnar, Alleppey'),
                  AdminField(
                      label: 'Highlights (one per line)',
                      controller: _highlights,
                      maxLines: 4),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _featured,
                    activeThumbColor: AppColors.gold,
                    title: Text('Featured', style: theme.bodyMedium),
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
                child: Text(_saving ? 'Saving…' : 'Save package'),
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
