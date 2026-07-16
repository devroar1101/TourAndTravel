import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/content_models.dart';
import '../../providers/providers.dart';
import 'widgets/admin_widgets.dart';

/// FAQ management: full CRUD.
class ManageFaqsPage extends ConsumerWidget {
  const ManageFaqsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqs = ref.watch(faqsProvider);

    return faqs.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 160),
        child: Center(
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.gold)),
      ),
      error: (e, _) => Text('Could not load FAQs: $e'),
      data: (items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminHeader(
            title: 'FAQs',
            subtitle: '${items.length} questions answered on the public site',
            action: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.emeraldDeep,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
              onPressed: () => showAdminDialog(context, const _FaqEditor()),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New question'),
            ),
          ),
          const SizedBox(height: 24),
          for (final f in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AdminCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusPill(label: f.category, color: AppColors.info),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.question,
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 6),
                          Text(f.answer,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: () =>
                          showAdminDialog(context, _FaqEditor(existing: f)),
                      icon: const Icon(Icons.edit_outlined, size: 19),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: () async {
                        if (await confirmDelete(context, 'this question')) {
                          await ref.read(faqRepositoryProvider).delete(f.id);
                          ref.invalidate(faqsProvider);
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

class _FaqEditor extends ConsumerStatefulWidget {
  const _FaqEditor({this.existing});

  final FaqItem? existing;

  @override
  ConsumerState<_FaqEditor> createState() => _FaqEditorState();
}

class _FaqEditorState extends ConsumerState<_FaqEditor> {
  final _formKey = GlobalKey<FormState>();
  late final f = widget.existing;

  late final _question = TextEditingController(text: f?.question ?? '');
  late final _answer = TextEditingController(text: f?.answer ?? '');
  late final _category =
      TextEditingController(text: f?.category ?? 'General');
  bool _saving = false;

  @override
  void dispose() {
    _question.dispose();
    _answer.dispose();
    _category.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final item = FaqItem(
      id: f?.id ?? 'f${DateTime.now().millisecondsSinceEpoch}',
      question: _question.text.trim(),
      answer: _answer.text.trim(),
      category:
          _category.text.trim().isEmpty ? 'General' : _category.text.trim(),
    );
    await ref.read(faqRepositoryProvider).upsert(item);
    ref.invalidate(faqsProvider);
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
                child: Text(f == null ? 'New question' : 'Edit question',
                    style: Theme.of(context).textTheme.headlineSmall),
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
                children: [
                  AdminField(
                      label: 'Question',
                      controller: _question,
                      validator: _required),
                  AdminField(
                      label: 'Answer',
                      controller: _answer,
                      maxLines: 5,
                      validator: _required),
                  AdminField(
                      label: 'Category',
                      controller: _category,
                      hint: 'Booking, Pricing, Travel…'),
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
